//! External log fixtures only; no real anchor or payout.
use arkhe_bugbounty::{
    bounty_evidence::{priority::*, *},
    review::votes::{self, *},
};
use async_trait::async_trait;
fn claim(id: u8, at: u64, pos: u64) -> AnchoredClaim {
    AnchoredClaim {
        log_id: [1; 32],
        commitment: [id; 32],
        report_digest: [id; 32],
        recipient: [id; 32],
        anchored_at: at,
        log_position: pos,
        chain_id: 1,
        submission_block: 110,
    }
}
struct Source(PrioritySnapshot);
#[async_trait]
impl AnchorSource for Source {
    async fn verified_anchor(&self, _: [u8; 32]) -> Result<AnchoredClaim, String> {
        Err("not used".into())
    }
    async fn verified_priority_snapshot(&self, _: [u8; 32]) -> Result<PrioritySnapshot, String> {
        Ok(self.0.clone())
    }
}
fn snapshot(claims: Vec<AnchoredClaim>) -> Source {
    Source(PrioritySnapshot {
        vulnerability_id: [8; 32],
        log_id: [1; 32],
        closed_at: 100,
        finalized: true,
        eligible_claims: claims,
    })
}
#[tokio::test]
async fn second_anchor_cannot_pay_first_and_ties_ignore_request_order() {
    let first = claim(2, 10, 3);
    let second = claim(3, 11, 1);
    let priority = ClosedPriority::resolve(&snapshot(vec![second.clone(), first.clone()]), [8; 32])
        .await
        .unwrap();
    let mut j = PayoutJournal::default();
    assert_eq!(
        j.pay([1; 32], [8; 32], second.recipient, 10, &second, &priority),
        PayoutResult::NotPriorityWinner
    );
    assert_eq!(
        j.pay([2; 32], [8; 32], first.recipient, 10, &first, &priority),
        PayoutResult::Applied
    );
    assert_eq!(
        j.pay([2; 32], [8; 32], first.recipient, 10, &first, &priority),
        PayoutResult::Replayed { amount: 10 }
    );
    assert_eq!(
        j.pay([2; 32], [8; 32], first.recipient, 20, &first, &priority),
        PayoutResult::ParameterMismatch
    );
    let tie = claim(4, 10, 2);
    for claims in [
        vec![first.clone(), tie.clone()],
        vec![tie.clone(), first.clone()],
    ] {
        let p = ClosedPriority::resolve(&snapshot(claims), [8; 32])
            .await
            .unwrap();
        assert_eq!(p.winner(), &tie);
    }
    let mut forged = first.clone();
    forged.anchored_at = 0;
    assert_eq!(
        j.pay([3; 32], [8; 32], forged.recipient, 10, &forged, &priority),
        PayoutResult::NotPriorityWinner
    );
}
#[tokio::test]
async fn incomplete_ambiguous_or_changed_snapshot_cannot_silently_replay() {
    let first = claim(2, 10, 1);
    let mut source = snapshot(vec![first.clone()]);
    source.0.finalized = false;
    assert!(ClosedPriority::resolve(&source, [8; 32]).await.is_err());
    assert!(
        ClosedPriority::resolve(&snapshot(vec![first.clone(), first.clone()]), [8; 32])
            .await
            .is_err()
    );
    let p = ClosedPriority::resolve(&snapshot(vec![first.clone()]), [8; 32])
        .await
        .unwrap();
    let mut j = PayoutJournal::default();
    assert_eq!(
        j.pay([1; 32], [8; 32], first.recipient, 10, &first, &p),
        PayoutResult::Applied
    );
    let mut changed = snapshot(vec![first.clone()]);
    changed.0.closed_at = 101;
    let p2 = ClosedPriority::resolve(&changed, [8; 32]).await.unwrap();
    assert_eq!(
        j.pay([1; 32], [8; 32], first.recipient, 10, &first, &p2),
        PayoutResult::ParameterMismatch
    );
    assert_eq!(
        j.pay([1; 32], [7; 32], first.recipient, 10, &first, &p),
        PayoutResult::PriorityNotEstablished
    );
}
fn entry(v: u8, op: u8) -> VerifierEntry {
    VerifierEntry {
        verifier_id: [v; 32],
        operator_id: [op; 32],
        key_id: [v; 32],
        level: AttestationLevel::Workload,
        not_before: 10,
        not_after: 100,
        revoked: false,
    }
}
#[test]
fn router_counts_operators_not_verifier_ids_and_rejects_bad_registry_binding() {
    let a = Some(votes::Assessment {
        severity: Severity::Critical,
        confidence_permille: 1000,
    });
    let p = votes::Policy {
        policy_digest: [7; 32],
        auto_accept_enabled: true,
        auto_reject_enabled: true,
        min_confidence_permille: [500, 600, 700, 900, 950],
        required_independent_confirmations: 2,
    };
    let v = |id: u8| RegisteredVote {
        vote: Vote {
            kind: VerifierKind::Replay,
            outcome: Outcome::Confirmed,
            verifier_id: [id; 32],
        },
        signing_key_id: [id; 32],
    };
    let mut r = VerifierRegistry::default();
    r.insert(entry(1, 7)).unwrap();
    r.insert(entry(2, 7)).unwrap();
    r.insert(entry(3, 8)).unwrap();
    assert_eq!(
        route_with_registry(
            a,
            &[v(1), v(2)],
            &p,
            true,
            &r,
            50,
            AttestationLevel::Workload
        )
        .decision,
        Decision::ReviewRequired
    );
    assert_eq!(
        route_with_registry(
            a,
            &[v(1), v(3)],
            &p,
            true,
            &r,
            50,
            AttestationLevel::Workload
        )
        .decision,
        Decision::AutoAccept
    );
    for (at, level) in [
        (100, AttestationLevel::Workload),
        (50, AttestationLevel::Hardware),
    ] {
        assert_eq!(
            route_with_registry(a, &[v(1), v(3)], &p, true, &r, at, level).reason,
            Reason::VerifierRegistryRejected
        );
    }
    let bad = RegisteredVote {
        signing_key_id: [9; 32],
        ..v(3)
    };
    assert_eq!(
        route_with_registry(
            a,
            &[v(1), bad],
            &p,
            true,
            &r,
            50,
            AttestationLevel::Workload
        )
        .reason,
        Reason::VerifierRegistryRejected
    );
    let mut reused = entry(4, 9);
    reused.key_id = [1; 32];
    assert_eq!(r.insert(reused), Err(RegistryError::DuplicateKey));
    r.revoke(&[3; 32]).unwrap();
    assert_eq!(
        route_with_registry(
            a,
            &[v(1), v(3)],
            &p,
            true,
            &r,
            50,
            AttestationLevel::Workload
        )
        .reason,
        Reason::VerifierRegistryRejected
    );
}

