-- Operational dispatch is mutable; admission/evidence remain append-only.
DO $$ BEGIN
 IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='arkhe_preview_execute') THEN
  CREATE ROLE arkhe_preview_execute NOLOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOINHERIT;
 END IF;
END $$;
CREATE TABLE preview_dispatches (
 tenant_id text NOT NULL, requested_by text NOT NULL, operation_id bytea NOT NULL,
 state text NOT NULL DEFAULT 'READY' CHECK(state IN ('READY','LEASED','RUNNING','RETRY','SUCCEEDED','FAILED','DEAD','UNKNOWN')),
 attempts integer NOT NULL DEFAULT 0 CHECK(attempts BETWEEN 0 AND 3),
 fence bigint NOT NULL DEFAULT 0 CHECK(fence >= 0),
 owner_token uuid, lease_until timestamptz, available_at timestamptz NOT NULL DEFAULT clock_timestamp(),
 result jsonb, updated_at timestamptz NOT NULL DEFAULT clock_timestamp(),
 PRIMARY KEY(tenant_id,requested_by,operation_id),
 FOREIGN KEY(tenant_id,requested_by,operation_id) REFERENCES preview_jobs(tenant_id,requested_by,operation_id),
 CHECK ((state IN ('LEASED','RUNNING')) = (owner_token IS NOT NULL AND lease_until IS NOT NULL))
);
CREATE TABLE preview_execution_events (
 tenant_id text NOT NULL, requested_by text NOT NULL, operation_id bytea NOT NULL,
 event_id uuid NOT NULL, fence bigint NOT NULL, state text NOT NULL, details jsonb NOT NULL,
 created_at timestamptz NOT NULL DEFAULT clock_timestamp(),
 PRIMARY KEY(tenant_id,event_id),
 FOREIGN KEY(tenant_id,requested_by,operation_id) REFERENCES preview_jobs(tenant_id,requested_by,operation_id)
);
CREATE FUNCTION arkhe_preview_dispatch_transition() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF ROW(NEW.tenant_id,NEW.requested_by,NEW.operation_id) IS DISTINCT FROM ROW(OLD.tenant_id,OLD.requested_by,OLD.operation_id)
 OR NOT (
  (OLD.state IN ('READY','RETRY','LEASED') AND NEW.state='LEASED' AND NEW.attempts=OLD.attempts+1 AND NEW.fence=OLD.fence+1
   AND (OLD.state<>'LEASED' OR OLD.lease_until<=clock_timestamp()) AND NEW.available_at<=clock_timestamp())
  OR (OLD.state IN ('LEASED','RUNNING') AND NEW.state=OLD.state AND NEW.attempts=OLD.attempts AND NEW.fence=OLD.fence AND NEW.owner_token=OLD.owner_token AND OLD.lease_until>clock_timestamp())
  OR (OLD.state='LEASED' AND NEW.state='RUNNING' AND NEW.attempts=OLD.attempts AND NEW.fence=OLD.fence AND NEW.owner_token=OLD.owner_token AND OLD.lease_until>clock_timestamp())
  OR (OLD.state IN ('LEASED','RUNNING') AND NEW.state IN ('FAILED','SUCCEEDED','UNKNOWN','DEAD','RETRY') AND NEW.attempts=OLD.attempts AND NEW.fence=OLD.fence
      AND (NEW.state<>'RETRY' OR OLD.state='LEASED') AND (NEW.state<>'SUCCEEDED' OR OLD.state='RUNNING'))
 ) THEN RAISE EXCEPTION 'invalid preview dispatch transition'; END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER preview_dispatch_transition BEFORE UPDATE ON preview_dispatches FOR EACH ROW EXECUTE FUNCTION arkhe_preview_dispatch_transition();
CREATE TRIGGER preview_dispatch_no_delete BEFORE DELETE ON preview_dispatches FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation();
CREATE TRIGGER preview_execution_immutable BEFORE UPDATE OR DELETE ON preview_execution_events FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation();
DO $$ DECLARE t text; BEGIN
 FOREACH t IN ARRAY ARRAY['preview_dispatches','preview_execution_events'] LOOP
  EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY',t);
  EXECUTE format('ALTER TABLE %I FORCE ROW LEVEL SECURITY',t);
  EXECUTE format('CREATE POLICY tenant_isolation_%I ON %I USING (tenant_id=arkhe_assert_tenant()) WITH CHECK (tenant_id=arkhe_assert_tenant())',t,t);
  EXECUTE format('REVOKE ALL ON %I FROM PUBLIC',t);
  EXECUTE format('GRANT SELECT,INSERT ON %I TO arkhe_preview_execute',t);
  EXECUTE format('GRANT SELECT ON %I TO arkhe_preview_enqueue,arkhe_read',t);
 END LOOP;
END $$;
GRANT UPDATE(state,attempts,fence,owner_token,lease_until,available_at,result,updated_at) ON preview_dispatches TO arkhe_preview_execute;
GRANT SELECT ON preview_admissions,preview_jobs TO arkhe_preview_execute;
