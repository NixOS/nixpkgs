-- Job-plan week 2: chunk table for the verified-RAG endpoint.
-- Redundant with PgVectorStore::migrate() and the compose initdb by design:
-- idempotent, so any boot path converges to the same schema.
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS chunks (
    id        TEXT PRIMARY KEY,
    text      TEXT NOT NULL,
    embedding vector(1536) NOT NULL
);

CREATE INDEX IF NOT EXISTS chunks_embedding_idx
    ON chunks USING hnsw (embedding vector_cosine_ops);
