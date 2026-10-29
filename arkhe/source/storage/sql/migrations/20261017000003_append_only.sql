CREATE OR REPLACE FUNCTION arkhe_reject_mutation()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  RAISE EXCEPTION 'table % is append-only; % is forbidden', TG_TABLE_NAME, TG_OP
    USING ERRCODE = 'check_violation';
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
        EXECUTE format(
          'CREATE TRIGGER %I_no_update_delete BEFORE UPDATE OR DELETE ON %I
           FOR EACH ROW EXECUTE FUNCTION arkhe_reject_mutation()',
          t, t
        );
    END LOOP;
END $$;
