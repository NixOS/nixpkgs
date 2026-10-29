//! Local qualification only. Actual Ollama, PostgreSQL and Ed25519; ephemeral TEST
//! signing keys, synthetic governance and simulated HackenProof writes.
use super::ollama_live_boundaries::{
    synthetic_report, CapturedAnalysis, FixtureClient, LivePolicy,
};
use super::*;
use arkhe_bugbounty::{
    ollama::{worker_version, OllamaAnalyzer, MODULE_ID},
    postgres::{PgKernel, PgOperations},
    provenance::*,
};
use arkhe_core::CanonicalEncode;
use arkhe_ollama::{Config, OllamaClient};
use arkhe_wormgraph::postgres::PgWormGraph;
use ed25519_dalek::{Signer, SigningKey};
use rand_core::{OsRng, RngCore};

type VerifiedPg = PgKernel<SignedWorkerVerifier<PgOperations, PgWormGraph>>;
struct TestSigner {
    inner: VerifiedPg,
    receipts: PgOperations,
    tenant: String,
    analysis_key: Arc<SigningKey>,
    execution_key: Arc<SigningKey>,
    captured: Mutex<Option<WorkerExecutionRecord>>,
}
fn test_key() -> Arc<SigningKey> {
    let mut seed = [0; 32];
    OsRng.fill_bytes(&mut seed);
    Arc::new(SigningKey::from_bytes(&seed))
}
fn registry(a: &SigningKey, e: &SigningKey, version: &str) -> Vec<TrustedWorkerKey> {
    vec![
        TrustedWorkerKey {
            key_id: "EPHEMERAL-TEST-ANALYSIS".into(),
            public_key: a.verifying_key().to_bytes(),
            module_id: MODULE_ID.into(),
            module_version: version.into(),
            allowed_operations: vec![CognitiveOperation::Decide],
            require_admitted_input: false,
            active: true,
        },
        TrustedWorkerKey {
            key_id: "EPHEMERAL-TEST-EXECUTION".into(),
            public_key: e.verifying_key().to_bytes(),
            module_id: "hackenproof-adapter-v1".into(),
            module_version: env!("CARGO_PKG_VERSION").into(),
            allowed_operations: vec![CognitiveOperation::Execute],
            require_admitted_input: true,
            active: true,
        },
    ]
}
async fn signing_kernel(
    url: &str,
    tenant: &str,
    a: Arc<SigningKey>,
    e: Arc<SigningKey>,
    version: &str,
) -> TestSigner {
    let verifier = SignedWorkerVerifier::new(
        tenant.into(),
        registry(&a, &e, version),
        PgOperations::connect(url, tenant).await.unwrap(),
        PgWormGraph::connect(url, tenant).await.unwrap(),
    )
    .unwrap();
    TestSigner {
        inner: PgKernel::connect(url, tenant, verifier).await.unwrap(),
        receipts: PgOperations::connect(url, tenant).await.unwrap(),
        tenant: tenant.into(),
        analysis_key: a,
        execution_key: e,
        captured: Mutex::new(None),
    }
}
#[async_trait]
impl EvidenceReader for TestSigner {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        self.inner.get(hash).await
    }
}
#[async_trait]
impl Kernel for TestSigner {
    async fn admit(&self, record: &WorkerExecutionRecord) -> Result<Digest32, String> {
        // Private keys live only in this local test fixture, never in inference prompts.
        if self.receipts.receipts(record.digest()).await?.is_empty() {
            let (id, key) = if record.operation == Some(CognitiveOperation::Decide) {
                ("EPHEMERAL-TEST-ANALYSIS", &self.analysis_key)
            } else {
                ("EPHEMERAL-TEST-EXECUTION", &self.execution_key)
            };
            let mut receipt = SignedWorkerReceipt {
                version: 1,
                tenant: self.tenant.clone(),
                key_id: id.into(),
                record_hash: record.digest(),
                completed_at_ms: std::time::SystemTime::now()
                    .duration_since(std::time::UNIX_EPOCH)
                    .unwrap()
                    .as_millis()
                    .try_into()
                    .unwrap(),
                outcome: ExecutionOutcome::Succeeded,
                signature_hex: String::new(),
            };
            receipt.signature_hex = hex::encode(key.sign(&receipt.signing_bytes()).to_bytes());
            self.receipts
                .stage_receipt(&receipt)
                .await
                .map_err(|e| e.to_string())?;
        }
        let hash = self.inner.admit(record).await?;
        if record.operation == Some(CognitiveOperation::Decide) {
            *self.captured.lock().unwrap() = Some(record.clone());
        }
        Ok(hash)
    }
}
async fn executor_pg<L: LlmAnalyzer>(
    url: &str,
    tenant: &str,
    analyzer: L,
    report: ReportDetails,
    fail: bool,
    keys: &(Arc<SigningKey>, Arc<SigningKey>),
    version: &str,
    calls: Arc<AtomicUsize>,
) -> TriageExecutor<FixtureClient, L, TestSigner, PgOperations, LivePolicy> {
    TriageExecutor {
        client: FixtureClient {
            report,
            calls,
            fail,
        },
        analyzer,
        kernel: signing_kernel(url, tenant, keys.0.clone(), keys.1.clone(), version).await,
        operational_log: PgOperations::connect(url, tenant).await.unwrap(),
        gate: ContainmentGate::new(LivePolicy),
        policy: policy(),
        requested_by: "LOCAL-QUALIFICATION-NOT-PRODUCTION".into(),
        journal: Arc::new(PgOperations::connect(url, tenant).await.unwrap()),
    }
}
fn save(path: &std::path::Path, value: &impl serde::Serialize) {
    use std::io::Write;
    let mut file = std::fs::OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(path)
        .unwrap();
    file.write_all(&serde_json::to_vec_pretty(value).unwrap())
        .unwrap();
}

