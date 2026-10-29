//! Synthetic attestation fixtures: no hardware validation is claimed.
use arkhe_bugbounty::{postgres::WorkerVerifier, workload::*};
use arkhe_core::{worker::WorkerExecutionRecord, Digest32};
use async_trait::async_trait;
use std::collections::BTreeMap;
struct Receipt;
#[async_trait]
impl WorkloadReceiptVerifier for Receipt {
    async fn verify_with_key(
        &self,
        _: &WorkerExecutionRecord,
        key: [u8; 32],
    ) -> Result<(), String> {
        if key == key_bytes() {
            Ok(())
        } else {
            Err("wrong key".into())
        }
    }
}
struct Artifact(bool);
#[async_trait]
impl ArtifactReader for Artifact {
    async fn bytes(&self, _: &str, _: &str) -> Result<Vec<u8>, String> {
        Ok(if self.0 {
            b"artifact".to_vec()
        } else {
            b"tampered".to_vec()
        })
    }
}
struct Clock;
impl AttestationClock for Clock {
    fn now_ms(&self) -> i64 {
        1000
    }
}
struct Fixture {
    mode: u8,
}
#[async_trait]
impl WorkloadAttestation for Fixture {
    async fn verify(&self, binding: Digest32) -> Result<VerifiedWorkload, String> {
        if self.mode == 1 {
            return Err("untrusted native chain".into());
        }
        let mut m = measurements();
        if self.mode == 2 {
            m.insert("PCR1".into(), vec![9; 48]);
        }
        Ok(VerifiedWorkload {
            platform: if self.mode == 3 {
                TeePlatform::Tdx
            } else {
                TeePlatform::Nitro
            },
            measurements: m,
            report_data: if self.mode == 4 {
                Digest32::ZERO
            } else {
                binding
            },
            issued_at_ms: if self.mode == 5 { 1 } else { 900 },
            expires_at_ms: if self.mode == 6 { 999 } else { 1100 },
        })
    }
}
fn key_bytes() -> [u8; 32] {
    ed25519_dalek::SigningKey::from_bytes(&[7; 32])
        .verifying_key()
        .to_bytes()
}
fn measurements() -> BTreeMap<String, Vec<u8>> {
    ["PCR0", "PCR1", "PCR2"]
        .into_iter()
        .map(|s| (s.into(), vec![1; 48]))
        .collect()
}
fn policy() -> WorkloadPolicy {
    WorkloadPolicy {
        tenant: "a".into(),
        platform: TeePlatform::Nitro,
        measurements: measurements(),
        artifact_digest: Digest32::blake3(b"", b"artifact"),
        max_age_ms: 200,
    }
}
fn record() -> WorkerExecutionRecord {
    WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "a".into(),
        module_version: "1".into(),
        input_digest: Digest32::ZERO,
        output_digest: Digest32::ZERO,
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: "one".into(),
    }
}
#[tokio::test]
async fn rejects_native_failure_measurement_platform_binding_expiry_and_artifact_mismatch() {
    for mode in 0..7 {
        let v = AttestedWorkerVerifier::new(
            Receipt,
            Fixture { mode },
            Artifact(true),
            Clock,
            policy(),
            key_bytes(),
        )
        .unwrap();
        assert_eq!(v.verify(&record()).await.is_ok(), mode == 0, "mode {mode}");
    }
    let v = AttestedWorkerVerifier::new(
        Receipt,
        Fixture { mode: 0 },
        Artifact(false),
        Clock,
        policy(),
        key_bytes(),
    )
    .unwrap();
    assert!(v.verify(&record()).await.is_err());
}
#[test]
fn rejects_missing_or_debug_pcr_and_binds_record_tenant_key_artifact() {
    let mut p = policy();
    p.measurements.remove("PCR2");
    assert!(AttestedWorkerVerifier::new(
        Receipt,
        Fixture { mode: 0 },
        Artifact(true),
        Clock,
        p,
        key_bytes()
    )
    .is_err());
    let mut p = policy();
    p.measurements.insert("PCR1".into(), vec![0; 48]);
    assert!(AttestedWorkerVerifier::new(
        Receipt,
        Fixture { mode: 0 },
        Artifact(true),
        Clock,
        p,
        key_bytes()
    )
    .is_err());
    let v = AttestedWorkerVerifier::new(
        Receipt,
        Fixture { mode: 0 },
        Artifact(true),
        Clock,
        policy(),
        key_bytes(),
    )
    .unwrap();
    let base = v.binding(&record());
    let mut r = record();
    r.execution_id = "two".into();
    assert_ne!(base, v.binding(&r));
    let mut p = policy();
    p.tenant = "b".into();
    let v = AttestedWorkerVerifier::new(
        Receipt,
        Fixture { mode: 0 },
        Artifact(true),
        Clock,
        p,
        key_bytes(),
    )
    .unwrap();
    assert_ne!(base, v.binding(&record()));
    let mut p = policy();
    p.artifact_digest = Digest32([8; 32]);
    let v = AttestedWorkerVerifier::new(
        Receipt,
        Fixture { mode: 0 },
        Artifact(true),
        Clock,
        p,
        key_bytes(),
    )
    .unwrap();
    assert_ne!(base, v.binding(&record()));
    let k = ed25519_dalek::SigningKey::from_bytes(&[8; 32])
        .verifying_key()
        .to_bytes();
    let v = AttestedWorkerVerifier::new(
        Receipt,
        Fixture { mode: 0 },
        Artifact(true),
        Clock,
        policy(),
        k,
    )
    .unwrap();
    assert_ne!(base, v.binding(&record()));
}
