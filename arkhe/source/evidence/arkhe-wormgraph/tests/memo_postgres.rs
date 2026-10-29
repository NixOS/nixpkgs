use arkhe_core::work::RequestIdentity;
use arkhe_verify_core::{
    memo_reconciliation::MemoBundle, mmr::build_root_and_proof, reconciliation::Trust,
};
use arkhe_wormgraph::postgres::{
    memo::{verify_export, MemoPackage, MemoStorageReceipt},
    PgWormGraph,
};
use sqlx::PgPool;
use std::{
    io::BufRead,
    process::{Child, Command, Stdio},
    time::{Duration, Instant, SystemTime, UNIX_EPOCH},
};

fn fixture() -> MemoPackage {
    MemoPackage {
        bundle: serde_json::from_str::<MemoBundle>(include_str!("fixtures/memo/bundle.json"))
            .unwrap(),
        local_trust: serde_json::from_str::<Trust>(include_str!("fixtures/memo/trust.json"))
            .unwrap(),
    }
}
struct Process(Child);
impl Drop for Process {
    fn drop(&mut self) {
        let _ = self.0.kill();
        let _ = self.0.wait();
    }
}
fn start_writer(tenant: &str) -> Process {
    let exe =
        std::env::var("ARKHE_MEMO_EXAMPLE_BINARY").expect("build memo_persistence example first");
    let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR")).join("tests/fixtures/memo");
    Process(
        Command::new(exe)
            .arg("commit-hold")
            .arg(root.join("bundle.json"))
            .arg(root.join("trust.json"))
            .env("ARKHE_MEMO_TENANT", tenant)
            .stdout(Stdio::piped())
            .stderr(Stdio::inherit())
            .spawn()
            .unwrap(),
    )
}
fn receive_commit(process: &mut Process) -> MemoStorageReceipt {
    let stdout = process.0.stdout.take().unwrap();
    let (send, receive) = std::sync::mpsc::channel();
    std::thread::spawn(move || {
        let mut line = String::new();
        let result = std::io::BufReader::new(stdout).read_line(&mut line);
        let _ = send.send((result.is_ok(), line));
    });
    let (ok, line) = receive
        .recv_timeout(Duration::from_secs(20))
        .expect("writer commit deadline");
    assert!(ok && !line.is_empty(), "writer did not report commit");
    serde_json::from_str(&line).unwrap()
}
fn refreshed(mut p: MemoPackage, nonce: Option<&[u8]>, changed_document: bool) -> MemoPackage {
    let r = &mut p.bundle.reconciliation.record;
    if let Some(nonce) = nonce {
        r.intent.request_identity = RequestIdentity::new(nonce);
    }
    if changed_document {
        r.input.invoices[0].document.push(b'!');
    }
    r.input.operation_id = r.intent.operation_id();
    r.intent.parameters_digest = r.input.digest();
    r.decision = arkhe_verify_core::reconciliation::evaluate(&r.input).unwrap();
    r.worker.input_digest = r.input.digest();
    r.worker.output_digest = r.decision.digest();
    p.local_trust.expected_intent = r.intent.digest();
    let (root, steps) = build_root_and_proof(&[r.leaf_bytes()], 0).unwrap();
    p.local_trust.root = root;
    p.local_trust.leaf_count = 1;
    p.bundle.reconciliation.leaf_index = 0;
    p.bundle.reconciliation.steps = steps;
    p
}

