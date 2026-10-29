//! pgvector chunk store — sqlx + pgvector 0.4.
//!
//! The query is embedded with the injected `Embedder` (the same Azure
//! provider), then matched with cosine distance (`<=>`) over an HNSW index.
//! `vector(1536)` matches the explicitly requested 1536 dimensions; a different embedding
//! dimension requires recreating the table.

use crate::pipeline::{ChunkStore, Embedder, StoredChunk};
use async_trait::async_trait;
use pgvector::Vector;
use sqlx::PgPool;
use std::sync::Arc;

pub struct PgVectorStore {
    pool: PgPool,
    embedder: Arc<dyn Embedder>,
}

impl PgVectorStore {
    /// Store that connects (and migrates) on first use, so the synchronous
    /// startup wiring can be built before an async pool exists. Connection
    /// or migration failure on first use surfaces as a store error.
    pub fn lazy(database_url: String, embedder: Arc<dyn Embedder>) -> LazyPgVectorStore {
        LazyPgVectorStore {
            database_url,
            embedder,
            pool: tokio::sync::OnceCell::new(),
        }
    }

    pub fn new(pool: PgPool, embedder: Arc<dyn Embedder>) -> Self {
        Self { pool, embedder }
    }

    /// Idempotent: safe on every boot, with or without the initdb script.
    pub async fn migrate(&self) -> Result<(), String> {
        sqlx::migrate!("./migrations")
            .run(&self.pool)
            .await
            .map_err(|e| format!("tenant migration: {e}"))?;
        Ok(())
    }

    /// Upsert one chunk; embedding comes from the injected embedder.
    pub async fn insert(&self, tenant_id: &str, id: &str, text: &str) -> Result<(), String> {
        if tenant_id.trim().is_empty() {
            return Err("tenant_id is required".into());
        }
        let embedding = self.embedder.embed(text).await?;
        let vector = Vector::from(embedding);
        sqlx::query(
            "INSERT INTO chunks (tenant_id, id, text, embedding) VALUES ($1, $2, $3, $4)
             ON CONFLICT (tenant_id, id) DO UPDATE SET text = EXCLUDED.text, embedding = EXCLUDED.embedding",
        )
        .bind(tenant_id)
        .bind(id)
        .bind(text)
        .bind(vector)
        .execute(&self.pool)
        .await
        .map_err(|e| format!("insert: {e}"))?;
        Ok(())
    }

    pub fn pool(&self) -> &PgPool {
        &self.pool
    }
}

#[async_trait]
impl ChunkStore for PgVectorStore {
    async fn retrieve(
        &self,
        tenant_id: &str,
        query: &str,
        k: usize,
    ) -> Result<Vec<StoredChunk>, String> {
        if tenant_id.trim().is_empty() {
            return Err("tenant_id is required".into());
        }
        let embedding = self.embedder.embed(query).await?;
        let vector = Vector::from(embedding);
        let mut tx = self
            .pool
            .begin()
            .await
            .map_err(|e| format!("query begin: {e}"))?;
        sqlx::query("SET LOCAL hnsw.iterative_scan = relaxed_order")
            .execute(&mut *tx)
            .await
            .map_err(|e| format!("iterative scan: {e}"))?;
        let rows: Vec<(String, String, String)> = sqlx::query_as(
            "WITH nearest AS MATERIALIZED (
                SELECT tenant_id, id, text, embedding <=> $2 AS distance
                FROM chunks WHERE tenant_id = $1 ORDER BY embedding <=> $2 LIMIT $3
             ) SELECT tenant_id, id, text FROM nearest ORDER BY distance + 0",
        )
        .bind(tenant_id)
        .bind(vector)
        .bind(i64::try_from(k).map_err(|_| "k exceeds database limit")?)
        .fetch_all(&mut *tx)
        .await
        .map_err(|e| format!("query: {e}"))?;
        tx.commit()
            .await
            .map_err(|e| format!("query commit: {e}"))?;
        Ok(rows
            .into_iter()
            .map(|(tenant_id, id, text)| StoredChunk {
                tenant_id,
                id,
                text,
            })
            .collect())
    }
}

/// First-use-connecting chunk store over pgvector.
pub struct LazyPgVectorStore {
    database_url: String,
    embedder: Arc<dyn Embedder>,
    pool: tokio::sync::OnceCell<PgPool>,
}

impl LazyPgVectorStore {
    async fn connected(&self) -> Result<PgPool, String> {
        let pool = self
            .pool
            .get_or_try_init(|| async {
                let pool = sqlx::postgres::PgPoolOptions::new()
                    .max_connections(5)
                    .connect(&self.database_url)
                    .await
                    .map_err(|e| format!("connect: {e}"))?;
                PgVectorStore::new(pool.clone(), Arc::clone(&self.embedder))
                    .migrate()
                    .await?;
                Ok::<PgPool, String>(pool)
            })
            .await?;
        Ok(pool.clone())
    }
}

#[async_trait]
impl ChunkStore for LazyPgVectorStore {
    async fn retrieve(
        &self,
        tenant_id: &str,
        query: &str,
        k: usize,
    ) -> Result<Vec<StoredChunk>, String> {
        if tenant_id.trim().is_empty() {
            return Err("tenant_id is required".into());
        }
        let pool = self.connected().await?;
        PgVectorStore::new(pool, Arc::clone(&self.embedder))
            .retrieve(tenant_id, query, k)
            .await
    }
}
