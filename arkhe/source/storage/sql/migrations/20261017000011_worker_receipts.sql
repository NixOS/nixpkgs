-- Detached receipts are untrusted until signature/provenance verification.
CREATE TABLE worker_receipts (
 tenant_id text NOT NULL,
 record_hash bytea NOT NULL CHECK (octet_length(record_hash)=32),
 key_id text NOT NULL,
 receipt jsonb NOT NULL CHECK (jsonb_typeof(receipt)='object'),
 created_at timestamptz NOT NULL DEFAULT now(),
 PRIMARY KEY(tenant_id,record_hash,key_id)
);
ALTER TABLE worker_receipts ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_receipts FORCE ROW LEVEL SECURITY;
CREATE POLICY worker_receipts_tenant ON worker_receipts USING(tenant_id=arkhe_assert_tenant()) WITH CHECK(tenant_id=arkhe_assert_tenant());
CREATE TRIGGER worker_receipts_immutable BEFORE UPDATE OR DELETE ON worker_receipts FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation();
REVOKE ALL ON worker_receipts FROM PUBLIC;
GRANT SELECT,INSERT ON worker_receipts TO arkhe_operations;
GRANT SELECT ON worker_receipts TO arkhe_read;