#[tokio::test]
async fn actual_ollama_signed_postgres_gate_survives_reconnect_and_rejects_unauthorized_module() {
    let url = std::env::var("ARKHE_TEST_DATABASE_URL")
        .expect("migrated real PostgreSQL runtime role required");
    let config =
        Config::load(std::env::var("ARKHE_OLLAMA_CONFIG").expect("pinned Ollama config required"))
            .unwrap();
    let output = std::path::PathBuf::from(
        std::env::var("ARKHE_QUALIFICATION_OUTPUT").expect("new capture directory required"),
    );
    let root = std::path::Path::new(env!("CARGO_MANIFEST_DIR"))
        .ancestors()
        .nth(2)
        .unwrap()
        .canonicalize()
        .unwrap();
    assert!(
        output.is_absolute() && !output.exists(),
        "never overwrite an earlier capture"
    );
    let parent = output.parent().unwrap();
    std::fs::create_dir_all(parent).unwrap();
    assert!(
        parent
            .canonicalize()
            .unwrap()
            .starts_with(root.join("docs/evidence")),
        "capture must remain in workspace evidence"
    );
    std::fs::create_dir(&output).unwrap();
    let client = OllamaClient::new(config.clone()).unwrap();
    let status = client.status().await.unwrap();
    let report = synthetic_report();
    let keys = (test_key(), test_key());
    let version = worker_version(&config.model_digest);
    let tenant = format!("ollama-qualified-{}", uuid::Uuid::new_v4());
    let calls = Arc::new(AtomicUsize::new(0));
    let e = executor_pg(
        &url,
        &tenant,
        OllamaAnalyzer::new(client),
        report.clone(),
        false,
        &keys,
        &version,
        calls.clone(),
    )
    .await;
    let request = RequestIdentity::new(b"signed-actual-ollama");
    let execution = e.execute_triage(&report.report_id, params(), request).await.expect("one actual inference, signed admission and durable dispatch must succeed; no inference retry");
    let analysis = e.kernel.captured.lock().unwrap().clone().unwrap();
    assert_eq!(analysis.module_version, version);
    assert_eq!(
        e.kernel
            .inner
            .canonical_worker(analysis.digest())
            .await
            .unwrap()
            .unwrap(),
        analysis.canonical_bytes()
    );
    save(&output.join("report.json"), &report);
    save(&output.join("analysis-candidate.json"), &analysis);
    save(&output.join("execution-record.json"), &execution);
    save(
        &output.join("analysis-receipts.json"),
        &e.kernel.receipts.receipts(analysis.digest()).await.unwrap(),
    );
    save(
        &output.join("execution-receipts.json"),
        &e.kernel
            .receipts
            .receipts(execution.digest())
            .await
            .unwrap(),
    );
    save(
        &output.join("public-test-registry.json"),
        &registry(&keys.0, &keys.1, &version),
    );
    drop(e);

    // Reconnect with new pools/readers. No second inference or upstream write is allowed.
    let reopened = executor_pg(
        &url,
        &tenant,
        CapturedAnalysis(analysis.clone()),
        report.clone(),
        false,
        &keys,
        &version,
        calls.clone(),
    )
    .await;
    assert_eq!(
        execution.digest(),
        reopened
            .execute_triage(&report.report_id, params(), request)
            .await
            .unwrap()
            .digest()
    );
    assert_eq!(calls.load(Ordering::SeqCst), 1);
    assert_eq!(
        reopened
            .kernel
            .inner
            .canonical_worker(execution.digest())
            .await
            .unwrap()
            .unwrap(),
        execution.canonical_bytes()
    );
    reopened.kernel.inner.admit(&analysis).await.unwrap(); // verifies stored signature after reconnect
    let changed = TriageParams {
        severity: Severity::Low,
        state: State::Triaged,
    };
    assert!(matches!(
        reopened
            .execute_triage(&report.report_id, changed, request)
            .await,
        Err(Error::ParameterMismatch)
    ));
    assert_eq!(calls.load(Ordering::SeqCst), 1);

    // Correct cryptographic signature, WRONG module: independent trust registry rejects it.
    let mut unauthorized = analysis.clone();
    unauthorized.module_id = "UNAUTHORIZED-MODULE".into();
    unauthorized.execution_id = uuid::Uuid::new_v4().to_string();
    assert!(reopened.kernel.admit(&unauthorized).await.is_err());
    assert!(reopened
        .kernel
        .get(unauthorized.digest())
        .await
        .unwrap()
        .is_none());
    let mut wrong_model = analysis.clone();
    wrong_model.module_version = worker_version(&"00".repeat(32));
    wrong_model.execution_id = uuid::Uuid::new_v4().to_string();
    assert!(reopened.kernel.admit(&wrong_model).await.is_err());
    assert!(reopened
        .kernel
        .get(wrong_model.digest())
        .await
        .unwrap()
        .is_none());
    save(
        &output.join("rejected-module-candidate.json"),
        &unauthorized,
    );
    save(
        &output.join("rejected-module-receipts.json"),
        &reopened
            .kernel
            .receipts
            .receipts(unauthorized.digest())
            .await
            .unwrap(),
    );

    // INV-WER-06: this real signed analysis is not admitted in another tenant.
    let absent_tenant = format!("ollama-unadmitted-{}", uuid::Uuid::new_v4());
    let empty = signing_kernel(
        &url,
        &absent_tenant,
        keys.0.clone(),
        keys.1.clone(),
        &version,
    )
    .await;
    let mut proposal = intent();
    proposal.target = report.target();
    proposal.context = vec![
        ContextEntry {
            kind: ContextKind::SourceReport,
            hash: report.digest(),
        },
        ContextEntry {
            kind: ContextKind::AnalysisRecord,
            hash: analysis.digest(),
        },
    ];
    assert!(matches!(
        ContainmentGate::new(LivePolicy)
            .authorize_admitted(&proposal, &analysis, &policy(), &empty)
            .await,
        AuthorizationDecision::Reject { .. }
    ));
    assert!(empty.get(analysis.digest()).await.unwrap().is_none());

    // INV-WER-07: uncertain external failure persists with no execution-success WER.
    let failure_tenant = format!("ollama-failed-{}", uuid::Uuid::new_v4());
    let failure_calls = Arc::new(AtomicUsize::new(0));
    let failed = executor_pg(
        &url,
        &failure_tenant,
        CapturedAnalysis(analysis.clone()),
        report.clone(),
        true,
        &keys,
        &version,
        failure_calls.clone(),
    )
    .await;
    let request = RequestIdentity::new(b"durable-failure");
    assert!(failed
        .execute_triage(&report.report_id, params(), request)
        .await
        .is_err());
    let queue = failed
        .operational_log
        .reconciliation_queue(300)
        .await
        .unwrap();
    assert_eq!(queue.len(), 1);
    assert_eq!(queue[0].status, "DISPATCHED");
    assert!(queue[0].reason.contains("execute"));
    let operation = queue[0].operation_id;
    drop(failed);
    let failed = executor_pg(
        &url,
        &failure_tenant,
        CapturedAnalysis(analysis.clone()),
        report.clone(),
        true,
        &keys,
        &version,
        failure_calls.clone(),
    )
    .await;
    assert!(matches!(
        failed
            .execute_triage(&report.report_id, params(), request)
            .await,
        Err(Error::Uncertain)
    ));
    assert_eq!(failure_calls.load(Ordering::SeqCst), 1);
    // Query through the runtime role and transaction-local tenant, never an admin bypass.
    let pool = sqlx::PgPool::connect(&url).await.unwrap();
    let mut tx = pool.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_operations")
        .execute(&mut *tx)
        .await
        .unwrap();
    arkhe_sql::tenant::set_tenant(&mut tx, &failure_tenant)
        .await
        .unwrap();
    let logs: i64 = sqlx::query_scalar(
        "SELECT count(*) FROM bugbounty_operational_log WHERE operation_id=$1 AND stage='execute'",
    )
    .bind(operation.0.to_vec())
    .fetch_one(&mut *tx)
    .await
    .unwrap();
    assert_eq!(logs, 1);
    tx.commit().await.unwrap();
    let failure_graph = PgWormGraph::connect(&url, &failure_tenant).await.unwrap();
    // Only the signed analysis exists in this failure graph.
    assert!(failure_graph
        .get(analysis.digest())
        .await
        .unwrap()
        .is_some());
    assert!(failure_graph
        .get(execution.digest())
        .await
        .unwrap()
        .is_none());
    save(
        &output.join("qualification.json"),
        &serde_json::json!({"status":"LOCAL_QUALIFICATION_PASS_NOT_PRODUCTION", "tenant":tenant,"failure_tenant":failure_tenant,"provider":status,"actual_inferences":1,"signing_keys":"EPHEMERAL_TEST_ONLY_PRIVATE_KEYS_NOT_EXPORTED","analysis_hash":analysis.digest().to_hex(),"execution_hash":execution.digest().to_hex(),"unauthorized_module_rejected":true,"wrong_model_version_rejected":true,"postgres_reconnect_replay":true,"parameter_mismatch":true,"missing_admission_rejected":true,"failure_log_persisted":true,"uncertain_retry_blocked":true,"upstream":"SYNTHETIC_NO_HACKENPROOF_CALL","governance":"TEST_ONLY_NOT_RATIFIED"}),
    );
    println!("PASS actual Ollama + Ed25519 SignedWorkerVerifier + PostgreSQL; reconnect replay, 409, unauthorized module/model, INV-WER-06/07; keys=EPHEMERAL_TEST; upstream=SYNTHETIC; tenant={tenant}");
}

