use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    review::{HumanReviewRecord, HumanVerdict},
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_runtime::preview::{PreviewRequest, PreviewSpec, PreviewTrust};
use async_trait::async_trait;
use ed25519_dalek::{Signer, SigningKey};

pub struct Baseline(pub Digest32);
#[async_trait]
impl EvidenceReader for Baseline {
    async fn get(&self, h: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok((h == self.0).then_some(EvidenceEnvelope {
            record_hash: h,
            kind: "TestBaseline".into(),
            subject: h,
            payload_digest: h,
            policy_digest: None,
            causal_parents: vec![],
        }))
    }
}
pub fn hash(b: u8) -> Digest32 {
    Digest32([b; 32])
}
// Deterministic keys only in test code; never valid deployment trust roots.
pub fn sign(request: &mut PreviewRequest) {
    request.intent.context = request.expected_context();
    request.supervisor_signature = hex::encode(
        SigningKey::from_bytes(&[7; 32])
            .sign(&request.supervisor_signing_bytes())
            .to_bytes(),
    );
    request.reviewer_signature = hex::encode(
        SigningKey::from_bytes(&[8; 32])
            .sign(&request.reviewer_signing_bytes())
            .to_bytes(),
    );
}
pub fn fixture(now: i64) -> (PreviewRequest, PreviewTrust, Baseline) {
    let mut trust = PreviewTrust {
        tenant: "preview-test".into(),
        requested_by: "builder".into(),
        reviewer: "governor".into(),
        reviewer_key: SigningKey::from_bytes(&[8; 32]).verifying_key().to_bytes(),
        supervisor_key: SigningKey::from_bytes(&[7; 32]).verifying_key().to_bytes(),
        supervisor_module: "preview-supervisor".into(),
        supervisor_version: "1".into(),
        policy_digest: hash(5),
        image: format!("sha256:{}", "a".repeat(64)),
        runtime_profile: hash(6),
        allowed_modules: vec!["arkhe-agent".into()],
        max_age_seconds: 300,
        emergency_stop: false,
    };
    trust.policy_digest = trust.digest();
    let spec = PreviewSpec {
        cockpit_binding: None,
        version: 1,
        tenant: trust.tenant.clone(),
        baseline_digest: hash(1),
        proposal_digest: hash(2),
        artifact_digest: hash(3),
        image: trust.image.clone(),
        runtime_profile: trust.runtime_profile,
        module: "arkhe-agent".into(),
    };
    let intent = WorkIntent {
        requested_by: trust.requested_by.clone(),
        intent_type: WorkIntentType::ReleaseSoftware,
        target: spec.baseline_digest,
        parameters_digest: spec.digest(),
        context: vec![],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"fixture-operation"),
        claimed_created_at: now - 20,
    };
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Execute),
        module_id: trust.supervisor_module.clone(),
        module_version: "1".into(),
        input_digest: spec.baseline_digest,
        output_digest: spec.digest(),
        evidence_refs: vec![spec.baseline_digest],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: intent.operation_id().to_hex(),
    };
    let review = HumanReviewRecord {
        requested_by: intent.requested_by.clone(),
        operation_id: intent.operation_id(),
        parameters_digest: spec.digest(),
        analysis_digest: worker.digest(),
        policy_digest: trust.policy_digest,
        routing_digest: PreviewRequest::route(trust.policy_digest).digest(),
        reviewer: trust.reviewer.clone(),
        verdict: HumanVerdict::Approve,
        reviewed_at: now - 5,
        expires_at: now + 200,
    };
    let mut request = PreviewRequest {
        spec,
        intent,
        worker,
        completed_at: now - 10,
        supervisor_signature: String::new(),
        review,
        reviewer_signature: String::new(),
    };
    sign(&mut request);
    (request, trust, Baseline(hash(1)))
}
