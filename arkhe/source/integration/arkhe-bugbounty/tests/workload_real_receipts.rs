//! Real receipt verification combined with synthetic attestation claims. No hardware qualification.
use arkhe_bugbounty::{postgres::WorkerVerifier, provenance::*, workload::*};
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use async_trait::async_trait;
use ed25519_dalek::{Signer, SigningKey};
use std::collections::BTreeMap;
struct Receipts(SignedWorkerReceipt);
#[async_trait]
impl ReceiptReader for Receipts {
    async fn receipts(&self, _: Digest32) -> Result<Vec<SignedWorkerReceipt>, String> {
        Ok(vec![self.0.clone()])
    }
}
struct NoEvidence;
#[async_trait]
impl EvidenceReader for NoEvidence {
    async fn get(&self, _: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(None)
    }
}
struct Artifact;
#[async_trait]
impl ArtifactReader for Artifact {
    async fn bytes(&self, _: &str, _: &str) -> Result<Vec<u8>, String> {
        Ok(b"qualified-test-artifact".to_vec())
    }
}
struct Clock;
impl AttestationClock for Clock {
    fn now_ms(&self) -> i64 {
        1000
    }
}
struct SyntheticAttestation {
    missing_native_roots: bool,
}
fn measurements() -> BTreeMap<String, Vec<u8>> {
    ["PCR0", "PCR1", "PCR2"]
        .into_iter()
        .map(|name| (name.into(), vec![1; 48]))
        .collect()
}
#[async_trait]
impl WorkloadAttestation for SyntheticAttestation {
    async fn verify(&self, binding: Digest32) -> Result<VerifiedWorkload, String> {
        if self.missing_native_roots {
            return Err("native platform roots unavailable; no fallback".into());
        }
        Ok(VerifiedWorkload {
            platform: TeePlatform::Nitro,
            measurements: measurements(),
            report_data: binding,
            issued_at_ms: 990,
            expires_at_ms: 1100,
        })
    }
}
#[tokio::test]
async fn attested_wrapper_requires_a_real_receipt_from_the_exact_bound_workload_key() {
    let key = SigningKey::from_bytes(&[91; 32]);
    let record = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Decide),
        module_id: "gov-native-verifier".into(),
        module_version: "test-1".into(),
        input_digest: Digest32::ZERO,
        output_digest: Digest32([1; 32]),
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: "test-only".into(),
    };
    for mode in 0..3 {
        let mut receipt = SignedWorkerReceipt {
            version: 1,
            tenant: "gov-test".into(),
            key_id: "ephemeral-test-key".into(),
            record_hash: record.digest(),
            completed_at_ms: 990,
            outcome: ExecutionOutcome::Succeeded,
            signature_hex: String::new(),
        };
        receipt.signature_hex = hex::encode(key.sign(&receipt.signing_bytes()).to_bytes());
        let trusted = TrustedWorkerKey {
            key_id: receipt.key_id.clone(),
            public_key: key.verifying_key().to_bytes(),
            module_id: record.module_id.clone(),
            module_version: record.module_version.clone(),
            allowed_operations: vec![CognitiveOperation::Decide],
            require_admitted_input: false,
            active: true,
        };
        let verifier = SignedWorkerVerifier::new(
            "gov-test".into(),
            vec![trusted],
            Receipts(receipt),
            NoEvidence,
        )
        .unwrap();
        let workload_key = if mode == 1 {
            SigningKey::from_bytes(&[92; 32]).verifying_key().to_bytes()
        } else {
            key.verifying_key().to_bytes()
        };
        let attested = AttestedWorkerVerifier::new(
            verifier,
            SyntheticAttestation {
                missing_native_roots: mode == 2,
            },
            Artifact,
            Clock,
            WorkloadPolicy {
                tenant: "gov-test".into(),
                platform: TeePlatform::Nitro,
                measurements: measurements(),
                artifact_digest: Digest32::blake3(b"", b"qualified-test-artifact"),
                max_age_ms: 100,
            },
            workload_key,
        )
        .unwrap();
        assert_eq!(
            attested.verify(&record).await.is_ok(),
            mode == 0,
            "mode {mode}"
        );
    }
}
