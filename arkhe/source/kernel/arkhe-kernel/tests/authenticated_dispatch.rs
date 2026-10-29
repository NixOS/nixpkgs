#![cfg(feature = "sqlite-broker")]
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    work::*,
    worker::*,
    Digest32,
};
use arkhe_governance::{authenticated::AuthenticatedResolver, *};
use arkhe_kernel::{
    authenticated_transport::AuthenticatedEvidence, broker::*, broker_sqlite::*,
    AuthorizationDecision, ContainmentGate,
};
use arkhe_verify_core::{
    action_proof::*,
    mmr::{build_root_and_proof, profile::PROFILE_DIGEST_HEX},
    policy::{self, Action, Context, Intent, Request, SignedIntent, WorkerRecord},
};
use async_trait::async_trait;
use ed25519_dalek::{Signer, SigningKey};
use std::{
    collections::{BTreeMap, BTreeSet},
    path::PathBuf,
    sync::{
        atomic::{AtomicUsize, Ordering},
        Arc, Barrier,
    },
};

struct Allow;
impl PolicyResolver for Allow {
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        PolicyVerdict::Allow
    }
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec!["test".into()],
            allowed_operations: vec![CognitiveOperation::Analyze],
        })
    }
}
struct Store(EvidenceEnvelope);
#[async_trait]
impl EvidenceReader for Store {
    async fn get(&self, h: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok((self.0.record_hash == h).then(|| self.0.clone()))
    }
}
struct Fixture {
    intent: WorkIntent,
    worker: WorkerExecutionRecord,
    policy: PolicyBinding,
    store: Store,
    request: Vec<u8>,
    proof: ActionProof,
    trust: Trust,
    ctx: Context,
}
fn fixture(target: u8) -> Fixture {
    let now = std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .unwrap()
        .as_secs() as i64;
    fixture_at(target, now)
}
fn fixture_at(target: u8, now: i64) -> Fixture {
    let pkey = SigningKey::from_bytes(&[7; 32]);
    let wkey = SigningKey::from_bytes(&[8; 32]);
    let rules = policy::Policy {
        policy_id: "legacy-auth-v1".into(),
        max_amount_cents: 100_000,
        allowed: BTreeSet::from([("test".into(), "1".into())]),
    };
    let ctx = Context {
        policy: rules,
        audience: "legacy-host".into(),
        now,
        principal_keys: BTreeMap::from([("operator".into(), pkey.verifying_key().to_bytes())]),
        worker_keys: BTreeMap::from([("worker".into(), wkey.verifying_key().to_bytes())]),
    };
    let policy = PolicyBinding {
        policy_id: "legacy-auth-v1".into(),
        version: 1,
        policy_digest: Digest32(ctx.policy.digest()),
    };
    let mut intent = WorkIntent {
        requested_by: "operator".into(),
        intent_type: WorkIntentType::ApproveExpense,
        target: Digest32([target; 32]),
        parameters_digest: Digest32::ZERO,
        context: vec![],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"same-caller-nonce"),
        claimed_created_at: now,
    };
    let action = Action {
        operation_id: intent.operation_id().to_hex(),
        amount_cents: 42,
        module_id: "test".into(),
        module_version: "1".into(),
        payload: br#"{"payee":"vendor-a"}"#.to_vec(),
    };
    intent.parameters_digest = policy::legacy_parameters_digest(&action);
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Analyze),
        module_id: "test".into(),
        module_version: "1".into(),
        input_digest: Digest32([1; 32]),
        output_digest: intent.parameters_digest,
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: "legacy-1".into(),
    };
    intent.context = vec![
        ContextEntry {
            kind: ContextKind::SourceReport,
            hash: worker.input_digest,
        },
        ContextEntry {
            kind: ContextKind::AnalysisRecord,
            hash: worker.digest(),
        },
    ];
    let signed = Intent {
        principal_id: "operator".into(),
        audience: ctx.audience.clone(),
        policy_digest: ctx.policy.digest(),
        not_before: now - 5,
        expires_at: now + 3600,
        action: action.clone(),
    };
    let mut record = WorkerRecord {
        worker_id: "worker".into(),
        action: action.clone(),
        intent_digest: signed.digest(),
        signature: vec![],
    };
    record.signature = wkey.sign(&record.signed_message()).to_bytes().to_vec();
    let request = Request {
        action,
        parameters_digest: signed.digest(),
        record_hash: record.digest(),
        worker_record: record,
        signed_intent: SignedIntent {
            signature: pkey.sign(&signed.signed_message()).to_bytes().to_vec(),
            intent: signed,
        },
    };
    let m = Mandate {
        profile: PROFILE.into(),
        requested_by: intent.requested_by.clone(),
        intent_type: intent.intent_type.clone(),
        operation_id: intent.operation_id(),
        target: intent.target,
        policy_digest: policy.policy_digest,
        allowed_parameters: vec![intent.parameters_digest],
        issued_at: now - 3,
        expires_at: now + 3600,
    };
    let key = SigningKey::from_bytes(&[11; 32]);
    let log = SigningKey::from_bytes(&[12; 32]);
    let payload = mandate_bytes(&m).unwrap();
    let (root, steps) = build_root_and_proof(std::slice::from_ref(&payload), 0).unwrap();
    let c = Checkpoint {
        profile_digest: PROFILE_DIGEST_HEX.into(),
        root,
        leaf_count: 1,
        issued_at: now - 1,
    };
    let proof = ActionProof {
        mandate: m,
        mandate_signature: key.sign(&payload).to_bytes().to_vec(),
        checkpoint_signature: log.sign(&checkpoint_bytes(&c).unwrap()).to_bytes().to_vec(),
        checkpoint: c.clone(),
        leaf_index: 0,
        steps,
    };
    let trust = Trust {
        mandate_key: key.verifying_key(),
        log_key: log.verifying_key(),
        policy_digest: policy.policy_digest,
        checkpoint: c,
        now,
        max_checkpoint_age: 100,
    };
    let store = Store(EvidenceEnvelope {
        record_hash: worker.digest(),
        kind: "WorkerExecutionRecord".into(),
        subject: worker.input_digest,
        payload_digest: worker.digest(),
        policy_digest: None,
        causal_parents: vec![],
    });
    Fixture {
        intent,
        worker,
        policy,
        store,
        request: serde_json::to_vec(&request).unwrap(),
        proof,
        trust,
        ctx,
    }
}
struct Effect {
    calls: Arc<AtomicUsize>,
    fail: bool,
    panic: bool,
}
impl CapabilityExecutor for Effect {
    fn execute(&mut self, _: &WorkIntent) -> Result<Vec<u8>, String> {
        panic!("authenticated broker must never use old executor path")
    }
    fn execute_authenticated(&mut self, i: &WorkIntent, a: &Action) -> Result<Vec<u8>, String> {
        assert_eq!(i.parameters_digest, policy::legacy_parameters_digest(a));
        self.calls.fetch_add(1, Ordering::SeqCst);
        assert!(!self.panic, "injected process failure after effect");
        if self.fail {
            Err("provider outcome unknown".into())
        } else {
            Ok(b"receipt".to_vec())
        }
    }
}
fn db() -> PathBuf {
    std::env::temp_dir().join(format!("arkhe-auth-{}.sqlite", uuid::Uuid::new_v4()))
}
fn broker(
    f: &Fixture,
    path: &std::path::Path,
    calls: Arc<AtomicUsize>,
    fail: bool,
) -> CapabilityBroker<AuthenticatedResolver<Allow>, SqliteDispatchJournal, Effect> {
    CapabilityBroker::new(
        ContainmentGate::new(AuthenticatedResolver::new(Allow, f.ctx.clone())),
        SqliteDispatchJournal::open(path).unwrap(),
        Effect {
            calls,
            fail,
            panic: false,
        },
    )
}
async fn execute(
    b: &mut CapabilityBroker<AuthenticatedResolver<Allow>, SqliteDispatchJournal, Effect>,
    f: &Fixture,
) -> Result<Vec<u8>, String> {
    let e = AuthenticatedEvidence {
        source: &f.store,
        worker: f.worker.digest(),
        request: &f.request,
    };
    b.execute(&f.intent, &f.worker, &f.policy, &e, &f.proof, &f.trust)
        .await
}

