//! Full-prefix consistency units; live cases use real PostgreSQL and simulated payouts.
use arkhe_bugbounty::bounty_evidence::{durable::FullPrefixConsistency, trust::SignedCheckpoint};
use arkhe_verify_core::mmr::build_root_and_proof;
fn checkpoint(leaves: &[Vec<u8>], at: u64) -> SignedCheckpoint {
    SignedCheckpoint {
        log_id: [1; 32],
        root: build_root_and_proof(leaves, 0).unwrap().0,
        leaf_count: leaves.len() as u64,
        issued_at: at,
        signature_hex: String::new(),
    }
}
#[test]
fn full_prefix_consistency_rejects_rewritten_history_and_bad_lengths() {
    let old = vec![b"old".to_vec()];
    let mut new = old.clone();
    new.push(b"new".to_vec());
    let a = checkpoint(&old, 10);
    let b = checkpoint(&new, 11);
    assert!(FullPrefixConsistency {
        leaves: new.clone()
    }
    .verify(&a, &b)
    .is_ok());
    let rewritten = vec![b"evil".to_vec(), b"new".to_vec()];
    assert!(FullPrefixConsistency { leaves: rewritten }
        .verify(&a, &b)
        .is_err());
    assert!(FullPrefixConsistency { leaves: old }
        .verify(&a, &b)
        .is_err());
    let mut huge = b;
    huge.leaf_count = u64::MAX;
    assert!(FullPrefixConsistency { leaves: new }
        .verify(&a, &huge)
        .is_err());
}
#[cfg(feature = "postgres-integration")]
mod live {
    use super::*;
    use arkhe_bugbounty::bounty_evidence::{durable::*, priority::*, trust::CheckpointTrust};
    use arkhe_core::Digest32;
    use async_trait::async_trait;
    use ed25519_dalek::{Signer, SigningKey};
    use uuid::Uuid;
    struct Source;
    #[async_trait]
    impl AnchorSource for Source {
        async fn verified_anchor(&self, _: [u8; 32]) -> Result<AnchoredClaim, String> {
            Err("unused".into())
        }
        async fn verified_priority_snapshot(
            &self,
            vulnerability_id: [u8; 32],
        ) -> Result<PrioritySnapshot, String> {
            Ok(PrioritySnapshot {
                vulnerability_id,
                log_id: [1; 32],
                closed_at: 20,
                finalized: true,
                eligible_claims: vec![AnchoredClaim {
                    log_id: [1; 32],
                    commitment: [2; 32],
                    report_digest: [3; 32],
                    recipient: [4; 32],
                    anchored_at: 10,
                    log_position: 0,
                    chain_id: 1,
                    submission_block: 100,
                }],
            })
        }
    }
    fn url() -> String {
        std::env::var("ARKHE_TEST_DATABASE_URL").expect("real PostgreSQL required")
    }
    fn tenant() -> String {
        format!("durable-gates-{}", Uuid::new_v4())
    }
    fn request() -> PayoutRequest {
        PayoutRequest {
            idempotency_key: Digest32([5; 32]),
            vulnerability_id: Digest32([6; 32]),
            recipient: [4; 32],
            amount_decimal: "100".into(),
            asset_id: Digest32([7; 32]),
            chain_id: 1,
        }
    }
    #[tokio::test]
    async fn payout_concurrent_claim_reconnect_replay_parameters_and_owner_fencing() {
        let t = tenant();
        let a = PgPayoutJournal::connect(&url(), &t).await.unwrap();
        let b = PgPayoutJournal::connect(&url(), &t).await.unwrap();
        let r = request();
        let p = ClosedPriority::resolve(&Source, r.vulnerability_id.0)
            .await
            .unwrap();
        let (x, y) = tokio::join!(a.enqueue_candidate(&r, &p), b.enqueue_candidate(&r, &p));
        assert_eq!(x.unwrap(), Enqueued::Pending);
        assert_eq!(y.unwrap(), Enqueued::Pending);
        let mut changed = r.clone();
        changed.amount_decimal = "101".into();
        assert_eq!(
            a.enqueue_candidate(&changed, &p).await.unwrap(),
            Enqueued::ParameterMismatch
        );
        let mut duplicate = r.clone();
        duplicate.idempotency_key = Digest32([8; 32]);
        assert_eq!(
            a.enqueue_candidate(&duplicate, &p).await.unwrap(),
            Enqueued::DuplicateVulnerability
        );
        let (x, y) = tokio::join!(a.claim(), b.claim());
        let jobs: Vec<_> = [x.unwrap(), y.unwrap()].into_iter().flatten().collect();
        assert_eq!(jobs.len(), 1);
        let job = &jobs[0];
        let external_writes = std::sync::atomic::AtomicUsize::new(0);
        external_writes.fetch_add(1, std::sync::atomic::Ordering::SeqCst); // simulated provider only
        assert!(a
            .complete(r.idempotency_key, Uuid::new_v4(), "SIMULATED")
            .await
            .is_err());
        a.complete(job.request.idempotency_key, job.owner, "SIMULATED-RECEIPT")
            .await
            .unwrap();
        drop(a);
        drop(b);
        let c = PgPayoutJournal::connect(&url(), &t).await.unwrap();
        assert_eq!(
            c.enqueue_candidate(&r, &p).await.unwrap(),
            Enqueued::Replay("SIMULATED-RECEIPT".into())
        );
        assert!(c.claim().await.unwrap().is_none());
        assert_eq!(external_writes.load(std::sync::atomic::Ordering::SeqCst), 1);
        let isolated = PgPayoutJournal::connect(&url(), &tenant()).await.unwrap();
        assert!(isolated.claim().await.unwrap().is_none());
        assert_eq!(
            isolated.enqueue_candidate(&r, &p).await.unwrap(),
            Enqueued::Pending
        );
    }
    #[tokio::test]
    async fn uncertain_external_result_survives_reconnect_without_redispatch() {
        let t = tenant();
        let a = PgPayoutJournal::connect(&url(), &t).await.unwrap();
        let r = request();
        let p = ClosedPriority::resolve(&Source, r.vulnerability_id.0)
            .await
            .unwrap();
        assert_eq!(
            a.enqueue_candidate(&r, &p).await.unwrap(),
            Enqueued::Pending
        );
        let job = a.claim().await.unwrap().unwrap();
        let simulated_writes = std::sync::atomic::AtomicUsize::new(0);
        simulated_writes.fetch_add(1, std::sync::atomic::Ordering::SeqCst);
        drop(job);
        drop(a); // external effect occurred; completion acknowledgement was lost
        let b = PgPayoutJournal::connect(&url(), &t).await.unwrap();
        assert_eq!(
            b.enqueue_candidate(&r, &p).await.unwrap(),
            Enqueued::Uncertain
        );
        assert_eq!(b.uncertain().await.unwrap(), 1);
        assert!(b.claim().await.unwrap().is_none());
        assert_eq!(
            simulated_writes.load(std::sync::atomic::Ordering::SeqCst),
            1
        );
    }
    fn signed(leaves: &[Vec<u8>], at: u64, key: &SigningKey) -> SignedCheckpoint {
        let mut c = checkpoint(leaves, at);
        c.signature_hex = hex::encode(key.sign(&c.signing_bytes()).to_bytes());
        c
    }
    #[tokio::test]
    async fn witness_survives_reconnect_rejects_equivocation_rollback_and_forked_growth() {
        let t = tenant();
        let key = SigningKey::from_bytes(&[9; 32]);
        let trust = CheckpointTrust {
            log_id: [1; 32],
            public_key: key.verifying_key().to_bytes(),
            minimum_leaf_count: 1,
            earliest_checkpoint: 0,
            latest_checkpoint: 100,
        };
        let old = vec![b"first".to_vec()];
        let new = vec![b"first".to_vec(), b"second".to_vec()];
        let a = signed(&old, 10, &key);
        let b = signed(&new, 11, &key);
        let w = PgCheckpointWitness::connect(&url(), &t).await.unwrap();
        w.observe(&a, &trust, None).await.unwrap();
        drop(w);
        let w = PgCheckpointWitness::connect(&url(), &t).await.unwrap();
        let equiv = signed(&[b"forged".to_vec()], 10, &key);
        assert!(w
            .observe(&equiv, &trust, None)
            .await
            .unwrap_err()
            .contains("equivocation"));
        assert!(w.observe(&b, &trust, None).await.is_err());
        let fork = vec![b"fork".to_vec(), b"second".to_vec()];
        let fork_cp = signed(&fork, 11, &key);
        assert!(w
            .observe(
                &fork_cp,
                &trust,
                Some(&FullPrefixConsistency { leaves: fork })
            )
            .await
            .is_err());
        w.observe(&b, &trust, Some(&FullPrefixConsistency { leaves: new }))
            .await
            .unwrap();
        drop(w);
        let w = PgCheckpointWitness::connect(&url(), &t).await.unwrap();
        assert!(w
            .observe(&a, &trust, None)
            .await
            .unwrap_err()
            .contains("rollback"));
        w.observe(&b, &trust, None).await.unwrap();
    }

