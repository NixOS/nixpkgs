//! Opt-in real-evidence harness. No native TEE verifier is bundled here.
#![cfg(feature = "workload-integration")]
use arkhe_bugbounty::{postgres::WorkerVerifier, provenance::*, workload::*};
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    worker::WorkerExecutionRecord,
    Digest32,
};
use async_trait::async_trait;
use serde::Deserialize;
use std::{
    collections::BTreeMap,
    io::Read,
    path::PathBuf,
    process::{Command, Stdio},
    time::{Duration, Instant, SystemTime, UNIX_EPOCH},
};
#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Manifest {
    tenant: String,
    platform: String,
    measurements: BTreeMap<String, String>,
    artifact: PathBuf,
    artifact_blake3: String,
    verifier: PathBuf,
    verifier_blake3: String,
    roots: PathBuf,
    roots_blake3: String,
    evidence: PathBuf,
    record: PathBuf,
    receipt: PathBuf,
    trusted_key: PathBuf,
    max_age_ms: i64,
}
#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct NativeClaims {
    platform: String,
    measurements: BTreeMap<String, String>,
    report_data: String,
    issued_at_ms: i64,
    expires_at_ms: i64,
}
fn platform(s: &str) -> Result<TeePlatform, String> {
    match s {
        "nitro" => Ok(TeePlatform::Nitro),
        "tdx" => Ok(TeePlatform::Tdx),
        "sev-snp" => Ok(TeePlatform::SevSnp),
        _ => Err("unsupported platform".into()),
    }
}
fn digest(s: &str) -> Result<Digest32, String> {
    let b = hex::decode(s).map_err(|_| "invalid digest hex")?;
    Ok(Digest32(
        b.try_into().map_err(|_| "digest must be 32 bytes")?,
    ))
}
fn measurements(m: &BTreeMap<String, String>) -> Result<BTreeMap<String, Vec<u8>>, String> {
    m.iter()
        .map(|(k, v)| {
            Ok((
                k.clone(),
                hex::decode(v).map_err(|_| "invalid measurement hex")?,
            ))
        })
        .collect()
}
fn read_json<T: serde::de::DeserializeOwned>(p: &PathBuf) -> T {
    assert!(p.is_absolute(), "all manifest paths must be absolute");
    serde_json::from_slice(&std::fs::read(p).expect("read input")).expect("valid input JSON")
}
fn pinned(p: &PathBuf, expected: &str) -> Result<(), String> {
    if !p.is_absolute() {
        return Err("absolute path required".into());
    }
    let bytes = std::fs::read(p).map_err(|_| "missing pinned file")?;
    if Digest32::blake3(b"", &bytes) != digest(expected)? {
        return Err("file pin mismatch".into());
    }
    Ok(())
}
struct Native {
    program: PathBuf,
    program_digest: String,
    roots: PathBuf,
    roots_digest: String,
    evidence: PathBuf,
}
#[async_trait]
impl WorkloadAttestation for Native {
    async fn verify(&self, binding: Digest32) -> Result<VerifiedWorkload, String> {
        pinned(&self.program, &self.program_digest)?;
        pinned(&self.roots, &self.roots_digest)?;
        if !self.evidence.is_absolute() {
            return Err("absolute evidence path required".into());
        }
        let mut command = Command::new(&self.program);
        command
            .args(["--evidence"])
            .arg(&self.evidence)
            .arg("--roots")
            .arg(&self.roots)
            .arg("--expected-binding")
            .arg(binding.to_hex())
            .stdin(Stdio::null())
            .stdout(Stdio::piped())
            .stderr(Stdio::null());
        #[cfg(windows)]
        {
            use std::os::windows::process::CommandExt;
            command.creation_flags(0x08000000);
        }
        let mut child = command
            .spawn()
            .map_err(|_| "native verifier could not start")?;
        let stdout = child.stdout.take().ok_or("missing verifier output")?;
        let reader = std::thread::spawn(move || {
            let mut bytes = Vec::new();
            stdout
                .take(1_048_577)
                .read_to_end(&mut bytes)
                .map(|_| bytes)
        });
        let start = Instant::now();
        let status = loop {
            match child.try_wait() {
                Ok(Some(s)) => break s,
                Ok(None) if start.elapsed() < Duration::from_secs(30) => {
                    std::thread::sleep(Duration::from_millis(10))
                }
                _ => {
                    let _ = child.kill();
                    let _ = child.wait();
                    let _ = reader.join();
                    return Err("native verifier timeout or process error".into());
                }
            }
        };
        let bytes = reader
            .join()
            .map_err(|_| "native reader panic")?
            .map_err(|_| "native output read failed")?;
        if !status.success() || bytes.len() > 1_048_576 {
            return Err("native evidence verification rejected".into());
        }
        let claims: NativeClaims =
            serde_json::from_slice(&bytes).map_err(|_| "invalid native claims")?;
        Ok(VerifiedWorkload {
            platform: platform(&claims.platform)?,
            measurements: measurements(&claims.measurements)?,
            report_data: digest(&claims.report_data)?,
            issued_at_ms: claims.issued_at_ms,
            expires_at_ms: claims.expires_at_ms,
        })
    }
}
struct Artifact(PathBuf);
#[async_trait]
impl ArtifactReader for Artifact {
    async fn bytes(&self, _: &str, _: &str) -> Result<Vec<u8>, String> {
        if !self.0.is_absolute() {
            return Err("absolute artifact required".into());
        }
        std::fs::read(&self.0).map_err(|_| "artifact unavailable".into())
    }
}
struct Clock;
impl AttestationClock for Clock {
    fn now_ms(&self) -> i64 {
        SystemTime::now()
            .duration_since(UNIX_EPOCH)
            .unwrap()
            .as_millis()
            .try_into()
            .unwrap()
    }
}
struct Receipts(SignedWorkerReceipt);
#[async_trait]
impl ReceiptReader for Receipts {
    async fn receipts(&self, _: Digest32) -> Result<Vec<SignedWorkerReceipt>, String> {
        Ok(vec![self.0.clone()])
    }
}
struct NoParents;
#[async_trait]
impl EvidenceReader for NoParents {
    async fn get(&self, _: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(None)
    }
}
#[tokio::test]
async fn real_workload_evidence_binds_native_measurements_artifact_and_signed_record() {
    let path = std::env::var("ARKHE_WORKLOAD_MANIFEST")
        .expect("real workload manifest required; no mock fallback");
    let m: Manifest = read_json(&PathBuf::from(path));
    let record: WorkerExecutionRecord = read_json(&m.record);
    // Initial qualification is an analysis root; never fake admitted parent evidence.
    assert!(
        record.evidence_refs.is_empty(),
        "use a root analysis fixture without parents"
    );
    let receipt: SignedWorkerReceipt = read_json(&m.receipt);
    let key: TrustedWorkerKey = read_json(&m.trusted_key);
    assert!(
        !key.require_admitted_input,
        "harness has no admitted-parent database reader"
    );
    let public_key = key.public_key;
    let verifier = AttestedWorkerVerifier::new(
        SignedWorkerVerifier::new(m.tenant.clone(), vec![key], Receipts(receipt), NoParents)
            .unwrap(),
        Native {
            program: m.verifier,
            program_digest: m.verifier_blake3,
            roots: m.roots,
            roots_digest: m.roots_blake3,
            evidence: m.evidence,
        },
        Artifact(m.artifact),
        Clock,
        WorkloadPolicy {
            tenant: m.tenant,
            platform: platform(&m.platform).unwrap(),
            measurements: measurements(&m.measurements).unwrap(),
            artifact_digest: digest(&m.artifact_blake3).unwrap(),
            max_age_ms: m.max_age_ms,
        },
        public_key,
    )
    .unwrap();
    // Emit binding for an external attester to reproduce; this hash contains no secrets.
    println!(
        "required_report_data={}",
        verifier.binding(&record).to_hex()
    );
    verifier
        .verify(&record)
        .await
        .expect("native evidence and real receipt must verify");
    let mut tampered = record.clone();
    tampered.execution_id.push_str(":tampered");
    assert!(
        verifier.verify(&tampered).await.is_err(),
        "evidence must reject changed WER"
    );
    println!("PASS external-verifier workload evidence; no inference, upstream write or payment");
}
