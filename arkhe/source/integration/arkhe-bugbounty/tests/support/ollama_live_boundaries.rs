//! Real inference; synthetic policy, scope, admission and upstream write fixtures.
//! This is a boundary regression, not a new benchmark or a production authorization.
use super::*;
use arkhe_bugbounty::ollama::{worker_version, OllamaAnalyzer, MODULE_ID};
use arkhe_ollama::{Config, OllamaClient};

pub(super) struct LivePolicy;
impl PolicyResolver for LivePolicy {
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        PolicyVerdict::Allow
    }
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec![MODULE_ID.into()],
            allowed_operations: vec![CognitiveOperation::Decide],
        })
    }
}
pub(super) struct FixtureClient {
    pub(super) report: ReportDetails,
    pub(super) calls: Arc<AtomicUsize>,
    pub(super) fail: bool,
}
#[async_trait]
impl HackenProofMcpClient for FixtureClient {
    async fn get_report_details(&self, _: &str) -> Result<ReportDetails, HackenProofError> {
        Ok(self.report.clone())
    }
    async fn get_program_info(&self, _: &str) -> Result<scope::ProgramScope, HackenProofError> {
        Ok(scope::ProgramScope {
            version: 1,
            program_id: "synthetic-local-only".into(),
            report_digest: self.report.digest(),
            included_assets: self.report.affected_assets.clone(),
            excluded_assets: vec![],
        })
    }
    async fn triage_report(
        &self,
        id: &str,
        _: TriageParams,
        _: Digest32,
    ) -> Result<TriageResponse, HackenProofError> {
        self.calls.fetch_add(1, Ordering::SeqCst);
        if self.fail {
            return Err(HackenProofError::Permanent(
                "synthetic upstream failure".into(),
            ));
        }
        Ok(TriageResponse {
            version: 1,
            report_id: id.into(),
            accepted_at: 1,
            transaction_digest: Digest32([5; 32]),
        })
    }
}
/// Reuse ONE actual inference result for deterministic transport/gate/journal checks.
/// This cache is a test fixture, not a production analyzer or repeated inference claim.
pub(super) struct CapturedAnalysis(pub(super) WorkerExecutionRecord);
#[async_trait]
impl LlmAnalyzer for CapturedAnalysis {
    async fn analyze(
        &self,
        r: &ReportDetails,
        p: TriageParams,
    ) -> Result<WorkerExecutionRecord, String> {
        if self.0.input_digest != r.digest() || self.0.output_digest != p.digest() {
            return Err("captured analysis binding mismatch".into());
        }
        Ok(self.0.clone())
    }
}
fn fixture_executor(
    report: ReportDetails,
    record: WorkerExecutionRecord,
    fail: bool,
) -> TriageExecutor<FixtureClient, CapturedAnalysis, Store, Log, LivePolicy> {
    TriageExecutor {
        client: FixtureClient {
            report,
            calls: Arc::new(AtomicUsize::new(0)),
            fail,
        },
        analyzer: CapturedAnalysis(record),
        kernel: Store::default(),
        operational_log: Log::default(),
        gate: ContainmentGate::new(LivePolicy),
        policy: policy(),
        requested_by: "synthetic-live-probe".into(),
        journal: Arc::new(OperationJournal::default()),
    }
}

pub(super) fn synthetic_report() -> ReportDetails {
    ReportDetails {
        version: 1, report_id: "synthetic-sqli-boundary-probe".into(), severity: Severity::Low,
        title: "Synthetic unauthenticated SQL injection report".into(),
        report_body: "Synthetic test scenario, not a claim about a real service. In the fixture application, the unauthenticated GET /users?q endpoint executes SELECT id,email,password_hash FROM users WHERE name = '<q>' using direct string concatenation with no escaping or bound parameters. Supplying q=' OR '1'='1 returns all user rows, including password hashes; UNION SELECT allows reading every table accessible to the same database role. No login, interaction or privileged attacker access is needed. The report explicitly demonstrates database-wide confidentiality loss from unauthenticated SQL injection. Assess the proposed Critical/Triaged classification for this synthetic vulnerability, not whether this is an authorized real-world submission.".into(),
        submitted_at: 1, affected_assets: vec![Digest32([42;32])],
    }
}

