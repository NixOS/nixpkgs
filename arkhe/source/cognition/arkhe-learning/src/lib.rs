use arkhe_cognition_sdk::{worker::WorkerExecutionRecord, Digest32};

#[derive(Debug, Clone)]
pub struct Proposal {
    pub baseline_ref: Digest32,
    pub candidate_ref: Digest32,
    pub evaluation_ref: Digest32,
    pub rollback_ref: Digest32,
}

pub fn propose(p: Proposal) -> WorkerExecutionRecord {
    let mut b = p.baseline_ref.0.to_vec();
    b.extend_from_slice(&p.candidate_ref.0);
    b.extend_from_slice(&p.evaluation_ref.0);
    b.extend_from_slice(&p.rollback_ref.0);
    let out = Digest32::blake3(b"AKG:LEARNING:PROPOSAL:v0\0", &b);
    WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "arkhe-learning".into(),
        module_version: env!("CARGO_PKG_VERSION").into(),
        input_digest: p.baseline_ref,
        output_digest: out,
        evidence_refs: vec![p.evaluation_ref, p.rollback_ref],
        confidence_bps: None,
        uncertainty_note: Some("proposal only; requires containment review and shadow run".into()),
        execution_id: format!("learn:{}", out.to_hex()),
    }
}