/// A separate verification pass reuses retained public artifacts and existing DB state.
/// No inference, signing or external write is performed by this check.
#[tokio::test]
async fn retained_capture_verifies_signatures_and_exact_failure_graph_after_reconnect() {
    let url = std::env::var("ARKHE_TEST_DATABASE_URL").expect("runtime database required");
    let capture = std::path::PathBuf::from(
        std::env::var("ARKHE_QUALIFICATION_CAPTURE").expect("retained capture directory required"),
    );
    let read = |name: &str| std::fs::read(capture.join(name)).unwrap();
    let metadata: serde_json::Value = serde_json::from_slice(&read("qualification.json")).unwrap();
    assert_eq!(
        metadata["status"],
        "LOCAL_QUALIFICATION_PASS_NOT_PRODUCTION"
    );
    let tenant = metadata["tenant"].as_str().unwrap();
    let failure_tenant = metadata["failure_tenant"].as_str().unwrap();
    let registry: Vec<TrustedWorkerKey> =
        serde_json::from_slice(&read("public-test-registry.json")).unwrap();
    assert!(registry
        .iter()
        .all(|key| key.key_id.starts_with("EPHEMERAL-TEST-")));
    let verifier = SignedWorkerVerifier::new(
        tenant.into(),
        registry.clone(),
        PgOperations::connect(&url, tenant).await.unwrap(),
        PgWormGraph::connect(&url, tenant).await.unwrap(),
    )
    .unwrap();
    for (record_name, receipts_name) in [
        ("analysis-candidate.json", "analysis-receipts.json"),
        ("execution-record.json", "execution-receipts.json"),
    ] {
        let record: WorkerExecutionRecord = serde_json::from_slice(&read(record_name)).unwrap();
        let receipts: Vec<SignedWorkerReceipt> =
            serde_json::from_slice(&read(receipts_name)).unwrap();
        assert_eq!(receipts.len(), 1);
        verifier
            .verify_detached(&record, &receipts[0])
            .await
            .unwrap();
        let graph = PgWormGraph::connect(&url, tenant).await.unwrap();
        assert_eq!(
            graph
                .canonical_object("WorkerExecutionRecord", record.digest())
                .await
                .unwrap()
                .unwrap(),
            record.canonical_bytes()
        );
    }
    let unauthorized: WorkerExecutionRecord =
        serde_json::from_slice(&read("rejected-module-candidate.json")).unwrap();
    let receipts: Vec<SignedWorkerReceipt> =
        serde_json::from_slice(&read("rejected-module-receipts.json")).unwrap();
    assert_eq!(receipts.len(), 1);
    let receipt = &receipts[0];
    let key = registry
        .iter()
        .find(|key| key.key_id == receipt.key_id)
        .unwrap();
    let sig = ed25519_dalek::Signature::from_slice(&hex::decode(&receipt.signature_hex).unwrap())
        .unwrap();
    ed25519_dalek::VerifyingKey::from_bytes(&key.public_key)
        .unwrap()
        .verify_strict(&receipt.signing_bytes(), &sig)
        .unwrap();
    assert!(verifier
        .verify_detached(&unauthorized, receipt)
        .await
        .is_err());
    assert!(PgWormGraph::connect(&url, tenant)
        .await
        .unwrap()
        .get(unauthorized.digest())
        .await
        .unwrap()
        .is_none());
    let pool = sqlx::PgPool::connect(&url).await.unwrap();
    let mut tx = pool.begin().await.unwrap();
    sqlx::query("SET LOCAL ROLE arkhe_read")
        .execute(&mut *tx)
        .await
        .unwrap();
    arkhe_sql::tenant::set_tenant(&mut tx, failure_tenant)
        .await
        .unwrap();
    let worker_count: i64 = sqlx::query_scalar(
        "SELECT count(*) FROM work_objects WHERE object_type='WorkerExecutionRecord'",
    )
    .fetch_one(&mut *tx)
    .await
    .unwrap();
    assert_eq!(
        worker_count, 1,
        "failure tenant must contain ONLY the analysis WER, no execution WER of any hash"
    );
    let analysis: WorkerExecutionRecord =
        serde_json::from_slice(&read("analysis-candidate.json")).unwrap();
    let stored: Vec<u8> = sqlx::query_scalar("SELECT canonical_bytes FROM work_objects WHERE object_type='WorkerExecutionRecord' AND object_digest=$1").bind(analysis.digest().0.to_vec()).fetch_one(&mut *tx).await.unwrap();
    assert_eq!(stored, analysis.canonical_bytes());
    let log_count: i64 =
        sqlx::query_scalar("SELECT count(*) FROM bugbounty_operational_log WHERE stage='execute'")
            .fetch_one(&mut *tx)
            .await
            .unwrap();
    assert_eq!(log_count, 1);
    tx.commit().await.unwrap();
    println!("PASS retained public artifacts: Ed25519 signatures valid, canonical WERs persisted, correctly signed unauthorized module rejected, exact failure graph=one analysis/zero execution WERs, durable execute log=1; additional inference=0; production_key=NONE");
}
