//! Attestation admission port. No built-in hardware verifier or implicit trust root.
use crate::postgres::WorkerVerifier;
use arkhe_core::{canonical::encode_value, worker::WorkerExecutionRecord, Digest32};
use async_trait::async_trait;
use std::collections::BTreeMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TeePlatform {
    Nitro,
    Tdx,
    SevSnp,
}

pub struct WorkloadPolicy {
    pub tenant: String,
    pub platform: TeePlatform,
    /// Nitro policies must enumerate PCR0, PCR1 and PCR2. No inferred relationships.
    pub measurements: BTreeMap<String, Vec<u8>>,
    pub artifact_digest: Digest32,
    pub max_age_ms: i64,
}

/// Authenticated claims returned only after native chain, signature, debug-mode,
/// revocation/TCB and report-data validation by a trusted platform implementation.
/// A deserialized self-report must never be returned as verified evidence.
pub struct VerifiedWorkload {
    pub platform: TeePlatform,
    pub measurements: BTreeMap<String, Vec<u8>>,
    pub report_data: Digest32,
    pub issued_at_ms: i64,
    pub expires_at_ms: i64,
}

#[async_trait]
pub trait WorkloadAttestation: Send + Sync {
    /// Native evidence must authenticate `binding` as report/user data. Implementations
    /// are trusted dependencies, like WorkerVerifier, and must reject missing roots.
    async fn verify(&self, binding: Digest32) -> Result<VerifiedWorkload, String>;
}
#[async_trait]
pub trait ArtifactReader: Send + Sync {
    /// Bytes from an independently controlled artifact store, not daemon metadata.
    async fn bytes(&self, module: &str, version: &str) -> Result<Vec<u8>, String>;
}
#[async_trait]
pub trait WorkloadReceiptVerifier: Send + Sync {
    async fn verify_with_key(
        &self,
        record: &WorkerExecutionRecord,
        key: [u8; 32],
    ) -> Result<(), String>;
}
pub trait AttestationClock: Send + Sync {
    fn now_ms(&self) -> i64;
}

/// Combines existing receipt/input admission with mandatory workload evidence.
/// Receipt verifier configuration must trust exactly the workload key below;
/// platform evidence binds that key and this particular WER to the artifact.
pub struct AttestedWorkerVerifier<V, A, R, C> {
    receipt: V,
    attestation: A,
    artifacts: R,
    clock: C,
    policy: WorkloadPolicy,
    workload_key: [u8; 32],
}

impl<V, A, R, C> AttestedWorkerVerifier<V, A, R, C> {
    /// The inner verifier is responsible for verifying possession of this exact key.
    /// No keys, native providers or production policies are enabled by default.
    pub fn new(
        receipt: V,
        attestation: A,
        artifacts: R,
        clock: C,
        policy: WorkloadPolicy,
        workload_key: [u8; 32],
    ) -> Result<Self, String> {
        if policy.tenant.trim().is_empty()
            || policy.max_age_ms <= 0
            || policy.measurements.is_empty()
            || policy.measurements.values().any(Vec::is_empty)
            || policy.artifact_digest == Digest32::ZERO
        {
            return Err("incomplete workload policy".into());
        }
        if policy.platform == TeePlatform::Nitro
            && ["PCR0", "PCR1", "PCR2"].iter().any(|p| {
                policy
                    .measurements
                    .get(*p)
                    .is_none_or(|v| v.len() != 48 || v.iter().all(|b| *b == 0))
            })
        {
            return Err("Nitro requires explicit non-debug PCR0/PCR1/PCR2 SHA-384 values".into());
        }
        let key = ed25519_dalek::VerifyingKey::from_bytes(&workload_key)
            .map_err(|_| "invalid workload key")?;
        if key.is_weak() {
            return Err("weak workload key".into());
        }
        Ok(Self {
            receipt,
            attestation,
            artifacts,
            clock,
            policy,
            workload_key,
        })
    }
    pub fn binding(&self, record: &WorkerExecutionRecord) -> Digest32 {
        Digest32::blake3(
            b"AKG:WORKLOAD:BINDING:v1\0",
            &encode_value(&serde_json::json!({
                "tenant": self.policy.tenant,
                "record_hash": record.digest().to_hex(),
                "workload_key": hex::encode(self.workload_key),
                "artifact_digest": self.policy.artifact_digest.to_hex()
            })),
        )
    }
}

#[async_trait]
impl<
        V: WorkloadReceiptVerifier,
        A: WorkloadAttestation,
        R: ArtifactReader,
        C: AttestationClock,
    > WorkerVerifier for AttestedWorkerVerifier<V, A, R, C>
{
    async fn verify(&self, record: &WorkerExecutionRecord) -> Result<(), String> {
        let binding = self.binding(record);
        let claims = self.attestation.verify(binding).await?;
        let now = self.clock.now_ms();
        if claims.platform != self.policy.platform
            || claims.report_data != binding
            || now < 0
            || claims.issued_at_ms < 0
            || claims.issued_at_ms > now
            || claims.expires_at_ms <= now
            || claims.expires_at_ms <= claims.issued_at_ms
            || now.saturating_sub(claims.issued_at_ms) > self.policy.max_age_ms
            || self
                .policy
                .measurements
                .iter()
                .any(|(k, v)| claims.measurements.get(k) != Some(v))
        {
            return Err("workload binding, freshness or measurements rejected".into());
        }
        let bytes = self
            .artifacts
            .bytes(&record.module_id, &record.module_version)
            .await?;
        if Digest32::blake3(b"", &bytes) != self.policy.artifact_digest {
            return Err("independent artifact BLAKE3 mismatch".into());
        }
        self.receipt
            .verify_with_key(record, self.workload_key)
            .await
    }
}
