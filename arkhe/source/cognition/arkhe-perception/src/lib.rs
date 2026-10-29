use arkhe_cognition_sdk::{worker::WorkerExecutionRecord, Digest32};

pub struct Observation {
    pub input_digest: Digest32,
    pub representation_digest: Digest32,
    pub encoder_attestation: Option<Digest32>,
}

pub fn observe(
    input: &[u8],
    encoder_attestation: Option<Digest32>,
) -> (Observation, WorkerExecutionRecord) {
    let input_digest = Digest32::blake3(b"AKG:PERCEPTION:INPUT:v0\0", input);
    let representation_digest = Digest32::blake3(b"AKG:PERCEPTION:REP:v0\0", input);
    let obs = Observation {
        input_digest,
        representation_digest,
        encoder_attestation,
    };
    let record = WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "arkhe-perception".into(),
        module_version: env!("CARGO_PKG_VERSION").into(),
        input_digest,
        output_digest: representation_digest,
        evidence_refs: encoder_attestation.into_iter().collect(),
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: format!("perception:{}", representation_digest.to_hex()),
    };
    (obs, record)
}
