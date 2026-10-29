-- Additive observation storage. Existing envelope/checkpoint tables are reused.
-- This is not payment authorization or external source authentication.
CREATE TABLE memo_observation_packages (
 tenant_id text NOT NULL,
 record_hash bytea NOT NULL CHECK(octet_length(record_hash)=32),
 operation_id bytea NOT NULL CHECK(octet_length(operation_id)=32),
 package_bytes bytea NOT NULL CHECK(octet_length(package_bytes) BETWEEN 1 AND 20000000),
 stream_id text NOT NULL,
 graph_leaf_count bigint NOT NULL CHECK(graph_leaf_count BETWEEN 1 AND 1000000),
 created_at timestamptz NOT NULL DEFAULT now(),
 PRIMARY KEY(tenant_id,record_hash),
 UNIQUE(tenant_id,operation_id),
 FOREIGN KEY(tenant_id,record_hash) REFERENCES wormgraph_records(tenant_id,record_hash),
 FOREIGN KEY(tenant_id,stream_id,graph_leaf_count) REFERENCES mmr_checkpoints(tenant_id,stream_id,leaf_count)
);
ALTER TABLE memo_observation_packages ENABLE ROW LEVEL SECURITY;
ALTER TABLE memo_observation_packages FORCE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation_memo_observation_packages ON memo_observation_packages
 USING(tenant_id=arkhe_assert_tenant()) WITH CHECK(tenant_id=arkhe_assert_tenant());
CREATE TRIGGER memo_observation_packages_no_update_delete
 BEFORE UPDATE OR DELETE ON memo_observation_packages
 FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation();
REVOKE ALL ON memo_observation_packages FROM PUBLIC;
GRANT SELECT,INSERT ON memo_observation_packages TO arkhe_append;
GRANT SELECT ON memo_observation_packages TO arkhe_read;
REVOKE UPDATE,DELETE,TRUNCATE ON memo_observation_packages FROM arkhe_append,arkhe_read;
