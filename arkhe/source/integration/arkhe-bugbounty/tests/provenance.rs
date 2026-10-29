use arkhe_bugbounty::{postgres::WorkerVerifier, provenance::*};
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use async_trait::async_trait;
use ed25519_dalek::{Signer, SigningKey};
use rand_core::{OsRng, RngCore};
use std::collections::HashMap;
#[derive(Default)]
struct Memory(HashMap<Digest32, EvidenceEnvelope>);
#[async_trait]
impl EvidenceReader for Memory {
    async fn get(&self, h: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(self.0.get(&h).cloned())
    }
}
struct Receipts(Vec<SignedWorkerReceipt>);
#[async_trait]
impl ReceiptReader for Receipts {
    async fn receipts(&self, _: Digest32) -> Result<Vec<SignedWorkerReceipt>, String> {
        Ok(self.0.clone())
    }
}
fn key() -> SigningKey {
    let mut seed = [0; 32];
    OsRng.fill_bytes(&mut seed);
    SigningKey::from_bytes(&seed)
}
fn record() -> WorkerExecutionRecord {
    WorkerExecutionRecord {
        classification: None,
        module_id: "trusted-analysis".into(),
        module_version: "1".into(),
        operation: Some(CognitiveOperation::Decide),
        input_digest: Digest32::ZERO,
        output_digest: Digest32([1; 32]),
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: "real-signature-test".into(),
    }
}
fn binding(key: &SigningKey) -> TrustedWorkerKey {
    TrustedWorkerKey {
        key_id: "worker-1".into(),
        public_key: key.verifying_key().to_bytes(),
        module_id: "trusted-analysis".into(),
        module_version: "1".into(),
        allowed_operations: vec![CognitiveOperation::Decide],
        require_admitted_input: false,
        active: true,
    }
}
fn receipt(key: &SigningKey, r: &WorkerExecutionRecord, tenant: &str) -> SignedWorkerReceipt {
    let mut receipt = SignedWorkerReceipt {
        version: 1,
        tenant: tenant.into(),
        key_id: "worker-1".into(),
        record_hash: r.digest(),
        completed_at_ms: 1,
        outcome: ExecutionOutcome::Succeeded,
        signature_hex: String::new(),
    };
    receipt.signature_hex = hex::encode(key.sign(&receipt.signing_bytes()).to_bytes());
    receipt
}
#[tokio::test]
async fn real_ed25519_signature_is_accepted_and_tampering_rejected() {
    let sk = key();
    let r = record();
    let signed = receipt(&sk, &r, "a");
    let v = SignedWorkerVerifier::new(
        "a".into(),
        vec![binding(&sk)],
        Receipts(vec![signed.clone()]),
        Memory::default(),
    )
    .unwrap();
    v.verify(&r).await.unwrap();
    let mut changed = r.clone();
    changed.output_digest = Digest32([7; 32]);
    let mut copied = signed.clone();
    copied.record_hash = changed.digest();
    assert!(v.verify_detached(&changed, &copied).await.is_err());
    for bad in [
        "00".repeat(64),
        "00".repeat(63),
        "not hex".into(),
        "00".repeat(65536),
    ] {
        let mut s = signed.clone();
        s.signature_hex = bad;
        assert!(v.verify_detached(&r, &s).await.is_err());
    }
    let mut failed = signed.clone();
    failed.outcome = ExecutionOutcome::Failed;
    failed.signature_hex = hex::encode(sk.sign(&failed.signing_bytes()).to_bytes());
    assert!(v.verify_detached(&r, &failed).await.is_err());
    let foreign = receipt(&sk, &r, "b");
    assert!(v.verify_detached(&r, &foreign).await.is_err());
    let unknown = receipt(&key(), &r, "a");
    assert!(v.verify_detached(&r, &unknown).await.is_err());
}

