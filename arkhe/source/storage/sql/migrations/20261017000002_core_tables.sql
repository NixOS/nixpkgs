CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE idempotency_keys (
    tenant_id         text NOT NULL,
    operation_type    text NOT NULL,
    idempotency_key   text NOT NULL,
    request_digest    bytea NOT NULL CHECK (octet_length(request_digest) = 32),
    operation_id      uuid NOT NULL DEFAULT gen_random_uuid(),
    created_at        timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, operation_type, idempotency_key),
    UNIQUE (operation_id)
);

CREATE TABLE usage_events (
    request_id          uuid PRIMARY KEY,
    operation_id        uuid NOT NULL REFERENCES idempotency_keys(operation_id),
    tenant_id           text NOT NULL,
    tool_name           text NOT NULL,
    started_at          timestamptz NOT NULL DEFAULT now(),
    duration_ms         bigint NOT NULL CHECK (duration_ms >= 0),
    result              text NOT NULL CHECK (result IN ('PASS','FAIL','INCONCLUSIVE')),
    policy_digest       bytea CHECK (policy_digest IS NULL OR octet_length(policy_digest)=32),
    evidence_hash       bytea CHECK (evidence_hash IS NULL OR octet_length(evidence_hash)=32),
    estimated_cost_usd  numeric(20,6) NOT NULL CHECK (estimated_cost_usd >= 0),
    billable_units      bigint NOT NULL CHECK (billable_units >= 0)
);

CREATE TABLE intents (
    intent_digest    bytea PRIMARY KEY CHECK (octet_length(intent_digest)=32),
    tenant_id        text NOT NULL,
    canonical_bytes  bytea NOT NULL,
    created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE verification_records (
    record_hash       bytea PRIMARY KEY CHECK (octet_length(record_hash)=32),
    tenant_id         text NOT NULL,
    intent_digest     bytea NOT NULL REFERENCES intents(intent_digest),
    policy_digest     bytea NOT NULL CHECK (octet_length(policy_digest)=32),
    result            text NOT NULL CHECK (result IN ('PASS','FAIL','INCONCLUSIVE')),
    canonical_bytes   bytea NOT NULL,
    created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE branch_states (
    branch_digest     bytea PRIMARY KEY CHECK (octet_length(branch_digest)=32),
    tenant_id         text NOT NULL,
    policy_digest     bytea NOT NULL CHECK (octet_length(policy_digest)=32),
    canonical_bytes   bytea NOT NULL,
    created_at        timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE finding_dispositions (
    disposition_digest bytea PRIMARY KEY CHECK (octet_length(disposition_digest)=32),
    tenant_id           text NOT NULL,
    finding_digest      bytea NOT NULL CHECK (octet_length(finding_digest)=32),
    policy_digest       bytea NOT NULL CHECK (octet_length(policy_digest)=32),
    disposition         text NOT NULL CHECK (disposition IN ('INFO','WARNING','BLOCKING')),
    canonical_bytes     bytea NOT NULL,
    created_at          timestamptz NOT NULL DEFAULT now()
);

CREATE TABLE mmr_checkpoints (
    tenant_id            text NOT NULL,
    stream_id            text NOT NULL,
    leaf_count           bigint NOT NULL CHECK (leaf_count > 0),
    mmr_size             bigint NOT NULL CHECK (mmr_size > 0),
    mmr_root             bytea NOT NULL CHECK (octet_length(mmr_root)=32),
    peaks                bytea[] NOT NULL,
    profile_digest       bytea NOT NULL CHECK (octet_length(profile_digest)=32),
    covered_up_to_hash   bytea NOT NULL CHECK (octet_length(covered_up_to_hash)=32),
    created_at           timestamptz NOT NULL DEFAULT now(),
    PRIMARY KEY (tenant_id, stream_id, leaf_count)
);