#[tokio::test]
async fn existing_broker_automatically_requires_proof_and_replays_after_restart() {
    let f = fixture(3);
    let path = db();
    let calls = Arc::new(AtomicUsize::new(0));
    let mut b = broker(&f, &path, calls.clone(), false);
    assert!(b
        .execute(&f.intent, &f.worker, &f.policy, &f.store, &f.proof, &f.trust)
        .await
        .is_err());
    assert_eq!(execute(&mut b, &f).await.unwrap(), b"receipt");
    drop(b);
    let mut b = broker(&f, &path, calls.clone(), false);
    assert_eq!(execute(&mut b, &f).await.unwrap(), b"receipt");
    assert_eq!(calls.load(Ordering::SeqCst), 1);
    let gate = ContainmentGate::new(AuthenticatedResolver::new(Allow, f.ctx.clone()));
    assert!(matches!(
        gate.authorize(&f.intent, Some(&f.worker), &f.policy),
        AuthorizationDecision::Reject { .. }
    ));
}

#[tokio::test]
async fn valid_signatures_cannot_bind_different_legacy_parameters() {
    let mut f = fixture(3);
    let mut request: Request = serde_json::from_slice(&f.request).unwrap();
    request.action.amount_cents = 43;
    request.signed_intent.intent.action = request.action.clone();
    request.signed_intent.signature = SigningKey::from_bytes(&[7; 32])
        .sign(&request.signed_intent.intent.signed_message())
        .to_bytes()
        .to_vec();
    request.parameters_digest = request.signed_intent.intent.digest();
    request.worker_record.action = request.action.clone();
    request.worker_record.intent_digest = request.parameters_digest;
    request.worker_record.signature = SigningKey::from_bytes(&[8; 32])
        .sign(&request.worker_record.signed_message())
        .to_bytes()
        .to_vec();
    request.record_hash = request.worker_record.digest();
    assert!(policy::evaluate(&request, &f.ctx).is_ok());
    f.request = serde_json::to_vec(&request).unwrap();
    let calls = Arc::new(AtomicUsize::new(0));
    let mut b = broker(&f, &db(), calls.clone(), false);
    assert!(execute(&mut b, &f)
        .await
        .unwrap_err()
        .contains("does not bind legacy"));
    assert_eq!(calls.load(Ordering::SeqCst), 0);
}

