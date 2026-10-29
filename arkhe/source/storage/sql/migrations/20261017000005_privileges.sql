REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;

GRANT USAGE ON SCHEMA public TO arkhe_append, arkhe_read;

GRANT SELECT, INSERT ON
  idempotency_keys,
  usage_events,
  intents,
  verification_records,
  branch_states,
  finding_dispositions,
  mmr_checkpoints
TO arkhe_append;

GRANT SELECT ON
  idempotency_keys,
  usage_events,
  intents,
  verification_records,
  branch_states,
  finding_dispositions,
  mmr_checkpoints
TO arkhe_read;

-- Explicit defense-in-depth.
REVOKE UPDATE, DELETE, TRUNCATE ON
  idempotency_keys,
  usage_events,
  intents,
  verification_records,
  branch_states,
  finding_dispositions,
  mmr_checkpoints
FROM arkhe_append, arkhe_read;
