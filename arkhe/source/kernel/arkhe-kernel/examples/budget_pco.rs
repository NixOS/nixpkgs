//! Offline proof-carrying budget proposal. Authorizes no real payment.
use arkhe_agent::budget_pco;
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    output_proof::{BudgetInput, BudgetProof, BudgetSpec},
    work::{ContextEntry, ContextKind, RequestIdentity, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_governance::{EvidenceKindRequirement, PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use async_trait::async_trait;

struct BudgetPolicy(BudgetSpec);
impl PolicyResolver for BudgetPolicy {
    fn required_budget_proof(&self, _: &WorkIntent, _: &PolicyBinding) -> Option<BudgetSpec> {
        Some(self.0.clone())
    }
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec!["budget-demo".into()],
            allowed_operations: vec![CognitiveOperation::Analyze],
        })
    }
    fn resolve(&self, i: &WorkIntent, p: &PolicyBinding) -> PolicyVerdict {
        if i.requested_by == "local-demo"
            && i.intent_type == WorkIntentType::ApproveExpense
            && p.policy_id == "offline-budget-demo"
            && p.version == 1
            && p.policy_digest == self.0.digest()
        {
            PolicyVerdict::Allow
        } else {
            PolicyVerdict::Deny("outside demo policy".into())
        }
    }
}
struct OfflineEvidence {
    envelopes: Vec<EvidenceEnvelope>,
    proof: BudgetProof,
}
#[async_trait]
impl EvidenceReader for OfflineEvidence {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(self
            .envelopes
            .iter()
            .find(|e| e.record_hash == hash)
            .cloned())
    }
    async fn budget_proof(&self, worker: Digest32) -> Result<Option<BudgetProof>, String> {
        Ok((self.proof.worker_digest == worker).then(|| self.proof.clone()))
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let input = BudgetInput {
        costs: vec![20, 30, 50],
    };
    // Host-owned specification; never supplied by the untrusted producer.
    let spec = BudgetSpec {
        version: 1,
        limit: 100,
        max_items: 16,
    };
    let binding = PolicyBinding {
        policy_id: "offline-budget-demo".into(),
        version: 1,
        policy_digest: spec.digest(),
    };
    let (output, _) = budget_pco::infer(&input, &spec)?;
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Analyze),
        module_id: "budget-demo".into(),
        module_version: "1".into(),
        input_digest: input.digest(),
        output_digest: output.digest(),
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: Some(
            "finite arithmetic only; no factual cost or payment guarantee".into(),
        ),
        execution_id: "offline-budget-1".into(),
    };
    let intent = WorkIntent {
        requested_by: "local-demo".into(),
        intent_type: WorkIntentType::ApproveExpense,
        target: Digest32::blake3(b"AKG:DEMO:TARGET\0", b"budget"),
        parameters_digest: output.digest(),
        context: vec![
            ContextEntry {
                kind: ContextKind::SourceReport,
                hash: input.digest(),
            },
            ContextEntry {
                kind: ContextKind::AnalysisRecord,
                hash: worker.digest(),
            },
        ],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"offline-budget-1"),
        claimed_created_at: 0,
    };
    let proof = budget_pco::prove(input, &spec, binding.policy_digest, &intent, &worker)?;
    // Cross the serialization boundary; checking does not invoke the producer.
    let proof: BudgetProof = serde_json::from_str(&serde_json::to_string(&proof)?)?;
    let proof_digest = arkhe_verify_core::output_proof::verify_budget_proof(
        &proof,
        &spec,
        binding.policy_digest,
        &intent,
        &worker,
    )?;
    let store = OfflineEvidence {
        envelopes: vec![
            EvidenceEnvelope {
                record_hash: worker.digest(),
                kind: "WorkerExecutionRecord".into(),
                subject: worker.input_digest,
                payload_digest: worker.digest(),
                policy_digest: Some(binding.policy_digest),
                causal_parents: vec![],
            },
            EvidenceEnvelope {
                record_hash: proof_digest,
                kind: "BudgetProof".into(),
                subject: worker.digest(),
                payload_digest: proof_digest,
                policy_digest: Some(binding.policy_digest),
                causal_parents: vec![worker.digest(), worker.input_digest],
            },
        ],
        proof,
    };
    let gate = ContainmentGate::new(BudgetPolicy(spec));
    let authorization = match gate
        .authorize_admitted(&intent, &worker, &binding, &store)
        .await
    {
        AuthorizationDecision::Allow { authorization_ref } => authorization_ref,
        AuthorizationDecision::Reject { reason } => return Err(reason.into()),
    };
    println!(
        "{}",
        serde_json::to_string_pretty(&serde_json::json!({
            "mode":"offline-budget-pco-demo", "total":output.total, "proof":proof_digest.to_hex(),
            "authorization_ref":authorization.to_hex(), "external_action_executed":false
        }))?
    );
    Ok(())
}
