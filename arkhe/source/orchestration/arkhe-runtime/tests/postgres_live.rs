#![cfg(feature = "postgres-integration")]
use arkhe_core::{
    evidence::{EvidenceCommitter, EvidenceEnvelope, EvidenceReader, WorkEvidenceCommitter},
    work::{WorkIntent, WorkIntentType},
    worker::WorkerExecutionRecord,
    CanonicalEncode, Digest32,
};
use arkhe_governance::{DevPolicyResolver, PolicyBinding};
use arkhe_kernel::ContainmentGate;
use arkhe_runtime::{Runtime, WorkCommitError};
use arkhe_wormgraph::postgres::PgWormGraph;
use std::sync::Arc;
fn intent() -> WorkIntent {
    WorkIntent {
        requested_by: "local-operator".into(),
        intent_type: WorkIntentType::Simulate,
        target: Digest32::ZERO,
        parameters_digest: Digest32::ZERO,
        context: vec![],
        context_refs: vec![],
        request_identity: arkhe_core::work::RequestIdentity::new(uuid::Uuid::new_v4().as_bytes()),
        claimed_created_at: 0,
    }
}
fn worker(i: &WorkIntent) -> WorkerExecutionRecord {
    arkhe_agent::plan(i, vec![]).1
}
fn policy() -> PolicyBinding {
    PolicyBinding {
        policy_id: "test".into(),
        version: 1,
        policy_digest: Digest32::ZERO,
    }
}
#[tokio::test]
async fn postgres_atomic_admission_isolation_replay_and_reconnect() {
    let url = std::env::var("ARKHE_TEST_DATABASE_URL")
        .expect("real non-admin PostgreSQL URL is required");
    let tenant = format!("test-{}", uuid::Uuid::new_v4());
    let store = Arc::new(PgWormGraph::connect(&url, &tenant).await.unwrap());
    let other = PgWormGraph::connect(&url, &format!("other-{tenant}"))
        .await
        .unwrap();
    let runtime = Runtime {
        gate: ContainmentGate::new(DevPolicyResolver),
    };
    let i = intent();
    let w = worker(&i);
    let p = policy();
    let hash = runtime
        .commit_proposed_work(store.as_ref(), &i, &w, &p)
        .await
        .unwrap();
    let envelope = store.get(hash).await.unwrap().unwrap();
    assert_eq!(envelope.subject, i.digest());
    assert_eq!(envelope.payload_digest, w.digest());
    assert_eq!(
        store
            .canonical_object("WorkIntent", i.digest())
            .await
            .unwrap(),
        Some(i.canonical_bytes())
    );
    assert_eq!(
        store
            .canonical_object("WorkerExecutionRecord", w.digest())
            .await
            .unwrap(),
        Some(w.canonical_bytes())
    );
    assert!(other.get(hash).await.unwrap().is_none());
    assert!(other
        .canonical_object("WorkIntent", i.digest())
        .await
        .unwrap()
        .is_none());
    let mut jobs = vec![];
    for _ in 0..8 {
        let store = store.clone();
        let i = i.clone();
        let w = w.clone();
        jobs.push(tokio::spawn(async move {
            Runtime {
                gate: ContainmentGate::new(DevPolicyResolver),
            }
            .commit_proposed_work(store.as_ref(), &i, &w, &policy())
            .await
            .unwrap()
        }));
    }
    for job in jobs {
        assert_eq!(job.await.unwrap(), hash);
    }
    let reconnect = PgWormGraph::connect(&url, &tenant).await.unwrap();
    assert_eq!(reconnect.get(hash).await.unwrap(), Some(envelope.clone()));
    // Any metadata conflict, not only a different payload, must be rejected.
    let mut conflict = envelope.clone();
    conflict.kind = "tampered".into();
    assert!(store.append_verified(conflict).await.is_err());
    assert_eq!(store.get(hash).await.unwrap(), Some(envelope));
    // Add a real parent link and verify it survives a connection change.
    let mut child = intent();
    child.context_refs = vec![hash];
    let mut cw = worker(&child);
    cw.evidence_refs = vec![hash];
    let ch = runtime
        .commit_proposed_work(store.as_ref(), &child, &cw, &p)
        .await
        .unwrap();
    assert_eq!(
        reconnect.get(ch).await.unwrap().unwrap().causal_parents,
        vec![hash]
    );
    // Object inserts occur before parent validation inside the transaction.
    // A missing evidence parent must roll back both objects, not just the envelope.
    let broken = intent();
    let mut bw = worker(&broken);
    bw.evidence_refs = vec![Digest32::ZERO];
    assert!(matches!(
        runtime
            .commit_proposed_work(store.as_ref(), &broken, &bw, &p)
            .await,
        Err(WorkCommitError::Storage(_))
    ));
    assert!(store
        .canonical_object("WorkIntent", broken.digest())
        .await
        .unwrap()
        .is_none());
    assert!(store
        .canonical_object("WorkerExecutionRecord", bw.digest())
        .await
        .unwrap()
        .is_none());
    // The same parent cannot be imported into another tenant by its hash.
    let mut cross = intent();
    cross.context_refs = vec![hash];
    let crossw = worker(&cross);
    assert!(runtime
        .commit_proposed_work(&other, &cross, &crossw, &p)
        .await
        .is_err());
    assert!(other
        .canonical_object("WorkIntent", cross.digest())
        .await
        .unwrap()
        .is_none());
    let mut protected = intent();
    protected.intent_type = WorkIntentType::Publish;
    let pw = worker(&protected);
    assert!(matches!(
        runtime
            .commit_proposed_work(store.as_ref(), &protected, &pw, &p)
            .await,
        Err(WorkCommitError::Rejected(_))
    ));
    assert!(store
        .canonical_object("WorkIntent", protected.digest())
        .await
        .unwrap()
        .is_none());
    let mismatch = intent();
    assert!(matches!(
        runtime
            .commit_proposed_work(store.as_ref(), &mismatch, &w, &p)
            .await,
        Err(WorkCommitError::Rejected(_))
    ));
    // Exercise PostgreSQL permissions through the real login, not an admin connection.
    let pool = sqlx::PgPool::connect(&url).await.unwrap();
    for table in ["work_objects", "wormgraph_records"] {
        for op in [
            format!("DELETE FROM {table}"),
            format!("TRUNCATE {table}"),
            format!("UPDATE {table} SET tenant_id='tampered'"),
        ] {
            let mut tx = pool.begin().await.unwrap();
            sqlx::query("SET LOCAL ROLE arkhe_append")
                .execute(&mut *tx)
                .await
                .unwrap();
            sqlx::query("SELECT set_config('app.tenant_id',$1,true)")
                .bind(&tenant)
                .execute(&mut *tx)
                .await
                .unwrap();
            let err = sqlx::query(&op).execute(&mut *tx).await.unwrap_err();
            assert_eq!(
                err.as_database_error().unwrap().code().as_deref(),
                Some("42501")
            );
            tx.rollback().await.unwrap();
        }
    }
    let mut tx = pool.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_append")
        .execute(&mut *tx)
        .await
        .unwrap();
    let missing = sqlx::query("SELECT count(*) FROM wormgraph_records")
        .execute(&mut *tx)
        .await
        .unwrap_err();
    assert_eq!(
        missing.as_database_error().unwrap().code().as_deref(),
        Some("42501")
    );
    tx.rollback().await.unwrap();
    // Query without an application tenant predicate: PostgreSQL itself must hide A.
    for table in ["work_objects", "wormgraph_records"] {
        let mut tx = pool.begin().await.unwrap();
        sqlx::query("SET LOCAL ROLE arkhe_append")
            .execute(&mut *tx)
            .await
            .unwrap();
        sqlx::query("SELECT set_config('app.tenant_id',$1,true)")
            .bind(format!("other-{tenant}"))
            .execute(&mut *tx)
            .await
            .unwrap();
        let count: i64 = sqlx::query_scalar(&format!("SELECT count(*) FROM {table}"))
            .fetch_one(&mut *tx)
            .await
            .unwrap();
        assert_eq!(
            count, 0,
            "RLS must enforce isolation without WHERE tenant_id"
        );
        let statement = if table == "work_objects" {
            "INSERT INTO work_objects(tenant_id,object_type,object_digest,canonical_bytes) VALUES($1,'WorkIntent',decode(repeat('ef',32),'hex'),decode('01','hex'))"
        } else {
            "INSERT INTO wormgraph_records(tenant_id,record_hash,envelope) VALUES($1,decode(repeat('ef',32),'hex'),'{}'::jsonb)"
        };
        let err = sqlx::query(statement)
            .bind(&tenant)
            .execute(&mut *tx)
            .await
            .unwrap_err();
        assert_eq!(
            err.as_database_error().unwrap().code().as_deref(),
            Some("42501")
        );
        tx.rollback().await.unwrap();
    }
    let admin = std::env::var("ARKHE_TEST_ADMIN_DATABASE_URL")
        .expect("admin URL required to verify runtime refuses elevated credentials");
    assert!(PgWormGraph::connect(&admin, &tenant).await.is_err());
    // Tenant context is transaction-local: no pool/session leakage after commit.
    let context: Option<String> =
        sqlx::query_scalar("SELECT current_setting('app.tenant_id',true)")
            .fetch_one(&pool)
            .await
            .unwrap();
    assert!(context.is_none_or(|s| s.is_empty()));
}
struct Unavailable;
#[async_trait::async_trait]
impl WorkEvidenceCommitter for Unavailable {
    async fn commit_work(
        &self,
        _: &WorkIntent,
        _: &WorkerExecutionRecord,
        _: EvidenceEnvelope,
    ) -> Result<Digest32, String> {
        Err("offline".into())
    }
}
#[tokio::test]
async fn no_receipt_when_evidence_store_is_unavailable() {
    let runtime = Runtime {
        gate: ContainmentGate::new(DevPolicyResolver),
    };
    let i = intent();
    assert!(matches!(
        runtime
            .commit_proposed_work(&Unavailable, &i, &worker(&i), &policy())
            .await,
        Err(WorkCommitError::Storage(_))
    ));
}
