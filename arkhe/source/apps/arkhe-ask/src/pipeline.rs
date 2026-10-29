//! AKG-ASK-0001 — the `/v1/ask` pipeline: retrieve → generate → REFUSE the
//! unsupported.
//!
//! Job-plan skeleton: every external dependency (LLM, vector store, identity
//! provider) is a trait with an in-memory default, and the one component
//! that is real today is the differential — the `CitationVerifier` from
//! arkhe-rag (AKG-CITE-0001). A claim is returned only when every entity in
//! it occurs literally in the chunk it cites; otherwise the endpoint refuses
//! with 422 and returns nothing. A RAG pipeline that refuses to return
//! unsupported claims.
//!
//! Week map (see `ops/jobplan/docker-compose.yml`):
//! - Week 2: `AzureOpenAiProvider` (reqwest) and `PgVectorStore` (sqlx)
//!   replace the in-memory defaults behind these same traits.
//! - Week 3: Keycloak JWT middleware authenticates tenant identity by default;
//!   header identity remains an explicit development option.
//! - Week 4: the proof digest is anchored through the outbox (Kafka relay).
//! - Week 5: OTel spans + `/metrics`.

use arkhe_cognition_sdk::Digest32;
use arkhe_rag::citation::{CitationVerifier, Claim, Evidence, OverlapVerifier};
use arkhe_rag::ncm_harness::ClaimData;
use async_trait::async_trait;
use tracing::Instrument;

pub use arkhe_rag::citation::CitationError;

#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub struct StoredChunk {
    pub tenant_id: String,
    pub id: String,
    pub text: String,
}

#[async_trait]
pub trait ChunkStore: Send + Sync {
    async fn retrieve(
        &self,
        tenant_id: &str,
        query: &str,
        k: usize,
    ) -> Result<Vec<StoredChunk>, String>;

    async fn retrieve_evidenced(
        &self,
        tenant_id: &str,
        query: &str,
        k: usize,
    ) -> Result<RetrievalBatch, String> {
        Ok(RetrievalBatch {
            chunks: self.retrieve(tenant_id, query, k).await?,
            evidence: vec![],
        })
    }
}

pub struct RetrievalBatch {
    pub chunks: Vec<StoredChunk>,
    pub evidence: Vec<crate::providers::invariant::ChunkEvidence>,
}

#[derive(Debug, Clone)]
pub struct GeneratedAnswer {
    pub answer: String,
    pub claims: Vec<ClaimData>,
}

#[async_trait]
pub trait LlmProvider: Send + Sync {
    async fn answer(&self, query: &str, chunks: &[StoredChunk]) -> Result<GeneratedAnswer, String>;
}

/// Embeds text into the vector space the chunk store indexes. Implemented
/// by the real provider (Azure OpenAI) and by test doubles.
#[async_trait]
pub trait Embedder: Send + Sync {
    async fn embed(&self, text: &str) -> Result<Vec<f32>, String>;
}

#[async_trait]
impl<T: ChunkStore + ?Sized> ChunkStore for Box<T> {
    async fn retrieve_evidenced(
        &self,
        tenant_id: &str,
        query: &str,
        k: usize,
    ) -> Result<RetrievalBatch, String> {
        (**self).retrieve_evidenced(tenant_id, query, k).await
    }
    async fn retrieve(
        &self,
        tenant_id: &str,
        query: &str,
        k: usize,
    ) -> Result<Vec<StoredChunk>, String> {
        (**self).retrieve(tenant_id, query, k).await
    }
}

#[async_trait]
impl<T: LlmProvider + ?Sized> LlmProvider for Box<T> {
    async fn answer(&self, query: &str, chunks: &[StoredChunk]) -> Result<GeneratedAnswer, String> {
        (**self).answer(query, chunks).await
    }
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct CitationProof {
    pub tenant_id: String,
    /// Evidence ids the returned claims cite, in first-citation order.
    pub evidence_ids: Vec<String>,
    /// BLAKE3 over the claims and their cited evidence, domain-separated.
    pub record_digest: Digest32,
}

#[derive(Debug, Clone, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct AskResponse {
    pub answer: String,
    pub claims: Vec<ClaimData>,
    pub citation_proof: CitationProof,
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub chunk_evidence: Vec<crate::providers::invariant::ChunkEvidence>,
}

#[derive(Debug, PartialEq)]
pub enum AskError {
    EmptyQuery,
    Unauthorized,
    Store(String),
    Llm(String),
    /// The differential: a claim cites an entity that does not occur
    /// literally in the cited chunk (or with insufficient overlap). Nothing
    /// is returned to the caller.
    UnsupportedClaim(CitationError),
}

