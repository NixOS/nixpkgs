use arkhe_core::{
    evidence::{EvidenceCommitter, EvidenceEnvelope},
    worker::WorkerExecutionRecord,
    Digest32,
};
use arkhe_sql::mmr::profile::PROFILE_DIGEST_HEX;
use arkhe_wormgraph::{
    anchor::{CheckpointTrust, SignedCheckpoint},
    fencing::promote_after_external_anchor,
    postgres::PgWormGraph,
    regenerate::rebuild,
    replica::{ReplicaBundle, ReplicaTrust},
};
use ed25519_dalek::{Signer, SigningKey};
use sqlx::PgPool;

#[tokio::test]
#[ignore = "requires isolated migrated PostgreSQL with distinct aws_writer/azure_writer logins"]
async fn storage_fences_old_login_and_export_recovers_contents() {
    let admin = PgPool::connect(&std::env::var("ARKHE_TEST_FENCE_ADMIN_URL").unwrap())
        .await
        .unwrap();
    let aws_url = std::env::var("ARKHE_TEST_FENCE_AWS_URL").unwrap();
    let azure_url = std::env::var("ARKHE_TEST_FENCE_AZURE_URL").unwrap();
    let tenant = format!("fence-{}", std::process::id());
    sqlx::query("INSERT INTO wormgraph_writer_fence VALUES($1,1,'aws_writer')")
        .bind(&tenant)
        .execute(&admin)
        .await
        .unwrap();
    let aws = PgWormGraph::connect_fenced(&aws_url, &tenant, "wormgraph", 1)
        .await
        .unwrap();
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "test".into(),
        module_version: "1".into(),
        input_digest: Digest32([1; 32]),
        output_digest: Digest32([2; 32]),
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: tenant.clone(),
    };
    aws.commit_verified_worker(&worker).await.unwrap();
    let mmr = rebuild(&[worker.digest()]).unwrap();
    let pool = PgPool::connect(&aws_url).await.unwrap();
    let mut tx = pool.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_append")
        .execute(&mut *tx)
        .await
        .unwrap();
    arkhe_sql::tenant::set_tenant(&mut tx, &tenant)
        .await
        .unwrap();
    sqlx::query("SELECT set_config('arkhe.writer_epoch','1',true)")
        .execute(&mut *tx)
        .await
        .unwrap();
    sqlx::query("INSERT INTO mmr_checkpoints(tenant_id,stream_id,leaf_count,mmr_size,mmr_root,peaks,profile_digest,covered_up_to_hash) VALUES($1,'wormgraph',1,1,$2,$3,$4,$5)")
        .bind(&tenant).bind(mmr.root.0.to_vec()).bind(vec![mmr.peaks[0].0.to_vec()]).bind(hex::decode(PROFILE_DIGEST_HEX).unwrap()).bind(worker.digest().0.to_vec()).execute(&mut *tx).await.unwrap();
    tx.commit().await.unwrap();
    let binding = aws
        .load_latest_checkpoint("wormgraph")
        .await
        .unwrap()
        .unwrap();
    let key = SigningKey::from_bytes(&[7; 32]);
    let mut cp = SignedCheckpoint::from_binding(&binding, [9; 32], 1500, String::new());
    cp.signature_hex = hex::encode(key.sign(&cp.signing_bytes()).to_bytes());
    let mut bundle = aws.export_replica_snapshot(cp).await.unwrap();
    bundle.signature_hex = hex::encode(key.sign(&bundle.signing_bytes()).to_bytes());
    let trust = ReplicaTrust {
        minimum_writer_epoch: 1,
        checkpoint: CheckpointTrust {
            log_id: [9; 32],
            public_key: key.verifying_key().to_bytes(),
            tenant_id: tenant.clone(),
            stream_id: "wormgraph".into(),
            minimum_leaf_count: 1,
            maximum_leaf_count: 100,
            earliest_issued_at: 1000,
            latest_issued_at: 2000,
        },
    };
    assert!(bundle.verify(&trust).is_ok());
    let raw = serde_json::to_vec(&bundle).unwrap();
    let decoded: ReplicaBundle = serde_json::from_slice(&raw).unwrap();
    assert!(decoded.verify(&trust).is_ok());
    let mut inflight = pool.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_append")
        .execute(&mut *inflight)
        .await
        .unwrap();
    arkhe_sql::tenant::set_tenant(&mut inflight, &tenant)
        .await
        .unwrap();
    sqlx::query("SELECT set_config('arkhe.writer_epoch','1',true)")
        .execute(&mut *inflight)
        .await
        .unwrap();
    sqlx::query("INSERT INTO wormgraph_records(tenant_id,record_hash,envelope) SELECT tenant_id,record_hash,envelope FROM wormgraph_records WHERE tenant_id=$1 ON CONFLICT DO NOTHING")
        .bind(&tenant).execute(&mut *inflight).await.unwrap();
    let spawn_promotion = || {
        let pool = admin.clone();
        let b = bundle.clone();
        let t = trust.clone();
        tokio::spawn(
            async move { promote_after_external_anchor(&pool, &b, &t, "azure_writer").await },
        )
    };
    let one = spawn_promotion();
    let two = spawn_promotion();
    let mut observed_lock = false;
    for _ in 0..200 {
        observed_lock=sqlx::query_scalar("SELECT EXISTS(SELECT 1 FROM pg_stat_activity WHERE query LIKE 'UPDATE wormgraph_writer_fence%' AND wait_event_type='Lock')")
            .fetch_one(&admin).await.unwrap();
        if observed_lock {
            break;
        }
        tokio::time::sleep(std::time::Duration::from_millis(10)).await;
    }
    assert!(
        observed_lock,
        "promotion must wait for admitted old transaction"
    );
    inflight.commit().await.unwrap();
    let first = one.await.unwrap();
    let second = two.await.unwrap();
    assert_eq!(usize::from(first.is_ok()) + usize::from(second.is_ok()), 1);
    assert!(aws.commit_verified_worker(&worker).await.is_err());
    let spoof = PgWormGraph::connect_fenced(&aws_url, &tenant, "wormgraph", 2)
        .await
        .unwrap();
    assert!(spoof.commit_verified_worker(&worker).await.is_err());
    let unfenced = PgWormGraph::connect(&azure_url, &tenant).await.unwrap();
    assert!(unfenced.commit_verified_worker(&worker).await.is_err());
    let azure = PgWormGraph::connect_fenced(&azure_url, &tenant, "wormgraph", 2)
        .await
        .unwrap();
    assert!(azure.commit_verified_worker(&worker).await.is_ok());
    // Hash-only journal rows are legal admission transports, not recoverable snapshots.
    let hash = Digest32([6; 32]);
    azure
        .append_verified(EvidenceEnvelope {
            record_hash: hash,
            kind: "WorkerExecutionRecord".into(),
            subject: Digest32::ZERO,
            payload_digest: hash,
            policy_digest: None,
            causal_parents: vec![],
        })
        .await
        .unwrap();
    assert!(
        promote_after_external_anchor(&admin, &bundle, &trust, "aws_writer")
            .await
            .is_err()
    );
    let mut stale = bundle.clone();
    stale.writer_epoch = 2;
    stale.signature_hex = hex::encode(key.sign(&stale.signing_bytes()).to_bytes());
    assert!(
        promote_after_external_anchor(&admin, &stale, &trust, "aws_writer")
            .await
            .is_err()
    );
    let current: i64 =
        sqlx::query_scalar("SELECT epoch FROM wormgraph_writer_fence WHERE tenant_id=$1")
            .bind(&tenant)
            .fetch_one(&admin)
            .await
            .unwrap();
    assert_eq!(
        current, 2,
        "failed prefix gate must roll back epoch/owner update"
    );
    // Publish the two-record checkpoint, then export must reject missing payload bytes.
    let mmr2 = rebuild(&[worker.digest(), hash]).unwrap();
    let az_pool = PgPool::connect(&azure_url).await.unwrap();
    let mut tx = az_pool.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_append")
        .execute(&mut *tx)
        .await
        .unwrap();
    arkhe_sql::tenant::set_tenant(&mut tx, &tenant)
        .await
        .unwrap();
    sqlx::query("SELECT set_config('arkhe.writer_epoch','2',true)")
        .execute(&mut *tx)
        .await
        .unwrap();
    sqlx::query("INSERT INTO mmr_checkpoints(tenant_id,stream_id,leaf_count,mmr_size,mmr_root,peaks,profile_digest,covered_up_to_hash) VALUES($1,'wormgraph',2,$2,$3,$4,$5,$6)")
        .bind(&tenant).bind(mmr2.mmr_size as i64).bind(mmr2.root.0.to_vec()).bind(mmr2.peaks.iter().map(|p|p.0.to_vec()).collect::<Vec<_>>())
        .bind(hex::decode(PROFILE_DIGEST_HEX).unwrap()).bind(hash.0.to_vec()).execute(&mut *tx).await.unwrap();
    tx.commit().await.unwrap();
    let binding = azure
        .load_latest_checkpoint("wormgraph")
        .await
        .unwrap()
        .unwrap();
    let mut cp = SignedCheckpoint::from_binding(&binding, [9; 32], 1500, String::new());
    cp.signature_hex = hex::encode(key.sign(&cp.signing_bytes()).to_bytes());
    assert!(
        azure.export_replica_snapshot(cp).await.is_err(),
        "hash-only prefix must not become a recoverable snapshot"
    );
    admin.close().await;
}
