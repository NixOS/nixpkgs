CREATE TABLE manual_reconciliation_requests (
 tenant_id text NOT NULL,
 requested_by text NOT NULL,
 operation_id bytea NOT NULL CHECK (octet_length(operation_id)=32),
 reason text NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(),
 PRIMARY KEY(tenant_id,requested_by,operation_id),
 FOREIGN KEY(tenant_id,requested_by,operation_id) REFERENCES operation_journal(tenant_id,requested_by,operation_id)
);
ALTER TABLE manual_reconciliation_requests ENABLE ROW LEVEL SECURITY;
ALTER TABLE manual_reconciliation_requests FORCE ROW LEVEL SECURITY;
CREATE POLICY reconciliation_tenant ON manual_reconciliation_requests USING(tenant_id=arkhe_assert_tenant()) WITH CHECK(tenant_id=arkhe_assert_tenant());
CREATE TRIGGER reconciliation_immutable BEFORE UPDATE OR DELETE ON manual_reconciliation_requests FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation();
REVOKE ALL ON manual_reconciliation_requests FROM PUBLIC;
GRANT SELECT,INSERT ON manual_reconciliation_requests TO arkhe_operations;
GRANT SELECT ON manual_reconciliation_requests TO arkhe_read;