#[tokio::test]
async fn failed_receipt_commit_leaves_external_effect_uncertain() {
    let f = fixture(3);
    let path = db();
    let calls = Arc::new(AtomicUsize::new(0));
    let mut b = broker(&f, &path, calls.clone(), false);
    let c = rusqlite::Connection::open(&path).unwrap();
    c.execute_batch("CREATE TRIGGER fail_completion BEFORE UPDATE OF status ON broker_dispatch WHEN NEW.status='COMPLETED' BEGIN SELECT RAISE(ABORT,'injected completion failure'); END;").unwrap();
    assert!(execute(&mut b, &f)
        .await
        .unwrap_err()
        .contains("injected completion failure"));
    drop(b);
    let mut b = broker(&f, &path, calls.clone(), false);
    assert!(execute(&mut b, &f)
        .await
        .unwrap_err()
        .contains("manual reconciliation"));
    assert_eq!(calls.load(Ordering::SeqCst), 1);
}

#[test]
fn panic_after_external_effect_cannot_redispatch() {
    let f = fixture(3);
    let path = db();
    let calls = Arc::new(AtomicUsize::new(0));
    let mut b = CapabilityBroker::new(
        ContainmentGate::new(AuthenticatedResolver::new(Allow, f.ctx.clone())),
        SqliteDispatchJournal::open(&path).unwrap(),
        Effect {
            calls: calls.clone(),
            fail: false,
            panic: true,
        },
    );
    let rt = tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
        .unwrap();
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(
        || rt.block_on(execute(&mut b, &f))
    ))
    .is_err());
    drop(b);
    let mut b = broker(&f, &path, calls.clone(), false);
    assert!(rt
        .block_on(execute(&mut b, &f))
        .unwrap_err()
        .contains("manual reconciliation"));
    assert_eq!(calls.load(Ordering::SeqCst), 1);
}

