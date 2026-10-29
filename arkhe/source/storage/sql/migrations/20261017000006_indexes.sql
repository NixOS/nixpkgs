CREATE INDEX usage_events_tenant_started_idx
  ON usage_events (tenant_id, started_at DESC);

CREATE INDEX verification_records_tenant_intent_idx
  ON verification_records (tenant_id, intent_digest, created_at DESC);

CREATE INDEX verification_records_policy_result_idx
  ON verification_records (tenant_id, policy_digest, result);

CREATE INDEX mmr_checkpoints_latest_idx
  ON mmr_checkpoints (tenant_id, stream_id, leaf_count DESC);
