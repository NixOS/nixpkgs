//! Uses Arkhe's existing journal and admission ports. No HTTP contract is invented.
use crate::{Error, Proposal};
use arkhe_bugbounty::{Claim, Journal, Kernel};
use arkhe_core::{
    work::{ContextEntry, ContextKind},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_governance::{PolicyBinding, PolicyResolver};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use async_trait::async_trait;

#[async_trait]
pub trait CommunityBackend: Send + Sync {
    /// No automatic retries. Backend must validate actual resource/community membership.
    async fn execute(&self, proposal: &Proposal, operation: Digest32) -> Result<Digest32, String>;
}
/// A host checks current time, token revocation and humanity immediately before dispatch.
/// Implementations MUST recheck original bearer/proof against trusted current state.
#[async_trait]
pub trait Revalidator: Send + Sync {
    async fn revalidate(&self, proposal: &Proposal) -> Result<(), String>;
}

pub struct Executor<K, B, V, R: PolicyResolver> {
    pub kernel: K,
    pub backend: B,
    pub revalidator: V,
    pub journal: std::sync::Arc<dyn Journal>,
    pub gate: ContainmentGate<R>,
    pub policy: PolicyBinding,
}
fn candidate(
    input: Digest32,
    output: Digest32,
    parents: Vec<Digest32>,
    execution_id: String,
    operation: CognitiveOperation,
) -> WorkerExecutionRecord {
    WorkerExecutionRecord {
        classification: None,
        operation: Some(operation),
        module_id: "orkut-community-v1".into(),
        module_version: env!("CARGO_PKG_VERSION").into(),
        input_digest: input,
        output_digest: output,
        evidence_refs: parents,
        confidence_bps: None,
        uncertainty_note: None,
        execution_id,
    }
}
impl<K: Kernel, B: CommunityBackend, V: Revalidator, R: PolicyResolver> Executor<K, B, V, R> {
    async fn admit(&self, record: &WorkerExecutionRecord) -> Result<Digest32, Error> {
        let hash = self.kernel.admit(record).await.map_err(Error::Execution)?;
        if hash != record.digest() {
            return Err(Error::Execution("admission hash mismatch".into()));
        }
        Ok(hash)
    }
    pub async fn execute(&self, proposal: &Proposal) -> Result<WorkerExecutionRecord, Error> {
        // Snapshot binds principal, target, action, token, humanity and provenance together.
        let source = proposal.intent.digest();
        let mut intent = proposal.intent.clone();
        let operation = intent.operation_id();
        let owner = match self
            .journal
            .claim(&intent)
            .await
            .map_err(|e| Error::Execution(e.to_string()))?
        {
            Claim::Replay(record) => return Ok(record),
            Claim::Pending => {
                return Err(Error::Execution("manual_reconciliation_required".into()))
            }
            Claim::Acquired(owner) => owner,
        };
        let result = async {
            let analysis = candidate(
                source,
                intent.parameters_digest,
                vec![],
                format!("{}:validate", operation.to_hex()),
                CognitiveOperation::Analyze,
            );
            let admitted = self.admit(&analysis).await?;
            intent.context.extend([
                ContextEntry {
                    kind: ContextKind::SourceReport,
                    hash: source,
                },
                ContextEntry {
                    kind: ContextKind::AnalysisRecord,
                    hash: admitted,
                },
            ]);
            if let AuthorizationDecision::Reject { reason } = self
                .gate
                .authorize_admitted(&intent, &analysis, &self.policy, &self.kernel)
                .await
            {
                return Err(Error::Execution(reason));
            }
            self.revalidator
                .revalidate(proposal)
                .await
                .map_err(Error::Execution)?;
            self.journal
                .mark_dispatched(&intent, owner)
                .await
                .map_err(|e| Error::Execution(e.to_string()))?;
            let receipt = self
                .backend
                .execute(proposal, operation)
                .await
                .map_err(Error::Execution)?;
            if receipt == Digest32::ZERO {
                return Err(Error::Execution("empty backend receipt".into()));
            }
            let record = candidate(
                admitted,
                receipt,
                vec![admitted],
                operation.to_hex(),
                CognitiveOperation::Execute,
            );
            self.admit(&record).await?;
            self.journal
                .complete(&intent, owner, &record)
                .await
                .map_err(|e| Error::Execution(e.to_string()))?;
            Ok(record)
        }
        .await;
        if let Err(error) = &result {
            self.journal
                .require_manual_reconciliation(&intent.requested_by, operation, &error.to_string())
                .await
                .map_err(|e| Error::Execution(e.to_string()))?;
        }
        result
    }
}
