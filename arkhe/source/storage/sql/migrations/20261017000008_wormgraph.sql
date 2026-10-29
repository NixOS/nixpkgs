-- Additive migration: original Phase-1 migrations remain immutable.
CREATE TABLE work_objects (
    tenant_id text NOT NULL,
    object_type text NOT NULL CHECK (object_type IN ('WorkIntent', 'WorkerExecutionRecord')),
    object_digest bytea NOT NULL CHECK (octet_length(object_digest) = 32),
    canonical_bytes bytea NOT NULL CHECK (octet_length(canonical_bytes) > 0),
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, object_type, object_digest)
);
CREATE TABLE wormgraph_records (
    tenant_id text NOT NULL,
    record_hash bytea NOT NULL CHECK (octet_length(record_hash) = 32),
    envelope jsonb NOT NULL CHECK (jsonb_typeof(envelope) = 'object'),
    created_at timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, record_hash)
);
DO $$
DECLARE t text;
BEGIN
    FOREACH t IN ARRAY ARRAY['work_objects', 'wormgraph_records'] LOOP
        EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t);
        EXECUTE format('ALTER TABLE %I FORCE ROW LEVEL SECURITY', t);
        EXECUTE format('CREATE POLICY tenant_isolation_%I ON %I USING (tenant_id = arkhe_assert_tenant()) WITH CHECK (tenant_id = arkhe_assert_tenant())', t, t);
        EXECUTE format('CREATE TRIGGER %I_no_update_delete BEFORE UPDATE OR DELETE ON %I FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation()', t, t);
        EXECUTE format('REVOKE ALL ON %I FROM PUBLIC', t);
        EXECUTE format('GRANT SELECT, INSERT ON %I TO arkhe_append', t);
        EXECUTE format('GRANT SELECT ON %I TO arkhe_read', t);
        EXECUTE format('REVOKE UPDATE, DELETE, TRUNCATE ON %I FROM arkhe_append, arkhe_read', t);
    END LOOP;
END $$;
