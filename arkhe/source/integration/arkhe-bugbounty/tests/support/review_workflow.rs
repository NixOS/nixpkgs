//! Synthetic reviewer/admission fixtures, never actual human review or signatures.
use super::*;
use arkhe_bugbounty::review::*;
struct Counted(Arc<AtomicUsize>);
#[async_trait]
impl LlmAnalyzer for Counted {
    async fn analyze(
        &self,
        _: &ReportDetails,
        _: TriageParams,
    ) -> Result<WorkerExecutionRecord, String> {
        self.0.fetch_add(1, Ordering::SeqCst);
        let mut w = worker();
        w.confidence_bps = Some(10000);
        Ok(w)
    }
}
fn reviewed() -> TriageExecutor<Client, Counted, Store, Log, ReviewProtectedPolicy<Policy>> {
    TriageExecutor {
        client: Client {
            calls: Arc::new(AtomicUsize::new(0)),
            fail: false,
        },
        analyzer: Counted(Arc::new(AtomicUsize::new(0))),
        kernel: Store::default(),
        operational_log: Log::default(),
        gate: ContainmentGate::new(ReviewProtectedPolicy {
            inner: Policy,
            approved_human_modules: vec!["HUMAN-REVIEW-TEST-ONLY".into()],
        }),
        policy: policy(),
        requested_by: "review-fixture".into(),
        journal: Arc::new(OperationJournal::default()),
    }
}
fn queue() -> (std::path::PathBuf, FileReviewQueue) {
    let dir = std::env::temp_dir().join(format!("arkhe-review-flow-{}", uuid::Uuid::new_v4()));
    std::fs::create_dir(&dir).unwrap();
    let path = dir.join("queue.json");
    (path.clone(), FileReviewQueue::new(path))
}
fn signals() -> ReviewSignals {
    ReviewSignals {
        supports_proposal: true,
        confidence_bps: Some(1),
        ambiguous: Some(false),
        text_decision_disagreement: Some(false),
        policy_exception: false,
        irreversible: false,
    }
}
fn approval(item: &ReviewItem) -> HumanReviewEvidence {
    let analysis = item.analysis.as_ref().unwrap().digest();
    let r = HumanReviewRecord {
        requested_by: item.requested_by.clone(),
        operation_id: item.operation_id,
        parameters_digest: item.parameters_digest,
        analysis_digest: analysis,
        policy_digest: item.governance_policy_digest,
        routing_digest: item.decision.digest(),
        reviewer: "SYNTHETIC-REVIEWER-NOT-A-HUMAN-VERDICT".into(),
        verdict: HumanVerdict::Approve,
        reviewed_at: 10,
        expires_at: 100,
    };
    let attestation = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Decide),
        module_id: "HUMAN-REVIEW-TEST-ONLY".into(),
        module_version: "test".into(),
        input_digest: analysis,
        output_digest: r.digest(),
        evidence_refs: vec![analysis],
        confidence_bps: None,
        uncertainty_note: Some("Synthetic admission fixture, not human approval".into()),
        execution_id: "test-review".into(),
    };
    HumanReviewEvidence {
        review: r,
        attestation,
    }
}
#[tokio::test]
async fn high_confidence_queues_without_dispatch_and_human_attestation_resumes_cached_analysis() {
    let e = reviewed();
    let router = ReviewRouter::new(ReviewPolicy::default()).unwrap();
    let (path, q) = queue();
    let req = RequestIdentity::new(b"human-review");
    for _ in 0..2 {
        assert!(matches!(
            e.execute_triage_reviewed("r1", params(), req, &router, &q, signals(), None, 20)
                .await,
            Err(Error::ReviewRequired(_))
        ));
    }
    assert_eq!(e.analyzer.0.load(Ordering::SeqCst), 1);
    assert_eq!(e.client.calls.load(Ordering::SeqCst), 0);
    assert!(e.kernel.records.lock().unwrap().is_empty());
    let item = q.list().unwrap().remove(0);
    assert_eq!(item.signals.confidence_bps, Some(10000));
    assert!(item.decision.reasons.contains(&ReviewReason::HighImpact));
    let human = approval(&item);
    let first = e
        .execute_triage_reviewed(
            "r1",
            params(),
            req,
            &router,
            &q,
            signals(),
            Some(&human),
            20,
        )
        .await
        .unwrap();
    assert_eq!(
        e.execute_triage_reviewed(
            "r1",
            params(),
            req,
            &router,
            &q,
            signals(),
            Some(&human),
            21
        )
        .await
        .unwrap()
        .digest(),
        first.digest()
    );
    assert_eq!(e.analyzer.0.load(Ordering::SeqCst), 1);
    assert_eq!(e.client.calls.load(Ordering::SeqCst), 1);
    assert!(q.list().unwrap().is_empty());
    let metrics = q.metrics().unwrap();
    assert_eq!(metrics.overall.total, 1);
    assert_eq!(metrics.completed_queue_cases, Some(1));
    assert_eq!(metrics.pending_queue_cases, Some(0));
    let changed = TriageParams {
        severity: Severity::Low,
        state: State::Triaged,
    };
    assert!(matches!(
        e.execute_triage_reviewed("r1", changed, req, &router, &q, signals(), Some(&human), 22)
            .await,
        Err(Error::ParameterMismatch)
    ));
    // The protected policy also rejects accidental use of the legacy entry point.
    assert!(e
        .execute_triage("r1", params(), RequestIdentity::new(b"legacy-bypass"))
        .await
        .is_err());
    assert_eq!(e.client.calls.load(Ordering::SeqCst), 1);
    std::fs::remove_file(&path).unwrap();
    std::fs::remove_dir(path.parent().unwrap()).unwrap();
}
#[tokio::test]
async fn expired_or_mismatched_human_approval_never_dispatches() {
    for mode in 0..4 {
        let e = reviewed();
        let router = ReviewRouter::new(ReviewPolicy::default()).unwrap();
        let (path, q) = queue();
        let req = RequestIdentity::new(b"invalid-review");
        assert!(matches!(
            e.execute_triage_reviewed("r1", params(), req, &router, &q, signals(), None, 20)
                .await,
            Err(Error::ReviewRequired(_))
        ));
        let mut human = approval(&q.list().unwrap()[0]);
        match mode {
            0 => human.review.expires_at = 20,
            1 => human.review.policy_digest = Digest32([5; 32]),
            2 => human.review.analysis_digest = Digest32([6; 32]),
            _ => human.attestation.module_id = "UNAUTHORIZED-REVIEWER".into(),
        }
        assert!(e
            .execute_triage_reviewed(
                "r1",
                params(),
                req,
                &router,
                &q,
                signals(),
                Some(&human),
                20
            )
            .await
            .is_err());
        assert_eq!(e.client.calls.load(Ordering::SeqCst), 0);
        std::fs::remove_file(&path).unwrap();
        std::fs::remove_dir(path.parent().unwrap()).unwrap();
    }
}

