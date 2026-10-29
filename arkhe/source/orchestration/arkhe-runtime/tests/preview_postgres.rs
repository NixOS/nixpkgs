//! Run only against a disposable PostgreSQL cluster: this test creates a login role.
#[path = "support/preview_fixture.rs"]
mod fixture;
use arkhe_core::evidence::EvidenceCommitter;
use arkhe_runtime::preview::{admit_preview, enqueue_preview};
use arkhe_wormgraph::postgres::PgWormGraph;
use fixture::{fixture, sign};
use sqlx::{PgPool, Postgres, Transaction};
use std::time::{SystemTime, UNIX_EPOCH};

fn now() -> i64 {
    SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_secs() as i64
}
fn renew(
    base: &arkhe_runtime::preview::PreviewRequest,
    nonce: &[u8],
) -> arkhe_runtime::preview::PreviewRequest {
    let mut r = base.clone();
    r.intent.request_identity = arkhe_core::work::RequestIdentity::new(nonce);
    r.worker.execution_id = r.intent.operation_id().to_hex();
    r.review.operation_id = r.intent.operation_id();
    r.review.analysis_digest = r.worker.digest();
    sign(&mut r);
    r
}
async fn begin<'a>(pool: &'a PgPool, tenant: &str) -> Transaction<'a, Postgres> {
    let mut tx = pool.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_preview_enqueue")
        .execute(&mut *tx)
        .await
        .unwrap();
    arkhe_sql::tenant::set_tenant(&mut tx, tenant)
        .await
        .unwrap();
    tx
}
async fn count(pool: &PgPool, tenant: &str) -> (i64, i64) {
    let mut tx = begin(pool, tenant).await;
    let n = sqlx::query_as(
        "SELECT (SELECT count(*) FROM preview_admissions),(SELECT count(*) FROM preview_jobs)",
    )
    .fetch_one(&mut *tx)
    .await
    .unwrap();
    tx.commit().await.unwrap();
    n
}

