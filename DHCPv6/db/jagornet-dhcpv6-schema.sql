-- IDENTIYASSOC table (many per HOST)
-- * DUID (not null) [foreign_key]
-- * IA-Type (permanent, temporary, prefix-delegation)
-- * IAID (non null)
-- * STATE (advertised, committed, expired)
CREATE TABLE IDENTITYASSOC (
    ID BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    DUID VARCHAR(32672) FOR BIT DATA NOT NULL,
    IATYPE SMALLINT,
    IAID BIGINT,
    STATE SMALLINT
);
CREATE UNIQUE INDEX IA_TUPLE ON IDENTITYASSOC (DUID, IATYPE, IAID);


-- IAADDRESS table (many per IATYPE=IA_NA,IA_TA IDENTITYASSOC)
-- * IPADDRESS
-- * STARTTIME
-- * PREFERREDENDTIME
-- * VALIDENDTIME
-- * STATE (advertised, committed, expired, released, declined)
CREATE TABLE IAADDRESS (
    ID BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    IPADDRESS CHAR(16) FOR BIT DATA NOT NULL UNIQUE,
    STARTTIME TIMESTAMP,
    PREFERREDENDTIME TIMESTAMP,
    VALIDENDTIME TIMESTAMP,
    STATE SMALLINT,
    IDENTITYASSOC_ID BIGINT,
    FOREIGN KEY (IDENTITYASSOC_ID) REFERENCES IDENTITYASSOC(ID) ON DELETE CASCADE
);

-- DHCPOPTION table (many per IDENTITYASSOC or IPADDRESS)
-- * CODE
-- * VALUE
-- * IAID (may be null) [foreign_key]
-- * IPADDRESS (may be null) [foreign_key]
CREATE TABLE DHCPOPTION (
    ID BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    CODE INTEGER,
    VALUE VARCHAR(32672) FOR BIT DATA,
    IDENTITYASSOC_ID BIGINT,
    IAADDRESS_ID BIGINT,
    FOREIGN KEY (IDENTITYASSOC_ID) REFERENCES IDENTITYASSOC(ID) ON DELETE CASCADE,
    FOREIGN KEY (IAADDRESS_ID) REFERENCES IAADDRESS(ID) ON DELETE CASCADE
);