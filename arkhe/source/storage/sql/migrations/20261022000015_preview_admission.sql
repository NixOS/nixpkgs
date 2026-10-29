-- Preview admission/outbox v1: no execution or production-release authority.
-- Evidence and pending job must be committed in the same application transaction.
DO $$ BEGIN
 IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='arkhe_preview_enqueue') THEN
  CREATE ROLE arkhe_preview_enqueue NOLOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOINHERIT;
 END IF;
END $$;

CREATE TABLE preview_admissions (
 tenant_id text NOT NULL,
 requested_by text NOT NULL,
 operation_id bytea NOT NULL CHECK (octet_length(operation_id)=32),
 bundle_digest bytea NOT NULL CHECK (octet_length(bundle_digest)=32),
 authorization_ref bytea NOT NULL CHECK (octet_length(authorization_ref)=32),
 expires_at bigint NOT NULL CHECK (expires_at > 0),
 intent_cbor bytea NOT NULL,
 worker_cbor bytea NOT NULL,
 bundle jsonb NOT NULL CHECK (jsonb_typeof(bundle)='object'),
 created_at timestamptz NOT NULL DEFAULT clock_timestamp(),
 PRIMARY KEY (tenant_id,requested_by,operation_id),
 UNIQUE (tenant_id,requested_by,operation_id,bundle_digest)
);

-- An append-only pending outbox, not a lease/retry/execution journal.
-- A qualified executor must add a separate operational journal in a later migration.
CREATE TABLE preview_jobs (
 tenant_id text NOT NULL,
 requested_by text NOT NULL,
 operation_id bytea NOT NULL CHECK (octet_length(operation_id)=32),
 bundle_digest bytea NOT NULL CHECK (octet_length(bundle_digest)=32),
 created_at timestamptz NOT NULL DEFAULT clock_timestamp(),
 PRIMARY KEY (tenant_id,requested_by,operation_id),
 FOREIGN KEY (tenant_id,requested_by,operation_id,bundle_digest)
  REFERENCES preview_admissions(tenant_id,requested_by,operation_id,bundle_digest)
);

DO $$ DECLARE t text; BEGIN
 FOREACH t IN ARRAY ARRAY['preview_admissions','preview_jobs'] LOOP
  EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY',t);
  EXECUTE format('ALTER TABLE %I FORCE ROW LEVEL SECURITY',t);
  EXECUTE format('CREATE POLICY tenant_isolation_%I ON %I USING (tenant_id=arkhe_assert_tenant()) WITH CHECK (tenant_id=arkhe_assert_tenant())',t,t);
  EXECUTE format('CREATE TRIGGER immutable_%I BEFORE UPDATE OR DELETE ON %I FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation()',t,t);
  EXECUTE format('REVOKE ALL ON %I FROM PUBLIC',t);
  EXECUTE format('GRANT SELECT,INSERT ON %I TO arkhe_preview_enqueue',t);
  EXECUTE format('GRANT SELECT ON %I TO arkhe_read',t);
 END LOOP;
END $$;
-- No role memberships, login, credentials, worker dispatch or trust roots granted.
