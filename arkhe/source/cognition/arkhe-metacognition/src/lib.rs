use arkhe_cognition_sdk::{worker::WorkerExecutionRecord, Digest32};

pub mod self_model;

pub struct SelfAssessment {
    pub confidence_bps: Option<u16>,
    pub evidence_coverage_bps: Option<u16>,
    pub uncertainty: String,
}

pub fn assess(
    input_digest: Digest32,
    output_digest: Digest32,
    evidence_refs: Vec<Digest32>,
) -> (SelfAssessment, WorkerExecutionRecord) {
    let assessment = SelfAssessment {
        confidence_bps: None,
        evidence_coverage_bps: None,
        uncertainty: "uncalibrated: references alone establish neither correctness nor coverage"
            .into(),
    };
    let record = WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "arkhe-metacognition".into(),
        module_version: env!("CARGO_PKG_VERSION").into(),
        input_digest,
        output_digest,
        evidence_refs,
        confidence_bps: assessment.confidence_bps,
        uncertainty_note: Some(assessment.uncertainty.clone()),
        execution_id: format!("meta:{}", output_digest.to_hex()),
    };
    (assessment, record)
}
