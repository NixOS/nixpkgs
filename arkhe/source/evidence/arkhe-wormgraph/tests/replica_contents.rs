use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    Digest32,
};
use arkhe_sql::mmr::profile::PROFILE_DIGEST_HEX;
use arkhe_wormgraph::{
    anchor::{CheckpointTrust, SignedCheckpoint},
    regenerate::{rebuild, CheckpointBinding},
    replica::{ReplicaBundle, ReplicaObject, ReplicaRecord, ReplicaTrust},
};
use ed25519_dalek::{Signer, SigningKey};

fn fixture() -> (ReplicaBundle, ReplicaTrust, SigningKey) {
    let key = SigningKey::from_bytes(&[7; 32]);
    let bytes = b"canonical worker fixture".to_vec();
    let hash = Digest32::blake3(b"AKG:WER:v1\0", &bytes);
    let mmr = rebuild(&[hash]).unwrap();
    let cp = CheckpointBinding {
        tenant_id: "a".into(),
        stream_id: "wormgraph".into(),
        leaf_count: 1,
        mmr_size: mmr.mmr_size,
        root: mmr.root,
        peaks: mmr.peaks,
        profile_digest: Digest32(hex::decode(PROFILE_DIGEST_HEX).unwrap().try_into().unwrap()),
        covered_up_to: hash,
    };
    let mut checkpoint = SignedCheckpoint::from_binding(&cp, [9; 32], 1500, String::new());
    checkpoint.signature_hex = hex::encode(key.sign(&checkpoint.signing_bytes()).to_bytes());
    let mut bundle = ReplicaBundle {
        schema: "arkhe-replica-bundle-v1".into(),
        writer_epoch: 2,
        checkpoint,
        signature_hex: String::new(),
        records: vec![ReplicaRecord {
            append_sequence: 4,
            writer_epoch: 1,
            envelope: EvidenceEnvelope {
                record_hash: hash,
                kind: "WorkerExecutionRecord".into(),
                subject: Digest32::ZERO,
                payload_digest: hash,
                policy_digest: None,
                causal_parents: vec![],
            },
            contents: vec![ReplicaObject {
                kind: "WorkerExecutionRecord".into(),
                digest: hash,
                bytes,
            }],
        }],
    };
    sign(&mut bundle, &key);
    let trust = ReplicaTrust {
        minimum_writer_epoch: 2,
        checkpoint: CheckpointTrust {
            log_id: [9; 32],
            public_key: key.verifying_key().to_bytes(),
            tenant_id: "a".into(),
            stream_id: "wormgraph".into(),
            minimum_leaf_count: 1,
            maximum_leaf_count: 1,
            earliest_issued_at: 1000,
            latest_issued_at: 2000,
        },
    };
    (bundle, trust, key)
}
fn sign(b: &mut ReplicaBundle, key: &SigningKey) {
    b.signature_hex = hex::encode(key.sign(&b.signing_bytes()).to_bytes());
}
#[tokio::test]
async fn verified_replica_serves_envelopes_and_actual_content() {
    let (b, t, _) = fixture();
    let reader = b.verify(&t).unwrap();
    let e = &b.records[0].envelope;
    assert_eq!(reader.get(e.record_hash).await.unwrap(), Some(e.clone()));
    assert_eq!(
        reader.canonical_object("WorkerExecutionRecord", e.payload_digest),
        Some(b"canonical worker fixture".as_slice())
    );
}
#[test]
fn stale_epoch_and_unsigned_epoch_upgrade_are_rejected() {
    let (mut b, t, _) = fixture();
    b.writer_epoch = 1;
    assert!(b.verify(&t).is_err());
    b.writer_epoch = 3;
    assert!(b.verify(&t).is_err());
    let mut t = t;
    t.minimum_writer_epoch = 0;
    assert!(b.verify(&t).is_err());
}
#[test]
fn missing_or_corrupt_content_fails_even_with_new_snapshot_signature() {
    let (b, t, key) = fixture();
    for mutation in 0..4 {
        let mut bad = b.clone();
        match mutation {
            0 => bad.records[0].contents.clear(),
            1 => bad.records[0].contents[0].bytes[0] ^= 1,
            2 => bad.records[0].envelope.record_hash = Digest32([4; 32]),
            _ => bad.records[0].writer_epoch = 3,
        };
        sign(&mut bad, &key);
        assert!(bad.verify(&t).is_err());
    }
}
#[test]
fn missing_journal_entries_and_wrong_order_are_rejected() {
    let (mut b, t, key) = fixture();
    b.records.clear();
    sign(&mut b, &key);
    assert!(b.verify(&t).is_err());
    let (mut b, t, key) = fixture();
    b.records[0].envelope.causal_parents.push(Digest32([4; 32]));
    sign(&mut b, &key);
    assert!(b.verify(&t).is_err());
    let (mut b, mut t, key) = fixture();
    let mut second = b.records[0].clone();
    second.append_sequence = 5;
    second.contents[0].bytes = b"second worker fixture".to_vec();
    let hash = Digest32::blake3(b"AKG:WER:v1\0", &second.contents[0].bytes);
    second.contents[0].digest = hash;
    second.envelope.record_hash = hash;
    second.envelope.payload_digest = hash;
    second.envelope.causal_parents = vec![b.records[0].envelope.record_hash];
    let mmr = rebuild(&[b.records[0].envelope.record_hash, hash]).unwrap();
    b.records.push(second);
    b.checkpoint.leaf_count = 2;
    b.checkpoint.mmr_size = mmr.mmr_size;
    b.checkpoint.root = mmr.root.0;
    b.checkpoint.peaks = mmr.peaks.iter().map(|p| p.0).collect();
    b.checkpoint.covered_up_to = hash.0;
    b.checkpoint.signature_hex = hex::encode(key.sign(&b.checkpoint.signing_bytes()).to_bytes());
    t.checkpoint.maximum_leaf_count = 2;
    sign(&mut b, &key);
    assert!(b.verify(&t).is_ok());
    b.records[0].writer_epoch = 2;
    sign(&mut b, &key);
    assert!(b.verify(&t).is_err(), "journal epochs cannot regress");
    b.records[0].writer_epoch = 1;
    b.records.swap(0, 1);
    sign(&mut b, &key);
    assert!(b.verify(&t).is_err());
}
#[test]
fn envelope_metadata_and_epoch_are_cryptographically_bound() {
    let (mut b, t, _) = fixture();
    b.records[0].envelope.subject = Digest32([2; 32]);
    assert!(b.verify(&t).is_err());
}
