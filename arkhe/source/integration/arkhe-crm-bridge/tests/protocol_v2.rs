use arkhe_crm_bridge_cli::{
    storage::Store,
    v2::{self, Event, Policy, Producer, Request},
    ProvenanceRecord,
};
use ed25519_dalek::SigningKey;
use std::{
    path::PathBuf,
    sync::{Arc, Barrier},
};

fn setup() -> (Policy, SigningKey, SigningKey, Request) {
    let bridge = SigningKey::from_bytes(&[1; 32]);
    let producer = SigningKey::from_bytes(&[2; 32]);
    let record: ProvenanceRecord =
        serde_json::from_str(include_str!("../fixtures/lead.json")).unwrap();
    let policy = Policy {
        schema: 2,
        log_id: "fixture-log".into(),
        bridge_public_key: v2::public_key(&bridge),
        producers: vec![Producer {
            id: "producer-1".into(),
            public_key: v2::public_key(&producer),
            org_id: record.org_id.clone(),
            object: record.object.clone(),
            source_system: record.source_system.clone(),
            fields: vec![record.field.clone()],
        }],
        max_age_secs: 300,
        max_ttl_secs: 300,
        future_skew_secs: 5,
    };
    let event = Event {
        schema: 2,
        log_id: policy.log_id.clone(),
        event_id: "evt-1".into(),
        producer_id: "producer-1".into(),
        issued_at: 1000,
        expires_at: 1300,
        record,
    };
    let request = Request::sign(event, &producer).unwrap();
    (policy, bridge, producer, request)
}
struct Database(PathBuf);
impl Database {
    fn new() -> Self {
        let mut id = [0u8; 16];
        getrandom::getrandom(&mut id).unwrap();
        Self(std::env::temp_dir().join(format!("arkhe-crm-{}.db", hex::encode(id))))
    }
    fn open(&self) -> Store {
        Store::open(&self.0).unwrap()
    }
}
impl Drop for Database {
    fn drop(&mut self) {
        for suffix in ["", "-wal", "-shm"] {
            let _ = std::fs::remove_file(format!("{}{suffix}", self.0.display()));
        }
    }
}

#[test]
fn signed_roundtrip_reopen_retry_and_export() {
    let (policy, bridge, _, request) = setup();
    let db = Database::new();
    let first = db
        .open()
        .anchor(request.clone(), &policy, &bridge, 1001)
        .unwrap();
    v2::verify(&first, &policy).unwrap();
    let retry = db.open().anchor(request, &policy, &bridge, 9999).unwrap();
    assert_eq!(
        serde_json::to_value(&first).unwrap(),
        serde_json::to_value(retry).unwrap()
    );
    let saved = db.open().export("evt-1", &policy).unwrap();
    assert_eq!(
        saved.checkpoint.hash().unwrap(),
        first.checkpoint.hash().unwrap()
    );
}

fn write_fixture() -> (
    Policy,
    ed25519_dalek::SigningKey,
    arkhe_crm_bridge_cli::salesforce::WriteIntent,
) {
    use arkhe_crm_bridge_cli::salesforce::WriteIntent;
    let (mut policy, bridge, producer, mut request) = setup();
    policy.producers[0].org_id = "00D000000000001AAA".into();
    request.event.record.org_id = policy.producers[0].org_id.clone();
    request.event.record.record_id = "00Q000000000001AAA".into();
    request = Request::sign(request.event, &producer).unwrap();
    let bundle = Database::new()
        .open()
        .anchor(request, &policy, &bridge, 1001)
        .unwrap();
    let intent = WriteIntent::sign(
        bundle,
        "2026-10-25T12:00:00.123Z".into(),
        &producer,
        &policy,
    )
    .unwrap();
    (policy, producer, intent)
}

#[test]
fn salesforce_write_binds_version_and_preserves_exact_expiry() {
    let (policy, _, intent) = write_fixture();
    let payload = intent
        .approval(&policy, "00D000000000001AAA", 1002)
        .unwrap();
    assert_eq!(payload["Expected_Version__c"], "2026-10-25T12:00:00.123Z");
    assert_eq!(payload["Expires_At__c"], "1970-01-01T00:21:40.000Z");
    assert_eq!(payload["New_Value__c"], "Web");
    let mut changed = intent.clone();
    changed.expected_version = "2026-10-25T12:00:00.124Z".into();
    assert!(changed.verify(&policy).is_err());
    changed = intent.clone();
    changed.bundle.request.event.record.value = serde_json::json!("Forged");
    assert!(changed.verify(&policy).is_err());
}

