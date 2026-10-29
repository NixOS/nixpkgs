use arkhe_cognition_sdk::{work::WorkIntent, worker::WorkerExecutionRecord, Digest32};

pub mod budget_pco;

#[derive(Debug, Clone)]
pub struct PlanStep {
    pub step_id: String,
    pub action: String,
    pub protected: bool,
}

#[derive(Debug, Clone)]
pub struct Plan {
    pub steps: Vec<PlanStep>,
    pub plan_digest: Digest32,
}

pub fn plan(intent: &WorkIntent, steps: Vec<PlanStep>) -> (Plan, WorkerExecutionRecord) {
    let input_digest = intent.digest();
    let repr = steps
        .iter()
        .map(|s| format!("{}:{}:{}", s.step_id, s.action, s.protected))
        .collect::<Vec<_>>()
        .join("|");
    let plan_digest = Digest32::blake3(b"AKG:PLAN:v0\0", repr.as_bytes());
    let plan = Plan { steps, plan_digest };
    let record = WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "arkhe-agent".into(),
        module_version: env!("CARGO_PKG_VERSION").into(),
        input_digest,
        output_digest: plan_digest,
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: Some("plan is a proposal, not authorization".into()),
        execution_id: format!("agent:{}", plan_digest.to_hex()),
    };
    (plan, record)
}
pub mod license_pco;