#[tokio::test]
async fn typed_classification_is_covered_by_the_detached_ed25519_receipt() {
    let sk = key();
    let mut r = record();
    r.classification = Some(arkhe_core::worker::ClassificationBinding {
        classification_digest: Digest32([3; 32]),
        policy_digest: Digest32([4; 32]),
    });
    let signed = receipt(&sk, &r, "a");
    let verifier = SignedWorkerVerifier::new(
        "a".into(),
        vec![binding(&sk)],
        Receipts(vec![signed.clone()]),
        Memory::default(),
    )
    .unwrap();
    verifier.verify(&r).await.unwrap();
    for change in 0..3 {
        let mut changed = r.clone();
        match change {
            0 => changed.classification = None,
            1 => {
                changed
                    .classification
                    .as_mut()
                    .unwrap()
                    .classification_digest = Digest32([9; 32])
            }
            _ => changed.classification.as_mut().unwrap().policy_digest = Digest32([9; 32]),
        }
        let mut forged = signed.clone();
        forged.record_hash = changed.digest();
        assert!(verifier.verify_detached(&changed, &forged).await.is_err());
    }
}
#[tokio::test]
async fn module_version_operation_and_revocation_are_trust_bound() {
    let sk = key();
    let r = record();
    let signed = receipt(&sk, &r, "a");
    for n in 0..4 {
        let mut b = binding(&sk);
        match n {
            0 => b.active = false,
            1 => b.module_id = "other".into(),
            2 => b.module_version = "2".into(),
            _ => b.allowed_operations = vec![CognitiveOperation::Execute],
        };
        let v = SignedWorkerVerifier::new(
            "a".into(),
            vec![b],
            Receipts(vec![signed.clone()]),
            Memory::default(),
        )
        .unwrap();
        assert!(v.verify(&r).await.is_err());
    }
}
#[tokio::test]
async fn signed_record_cannot_invent_admitted_inputs() {
    let sk = key();
    let mut r = record();
    r.evidence_refs.push(Digest32([4; 32]));
    r.input_digest = Digest32([4; 32]);
    let signed = receipt(&sk, &r, "a");
    let mut b = binding(&sk);
    b.require_admitted_input = true;
    let v = SignedWorkerVerifier::new(
        "a".into(),
        vec![b.clone()],
        Receipts(vec![signed.clone()]),
        Memory::default(),
    )
    .unwrap();
    assert!(v.verify(&r).await.is_err());
    let h = r.input_digest;
    let mut e = Memory::default();
    e.0.insert(
        h,
        EvidenceEnvelope {
            record_hash: h,
            kind: "WorkerExecutionRecord".into(),
            subject: Digest32::ZERO,
            payload_digest: h,
            policy_digest: None,
            causal_parents: vec![],
        },
    );
    SignedWorkerVerifier::new("a".into(), vec![b], Receipts(vec![signed]), e)
        .unwrap()
        .verify(&r)
        .await
        .unwrap();
}
#[cfg(feature = "postgres-integration")]
#[tokio::test]
async fn signed_parent_and_child_admitted_with_real_postgres_reader_after_reconnect() {
    use arkhe_bugbounty::{
        postgres::{PgKernel, PgOperations},
        Kernel,
    };
    use arkhe_core::CanonicalEncode;
    use arkhe_wormgraph::postgres::PgWormGraph;
    let url = std::env::var("ARKHE_TEST_DATABASE_URL").expect("real database required");
    let tenant = format!("signed-{}", uuid::Uuid::new_v4());
    let sk = key();
    let parent = record();
    let make_verifier = || async {
        SignedWorkerVerifier::new(
            tenant.clone(),
            vec![binding(&sk)],
            PgOperations::connect(&url, &tenant).await.unwrap(),
            PgWormGraph::connect(&url, &tenant).await.unwrap(),
        )
        .unwrap()
    };
    let receipts = PgOperations::connect(&url, &tenant).await.unwrap();
    receipts
        .stage_receipt(&receipt(&sk, &parent, &tenant))
        .await
        .unwrap();
    let k = PgKernel::connect(&url, &tenant, make_verifier().await)
        .await
        .unwrap();
    let h = k.admit(&parent).await.unwrap();
    drop(k);
    let mut child = record();
    child.execution_id = "signed-child".into();
    child.input_digest = h;
    child.evidence_refs = vec![h];
    let mut b = binding(&sk);
    b.require_admitted_input = true;
    receipts
        .stage_receipt(&receipt(&sk, &child, &tenant))
        .await
        .unwrap();
    drop(receipts);
    let verifier = SignedWorkerVerifier::new(
        tenant.clone(),
        vec![b.clone()],
        PgOperations::connect(&url, &tenant).await.unwrap(),
        PgWormGraph::connect(&url, &tenant).await.unwrap(),
    )
    .unwrap();
    let k = PgKernel::connect(&url, &tenant, verifier).await.unwrap();
    let ch = k.admit(&child).await.unwrap();
    assert_eq!(
        k.canonical_worker(ch).await.unwrap().unwrap(),
        child.canonical_bytes()
    );
    // A valid signature cannot manufacture an absent parent.
    let mut orphan = child.clone();
    orphan.input_digest = Digest32([9; 32]);
    orphan.evidence_refs = vec![orphan.input_digest];
    orphan.execution_id = "orphan".into();
    let receipts = PgOperations::connect(&url, &tenant).await.unwrap();
    receipts
        .stage_receipt(&receipt(&sk, &orphan, &tenant))
        .await
        .unwrap();
    assert!(k.admit(&orphan).await.is_err());
    assert!(k.get(orphan.digest()).await.unwrap().is_none());
    // A forged signature remains untrusted material and never reaches the graph.
    let mut forged = child.clone();
    forged.execution_id = "forged".into();
    receipts
        .stage_receipt(&receipt(&key(), &forged, &tenant))
        .await
        .unwrap();
    assert!(k.admit(&forged).await.is_err());
    assert!(k.get(forged.digest()).await.unwrap().is_none());
}

#[tokio::test]
async fn workload_receipt_requires_exact_attested_key() {
    use arkhe_bugbounty::workload::WorkloadReceiptVerifier;
    let sk = key();
    let other = key();
    let r = record();
    let v = SignedWorkerVerifier::new(
        "a".into(),
        vec![binding(&sk)],
        Receipts(vec![receipt(&sk, &r, "a")]),
        Memory::default(),
    )
    .unwrap();
    assert!(v
        .verify_with_key(&r, sk.verifying_key().to_bytes())
        .await
        .is_ok());
    assert!(v
        .verify_with_key(&r, other.verifying_key().to_bytes())
        .await
        .is_err());
}