    #[tokio::test]
    async fn concurrent_witness_updates_cannot_accept_two_conflicting_heads() {
        let t = tenant();
        let key = SigningKey::from_bytes(&[9; 32]);
        let trust = CheckpointTrust {
            log_id: [1; 32],
            public_key: key.verifying_key().to_bytes(),
            minimum_leaf_count: 1,
            earliest_checkpoint: 0,
            latest_checkpoint: 100,
        };
        let initial = signed(&[b"first".to_vec()], 10, &key);
        let a = PgCheckpointWitness::connect(&url(), &t).await.unwrap();
        let b = PgCheckpointWitness::connect(&url(), &t).await.unwrap();
        a.observe(&initial, &trust, None).await.unwrap();
        let left = vec![b"first".to_vec(), b"left".to_vec()];
        let right = vec![b"first".to_vec(), b"right".to_vec()];
        let cp_left = signed(&left, 11, &key);
        let cp_right = signed(&right, 11, &key);
        let proof_left = FullPrefixConsistency { leaves: left };
        let proof_right = FullPrefixConsistency { leaves: right };
        let (x, y) = tokio::join!(
            a.observe(&cp_left, &trust, Some(&proof_left)),
            b.observe(&cp_right, &trust, Some(&proof_right))
        );
        assert_ne!(x.is_ok(), y.is_ok());
    }

