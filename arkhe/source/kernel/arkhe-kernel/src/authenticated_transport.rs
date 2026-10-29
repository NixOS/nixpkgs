//! Adapter for existing evidence ports. Proof bytes remain untrusted; all
//! original evidence/formal/budget lookups are retained and forwarded unchanged.
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    Digest32,
};
use async_trait::async_trait;
pub struct AuthenticatedEvidence<'a, E> {
    pub source: &'a E,
    pub worker: Digest32,
    pub request: &'a [u8],
}
#[async_trait]
impl<E: EvidenceReader> EvidenceReader for AuthenticatedEvidence<'_, E> {
    async fn get(&self, h: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        self.source.get(h).await
    }
    async fn authenticated_policy_request(&self, h: Digest32) -> Result<Option<Vec<u8>>, String> {
        if h != self.worker {
            return Ok(None);
        }
        if self.request.len() > 1_048_576 {
            return Err("authenticated proof too large".into());
        }
        Ok(Some(self.request.to_vec()))
    }
    async fn formal_proof(
        &self,
        h: Digest32,
    ) -> Result<Option<arkhe_core::formal_proof::ProofCarryingOutput>, String> {
        self.source.formal_proof(h).await
    }
    async fn budget_proof(
        &self,
        h: Digest32,
    ) -> Result<Option<arkhe_core::output_proof::BudgetProof>, String> {
        self.source.budget_proof(h).await
    }
}
