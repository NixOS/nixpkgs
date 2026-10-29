use arkhe_bugbounty::{review::*, Severity};
use arkhe_core::Digest32;

fn clean(confidence: u16) -> ReviewSignals {
    ReviewSignals {
        supports_proposal: true,
        confidence_bps: Some(confidence),
        ambiguous: Some(false),
        text_decision_disagreement: Some(false),
        policy_exception: false,
        irreversible: false,
    }
}
fn approved() -> ReviewPolicy {
    ReviewPolicy {
        automation_approved: true,
        model_version: Some("model-1".into()),
        ..ReviewPolicy::default()
    }
}

#[test]
fn priorities_and_unknowns_cannot_be_overridden_by_perfect_confidence() {
    let router = ReviewRouter::new(approved()).unwrap();
    for severity in [Severity::Critical, Severity::High] {
        let d = router.decide(severity, "model-1", &clean(10000));
        assert_eq!(d.verdict, ReviewVerdict::ReviewRequired);
        assert!(d.reasons.contains(&ReviewReason::HighImpact));
    }
    let mut s = clean(10000);
    s.policy_exception = true;
    s.irreversible = true;
    s.ambiguous = Some(true);
    let d = router.decide(Severity::Low, "model-1", &s);
    assert_eq!(d.reasons[0], ReviewReason::PolicyException);
    assert_eq!(d.reasons[1], ReviewReason::Irreversible);
    assert_eq!(d.verdict, ReviewVerdict::ReviewRequired);
    s = clean(10000);
    s.ambiguous = None;
    assert_eq!(
        router.decide(Severity::Low, "model-1", &s).verdict,
        ReviewVerdict::ReviewRequired
    );
    s = clean(10000);
    s.confidence_bps = None;
    assert_eq!(
        router.decide(Severity::Low, "model-1", &s).verdict,
        ReviewVerdict::ReviewRequired
    );
}
#[test]
fn gray_zones_are_policy_model_specific_and_rejection_is_not_authority() {
    let router = ReviewRouter::new(approved()).unwrap();
    assert_eq!(
        router
            .decide(Severity::Medium, "model-1", &clean(7499))
            .verdict,
        ReviewVerdict::ReviewRequired
    );
    assert_eq!(
        router
            .decide(Severity::Medium, "model-1", &clean(7500))
            .verdict,
        ReviewVerdict::AutoAccept
    );
    assert_eq!(
        router
            .decide(Severity::Low, "model-1", &clean(6000))
            .verdict,
        ReviewVerdict::AutoAccept
    );
    assert_eq!(
        router
            .decide(Severity::Low, "other-model", &clean(10000))
            .verdict,
        ReviewVerdict::ReviewRequired
    );
    assert_eq!(
        ReviewRouter::new(ReviewPolicy::default())
            .unwrap()
            .decide(Severity::Low, "model-1", &clean(10000))
            .verdict,
        ReviewVerdict::ReviewRequired
    );
    let mut rejected = clean(10000);
    rejected.supports_proposal = false;
    assert_eq!(
        router.decide(Severity::Low, "model-1", &rejected).verdict,
        ReviewVerdict::AutoReject
    );
    assert_eq!(
        router.decide(Severity::High, "model-1", &rejected).verdict,
        ReviewVerdict::ReviewRequired
    );
}
fn item(id: &str, severity: Severity, confidence: u16, disagreement: bool) -> ReviewItem {
    let mut signals = clean(confidence);
    signals.text_decision_disagreement = Some(disagreement);
    let router = ReviewRouter::new(ReviewPolicy::default()).unwrap();
    ReviewItem {
        completed_execution: None,
        review_evidence: None,
        case_id: id.into(),
        requested_by: "fixture".into(),
        operation_id: Digest32::blake3(b"case", id.as_bytes()),
        report_digest: Digest32([1; 32]),
        parameters_digest: Digest32([2; 32]),
        governance_policy_digest: Digest32([3; 32]),
        severity,
        model_version: "model-1".into(),
        decision: router.decide(severity, "model-1", &signals),
        signals,
        analysis: None,
        source: "synthetic test".into(),
    }
}
#[test]
fn queue_persists_prioritizes_and_fails_closed_on_lock_conflict_and_bad_json() {
    let dir = std::env::temp_dir().join(format!("arkhe-review-{}", uuid::Uuid::new_v4()));
    std::fs::create_dir(&dir).unwrap();
    let path = dir.join("queue.json");
    let q = FileReviewQueue::new(&path);
    for i in [
        item("low", Severity::Low, 1, false),
        item("high", Severity::High, 10000, false),
        item("critical", Severity::Critical, 10000, false),
        item("uncertain", Severity::High, 6000, false),
        item("disagreement", Severity::High, 6000, true),
    ] {
        q.enqueue(i).unwrap();
    }
    let ids: Vec<_> = FileReviewQueue::new(&path)
        .list()
        .unwrap()
        .into_iter()
        .map(|i| i.case_id)
        .collect();
    assert_eq!(
        ids,
        vec!["critical", "disagreement", "uncertain", "high", "low"]
    );
    let mut changed = item("high", Severity::High, 10000, false);
    changed.parameters_digest = Digest32::ZERO;
    assert!(q.enqueue(changed).unwrap_err().contains("409"));
    let lock = path.with_extension("lock");
    std::fs::write(&lock, b"owner crashed").unwrap();
    assert!(q.list().is_err());
    std::fs::remove_file(lock).unwrap();
    std::fs::write(&path, b"not JSON").unwrap();
    assert!(q.list().is_err());
    std::fs::remove_file(path).unwrap();
    std::fs::remove_dir(dir).unwrap();
}
#[test]
fn feedback_only_proposes_conservative_policy_and_never_activates_it() {
    let policy = approved();
    let before = policy.digest();
    let p = propose_threshold_update(
        &policy,
        vec![ReviewerFeedback {
            human_review_digest: Digest32([4; 32]),
            severity: Severity::Medium,
            confidence_bps: 9900,
            corrected_model: true,
        }],
    )
    .unwrap();
    assert_eq!(p.candidate.medium_threshold_bps, 9901);
    assert!(!p.candidate.automation_approved);
    assert_eq!(policy.digest(), before);
    assert!(p.status.contains("PENDING"));
    assert!(propose_threshold_update(&policy, vec![]).is_err());
}

