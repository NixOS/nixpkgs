use arkhe_core::work::WorkIntent;
use arkhe_governance::{PolicyBinding, PolicyResolver};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};

pub mod http_routes;
pub mod preview;
pub mod portable_wer;
#[cfg(feature="sqlite-dispatch")]
pub mod authenticated_dispatch;

pub struct Runtime<R: PolicyResolver> {
    pub gate: ContainmentGate<R>,
}

impl<R: PolicyResolver> Runtime<R> {
    pub fn authorize_proposed_work(
        &self,
        intent: &WorkIntent,
        record: &arkhe_core::worker::WorkerExecutionRecord,
        policy: &PolicyBinding,
    ) -> AuthorizationDecision {
        self.gate.authorize(intent, Some(record), policy)
    }
}

#[derive(Debug, thiserror::Error)]
pub enum WorkCommitError {
    #[error("authorization rejected: {0}")]
    Rejected(String),
    #[error("evidence commit failed: {0}")]
    Storage(String),
}

/// Returns a receipt only after the complete evidence transaction has committed.
/// A receipt records authorization; it does not execute external effects.
impl<R: PolicyResolver> Runtime<R> {
    pub async fn commit_proposed_work<S: arkhe_core::evidence::WorkEvidenceCommitter>(
        &self,
        store: &S,
        intent: &WorkIntent,
        record: &arkhe_core::worker::WorkerExecutionRecord,
        policy: &PolicyBinding,
    ) -> Result<arkhe_core::Digest32, WorkCommitError> {
        if record.input_digest != intent.digest() {
            return Err(WorkCommitError::Rejected(
                "worker record does not bind this WorkIntent".into(),
            ));
        }
        let authorization_ref = match self.gate.authorize(intent, Some(record), policy) {
            AuthorizationDecision::Allow { authorization_ref } => authorization_ref,
            AuthorizationDecision::Reject { reason } => {
                return Err(WorkCommitError::Rejected(reason))
            }
        };
        store
            .commit_work(
                intent,
                record,
                arkhe_core::evidence::EvidenceEnvelope {
                    record_hash: authorization_ref,
                    kind: "work-authorization".into(),
                    subject: intent.digest(),
                    payload_digest: record.digest(),
                    policy_digest: Some(policy.policy_digest),
                    causal_parents: record.evidence_refs.clone(),
                },
            )
            .await
            .map_err(WorkCommitError::Storage)
    }
}