pub struct AskPipeline<S, L> {
    store: S,
    llm: L,
    verifier: OverlapVerifier,
}

impl<S: ChunkStore, L: LlmProvider> AskPipeline<S, L> {
    pub fn new(store: S, llm: L) -> Self {
        Self {
            store,
            llm,
            verifier: OverlapVerifier::default(),
        }
    }

    pub async fn ask(&self, tenant: &str, query: &str) -> Result<AskResponse, AskError> {
        if tenant.trim().is_empty() {
            return Err(AskError::Unauthorized);
        }
        if query.trim().is_empty() {
            return Err(AskError::EmptyQuery);
        }
        let retrieved = self
            .store
            .retrieve_evidenced(tenant, query, 4)
            .instrument(tracing::info_span!("arkhe.ask.rag.retrieve"))
            .await
            .map_err(AskError::Store)?;
        let chunks = retrieved.chunks;
        if !retrieved.evidence.is_empty()
            && (retrieved.evidence.len() != chunks.len()
                || retrieved.evidence.iter().zip(&chunks).any(|(e, c)| {
                    e.id != c.id || e.text != c.text || !e.verify(tenant, &e.inclusion_proof.root)
                }))
        {
            return Err(AskError::Store(
                "invalid retrieval inclusion evidence".into(),
            ));
        }
        if chunks.iter().any(|chunk| chunk.tenant_id != tenant) {
            return Err(AskError::Store(
                "store returned evidence outside tenant scope".into(),
            ));
        }
        if chunks.is_empty() {
            return Err(AskError::Store("no evidence retrieved".into()));
        }
        let generated = self
            .llm
            .answer(query, &chunks)
            .instrument(tracing::info_span!("arkhe.ask.rag.generate"))
            .await
            .map_err(AskError::Llm)?;

        // The layer that makes this more than a RAG tutorial.
        let evidence: Vec<Evidence<'_>> = chunks
            .iter()
            .map(|c| Evidence {
                id: c.id.as_str(),
                text: c.text.as_str(),
            })
            .collect();
        let claims: Vec<Claim<'_>> = generated
            .claims
            .iter()
            .map(|c| Claim {
                text: c.text.as_str(),
                evidence_id: c.evidence_id.as_str(),
            })
            .collect();
        tracing::info_span!("arkhe.ask.rag.verify")
            .in_scope(|| self.verifier.verify(&claims, &evidence))
            .map_err(AskError::UnsupportedClaim)?;

        // Proof digest: cited evidence ids then claims, length-prefixed,
        // under the ask domain.
        let mut evidence_ids: Vec<String> = Vec::new();
        let mut buf = Vec::new();
        buf.extend_from_slice(&(tenant.len() as u64).to_be_bytes());
        buf.extend_from_slice(tenant.as_bytes());
        for claim in &generated.claims {
            if !evidence_ids.contains(&claim.evidence_id) {
                evidence_ids.push(claim.evidence_id.clone());
            }
        }
        for id in &evidence_ids {
            buf.extend_from_slice(&(id.len() as u64).to_be_bytes());
            buf.extend_from_slice(id.as_bytes());
        }
        for claim in &generated.claims {
            buf.extend_from_slice(&(claim.text.len() as u64).to_be_bytes());
            buf.extend_from_slice(claim.text.as_bytes());
            buf.extend_from_slice(&(claim.evidence_id.len() as u64).to_be_bytes());
            buf.extend_from_slice(claim.evidence_id.as_bytes());
        }
        let chunk_evidence: Vec<_> = retrieved
            .evidence
            .into_iter()
            .filter(|e| evidence_ids.contains(&e.id))
            .collect();
        let record_digest = if chunk_evidence.is_empty() {
            Digest32::blake3(b"AKG:ASK:PROOF:v2\0", &buf)
        } else {
            // The opt-in v3 commitment also binds the cited content and snapshot
            // proofs. Legacy providers preserve their v2 bytes and domain.
            let encoded = arkhe_core::canonical::encode_value(
                &serde_json::to_value(&chunk_evidence)
                    .map_err(|e| AskError::Store(format!("evidence encoding: {e}")))?,
            );
            buf.extend_from_slice(&(encoded.len() as u64).to_be_bytes());
            buf.extend_from_slice(&encoded);
            Digest32::blake3(b"AKG:ASK:PROOF:v3\0", &buf)
        };
        Ok(AskResponse {
            answer: generated.answer,
            claims: generated.claims,
            chunk_evidence,
            citation_proof: CitationProof {
                tenant_id: tenant.to_string(),
                evidence_ids,
                record_digest,
            },
        })
    }
}