#[tokio::test]
async fn earlier_priority_after_settlement_freezes_payout_without_second_application() {
    let late = claim(3, 20, 2);
    let early = claim(2, 10, 1);
    let old = ClosedPriority::resolve(&snapshot(vec![late.clone()]), [8; 32])
        .await
        .unwrap();
    let mut j = PayoutJournal::default();
    assert_eq!(
        j.pay([1; 32], [8; 32], late.recipient, 10, &late, &old),
        PayoutResult::Applied
    );
    let corrected = ClosedPriority::resolve(&snapshot(vec![late.clone(), early.clone()]), [8; 32])
        .await
        .unwrap();
    assert_eq!(
        j.pay([2; 32], [8; 32], early.recipient, 10, &early, &corrected),
        PayoutResult::EarlierClaimAfterSettlement
    );
    assert!(j.requires_manual_reconciliation(&[8; 32]));
    assert_eq!(
        j.pay([1; 32], [8; 32], late.recipient, 10, &late, &old),
        PayoutResult::ManualReconciliationRequired
    );
}

#[tokio::test]
async fn changing_log_after_settlement_requires_reconciliation_not_time_comparison() {
    let first = claim(2, 10, 1);
    let p = ClosedPriority::resolve(&snapshot(vec![first.clone()]), [8; 32])
        .await
        .unwrap();
    let mut j = PayoutJournal::default();
    assert_eq!(
        j.pay([1; 32], [8; 32], first.recipient, 10, &first, &p),
        PayoutResult::Applied
    );
    let mut another = first;
    another.log_id = [9; 32];
    let mut source = snapshot(vec![another.clone()]);
    source.0.log_id = [9; 32];
    let p2 = ClosedPriority::resolve(&source, [8; 32]).await.unwrap();
    assert_eq!(
        j.pay([2; 32], [8; 32], another.recipient, 10, &another, &p2),
        PayoutResult::ManualReconciliationRequired
    );
    assert!(j.requires_manual_reconciliation(&[8; 32]));
}