#[tokio::test]
async fn auto_accept_is_not_a_governance_or_evidence_bypass() {
    let e = reviewed();
    let w = worker();
    let hash = e.kernel.admit(&w).await.unwrap();
    let router = ReviewRouter::new(ReviewPolicy {
        automation_approved: true,
        model_version: Some("1".into()),
        ..ReviewPolicy::default()
    })
    .unwrap();
    let mut s = signals();
    s.confidence_bps = Some(10000);
    let decision = router.decide(Severity::Low, "1", &s);
    assert_eq!(decision.verdict, ReviewVerdict::AutoAccept);
    let mut i = intent();
    i.context.extend([
        ContextEntry {
            kind: ContextKind::AnalysisRecord,
            hash,
        },
        ContextEntry {
            kind: ContextKind::ReviewDecision,
            hash: decision.digest(),
        },
    ]);
    assert!(
        matches!(e.gate.authorize_routed_admitted(&i,&w,&e.policy,&e.kernel,&decision,None,20).await,AuthorizationDecision::Reject{reason} if reason.contains("not approved"))
    );
    let gate = ContainmentGate::new(Policy);
    assert!(matches!(
        gate.authorize_routed_admitted(&i, &w, &e.policy, &Store::default(), &decision, None, 20)
            .await,
        AuthorizationDecision::Reject { .. }
    ));
}
