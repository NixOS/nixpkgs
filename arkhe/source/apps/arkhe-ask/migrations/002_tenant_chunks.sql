-- Run atomically (PgVectorStore::migrate or psql --single-transaction).
-- Legacy rows have no attributable tenant: preserve them with NULL tenant_id.
-- The NOT VALID check admits old rows but rejects every new unscoped write.
SELECT pg_advisory_xact_lock(8172046001);
CREATE EXTENSION IF NOT EXISTS vector;
CREATE TABLE IF NOT EXISTS chunks (
    tenant_id TEXT,
    id TEXT NOT NULL,
    text TEXT NOT NULL,
    embedding vector(1536) NOT NULL
);
ALTER TABLE chunks ADD COLUMN IF NOT EXISTS tenant_id TEXT;
ALTER TABLE chunks DROP CONSTRAINT IF EXISTS chunks_pkey;
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint
        WHERE conrelid = 'chunks'::regclass AND conname = 'chunks_tenant_required') THEN
        ALTER TABLE chunks ADD CONSTRAINT chunks_tenant_required
            CHECK (tenant_id IS NOT NULL AND btrim(tenant_id) <> '') NOT VALID;
    END IF;
END $$;
CREATE UNIQUE INDEX IF NOT EXISTS chunks_tenant_id_id_idx ON chunks (tenant_id, id);
-- The leading tenant column supports filtering; HNSW remains a separate index.
CREATE INDEX IF NOT EXISTS chunks_embedding_idx
    ON chunks USING hnsw (embedding vector_cosine_ops);