#[test]
fn local_transaction_panic_rolls_back_effect_and_consumption() {
    let path = db();
    let mut j = SqliteDispatchJournal::open(&path).unwrap();
    let c = rusqlite::Connection::open(&path).unwrap();
    c.execute_batch("CREATE TABLE effects(value INTEGER)")
        .unwrap();
    assert!(std::panic::catch_unwind(std::panic::AssertUnwindSafe(|| {
        let _ = j.transact_authenticated(
            "actor",
            Digest32([1; 32]),
            Digest32([2; 32]),
            Digest32([3; 32]),
            |tx| -> Result<Vec<u8>, String> {
                tx.execute("INSERT INTO effects VALUES(1)", []).unwrap();
                panic!("injected local crash")
            },
        );
    }))
    .is_err());
    drop(j);
    assert_eq!(
        c.query_row::<i64, _, _>("SELECT count(*) FROM effects", [], |r| r.get(0))
            .unwrap(),
        0
    );
    assert_eq!(
        c.query_row::<i64, _, _>("SELECT count(*) FROM broker_dispatch", [], |r| r.get(0))
            .unwrap(),
        0
    );
    let mut j = SqliteDispatchJournal::open(&path).unwrap();
    assert_eq!(
        j.transact_authenticated(
            "actor",
            Digest32([1; 32]),
            Digest32([2; 32]),
            Digest32([3; 32]),
            |tx| {
                tx.execute("INSERT INTO effects VALUES(1)", []).unwrap();
                Ok(vec![1])
            }
        )
        .unwrap(),
        TransactionalResult::Executed(vec![1])
    );
}

#[tokio::test]
async fn nonce_cannot_be_reused_for_another_signed_target() {
    let f = fixture(3);
    let other = fixture(4);
    let calls = Arc::new(AtomicUsize::new(0));
    let mut b = broker(&f, &db(), calls.clone(), false);
    execute(&mut b, &f).await.unwrap();
    assert!(execute(&mut b, &other)
        .await
        .unwrap_err()
        .contains("nonce already consumed"));
    assert_eq!(calls.load(Ordering::SeqCst), 1);
}

#[tokio::test]
async fn unknown_external_effect_is_never_retried_after_restart() {
    let f = fixture(3);
    let path = db();
    let calls = Arc::new(AtomicUsize::new(0));
    let mut b = broker(&f, &path, calls.clone(), true);
    assert!(execute(&mut b, &f).await.is_err());
    drop(b);
    let mut b = broker(&f, &path, calls.clone(), false);
    assert!(execute(&mut b, &f)
        .await
        .unwrap_err()
        .contains("manual reconciliation"));
    assert_eq!(calls.load(Ordering::SeqCst), 1);
}

#[test]
fn concurrent_connections_dispatch_at_most_once() {
    let path = db();
    drop(SqliteDispatchJournal::open(&path).unwrap());
    let calls = Arc::new(AtomicUsize::new(0));
    let barrier = Arc::new(Barrier::new(2));
    let handles: Vec<_> = (0..2)
        .map(|_| {
            let path = path.clone();
            let calls = calls.clone();
            let barrier = barrier.clone();
            std::thread::spawn(move || {
                let f = fixture(3);
                let mut b = broker(&f, &path, calls, false);
                barrier.wait();
                tokio::runtime::Builder::new_current_thread()
                    .enable_all()
                    .build()
                    .unwrap()
                    .block_on(execute(&mut b, &f))
            })
        })
        .collect();
    let outcomes: Vec<_> = handles.into_iter().map(|h| h.join().unwrap()).collect();
    assert!(outcomes.iter().any(Result::is_ok));
    assert_eq!(calls.load(Ordering::SeqCst), 1);
}

#[test]
#[ignore = "subprocess fault-injection helper, invoked by abrupt_process_exit_preserves_uncertainty"]
fn process_crash_child() {
    struct Abort(std::path::PathBuf);
    impl CapabilityExecutor for Abort {
        fn execute(&mut self, _: &WorkIntent) -> Result<Vec<u8>, String> {
            panic!("wrong path")
        }
        fn execute_authenticated(&mut self, _: &WorkIntent, _: &Action) -> Result<Vec<u8>, String> {
            use std::io::Write;
            let mut file = std::fs::OpenOptions::new()
                .create(true)
                .append(true)
                .open(&self.0)
                .unwrap();
            file.write_all(b"effect\n").unwrap();
            file.sync_all().unwrap();
            std::process::exit(86); // No unwinding/destructors/receipt completion.
        }
    }
    let path = PathBuf::from(std::env::var_os("ARKHE_CRASH_DB").expect("child database"));
    let now = std::env::var("ARKHE_CRASH_NOW").unwrap().parse().unwrap();
    let f = fixture_at(3, now);
    let marker = path.with_extension("effect");
    let mut broker = CapabilityBroker::new(
        ContainmentGate::new(AuthenticatedResolver::new(Allow, f.ctx.clone())),
        SqliteDispatchJournal::open(&path).unwrap(),
        Abort(marker),
    );
    let e = AuthenticatedEvidence {
        source: &f.store,
        worker: f.worker.digest(),
        request: &f.request,
    };
    tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
        .unwrap()
        .block_on(broker.execute(&f.intent, &f.worker, &f.policy, &e, &f.proof, &f.trust))
        .unwrap();
    panic!("child did not exit at effect boundary");
}

