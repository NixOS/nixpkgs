-- Additive only: journal is operational state, never normative evidence.
DO $$ BEGIN
 IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname='arkhe_operations') THEN
  CREATE ROLE arkhe_operations NOLOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOINHERIT;
 END IF;
END $$;
CREATE TABLE operation_journal (
 tenant_id text NOT NULL,
 requested_by text NOT NULL,
 operation_id bytea NOT NULL CHECK (octet_length(operation_id)=32),
 request_identity bytea NOT NULL CHECK (octet_length(request_identity)=32),
 intent_type text NOT NULL,
 target_digest bytea NOT NULL CHECK (octet_length(target_digest)=32),
 parameters_digest bytea NOT NULL CHECK (octet_length(parameters_digest)=32),
 owner_token uuid NOT NULL,
 status text NOT NULL CHECK (status IN ('PREPARED','DISPATCHED','COMPLETED')),
 response jsonb,
 created_at timestamptz NOT NULL DEFAULT now(),
 completed_at timestamptz,
 PRIMARY KEY (tenant_id,requested_by,operation_id),
 UNIQUE (tenant_id,requested_by,request_identity,intent_type,target_digest),
 CHECK ((status='COMPLETED')=(response IS NOT NULL AND completed_at IS NOT NULL))
);
CREATE FUNCTION arkhe_journal_transition() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
 IF ROW(NEW.tenant_id,NEW.requested_by,NEW.operation_id,NEW.request_identity,NEW.intent_type,NEW.target_digest,NEW.parameters_digest,NEW.owner_token,NEW.created_at)
 IS DISTINCT FROM ROW(OLD.tenant_id,OLD.requested_by,OLD.operation_id,OLD.request_identity,OLD.intent_type,OLD.target_digest,OLD.parameters_digest,OLD.owner_token,OLD.created_at)
 OR NOT ((OLD.status='PREPARED' AND NEW.status='DISPATCHED') OR (OLD.status='DISPATCHED' AND NEW.status='COMPLETED')) THEN
  RAISE EXCEPTION 'invalid operation journal transition';
 END IF;
 RETURN NEW;
END $$;
CREATE TRIGGER operation_journal_transition BEFORE UPDATE ON operation_journal FOR EACH ROW EXECUTE FUNCTION arkhe_journal_transition();
CREATE TRIGGER operation_journal_no_delete BEFORE DELETE ON operation_journal FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation();
CREATE TABLE bugbounty_operational_log (
 tenant_id text NOT NULL,
 event_id uuid NOT NULL,
 report_id text NOT NULL,
 operation_id bytea CHECK (operation_id IS NULL OR octet_length(operation_id)=32),
 stage text NOT NULL,
 error text NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(),
 expires_at timestamptz NOT NULL DEFAULT now()+interval '30 days',
 PRIMARY KEY(tenant_id,event_id)
);
CREATE INDEX bugbounty_operational_log_expiry ON bugbounty_operational_log(expires_at);
CREATE TRIGGER bugbounty_log_no_update BEFORE UPDATE ON bugbounty_operational_log FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation();
DO $$ DECLARE t text; BEGIN
 FOREACH t IN ARRAY ARRAY['operation_journal','bugbounty_operational_log'] LOOP
  EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY',t);
  EXECUTE format('ALTER TABLE %I FORCE ROW LEVEL SECURITY',t);
  EXECUTE format('CREATE POLICY tenant_isolation_%I ON %I USING (tenant_id=arkhe_assert_tenant()) WITH CHECK (tenant_id=arkhe_assert_tenant())',t,t);
  EXECUTE format('REVOKE ALL ON %I FROM PUBLIC',t);
  EXECUTE format('GRANT SELECT,INSERT ON %I TO arkhe_operations',t);
  EXECUTE format('GRANT SELECT ON %I TO arkhe_read',t);
 END LOOP;
END $$;
GRANT UPDATE(status,response,completed_at) ON operation_journal TO arkhe_operations;
-- TTL cleanup is a deployment maintenance operation, not an evidence-writer privilege.
GRANT DELETE ON bugbounty_operational_log TO arkhe_admin;
