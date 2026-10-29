
CREATE TABLE ask_verified_outbox (
    event_id TEXT PRIMARY KEY,
    tenant_id TEXT NOT NULL CHECK (btrim(tenant_id) <> ''),
    payload JSONB NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    published_at TIMESTAMPTZ
);
CREATE INDEX ask_verified_pending_idx ON ask_verified_outbox(created_at) WHERE published_at IS NULL;
CREATE TABLE ask_proof_anchors (
    event_id TEXT PRIMARY KEY REFERENCES ask_verified_outbox(event_id),
    payload JSONB NOT NULL,
    envelope JSONB NOT NULL,
    anchored_at TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE TABLE ask_kafka_cursors (
    topic TEXT PRIMARY KEY,
    next_offset BIGINT NOT NULL CHECK (next_offset >= 0)
);
