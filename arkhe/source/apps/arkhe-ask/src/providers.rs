//! Dev-default and production providers for the `/v1/ask` frontiers.
//!
//! - `InMemoryStore` / `EchoProvider`: dev defaults (week 1).
//! - `azure::AzureOpenAiProvider`: real LLM over reqwest, no SDK (week 2).
//! - `pgvector::PgVectorStore`: real vector store over sqlx + pgvector
//!   (week 2).

pub mod azure;
pub mod invariant;
pub mod pgvector;

use crate::pipeline::{ChunkStore, GeneratedAnswer, LlmProvider, StoredChunk};
use arkhe_rag::ncm_harness::ClaimData;
use async_trait::async_trait;

/// In-memory corpus; `retrieve` ignores the query (no embeddings yet) and
/// returns the first `k` chunks.
pub struct InMemoryStore {
    pub chunks: Vec<StoredChunk>,
}

#[async_trait]
impl ChunkStore for InMemoryStore {
    async fn retrieve(
        &self,
        tenant_id: &str,
        _query: &str,
        k: usize,
    ) -> Result<Vec<StoredChunk>, String> {
        if tenant_id.trim().is_empty() {
            return Err("tenant_id is required".into());
        }
        Ok(self
            .chunks
            .iter()
            .filter(|c| c.tenant_id == tenant_id)
            .take(k)
            .cloned()
            .collect())
    }
}

/// Deterministic, grounded-by-construction provider: echoes the first chunk
/// as both the answer and its single claim. The verifier passes by
/// construction, so tests against it exercise the plumbing, not the
/// verification. Verification itself is exercised by injecting a
/// hallucinating provider (see `tests/ask_e2e.rs`).
pub struct EchoProvider;

#[async_trait]
impl LlmProvider for EchoProvider {
    async fn answer(
        &self,
        _query: &str,
        chunks: &[StoredChunk],
    ) -> Result<GeneratedAnswer, String> {
        let chunk = chunks.first().ok_or("no chunks")?;
        Ok(GeneratedAnswer {
            answer: chunk.text.clone(),
            claims: vec![ClaimData {
                text: chunk.text.clone(),
                evidence_id: chunk.id.clone(),
            }],
        })
    }
}