#[tokio::test]
#[ignore = "requires isolated migrated PostgreSQL, restricted runtime role and memo_persistence binary"]
async fn real_postgres_commit_kill_reopen_rollback_and_tenant_isolation() {
    let url = std::env::var("ARKHE_MEMO_DATABASE_URL").unwrap();
    let admin_url = std::env::var("ARKHE_MEMO_TEST_ADMIN_URL").unwrap();
    let unique = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_nanos();
    let tenant = format!("memo-committed-{unique}");
    let mut child = start_writer(&tenant);
    let receipt = receive_commit(&mut child);
    child.0.kill().unwrap();
    assert!(!child.0.wait().unwrap().success());
    println!("PASS writer forcibly terminated after committed receipt");

    let graph = PgWormGraph::connect(&url, &tenant).await.unwrap();
    let export = graph
        .export_memo_observation(receipt.record_hash)
        .await
        .unwrap();
    assert!(verify_export(&export, &export.graph).is_ok());
    let expected = serde_json::to_vec(&fixture()).unwrap();
    assert_eq!(export.package_bytes, expected);
    let replay = graph.commit_memo_observation(&fixture()).await.unwrap();
    assert_eq!(replay.record_hash, receipt.record_hash);
    assert_eq!(replay.graph_leaf_count, 1);
    assert!(graph
        .commit_memo_observation(&refreshed(fixture(), None, true))
        .await
        .is_err());
    println!(
        "PASS reopened package byte equality, verification, idempotency and operation conflict"
    );

    // Grow to three leaves and recover an older retained checkpoint as well.
    graph
        .commit_memo_observation(&refreshed(fixture(), Some(b"second"), false))
        .await
        .unwrap();
    let third = graph
        .commit_memo_observation(&refreshed(fixture(), Some(b"third"), false))
        .await
        .unwrap();
    assert_eq!(third.graph_leaf_count, 3);
    let third_export = graph
        .export_memo_observation(third.record_hash)
        .await
        .unwrap();
    assert!(verify_export(&third_export, &third_export.graph).is_ok());
    assert!(verify_export(
        &graph
            .export_memo_observation(receipt.record_hash)
            .await
            .unwrap(),
        &export.graph
    )
    .is_ok());
    let mut wrong_pin = third_export.graph.clone();
    wrong_pin.root[0] ^= 1;
    assert!(verify_export(&third_export, &wrong_pin).is_err());
    let mut tampered = third_export.clone();
    tampered.package_bytes[0] ^= 1;
    assert!(verify_export(&tampered, &third_export.graph).is_err());
    let mut wrong_index = third_export.clone();
    wrong_index.leaf_index = u64::MAX;
    assert!(verify_export(&wrong_index, &third_export.graph).is_err());
    let other = PgWormGraph::connect(&url, &format!("memo-other-{unique}"))
        .await
        .unwrap();
    assert!(other
        .export_memo_observation(receipt.record_hash)
        .await
        .is_err());
    println!("PASS three-leaf graph, old checkpoint, tamper rejection and cross-tenant isolation");

    let admin = PgPool::connect(&admin_url).await.unwrap();
    let runtime = PgPool::connect(&url).await.unwrap();
    let mut isolation = runtime.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_read")
        .execute(&mut *isolation)
        .await
        .unwrap();
    arkhe_sql::tenant::set_tenant(&mut isolation, &format!("memo-other-{unique}"))
        .await
        .unwrap();
    // No application tenant predicate: visibility must be restricted by SQL RLS.
    let hidden: i64 =
        sqlx::query_scalar("SELECT count(*) FROM memo_observation_packages WHERE record_hash=$1")
            .bind(receipt.record_hash.0.to_vec())
            .fetch_one(&mut *isolation)
            .await
            .unwrap();
    assert_eq!(hidden, 0);
    isolation.commit().await.unwrap();
    println!("PASS direct SQL read without tenant predicate is isolated by RLS");
    let mut tx = runtime.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_append")
        .execute(&mut *tx)
        .await
        .unwrap();
    arkhe_sql::tenant::set_tenant(&mut tx, &tenant)
        .await
        .unwrap();
    assert!(sqlx::query(
        "UPDATE memo_observation_packages SET package_bytes=package_bytes WHERE tenant_id=$1"
    )
    .bind(&tenant)
    .execute(&mut *tx)
    .await
    .is_err());
    tx.rollback().await.unwrap();
    println!("PASS runtime append role cannot mutate stored packages");

    // Test-only trigger in the isolated DB pauses AFTER envelope/checkpoint insert,
    // BEFORE package insert, while all changes are still in the same transaction.
    sqlx::query("CREATE FUNCTION memo_test_pause() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN IF NEW.tenant_id LIKE 'memo-uncommitted-%' THEN PERFORM pg_sleep(5); END IF; RETURN NEW; END $$")
        .execute(&admin).await.unwrap();
    sqlx::query("CREATE TRIGGER memo_test_pause BEFORE INSERT ON memo_observation_packages FOR EACH ROW EXECUTE FUNCTION memo_test_pause()")
        .execute(&admin).await.unwrap();
    let uncommitted = format!("memo-uncommitted-{unique}");
    let mut before_commit = start_writer(&uncommitted);
    let deadline = Instant::now();
    let backend_pid: i32 = loop {
        let pid: Option<i32> = sqlx::query_scalar("SELECT pid FROM pg_stat_activity WHERE datname=current_database() AND wait_event='PgSleep' AND query LIKE 'INSERT INTO memo_observation_packages%' LIMIT 1")
            .fetch_optional(&admin).await.unwrap();
        if let Some(pid) = pid {
            break pid;
        }
        assert!(
            deadline.elapsed() < Duration::from_secs(20),
            "did not observe uncommitted write"
        );
        tokio::time::sleep(Duration::from_millis(100)).await;
    };
    before_commit.0.kill().unwrap();
    before_commit.0.wait().unwrap();
    let deadline = Instant::now();
    loop {
        let exists: bool =
            sqlx::query_scalar("SELECT EXISTS(SELECT 1 FROM pg_stat_activity WHERE pid=$1)")
                .bind(backend_pid)
                .fetch_one(&admin)
                .await
                .unwrap();
        if !exists {
            break;
        }
        assert!(
            deadline.elapsed() < Duration::from_secs(15),
            "killed writer backend did not close"
        );
        tokio::time::sleep(Duration::from_millis(100)).await;
    }
    for table in [
        "memo_observation_packages",
        "wormgraph_records",
        "mmr_checkpoints",
    ] {
        let count: i64 =
            sqlx::query_scalar(&format!("SELECT count(*) FROM {table} WHERE tenant_id=$1"))
                .bind(&uncommitted)
                .fetch_one(&admin)
                .await
                .unwrap();
        assert_eq!(count, 0, "partial state in {table}");
    }
    println!("PASS killed uncommitted writer leaves zero package/envelope/checkpoint rows");
    admin.close().await;
    runtime.close().await;
}
