use crate::Digest32;
use async_trait::async_trait;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct EvidenceEnvelope {
    pub record_hash: Digest32,
    pub kind: String,
    pub subject: Digest32,
    pub payload_digest: Digest32,
    pub policy_digest: Option<Digest32>,
    pub causal_parents: Vec<Digest32>,
}

#[async_trait]
pub trait EvidenceReader: Send + Sync {
    /// Untrusted signed-policy JSON keyed by the exact legacy WER. The kernel
    /// independently validates signatures, policy and legacy parameter bindings.
    async fn authenticated_policy_request(
        &self,
        _worker: Digest32,
    ) -> Result<Option<Vec<u8>>, String> {
        Ok(None)
    }
    async fn get(&self, record_hash: Digest32) -> Result<Option<EvidenceEnvelope>, String>;

    /// Opt-in untrusted transport. A required predicate with no proof fails closed.
    async fn formal_proof(
        &self,
        _worker_digest: Digest32,
    ) -> Result<Option<crate::formal_proof::ProofCarryingOutput>, String> {
        Ok(None)
    }

    /// Optional proof transport, keyed by the exact admitted WER. Returned bytes
    /// are untrusted: the kernel always checks the certificate independently.
    /// Stores without this capability fail closed for proof-requiring policies.
    async fn budget_proof(
        &self,
        _worker_digest: Digest32,
    ) -> Result<Option<crate::output_proof::BudgetProof>, String> {
        Ok(None)
    }
}

#[async_trait]
pub trait EvidenceCommitter: Send + Sync {
    async fn append_verified(&self, evidence: EvidenceEnvelope) -> Result<Digest32, String>;
}

/// A trusted admission boundary calls this only after authorization.
/// Implementations must commit both canonical objects and evidence atomically.
#[async_trait]
pub trait WorkEvidenceCommitter: Send + Sync {
    async fn commit_work(
        &self,
        intent: &crate::work::WorkIntent,
        worker: &crate::worker::WorkerExecutionRecord,
        evidence: EvidenceEnvelope,
    ) -> Result<Digest32, String>;
}