#[test]
fn historical_verification_cannot_authorize_expired_or_wrong_org_write() {
    let (policy, _, intent) = write_fixture();
    assert!(intent.verify(&policy).is_ok());
    assert!(intent
        .approval(&policy, "00D000000000001AAA", 1300)
        .is_err());
    assert!(intent
        .approval(&policy, "00D000000000002AAA", 1002)
        .is_err());
    assert!(intent.approval(&policy, "00D000000000001AAA", 900).is_err());
}

#[test]
fn salesforce_write_rejects_other_signer_and_noncanonical_version() {
    use arkhe_crm_bridge_cli::salesforce::WriteIntent;
    let (policy, producer, intent) = write_fixture();
    assert!(WriteIntent::sign(
        intent.bundle.clone(),
        intent.expected_version.clone(),
        &ed25519_dalek::SigningKey::from_bytes(&[9; 32]),
        &policy
    )
    .is_err());
    assert!(WriteIntent::sign(
        intent.bundle,
        "2026-10-25T12:00:00Z".into(),
        &producer,
        &policy
    )
    .is_err());
}

#[test]
fn signed_checkpoint_binds_every_security_field() {
    let (policy, bridge, _, request) = setup();
    let db = Database::new();
    let valid = db.open().anchor(request, &policy, &bridge, 1001).unwrap();
    for mutation in 0..9 {
        let mut b = valid.clone();
        match mutation {
            0 => b.checkpoint.leaf_count += 1,
            1 => b.checkpoint.root = "00".repeat(32),
            2 => b.checkpoint.log_id.push('x'),
            3 => b.checkpoint.previous_checkpoint_hash = "01".repeat(32),
            4 => b.checkpoint.issued_at += 1,
            5 => b.checkpoint.policy_hash = "00".repeat(32),
            6 => b.request.event.record.value = serde_json::json!("forged"),
            7 => b.request.signature = "00".repeat(64),
            _ => b.schema = 1,
        }
        assert!(v2::verify(&b, &policy).is_err(), "mutation {mutation}");
    }
    let mut untrusted = policy.clone();
    untrusted.bridge_public_key = v2::public_key(&SigningKey::from_bytes(&[3; 32]));
    assert!(v2::verify(&valid, &untrusted).is_err());
}

#[test]
fn scope_freshness_and_replay_conflicts_leave_no_new_leaf() {
    let (policy, bridge, producer, request) = setup();
    let db = Database::new();
    let mut store = db.open();
    let first = store
        .anchor(request.clone(), &policy, &bridge, 1001)
        .unwrap();
    for mutation in 0..8 {
        let mut e = request.event.clone();
        match mutation {
            0 => e.record.value = serde_json::json!("conflicting same event id"),
            1 => {
                e.event_id = "new".into();
                e.record.field = "Secret__c".into();
            }
            2 => {
                e.event_id = "new".into();
                e.record.org_id = "other".into();
            }
            3 => {
                e.event_id = "new".into();
                e.record.source_system = "other".into();
            }
            4 => {
                e.event_id = "new".into();
                e.issued_at = 1;
                e.expires_at = 10;
            }
            5 => {
                e.event_id = "new".into();
                e.issued_at = 2000;
                e.expires_at = 2100;
            }
            6 => {
                e.event_id = "new".into();
                e.expires_at = 9999;
            }
            _ => {
                e.event_id = "new".into();
                e.log_id = "other".into();
            }
        }
        assert!(store
            .anchor(Request::sign(e, &producer).unwrap(), &policy, &bridge, 1001)
            .is_err());
    }
    let mut e = request.event;
    e.event_id = "evt-2".into();
    let second = store
        .anchor(Request::sign(e, &producer).unwrap(), &policy, &bridge, 1002)
        .unwrap();
    assert_eq!(second.checkpoint.leaf_count, 2);
    assert_eq!(
        second.checkpoint.previous_checkpoint_hash,
        first.checkpoint.hash().unwrap()
    );
    let mut bad = second.clone();
    bad.proof[0].hash[0] ^= 1;
    assert!(v2::verify(&bad, &policy).is_err());
}

