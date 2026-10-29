ALTER TABLE ask_verified_outbox ADD COLUMN trace_context JSONB NOT NULL DEFAULT '{}'::jsonb;