#[tokio::test]
#[ignore = "requires ARKHE_TEST_PREVIEW_ADMIN_DATABASE_URL pointing only to a disposable PostgreSQL cluster"]
async fn transactional_preview_outbox_and_real_cli() {
    let admin_url = std::env::var("ARKHE_TEST_PREVIEW_ADMIN_DATABASE_URL")
        .expect("disposable PostgreSQL admin URL required");
    let setup = PgPool::connect(&admin_url).await.unwrap();
    let suffix = uuid::Uuid::new_v4().simple().to_string();
    let database = format!("preview_test_{suffix}");
    let login = format!("preview_login_{suffix}");
    // Generated identifiers contain only a fixed prefix and UUID hex digits.
    sqlx::query(&format!("CREATE DATABASE {database}"))
        .execute(&setup)
        .await
        .unwrap();
    let (base_url, _) = admin_url
        .rsplit_once('/')
        .expect("test URL must contain a database path");
    let url = format!("{base_url}/{database}");
    setup.close().await;
    let pool = PgPool::connect(&url).await.unwrap();
    sqlx::migrate!("../../storage/sql/migrations")
        .run(&pool)
        .await
        .unwrap();
    sqlx::query(&format!(
        "CREATE ROLE {login} LOGIN NOSUPERUSER NOBYPASSRLS NOCREATEDB NOCREATEROLE NOINHERIT"
    ))
    .execute(&pool)
    .await
    .unwrap();
    sqlx::query(&format!(
        "GRANT arkhe_append,arkhe_read,arkhe_preview_enqueue,arkhe_preview_execute TO {login}"
    ))
    .execute(&pool)
    .await
    .unwrap();
    let runtime_url = url.replace("postgres@", &format!("{login}@"));
    assert_ne!(
        runtime_url, url,
        "test URL must contain postgres@ for safe login substitution"
    );
    let runtime = PgPool::connect(&runtime_url).await.unwrap();
    let (request, trust, baseline) = fixture(now());
    let admitted = admit_preview(request.clone(), &trust, &baseline, now())
        .await
        .unwrap();

    let mut tx = begin(&runtime, &trust.tenant).await;
    enqueue_preview(&mut tx, &admitted).await.unwrap();
    tx.rollback().await.unwrap();
    assert_eq!(
        count(&runtime, &trust.tenant).await,
        (0, 0),
        "rollback removes both rows"
    );
    let mut tx = begin(&runtime, &trust.tenant).await;
    let digest = enqueue_preview(&mut tx, &admitted).await.unwrap();
    tx.commit().await.unwrap();
    let mut tx = begin(&runtime, &trust.tenant).await;
    assert_eq!(enqueue_preview(&mut tx, &admitted).await.unwrap(), digest);
    tx.commit().await.unwrap();
    assert_eq!(count(&runtime, &trust.tenant).await, (1, 1));

    let mut changed = request.clone();
    changed.spec.artifact_digest = fixture::hash(98);
    changed.intent.parameters_digest = changed.spec.digest();
    changed.worker.output_digest = changed.spec.digest();
    changed.review.parameters_digest = changed.spec.digest();
    changed.review.analysis_digest = changed.worker.digest();
    sign(&mut changed);
    let changed = admit_preview(changed, &trust, &baseline, now())
        .await
        .unwrap();
    assert_eq!(admitted.operation_id(), changed.operation_id());
    let mut tx = begin(&runtime, &trust.tenant).await;
    assert!(
        enqueue_preview(&mut tx, &changed).await.is_err(),
        "same operation cannot change bundle"
    );
    tx.rollback().await.unwrap();
    assert_eq!(count(&runtime, "other-tenant").await, (0, 0));
    let mut tx = begin(&runtime, "other-tenant").await;
    assert!(enqueue_preview(&mut tx, &admitted).await.is_err());
    tx.rollback().await.unwrap();
    for statement in [
        "UPDATE preview_admissions SET expires_at=expires_at+1",
        "DELETE FROM preview_jobs",
        "TRUNCATE preview_jobs",
    ] {
        let mut tx = begin(&runtime, &trust.tenant).await;
        assert!(sqlx::query(statement).execute(&mut *tx).await.is_err());
        tx.rollback().await.unwrap();
    }
    let mut tx = runtime.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_preview_enqueue")
        .execute(&mut *tx)
        .await
        .unwrap();
    assert!(sqlx::query("SELECT * FROM preview_admissions")
        .fetch_all(&mut *tx)
        .await
        .is_err());
    tx.rollback().await.unwrap();
    let mut tx = begin(&runtime, &trust.tenant).await;
    assert!(sqlx::query("INSERT INTO preview_jobs(tenant_id,requested_by,operation_id,bundle_digest) VALUES($1,'orphan',$2,$3)")
        .bind(&trust.tenant).bind(vec![0u8;32]).bind(vec![0u8;32]).execute(&mut *tx).await.is_err());
    tx.rollback().await.unwrap();

    // If the second write fails, the savepoint removes the first one, even when
    // the caller commits after inspecting the error.
    let mut failed = request.clone();
    failed.intent.request_identity = arkhe_core::work::RequestIdentity::new(b"failed-enqueue");
    failed.worker.execution_id = failed.intent.operation_id().to_hex();
    failed.review.operation_id = failed.intent.operation_id();
    failed.review.analysis_digest = failed.worker.digest();
    sign(&mut failed);
    let failed = admit_preview(failed, &trust, &baseline, now())
        .await
        .unwrap();
    sqlx::query("REVOKE INSERT ON preview_jobs FROM arkhe_preview_enqueue")
        .execute(&pool)
        .await
        .unwrap();
    let mut tx = begin(&runtime, &trust.tenant).await;
    assert!(enqueue_preview(&mut tx, &failed).await.is_err());
    tx.commit().await.unwrap();
    assert_eq!(count(&runtime, &trust.tenant).await, (1, 1));
    sqlx::query("GRANT INSERT ON preview_jobs TO arkhe_preview_enqueue")
        .execute(&pool)
        .await
        .unwrap();

    let mut concurrent = request.clone();
    concurrent.intent.request_identity =
        arkhe_core::work::RequestIdentity::new(b"concurrent-preview");
    concurrent.worker.execution_id = concurrent.intent.operation_id().to_hex();
    concurrent.review.operation_id = concurrent.intent.operation_id();
    concurrent.review.analysis_digest = concurrent.worker.digest();
    sign(&mut concurrent);
    let mut handles = vec![];
    for _ in 0..8 {
        let request = concurrent.clone();
        let trust = trust.clone();
        let pool = runtime.clone();
        handles.push(tokio::spawn(async move {
            let baseline = fixture::Baseline(request.spec.baseline_digest);
            let admitted = admit_preview(request, &trust, &baseline, now())
                .await
                .unwrap();
            let mut tx = begin(&pool, &trust.tenant).await;
            enqueue_preview(&mut tx, &admitted).await.unwrap();
            tx.commit().await.unwrap();
        }));
    }
    for handle in handles {
        handle.await.unwrap();
    }
    assert_eq!(count(&runtime, &trust.tenant).await, (2, 2));

    // CLI uses the real tenant-scoped evidence store, not the test EvidenceReader.
    let graph = PgWormGraph::connect(&runtime_url, &trust.tenant)
        .await
        .unwrap();
    let envelope = arkhe_core::evidence::EvidenceEnvelope {
        record_hash: request.spec.baseline_digest,
        kind: "TestBaseline".into(),
        subject: request.spec.baseline_digest,
        payload_digest: request.spec.baseline_digest,
        policy_digest: None,
        causal_parents: vec![],
    };
    graph.append_verified(envelope).await.unwrap();
    let temp = std::env::temp_dir().join(format!("arkhe-preview-test-{}", uuid::Uuid::new_v4()));
    std::fs::create_dir(&temp).unwrap();
    let trust_path = temp.join("trust.json");
    let request_path = temp.join("request.json");
    std::fs::write(&trust_path, serde_json::to_vec(&trust).unwrap()).unwrap();
    std::fs::write(&request_path, serde_json::to_vec(&request).unwrap()).unwrap();
    for enqueue in [false, true] {
        let mut command = std::process::Command::new(env!("CARGO_BIN_EXE_arkhe-preview"));
        command.args([
            "--trust",
            trust_path.to_str().unwrap(),
            "--request",
            request_path.to_str().unwrap(),
        ]);
        if enqueue {
            command.arg("--enqueue");
        }
        let result = command
            .env("ARKHE_PREVIEW_DATABASE_URL", &runtime_url)
            .output()
            .unwrap();
        assert!(
            result.status.success(),
            "{}",
            String::from_utf8_lossy(&result.stderr)
        );
        let value: serde_json::Value = serde_json::from_slice(&result.stdout).unwrap();
        assert_eq!(value["execution_authority"], false);
        assert_eq!(value["executed"], false);
        assert_eq!(
            value["status"],
            if enqueue {
                "ADMITTED_PENDING"
            } else {
                "VERIFIED_ONLY"
            }
        );
    }
    // Only exact test-owned files/directories are removed; no recursive deletion.
    std::fs::remove_file(trust_path).unwrap();
    std::fs::remove_file(request_path).unwrap();
    std::fs::remove_dir(temp).unwrap();
    assert_eq!(count(&runtime, &trust.tenant).await, (2, 2));
    use arkhe_runtime::preview::dispatch::{Completion, PreviewQueue};
    let queue = PreviewQueue::connect(&runtime_url, &trust.tenant)
        .await
        .unwrap();
    let first = queue.claim(10).await.unwrap().unwrap();
    assert!(
        queue
            .finish(&first, Completion::Succeeded(serde_json::json!({})))
            .await
            .is_err(),
        "cannot succeed before dispatch"
    );
    assert!(queue.heartbeat(&first, 10).await.unwrap());
    assert!(queue
        .finish(&first, Completion::Retry("preflight unavailable".into()))
        .await
        .unwrap());
    let second = queue.claim(10).await.unwrap().unwrap();
    assert_ne!(
        first.request.intent.operation_id(),
        second.request.intent.operation_id()
    );
    assert!(queue.start(&second).await.unwrap());
    assert!(!queue.start(&second).await.unwrap());
    assert!(!queue
        .finish(&second, Completion::Retry("already dispatched".into()))
        .await
        .unwrap());
    sqlx::query("UPDATE preview_dispatches SET lease_until=clock_timestamp()-interval '1 second' WHERE operation_id=$1")
        .bind(second.request.intent.operation_id().0.to_vec()).execute(&pool).await.unwrap();
    let _ = queue.claim(10).await.unwrap();
    let status = queue
        .status(&trust.requested_by, second.request.intent.operation_id())
        .await
        .unwrap()
        .unwrap();
    assert_eq!(status.state, "UNKNOWN");
    assert!(!queue.heartbeat(&second, 10).await.unwrap());
    assert!(!queue
        .finish(&second, Completion::Succeeded(serde_json::json!({})))
        .await
        .unwrap());
    tokio::time::sleep(std::time::Duration::from_millis(2200)).await;
    let retry = queue.claim(10).await.unwrap().unwrap();
    assert_eq!(retry.attempts, 2);
    assert!(retry.fence > first.fence);
    assert!(!queue.start(&first).await.unwrap());
    assert!(!queue.heartbeat(&first, 10).await.unwrap());
    assert!(queue
        .finish(&retry, Completion::Retry("still unavailable".into()))
        .await
        .unwrap());
    tokio::time::sleep(std::time::Duration::from_millis(4200)).await;
    let last = queue.claim(10).await.unwrap().unwrap();
    assert_eq!(last.attempts, 3);
    assert!(queue
        .finish(&last, Completion::Retry("third failure".into()))
        .await
        .unwrap());
    assert_eq!(
        queue
            .status(&trust.requested_by, last.request.intent.operation_id())
            .await
            .unwrap()
            .unwrap()
            .state,
        "DEAD"
    );
    assert!(queue.claim(10).await.unwrap().is_none());
    assert!(queue
        .status("other-actor", last.request.intent.operation_id())
        .await
        .unwrap()
        .is_none());
    assert!(
        PreviewQueue::connect(&url, &trust.tenant).await.is_err(),
        "worker refuses admin credentials"
    );
    for nonce in [
        b"completed".as_slice(),
        b"expired-before-start".as_slice(),
        b"qualification-denied".as_slice(),
    ] {
        let r = renew(&request, nonce);
        let a = admit_preview(r.clone(), &trust, &baseline, now())
            .await
            .unwrap();
        let mut tx = begin(&runtime, &trust.tenant).await;
        enqueue_preview(&mut tx, &a).await.unwrap();
        tx.commit().await.unwrap();
        assert!(queue.claim_for("other-actor", 10).await.unwrap().is_none());
        if nonce == b"qualification-denied" {
            let dir =
                std::env::temp_dir().join(format!("arkhe-preview-deny-{}", uuid::Uuid::new_v4()));
            std::fs::create_dir(&dir).unwrap();
            let trust_path = dir.join("trust.json");
            let config_path = dir.join("executor.json");
            std::fs::write(&trust_path, serde_json::to_vec(&trust).unwrap()).unwrap();
            let config = arkhe_runtime::preview::executor::ExecutorConfig {
                authority: None,
                podman: dir.join("absent-podman"),
                connection: "test".into(),
                artifact_store: dir.join("artifacts"),
                qualification: dir.join("absent-qualification.json"),
                qualification_key: [21; 32],
                trust_file: trust_path.clone(),
            };
            std::fs::write(&config_path, serde_json::to_vec(&config).unwrap()).unwrap();
            let output = std::process::Command::new(env!("CARGO_BIN_EXE_arkhe-preview-worker"))
                .arg("--executor")
                .arg(&config_path)
                .env("ARKHE_PREVIEW_DATABASE_URL", &runtime_url)
                .output()
                .unwrap();
            assert!(
                output.status.success(),
                "{}",
                String::from_utf8_lossy(&output.stderr)
            );
            let value: serde_json::Value = serde_json::from_slice(&output.stdout).unwrap();
            assert_eq!(value["state"], "RETRY_OR_DEAD");
            assert_eq!(
                queue
                    .status(&trust.requested_by, r.intent.operation_id())
                    .await
                    .unwrap()
                    .unwrap()
                    .state,
                "RETRY"
            );
            std::fs::remove_file(trust_path).unwrap();
            std::fs::remove_file(config_path).unwrap();
            std::fs::remove_dir(dir).unwrap();
            continue;
        }
        let owned = queue
            .claim_for(&trust.requested_by, 10)
            .await
            .unwrap()
            .unwrap();
        if nonce == b"expired-before-start" {
            sqlx::query("UPDATE preview_dispatches SET lease_until=clock_timestamp()-interval '1 second' WHERE operation_id=$1").bind(owned.request.intent.operation_id().0.to_vec()).execute(&pool).await.unwrap();
            let recovered = queue
                .claim_for(&trust.requested_by, 10)
                .await
                .unwrap()
                .unwrap();
            assert!(recovered.fence > owned.fence);
            assert!(!queue.start(&owned).await.unwrap());
            assert!(queue
                .finish(&recovered, Completion::Failed("test preflight".into()))
                .await
                .unwrap());
        } else {
            assert!(queue.start(&owned).await.unwrap());
            assert!(queue
                .finish(
                    &owned,
                    Completion::Succeeded(serde_json::json!({"test_fixture":true}))
                )
                .await
                .unwrap());
            assert!(!queue
                .finish(&owned, Completion::Succeeded(serde_json::json!({})))
                .await
                .unwrap());
        }
    }
    runtime.close().await;
    pool.close().await;
}