#[test]
fn abrupt_process_exit_preserves_uncertainty() {
    let f = fixture(3);
    let path = db();
    let output = std::process::Command::new(std::env::current_exe().unwrap())
        .args(["--ignored", "--exact", "process_crash_child", "--nocapture"])
        .env("ARKHE_CRASH_DB", &path)
        .env("ARKHE_CRASH_NOW", f.ctx.now.to_string())
        .output()
        .unwrap();
    assert_eq!(
        output.status.code(),
        Some(86),
        "{}",
        String::from_utf8_lossy(&output.stderr)
    );
    assert_eq!(
        std::fs::read(path.with_extension("effect")).unwrap(),
        b"effect\n"
    );
    let conn = rusqlite::Connection::open(&path).unwrap();
    assert_eq!(
        conn.query_row::<String, _, _>("SELECT status FROM broker_dispatch", [], |r| r.get(0))
            .unwrap(),
        "UNCERTAIN"
    );
    let calls = Arc::new(AtomicUsize::new(0));
    let mut b = broker(&f, &path, calls.clone(), false);
    let result = tokio::runtime::Builder::new_current_thread()
        .enable_all()
        .build()
        .unwrap()
        .block_on(execute(&mut b, &f));
    assert!(result.unwrap_err().contains("manual reconciliation"));
    assert_eq!(calls.load(Ordering::SeqCst), 0);
}

#[tokio::test]
async fn local_effect_receipt_and_nonce_commit_atomically_and_replay() {
    let f = fixture(3);
    let path = db();
    let conn = rusqlite::Connection::open(&path).unwrap();
    conn.execute_batch("CREATE TABLE local_effect(value INTEGER NOT NULL)")
        .unwrap();
    let mut b = broker(&f, &path, Arc::new(AtomicUsize::new(0)), false);
    let e = AuthenticatedEvidence {
        source: &f.store,
        worker: f.worker.digest(),
        request: &f.request,
    };
    let failed = b
        .execute_authenticated_local(
            &f.intent,
            &f.worker,
            &f.policy,
            &e,
            &f.proof,
            &f.trust,
            |tx, _| {
                tx.execute("INSERT INTO local_effect VALUES(42)", [])
                    .unwrap();
                Err("rollback".into())
            },
        )
        .await;
    assert!(failed.is_err());
    assert_eq!(
        conn.query_row::<i64, _, _>("SELECT count(*) FROM local_effect", [], |r| r.get(0))
            .unwrap(),
        0
    );
    assert_eq!(
        conn.query_row::<i64, _, _>(
            "SELECT count(*) FROM broker_authenticated_consumption",
            [],
            |r| r.get(0)
        )
        .unwrap(),
        0
    );
    let outcome = b
        .execute_authenticated_local(
            &f.intent,
            &f.worker,
            &f.policy,
            &e,
            &f.proof,
            &f.trust,
            |tx, a| {
                tx.execute(
                    "INSERT INTO local_effect VALUES(?1)",
                    [a.amount_cents as i64],
                )
                .map_err(|e| e.to_string())?;
                Ok(b"local-receipt".to_vec())
            },
        )
        .await
        .unwrap();
    assert_eq!(
        outcome,
        TransactionalResult::Executed(b"local-receipt".to_vec())
    );
    drop(b);
    let mut b = broker(&f, &path, Arc::new(AtomicUsize::new(0)), false);
    assert_eq!(
        b.execute_authenticated_local(
            &f.intent,
            &f.worker,
            &f.policy,
            &e,
            &f.proof,
            &f.trust,
            |_, _| panic!("replay callback must not run")
        )
        .await
        .unwrap(),
        TransactionalResult::Replay(b"local-receipt".to_vec())
    );
    assert_eq!(
        conn.query_row::<i64, _, _>("SELECT count(*) FROM local_effect", [], |r| r.get(0))
            .unwrap(),
        1
    );
}
