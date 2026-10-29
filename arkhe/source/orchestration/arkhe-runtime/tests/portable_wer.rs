use arkhe_core::{
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::WorkerExecutionRecord,
    Digest32,
};
use arkhe_runtime::portable_wer::{append, WerTrust};
use arkhe_wormgraph::anchor::CheckpointTrust;
use ed25519_dalek::SigningKey;
use std::{fs, path::PathBuf};

struct Fixture {
    dir: PathBuf,
    worker_key: SigningKey,
    log_key: SigningKey,
    trust: WerTrust,
}
impl Fixture {
    fn new() -> Self {
        let dir = std::env::temp_dir().join(format!("arkhe-wer-{}", uuid::Uuid::new_v4()));
        fs::create_dir(&dir).unwrap();
        let worker_key = SigningKey::from_bytes(&[17; 32]);
        let log_key = SigningKey::from_bytes(&[18; 32]);
        let trust = WerTrust {
            worker_public_key: worker_key.verifying_key().to_bytes(),
            checkpoint: CheckpointTrust {
                log_id: [19; 32],
                public_key: log_key.verifying_key().to_bytes(),
                tenant_id: "test".into(),
                stream_id: "pilot-wer".into(),
                minimum_leaf_count: 1,
                maximum_leaf_count: 100,
                earliest_issued_at: 1000,
                latest_issued_at: 2000,
            },
        };
        Self {
            dir,
            worker_key,
            log_key,
            trust,
        }
    }
    fn objects(&self, id: &str) -> (WorkIntent, WorkerExecutionRecord) {
        let intent = WorkIntent {
            requested_by: "fixture".into(),
            intent_type: WorkIntentType::Simulate,
            target: Digest32([1; 32]),
            parameters_digest: Digest32([2; 32]),
            context: vec![],
            context_refs: vec![],
            request_identity: RequestIdentity::new(id.as_bytes()),
            claimed_created_at: 1000,
        };
        let worker = WorkerExecutionRecord {
            classification: None,
            operation: None,
            module_id: "test".into(),
            module_version: "1".into(),
            input_digest: intent.digest(),
            output_digest: Digest32([3; 32]),
            evidence_refs: vec![],
            confidence_bps: None,
            uncertainty_note: None,
            execution_id: id.into(),
        };
        (intent, worker)
    }
    fn add(&self, id: &str) -> arkhe_runtime::portable_wer::PortableWer {
        let (i, w) = self.objects(id);
        append(
            &self.dir.join("journal.jsonl"),
            i,
            w,
            &self.worker_key,
            &self.log_key,
            &self.trust,
            1500,
        )
        .unwrap()
    }
}
impl Drop for Fixture {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.dir);
    }
}

#[test]
fn roundtrip_and_multi_peak_mmr_verify_offline() {
    let f = Fixture::new();
    for n in 0..7 {
        let b = f.add(&n.to_string());
        b.verify(&f.trust).unwrap();
        assert_eq!(b.leaf_index, n);
    }
}
#[test]
fn altered_worker_intent_signature_and_position_are_rejected() {
    let f = Fixture::new();
    let b = f.add("one");
    let mut x = b.clone();
    x.signed_wer.worker.output_digest = Digest32([9; 32]);
    assert!(x.verify(&f.trust).is_err());
    let mut x = b.clone();
    x.signed_wer.intent.requested_by = "other".into();
    assert!(x.verify(&f.trust).is_err());
    let mut x = b.clone();
    x.signed_wer.signature_hex = "00".repeat(64);
    assert!(x.verify(&f.trust).is_err());
    let mut x = b;
    x.leaf_index = 1;
    assert!(x.verify(&f.trust).is_err());
}
#[test]
fn untrusted_keys_scope_and_stale_checkpoint_are_rejected() {
    let f = Fixture::new();
    let b = f.add("one");
    let mut t = f.trust.clone();
    t.worker_public_key = [0; 32];
    assert!(b.verify(&t).is_err());
    let mut t = f.trust.clone();
    t.checkpoint.public_key = SigningKey::from_bytes(&[21; 32]).verifying_key().to_bytes();
    assert!(b.verify(&t).is_err());
    let mut t = f.trust.clone();
    t.checkpoint.tenant_id = "other".into();
    assert!(b.verify(&t).is_err());
    let mut t = f.trust.clone();
    t.checkpoint.earliest_issued_at = 1600;
    assert!(b.verify(&t).is_err());
    let mut t = f.trust.clone();
    t.checkpoint.minimum_leaf_count = 2;
    assert!(b.verify(&t).is_err());
}
#[test]
fn duplicate_run_and_binding_mismatch_do_not_append() {
    let f = Fixture::new();
    f.add("one");
    let path = f.dir.join("journal.jsonl");
    let old = fs::read(&path).unwrap();
    let (i, w) = f.objects("one");
    assert!(append(&path, i, w, &f.worker_key, &f.log_key, &f.trust, 1500).is_err());
    let (i, mut w) = f.objects("two");
    w.input_digest = Digest32::ZERO;
    assert!(append(&path, i, w, &f.worker_key, &f.log_key, &f.trust, 1500).is_err());
    assert_eq!(old, fs::read(path).unwrap());
}
#[test]
fn modified_prefix_partial_tail_and_lock_fail_closed() {
    let f = Fixture::new();
    f.add("one");
    let path = f.dir.join("journal.jsonl");
    let old = fs::read(&path).unwrap();
    fs::write(path.with_extension("lock"), b"locked").unwrap();
    let (i, w) = f.objects("two");
    assert!(append(&path, i, w, &f.worker_key, &f.log_key, &f.trust, 1500).is_err());
    fs::remove_file(path.with_extension("lock")).unwrap();
    let mut broken = old.clone();
    broken.pop();
    fs::write(&path, broken).unwrap();
    let (i, w) = f.objects("two");
    assert!(append(&path, i, w, &f.worker_key, &f.log_key, &f.trust, 1500).is_err());
    let mut text = String::from_utf8(old).unwrap();
    text = text.replace("fixture", "changed");
    fs::write(&path, text).unwrap();
    let (i, w) = f.objects("two");
    assert!(append(&path, i, w, &f.worker_key, &f.log_key, &f.trust, 1500).is_err());
}
#[test]
fn retained_floor_detects_tail_truncation() {
    let mut f = Fixture::new();
    f.add("one");
    let path = f.dir.join("journal.jsonl");
    let first = fs::read(&path).unwrap();
    f.add("two");
    f.trust.checkpoint.minimum_leaf_count = 2;
    fs::write(&path, first).unwrap();
    let (i, w) = f.objects("three");
    assert!(append(&path, i, w, &f.worker_key, &f.log_key, &f.trust, 1500).is_err());
}
