use arkhe_cognition_sdk::{worker::WorkerExecutionRecord, Digest32};

pub struct Forecast {
    pub scenario_digest: Digest32,
    pub forecast_digest: Digest32,
    pub uncertainty_bps: u16,
}

pub fn simulate(scenario: &[u8]) -> (Forecast, WorkerExecutionRecord) {
    let scenario_digest = Digest32::blake3(b"AKG:WORLD:SCENARIO:v0\0", scenario);
    // Reference environment deliberately does not claim causal validity.
    let forecast_digest = Digest32::blake3(b"AKG:WORLD:FORECAST:v0\0", scenario);
    let forecast = Forecast {
        scenario_digest,
        forecast_digest,
        uncertainty_bps: 5000,
    };
    let record = WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "arkhe-world-model".into(),
        module_version: env!("CARGO_PKG_VERSION").into(),
        input_digest: scenario_digest,
        output_digest: forecast_digest,
        evidence_refs: vec![],
        confidence_bps: Some(5000),
        uncertainty_note: Some("reference simulator; causal validity not demonstrated".into()),
        execution_id: format!("world:{}", forecast_digest.to_hex()),
    };
    (forecast, record)
}