#[tokio::test]
async fn actual_ollama_analysis_obeys_admission_failure_retry_and_conflict_boundaries() {
    let path = std::env::var("ARKHE_OLLAMA_CONFIG")
        .expect("explicit live gate requires ARKHE_OLLAMA_CONFIG");
    let config = Config::load(path).unwrap();
    let client = OllamaClient::new(config.clone()).unwrap();
    let status = client
        .status()
        .await
        .expect("real local provider and pinned model required");
    let report = synthetic_report();
    let analyzer = OllamaAnalyzer::new(client);
    // No fallback, no retries, no changed prompt/model on disagreement.
    let record = analyzer
        .analyze(&report, params())
        .await
        .expect("real model must support this fixture; otherwise this gate fails without tuning");
    assert_eq!(record.module_version, worker_version(&config.model_digest));
    assert_eq!(record.input_digest, report.digest());
    assert_eq!(record.output_digest, params().digest());
    println!("actual_inference_count=1; model={}; digest={}; server_version={}; worker_version={}; candidate_hash={}; admission=synthetic; upstream=synthetic; semantic_accuracy=not_measured", status.model, status.model_digest, status.version, record.module_version, record.digest().to_hex());

    // INV-WER-06: even a real model's record cannot bypass admitted evidence lookup.
    let mut proposal = intent();
    proposal.target = report.target();
    proposal.context = vec![ContextEntry {
        kind: ContextKind::SourceReport,
        hash: report.digest(),
    }];
    let gate = ContainmentGate::new(LivePolicy);
    assert!(matches!(
        gate.authorize_admitted(&proposal, &record, &policy(), &Store::default())
            .await,
        AuthorizationDecision::Reject { .. }
    ));
    proposal.context.push(ContextEntry {
        kind: ContextKind::AnalysisRecord,
        hash: record.digest(),
    });
    assert!(matches!(
        gate.authorize_admitted(&proposal, &record, &policy(), &Store::default())
            .await,
        AuthorizationDecision::Reject { .. }
    ));
    println!("PASS INV-WER-06: actual inference is not admitted authority");

    // Idempotency and 409: completed replay writes once; changed parameters conflict.
    let e = fixture_executor(report.clone(), record.clone(), false);
    let request = RequestIdentity::new(b"actual-inference-retry");
    let first = e
        .execute_triage(&report.report_id, params(), request)
        .await
        .unwrap();
    assert_eq!(
        first.digest(),
        e.execute_triage(&report.report_id, params(), request)
            .await
            .unwrap()
            .digest()
    );
    assert_eq!(e.client.calls.load(Ordering::SeqCst), 1);
    println!("PASS idempotency: completed retry returns same record; one simulated write");
    let changed = TriageParams {
        severity: Severity::Low,
        state: State::Triaged,
    };
    assert!(matches!(
        e.execute_triage(&report.report_id, changed, request).await,
        Err(Error::ParameterMismatch)
    ));
    assert_eq!(e.client.calls.load(Ordering::SeqCst), 1);
    println!(
        "PASS ParameterMismatch: same request, different parameters; no second simulated write"
    );

    // INV-WER-07: failure is operational logging, never execution-success evidence.
    let failed = fixture_executor(report.clone(), record, true);
    let request = RequestIdentity::new(b"actual-inference-failure");
    assert!(failed
        .execute_triage(&report.report_id, params(), request)
        .await
        .is_err());
    assert!(failed
        .operational_log
        .0
        .lock()
        .unwrap()
        .iter()
        .any(|line| line.starts_with("execute:")));
    assert!(!failed
        .kernel
        .records
        .lock()
        .unwrap()
        .values()
        .any(|r| r.operation == Some(CognitiveOperation::Execute)));
    assert!(matches!(
        failed
            .execute_triage(&report.report_id, params(), request)
            .await,
        Err(Error::Uncertain)
    ));
    assert_eq!(failed.client.calls.load(Ordering::SeqCst), 1);
    println!(
        "PASS INV-WER-07: failure logged; no successful execution WER; uncertain retry blocked"
    );
}
