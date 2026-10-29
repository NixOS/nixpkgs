//! Explicit synthetic probe run in separate processes before/after PostgreSQL restart.
use arkhe_bugbounty::{
    postgres::{PgKernel, PgOperations, WorkerVerifier},
    Claim, Journal, Kernel,
};
use arkhe_core::{
    evidence::EvidenceReader,
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    CanonicalEncode, Digest32,
};
use async_trait::async_trait;
struct Pinned(Digest32);
#[async_trait]
impl WorkerVerifier for Pinned {
    async fn verify(&self, r: &WorkerExecutionRecord) -> Result<(), String> {
        if r.digest() == self.0 {
            Ok(())
        } else {
            Err("probe receipt mismatch".into())
        }
    }
}
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = std::env::var("DATABASE_URL")?;
    let tenant = std::env::var("ARKHE_PROBE_TENANT")?;
    let mode = std::env::args().nth(1).ok_or("seed or check required")?;
    let i = WorkIntent {
        requested_by: "synthetic-restart-probe".into(),
        intent_type: WorkIntentType::TriageReport,
        target: Digest32::blake3(b"probe-target", b"1"),
        parameters_digest: Digest32::blake3(b"probe-params", b"1"),
        context: vec![],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"probe-request"),
        claimed_created_at: 0,
    };
    let r = WorkerExecutionRecord {
        classification: None,
        module_id: "synthetic-restart-probe".into(),
        module_version: "1".into(),
        operation: Some(CognitiveOperation::Execute),
        input_digest: i.target,
        output_digest: i.parameters_digest,
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: Some("synthetic storage probe; no external operation".into()),
        execution_id: i.operation_id().to_hex(),
    };
    let j = PgOperations::connect(&url, &tenant).await?;
    let k = PgKernel::connect(&url, &tenant, Pinned(r.digest())).await?;
    if mode == "seed" {
        let owner = match j.claim(&i).await? {
            Claim::Acquired(o) => o,
            _ => return Err("probe tenant was not empty".into()),
        };
        k.admit(&r).await?;
        j.mark_dispatched(&i, owner).await?;
        j.complete(&i, owner, &r).await?;
    } else if mode == "check" {
        match j.claim(&i).await? {
            Claim::Replay(w) if w.digest() == r.digest() => (),
            _ => return Err("journal did not survive restart".into()),
        }
        if k.get(r.digest()).await?.is_none()
            || k.canonical_worker(r.digest()).await?.as_deref()
                != Some(r.canonical_bytes().as_slice())
        {
            return Err("evidence did not survive restart".into());
        }
    } else {
        return Err("seed or check required".into());
    }
    println!("PASS {mode}: journal and verified evidence {tenant}");
    Ok(())
}