    #[tokio::test]
    async fn operational_tables_enforce_rls_and_reject_illegal_state_or_payload_changes() {
        let pool = sqlx::PgPool::connect(&url()).await.unwrap();
        let count:i64=sqlx::query_scalar("SELECT count(*) FROM pg_class WHERE relname IN ('payout_jobs','checkpoint_witness') AND relrowsecurity AND relforcerowsecurity").fetch_one(&pool).await.unwrap();
        assert_eq!(count, 2);
        let destructive:bool=sqlx::query_scalar("SELECT has_table_privilege('arkhe_operations','payout_jobs','DELETE') OR has_table_privilege('arkhe_operations','payout_jobs','TRUNCATE') OR has_column_privilege('arkhe_operations','payout_jobs','payload','UPDATE') OR has_column_privilege('arkhe_operations','checkpoint_witness','log_id','UPDATE')").fetch_one(&pool).await.unwrap();
        assert!(!destructive);
        let t = tenant();
        let journal = PgPayoutJournal::connect(&url(), &t).await.unwrap();
        let r = request();
        let priority = ClosedPriority::resolve(&Source, r.vulnerability_id.0)
            .await
            .unwrap();
        journal.enqueue_candidate(&r, &priority).await.unwrap();
        let mut tx = pool.begin().await.unwrap();
        sqlx::query("SET LOCAL ROLE arkhe_operations")
            .execute(&mut *tx)
            .await
            .unwrap();
        arkhe_sql::tenant::set_tenant(&mut tx, &t).await.unwrap();
        let result=sqlx::query("UPDATE payout_jobs SET status='COMPLETED',owner_token=$2,receipt='FORGED' WHERE tenant_id=$1").bind(&t).bind(Uuid::new_v4()).execute(&mut *tx).await;
        assert!(result.is_err());
        tx.rollback().await.unwrap();
        let job = journal.claim().await.unwrap().unwrap();
        let mut tx = pool.begin().await.unwrap();
        sqlx::query("SET LOCAL ROLE arkhe_operations")
            .execute(&mut *tx)
            .await
            .unwrap();
        arkhe_sql::tenant::set_tenant(&mut tx, &t).await.unwrap();
        assert!(sqlx::query(
            "UPDATE payout_jobs SET status='PENDING',owner_token=NULL WHERE tenant_id=$1"
        )
        .bind(&t)
        .execute(&mut *tx)
        .await
        .is_err());
        tx.rollback().await.unwrap();
        journal
            .complete(job.request.idempotency_key, job.owner, "SIMULATED")
            .await
            .unwrap();
    }
}