#[test]
fn failed_commit_rolls_back_replay_key_and_policy_pin() {
    let (policy, bridge, _, request) = setup();
    let db = Database::new();
    let mut store = db.open();
    let sql = rusqlite::Connection::open(&db.0).unwrap();
    sql.execute_batch("CREATE TRIGGER fail_insert BEFORE INSERT ON bridge_events BEGIN SELECT RAISE(ABORT, 'injected failure'); END;").unwrap();
    assert!(store
        .anchor(request.clone(), &policy, &bridge, 1001)
        .is_err());
    assert_eq!(
        sql.query_row("SELECT count(*) FROM bridge_meta", [], |r| r
            .get::<_, u64>(0))
            .unwrap(),
        0
    );
    sql.execute_batch("DROP TRIGGER fail_insert").unwrap();
    assert_eq!(
        store
            .anchor(request, &policy, &bridge, 1001)
            .unwrap()
            .checkpoint
            .leaf_count,
        1
    );
}

#[test]
fn concurrent_exact_retries_commit_once() {
    let (policy, bridge, _, request) = setup();
    let db = Database::new();
    let stores = [db.open(), db.open()];
    let barrier = Arc::new(Barrier::new(2));
    let handles: Vec<_> = stores
        .into_iter()
        .map(|mut store| {
            let barrier = barrier.clone();
            let policy = policy.clone();
            let bridge = bridge.clone();
            let request = request.clone();
            std::thread::spawn(move || {
                barrier.wait();
                store.anchor(request, &policy, &bridge, 1001).unwrap()
            })
        })
        .collect();
    for handle in handles {
        assert_eq!(handle.join().unwrap().checkpoint.leaf_count, 1);
    }
}

#[test]
fn canonical_contract_ignores_json_order_and_rejects_ambiguity() {
    let (_, _, producer, request) = setup();
    // Value's default sorted object map actually reorders struct properties.
    let encoded =
        serde_json::to_string_pretty(&serde_json::to_value(&request.event).unwrap()).unwrap();
    let event: Event = serde_json::from_str(&encoded).unwrap();
    assert_eq!(
        event.canonical().unwrap(),
        request.event.canonical().unwrap()
    );
    let mut e = event.clone();
    e.record.observed_at = "2026-10-22T12:00:00+00:00".into();
    assert!(Request::sign(e, &producer).is_err());
    let mut e = event.clone();
    e.record.value = serde_json::json!(1.5);
    assert!(e.canonical().is_err());
    let mut e = event.clone();
    e.schema = 3;
    assert!(e.canonical().is_err());
    let mut e = event;
    e.record.value = serde_json::json!("1");
    let string_hash = e.hash().unwrap();
    e.record.value = serde_json::json!(1);
    assert_ne!(string_hash, e.hash().unwrap());
}

#[test]
fn frozen_v2_vector_matches_bytes_hash_and_signature() {
    let vector: serde_json::Value =
        serde_json::from_str(include_str!("../fixtures/golden-v2.json")).unwrap();
    let event: Event = serde_json::from_str(include_str!("../fixtures/event-v2.json")).unwrap();
    let signed = Request::sign(event, &SigningKey::from_bytes(&[2; 32])).unwrap();
    assert_eq!(
        hex::encode(signed.event.canonical().unwrap()),
        vector["canonical_hex"].as_str().unwrap()
    );
    assert_eq!(
        signed.event.hash().unwrap(),
        vector["event_hash"].as_str().unwrap()
    );
    assert_eq!(signed.signature, vector["signature"].as_str().unwrap());
}

#[test]
fn policy_changes_and_corrupt_history_are_rejected() {
    let (policy, bridge, producer, request) = setup();
    let db = Database::new();
    let mut store = db.open();
    store
        .anchor(request.clone(), &policy, &bridge, 1001)
        .unwrap();
    let mut event = request.event;
    event.event_id = "evt-2".into();
    let second = Request::sign(event, &producer).unwrap();
    let mut changed = policy.clone();
    changed.max_age_secs += 1;
    assert!(store
        .anchor(second.clone(), &changed, &bridge, 1002)
        .is_err());
    let sql = rusqlite::Connection::open(&db.0).unwrap();
    sql.execute("UPDATE bridge_events SET event_hash=?1", ["00".repeat(32)])
        .unwrap();
    assert!(store.anchor(second, &policy, &bridge, 1002).is_err());
}
