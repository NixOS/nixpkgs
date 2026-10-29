//! Untrusted transparent proof packaging. The independent gate checker evaluates
//! SPDX/obligations; a producer assertion of compatibility has no authority.
use arkhe_cognition_sdk::{
    formal_proof::*, work::WorkIntent, worker::WorkerExecutionRecord, Digest32,
};

pub fn propose_output(input: &LicenseInput) -> LicenseOutput {
    LicenseOutput {
        compatible: true,
        sbom_digest: input.sbom_digest(),
        artifact_digest: input.artifact_digest(),
    }
}
pub fn prove_license(
    input: LicenseInput,
    spec: &LicensePolicy,
    policy_digest: Digest32,
    intent: &WorkIntent,
    worker: &WorkerExecutionRecord,
) -> ProofCarryingOutput {
    ProofCarryingOutput::License(Box::new(LicenseProof {
        checker: "arkhe/spdx23-obligations/v1".into(),
        policy_digest,
        spec_digest: spec.digest(),
        intent_digest: intent.digest(),
        worker_digest: worker.digest(),
        output: propose_output(&input),
        input,
    }))
}
