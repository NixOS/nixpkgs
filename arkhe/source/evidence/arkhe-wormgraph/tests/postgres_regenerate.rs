use arkhe_core::{
    evidence::{EvidenceCommitter, EvidenceEnvelope},
    Digest32,
};
use arkhe_sql::mmr::profile::PROFILE_DIGEST_HEX;
use arkhe_wormgraph::{
    anchor::{CheckpointTrust, SignedCheckpoint, SignedCheckpointAnchor},
    postgres::PgWormGraph,
    regenerate::{
        rebuild, regenerate_anchored, RegenerationLimits, RegenerationStatus, DEFAULT_STREAM_ID,
    },
};
use ed25519_dalek::{Signer, SigningKey};
use sqlx::PgPool;

fn digest(value: u8) -> Digest32 {
    let mut bytes = [0u8; 32];
    bytes[31] = value;
    Digest32(bytes)
}

fn parse_digest(hex: &str) -> Digest32 {
    let mut bytes = [0u8; 32];
    for (index, byte) in bytes.iter_mut().enumerate() {
        *byte = u8::from_str_radix(&hex[index * 2..index * 2 + 2], 16).unwrap();
    }
    Digest32(bytes)
}

#[tokio::test]
#[ignore = "requires ARKHE_TEST_RUNTIME_DATABASE_URL with migrated storage roles"]
async fn postgres_source_and_anchored_checkpoint_round_trip() {
    let url = std::env::var("ARKHE_TEST_RUNTIME_DATABASE_URL")
        .expect("ARKHE_TEST_RUNTIME_DATABASE_URL must point to a migrated test database");
    let tenant = format!("tenant-regenerate-{}", std::process::id());
    let graph = PgWormGraph::connect(&url, &tenant).await.unwrap();

    let records: Vec<Digest32> = (1..=7).map(digest).collect();
    for record_hash in &records {
        graph
            .append_verified(EvidenceEnvelope {
                record_hash: *record_hash,
                kind: "regenerate-test".into(),
                subject: Digest32::ZERO,
                payload_digest: Digest32::ZERO,
                policy_digest: None,
                causal_parents: Vec::new(),
            })
            .await
            .unwrap();
    }

    let snapshot = rebuild(&records).unwrap();
    let pool = PgPool::connect(&url).await.unwrap();
    let mut tx = pool.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_append")
        .execute(&mut *tx)
        .await
        .unwrap();
    arkhe_sql::tenant::set_tenant(&mut tx, &tenant)
        .await
        .unwrap();
    sqlx::query(
        "INSERT INTO mmr_checkpoints(
            tenant_id, stream_id, leaf_count, mmr_size, mmr_root, peaks,
            profile_digest, covered_up_to_hash
         ) VALUES($1,$2,$3,$4,$5,$6,$7,$8)",
    )
    .bind(&tenant)
    .bind(DEFAULT_STREAM_ID)
    .bind(snapshot.leaf_count as i64)
    .bind(snapshot.mmr_size as i64)
    .bind(snapshot.root.0.to_vec())
    .bind(
        snapshot
            .peaks
            .iter()
            .map(|peak| peak.0.to_vec())
            .collect::<Vec<_>>(),
    )
    .bind(parse_digest(PROFILE_DIGEST_HEX).0.to_vec())
    .bind(records[6].0.to_vec())
    .execute(&mut *tx)
    .await
    .unwrap();
    tx.commit().await.unwrap();
    pool.close().await;

    let loaded = graph
        .load_checkpoint(DEFAULT_STREAM_ID, snapshot.leaf_count)
        .await
        .unwrap()
        .unwrap();
    assert_eq!(loaded.root, snapshot.root);
    assert_eq!(loaded.peaks, snapshot.peaks);

    let key = SigningKey::from_bytes(&[11u8; 32]);
    let mut signed = SignedCheckpoint::from_binding(&loaded, [12u8; 32], 1_500, String::new());
    signed.signature_hex = hex::encode(key.sign(&signed.signing_bytes()).to_bytes());
    let anchor = SignedCheckpointAnchor::new(
        CheckpointTrust {
            log_id: [12u8; 32],
            public_key: key.verifying_key().to_bytes(),
            tenant_id: tenant.clone(),
            stream_id: DEFAULT_STREAM_ID.into(),
            minimum_leaf_count: 1,
            maximum_leaf_count: 100,
            earliest_issued_at: 1_000,
            latest_issued_at: 2_000,
        },
        signed,
    );
    let anchored = graph
        .load_anchored_checkpoint(DEFAULT_STREAM_ID, snapshot.leaf_count, &anchor)
        .await
        .unwrap();
    assert_eq!(anchored.binding(), &loaded);

    let report = regenerate_anchored(&graph, &anchored, &RegenerationLimits::default()).await;
    assert_eq!(report.status, RegenerationStatus::Verified);
}
