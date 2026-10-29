-- Candidate operational payout state and persistent checkpoint witness. No transfer authority.
CREATE TABLE payout_jobs (
 tenant_id text NOT NULL,
 idempotency_key bytea NOT NULL CHECK(octet_length(idempotency_key)=32),
 vulnerability_id bytea NOT NULL CHECK(octet_length(vulnerability_id)=32),
 parameters_digest bytea NOT NULL CHECK(octet_length(parameters_digest)=32),
 payload jsonb NOT NULL,
 status text NOT NULL DEFAULT 'PENDING' CHECK(status IN ('PENDING','DISPATCHED','COMPLETED')),
 owner_token uuid, receipt text,
 created_at timestamptz NOT NULL DEFAULT now(),
 PRIMARY KEY(tenant_id,idempotency_key), UNIQUE(tenant_id,vulnerability_id),
 CHECK((status='PENDING' AND owner_token IS NULL AND receipt IS NULL)
 OR (status='DISPATCHED' AND owner_token IS NOT NULL AND receipt IS NULL)
 OR (status='COMPLETED' AND owner_token IS NOT NULL AND receipt IS NOT NULL))
);
CREATE FUNCTION arkhe_payout_transition() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF ROW(NEW.tenant_id,NEW.idempotency_key,NEW.vulnerability_id,NEW.parameters_digest,NEW.payload,NEW.created_at)
 IS DISTINCT FROM ROW(OLD.tenant_id,OLD.idempotency_key,OLD.vulnerability_id,OLD.parameters_digest,OLD.payload,OLD.created_at)
 OR NOT ((OLD.status='PENDING' AND NEW.status='DISPATCHED')
 OR (OLD.status='DISPATCHED' AND NEW.status='COMPLETED' AND NEW.owner_token=OLD.owner_token)) THEN
 RAISE EXCEPTION 'invalid payout transition'; END IF; RETURN NEW;
END $$;
CREATE TRIGGER payout_transition BEFORE UPDATE ON payout_jobs FOR EACH ROW EXECUTE FUNCTION arkhe_payout_transition();
CREATE TABLE checkpoint_witness (
 tenant_id text NOT NULL, log_id bytea NOT NULL CHECK(octet_length(log_id)=32),checkpoint jsonb NOT NULL,
 PRIMARY KEY(tenant_id,log_id)
);
CREATE FUNCTION arkhe_witness_transition() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF ROW(NEW.tenant_id,NEW.log_id) IS DISTINCT FROM ROW(OLD.tenant_id,OLD.log_id)
 OR (NEW.checkpoint->>'leaf_count')::numeric < (OLD.checkpoint->>'leaf_count')::numeric
 OR (NEW.checkpoint->>'issued_at')::numeric < (OLD.checkpoint->>'issued_at')::numeric
 OR ((NEW.checkpoint->>'leaf_count')::numeric = (OLD.checkpoint->>'leaf_count')::numeric AND NEW.checkpoint->'root' IS DISTINCT FROM OLD.checkpoint->'root')
 THEN RAISE EXCEPTION 'witness rollback or same-size equivocation'; END IF; RETURN NEW;
END $$;
CREATE TRIGGER witness_transition BEFORE UPDATE ON checkpoint_witness FOR EACH ROW EXECUTE FUNCTION arkhe_witness_transition();
DO $$ DECLARE t text; BEGIN
 FOREACH t IN ARRAY ARRAY['payout_jobs','checkpoint_witness'] LOOP
 EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY',t);
 EXECUTE format('ALTER TABLE %I FORCE ROW LEVEL SECURITY',t);
 EXECUTE format('CREATE POLICY tenant_isolation_%I ON %I USING(tenant_id=arkhe_assert_tenant()) WITH CHECK(tenant_id=arkhe_assert_tenant())',t,t);
 EXECUTE format('CREATE TRIGGER no_delete_%I BEFORE DELETE ON %I FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation()',t,t);
 EXECUTE format('REVOKE ALL ON %I FROM PUBLIC',t);
 EXECUTE format('GRANT SELECT,INSERT ON %I TO arkhe_operations',t);
 EXECUTE format('GRANT SELECT ON %I TO arkhe_read',t);
 END LOOP;
END $$;
GRANT UPDATE(status,owner_token,receipt) ON payout_jobs TO arkhe_operations;
GRANT UPDATE(checkpoint) ON checkpoint_witness TO arkhe_operations;
CREATE INDEX payout_pending ON payout_jobs(tenant_id,created_at) WHERE status='PENDING';
