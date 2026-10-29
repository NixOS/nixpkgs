CREATE OR REPLACE FUNCTION arkhe_assert_tenant()
RETURNS text
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
  tid text := current_setting('app.tenant_id', true);
BEGIN
  IF tid IS NULL OR tid = '' THEN
    RAISE EXCEPTION 'app.tenant_id is not set'
      USING ERRCODE = 'insufficient_privilege';
  END IF;
  RETURN tid;
END
$$;

DO $$
DECLARE
    t text;
BEGIN
    FOREACH t IN ARRAY ARRAY[
      'idempotency_keys',
      'usage_events',
      'intents',
      'verification_records',
      'branch_states',
      'finding_dispositions',
      'mmr_checkpoints'
    ]
    LOOP
        EXECUTE format('ALTER TABLE %I ENABLE ROW LEVEL SECURITY', t);
        EXECUTE format('ALTER TABLE %I FORCE ROW LEVEL SECURITY', t);
        EXECUTE format(
          'CREATE POLICY tenant_isolation_%I ON %I
             USING (tenant_id = arkhe_assert_tenant())
             WITH CHECK (tenant_id = arkhe_assert_tenant())',
          t, t
        );
    END LOOP;
END $$;