#[test]
fn load_counts_all_routes_per_severity_without_counting_retries_or_claiming_gamma_area() {
    let dir = std::env::temp_dir().join(format!("arkhe-load-{}", uuid::Uuid::new_v4()));
    std::fs::create_dir(&dir).unwrap();
    let path = dir.join("queue.json");
    let q = FileReviewQueue::new(&path);
    let high = item("high", Severity::High, 10000, false);
    q.enqueue(high.clone()).unwrap();
    q.enqueue(high.clone()).unwrap();
    let router = ReviewRouter::new(approved()).unwrap();
    let mut accept = item("accept", Severity::Medium, 8000, false);
    accept.decision = router.decide(accept.severity, &accept.model_version, &accept.signals);
    let mut reject = item("reject", Severity::Low, 10000, false);
    reject.signals.supports_proposal = false;
    reject.decision = router.decide(reject.severity, &reject.model_version, &reject.signals);
    q.observe(ReviewObservation::from_item(
        &accept,
        ObservationSource::Executor,
    ))
    .unwrap();
    q.observe(ReviewObservation::from_item(
        &reject,
        ObservationSource::Executor,
    ))
    .unwrap();
    let report = q.metrics().unwrap();
    assert_eq!(report.overall.total, 3);
    assert_eq!(report.overall.review_required, 1);
    assert_eq!(report.overall.auto_accept, 1);
    assert_eq!(report.overall.auto_reject, 1);
    assert_eq!(report.pending_queue_cases, Some(1));
    assert_eq!(report.overall.review_fraction, Some(1.0 / 3.0));
    assert!(report.gamma_area.is_none());
    assert!(report.human_agreement.is_none());
    assert!(report.monetary_cost.is_none());
    assert_eq!(report.overall.reason_counts["HighImpact"], 1);
    let critical = report
        .by_severity
        .iter()
        .find(|r| r.severity == Severity::Critical)
        .unwrap();
    assert_eq!(critical.counts.total, 0);
    assert!(critical.counts.review_fraction.is_none());
    assert_eq!(FileReviewQueue::new(&path).observations().unwrap().len(), 3);
    std::fs::remove_file(path).unwrap();
    std::fs::remove_dir(dir).unwrap();
}

#[test]
fn shadow_comparison_only_simulates_and_has_no_human_agreement_or_promotion() {
    use arkhe_bugbounty::review::telemetry::compare_shadow;
    let active = ReviewRouter::new(approved()).unwrap();
    let mut case = item("medium", Severity::Medium, 8000, false);
    case.decision = active.decide(case.severity, &case.model_version, &case.signals);
    let observations = vec![ReviewObservation::from_item(
        &case,
        ObservationSource::Executor,
    )];
    let before = serde_json::to_vec(&observations).unwrap();
    let policy_before = active.policy().digest();
    let candidate = ReviewRouter::new(ReviewPolicy {
        medium_threshold_bps: 9000,
        ..approved()
    })
    .unwrap();
    let report = compare_shadow(&observations, &candidate);
    assert_eq!(report.changed, 1);
    assert_eq!(report.transitions["AutoAccept->ReviewRequired"], 1);
    assert_eq!(report.shadow_load.overall.review_fraction, Some(1.0));
    assert!(!report.production_authorized);
    assert!(report.human_agreement.is_none());
    assert!(report.active_load.pending_queue_cases.is_none());
    assert_eq!(serde_json::to_vec(&observations).unwrap(), before);
    assert_eq!(active.policy().digest(), policy_before);
    let empty = compare_shadow(&[], &candidate);
    assert_eq!(empty.sampled_snapshots, 0);
    assert!(empty.shadow_load.overall.review_fraction.is_none());
}

#[test]
fn legacy_queue_without_telemetry_does_not_invent_an_escalation_denominator() {
    let dir = std::env::temp_dir().join(format!("arkhe-legacy-load-{}", uuid::Uuid::new_v4()));
    std::fs::create_dir(&dir).unwrap();
    let path = dir.join("queue.json");
    std::fs::write(
        &path,
        serde_json::to_vec(
            &serde_json::json!({"items":[item("legacy",Severity::High,10000,false)]}),
        )
        .unwrap(),
    )
    .unwrap();
    let before = std::fs::read(&path).unwrap();
    let q = FileReviewQueue::new(&path);
    let report = q.metrics().unwrap();
    assert_eq!(report.overall.total, 0);
    assert!(report.overall.review_fraction.is_none());
    assert_eq!(report.pending_queue_cases, Some(1));
    assert_eq!(report.queue_cases_without_observation, Some(1));
    assert_eq!(std::fs::read(&path).unwrap(), before);
    std::fs::remove_file(path).unwrap();
    std::fs::remove_dir(dir).unwrap();
}
