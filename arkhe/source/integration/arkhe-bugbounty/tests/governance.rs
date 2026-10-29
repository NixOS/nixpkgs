//! Synthetic keys and admitted-memory fixtures; no deployment approval is produced.
use arkhe_bugbounty::{
    classification::{ClassificationPolicy, CvssRequirement},
    governance::*,
    journal::{Claim, Journal, OperationJournal},
    Error, Severity, State, TriageParams,
};
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    work::{ContextEntry, ContextKind, RequestIdentity, WorkIntent, WorkIntentType},
    worker::{ClassificationBinding, CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_governance::{PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use async_trait::async_trait;
use ed25519_dalek::{Signer, SigningKey};
fn fixture() -> (
    SignedTriagePolicyProfile,
    GovernanceTrustRegistry,
    Vec<SigningKey>,
) {
    let now = now_ms();
    let profile = TriagePolicyProfile {
        version: 1,
        policy_id: "synthetic-test-only".into(),
        policy_version: 1,
        requested_by: "triager".into(),
        classification_policy: ClassificationPolicy {
            policy_id: "test-classification".into(),
            version: 1,
            web_table_cvss: CvssRequirement::Required,
            web_cvss_only: false,
            rows: vec![],
        },
        allowed_modules: vec!["trusted-test-worker".into()],
        required_evidence: vec![
            RequiredTriageEvidence::ClassificationDigest,
            RequiredTriageEvidence::ClassificationPolicyDigest,
        ],
        valid_from_ms: now - 10000,
        valid_until_ms: now + 3600000,
    };
    let keys = vec![
        SigningKey::from_bytes(&[71; 32]),
        SigningKey::from_bytes(&[72; 32]),
    ];
    let registry = GovernanceTrustRegistry {
        version: 1,
        registry_id: "synthetic-registry".into(),
        threshold: 2,
        keys: keys
            .iter()
            .enumerate()
            .map(|(i, key)| TrustedGovernanceKey {
                key_id: format!("test-{i}"),
                public_key: key.verifying_key().to_bytes(),
                active: true,
                policy_ids: vec![profile.policy_id.clone()],
                valid_from_ms: now - 10000,
                valid_until_ms: now + 3600000,
            })
            .collect(),
    };
    let mut signed = SignedTriagePolicyProfile {
        profile,
        registry_digest: registry.digest(),
        approvals: vec![],
    };
    resign(&mut signed, &registry, &keys);
    (signed, registry, keys)
}
fn resign(
    signed: &mut SignedTriagePolicyProfile,
    registry: &GovernanceTrustRegistry,
    keys: &[SigningKey],
) {
    signed.registry_digest = registry.digest();
    signed.approvals = keys
        .iter()
        .enumerate()
        .map(|(i, key)| {
            let key_id = format!("test-{i}");
            let signature_hex = hex::encode(key.sign(&signed.signing_bytes(&key_id)).to_bytes());
            GovernanceApproval {
                key_id,
                signature_hex,
            }
        })
        .collect();
}
fn params() -> TriageParams {
    TriageParams {
        severity: Severity::High,
        state: State::Triaged,
    }
}
fn worker(policy: Digest32) -> WorkerExecutionRecord {
    let classification = ClassificationBinding {
        classification_digest: Digest32([3; 32]),
        policy_digest: policy,
    };
    WorkerExecutionRecord {
        classification: Some(classification),
        operation: Some(CognitiveOperation::Decide),
        module_id: "trusted-test-worker".into(),
        module_version: "test".into(),
        input_digest: Digest32([1; 32]),
        output_digest: params().digest_for(Some(classification)),
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: Some("synthetic admitted fixture".into()),
        execution_id: "test".into(),
    }
}
fn intent(w: &WorkerExecutionRecord) -> WorkIntent {
    let b = w.classification.unwrap();
    WorkIntent {
        requested_by: "triager".into(),
        intent_type: WorkIntentType::TriageReport,
        target: Digest32([2; 32]),
        parameters_digest: w.output_digest,
        context: vec![
            ContextEntry {
                kind: ContextKind::SourceReport,
                hash: w.input_digest,
            },
            ContextEntry {
                kind: ContextKind::AnalysisRecord,
                hash: w.digest(),
            },
            ContextEntry {
                kind: ContextKind::SeverityClassification,
                hash: b.classification_digest,
            },
            ContextEntry {
                kind: ContextKind::ClassificationPolicy,
                hash: b.policy_digest,
            },
        ],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"same-test-request"),
        claimed_created_at: 0,
    }
}
struct Admitted(WorkerExecutionRecord);
#[async_trait]
impl EvidenceReader for Admitted {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok((hash == self.0.digest()).then(|| EvidenceEnvelope {
            record_hash: hash,
            kind: "WorkerExecutionRecord".into(),
            subject: self.0.input_digest,
            payload_digest: hash,
            policy_digest: None,
            causal_parents: vec![],
        }))
    }
}
#[test]
fn quorum_registry_pin_scope_expiry_and_tampering_are_enforced() {
    let (signed, registry, keys) = fixture();
    assert!(VerifiedTriagePolicy::verify(signed.clone(), &registry, registry.digest()).is_ok());
    assert!(VerifiedTriagePolicy::verify(signed.clone(), &registry, Digest32::ZERO).is_err());
    assert!(VerifiedTriagePolicy::verify(signed.clone(), &registry, Digest32([9; 32])).is_err());
    let mut single = signed.clone();
    single.approvals.pop();
    assert!(VerifiedTriagePolicy::verify(single, &registry, registry.digest()).is_err());
    let mut duplicate = signed.clone();
    duplicate.approvals[1] = duplicate.approvals[0].clone();
    assert!(VerifiedTriagePolicy::verify(duplicate, &registry, registry.digest()).is_err());
    let mut tampered = signed.clone();
    tampered.profile.requested_by = "attacker".into();
    assert!(VerifiedTriagePolicy::verify(tampered, &registry, registry.digest()).is_err());
    let mut forged = signed.clone();
    forged.approvals[0].signature_hex = "00".repeat(64);
    assert!(VerifiedTriagePolicy::verify(forged, &registry, registry.digest()).is_err());
    for mutation in 0..4 {
        let mut registry = registry.clone();
        let mut signed = signed.clone();
        match mutation {
            0 => registry.keys[0].active = false,
            1 => registry.keys[0].policy_ids = vec!["other".into()],
            2 => registry.keys[0].valid_until_ms = now_ms() - 1,
            _ => signed.profile.valid_until_ms = now_ms() - 1,
        }
        resign(&mut signed, &registry, &keys);
        assert!(VerifiedTriagePolicy::verify(signed, &registry, registry.digest()).is_err());
    }
    let mut duplicate = registry.clone();
    duplicate.keys[1].public_key = duplicate.keys[0].public_key;
    assert!(duplicate.validate().is_err());
    let mut changed_registry = registry.clone();
    changed_registry.threshold = 1;
    assert!(changed_registry.validate().is_err());
}
#[tokio::test]
async fn gate_requires_typed_classification_and_never_parses_note_as_authority() {
    let (signed, registry, _) = fixture();
    let policy = VerifiedTriagePolicy::verify(signed, &registry, registry.digest()).unwrap();
    let binding = policy.binding();
    let w = worker(policy.classification_policy().digest());
    let i = intent(&w);
    let gate = ContainmentGate::new(policy);
    assert!(matches!(
        gate.authorize_admitted(&i, &w, &binding, &Admitted(w.clone()))
            .await,
        AuthorizationDecision::Allow { .. }
    ));
    for mutation in 0..8 {
        let mut changed = w.clone();
        let mut i = i.clone();
        let mut binding = binding.clone();
        match mutation {
            0 => {
                changed.classification = None;
                changed.uncertainty_note = Some("classification=present; policy=approved".into());
            }
            1 => changed.classification.as_mut().unwrap().policy_digest = Digest32([8; 32]),
            2 => i
                .context
                .retain(|e| e.kind != ContextKind::SeverityClassification),
            3 => i.context.push(
                i.context
                    .iter()
                    .find(|e| e.kind == ContextKind::ClassificationPolicy)
                    .unwrap()
                    .clone(),
            ),
            4 => i.requested_by = "other".into(),
            5 => binding.policy_digest = Digest32([8; 32]),
            6 => {
                i.context
                    .iter_mut()
                    .find(|e| e.kind == ContextKind::SeverityClassification)
                    .unwrap()
                    .hash = Digest32([8; 32])
            }
            _ => changed.module_id = "unapproved".into(),
        }
        i.context
            .iter_mut()
            .find(|e| e.kind == ContextKind::AnalysisRecord)
            .unwrap()
            .hash = changed.digest();
        assert!(
            matches!(
                gate.authorize_admitted(&i, &changed, &binding, &Admitted(changed.clone()))
                    .await,
                AuthorizationDecision::Reject { .. }
            ),
            "mutation {mutation}"
        );
    }
}
#[tokio::test]
async fn classified_parameters_conflict_without_changing_operation_identity() {
    let (_, registry, _) = fixture();
    let w = worker(registry.digest());
    let i = intent(&w);
    let mut other = i.clone();
    let mut changed = w.classification.unwrap();
    changed.classification_digest = Digest32([8; 32]);
    other.parameters_digest = params().digest_for(Some(changed));
    assert_eq!(i.operation_id(), other.operation_id());
    assert_ne!(i.parameters_digest, other.parameters_digest);
    let journal = OperationJournal::default();
    assert!(matches!(
        journal.claim(&i).await.unwrap(),
        Claim::Acquired(_)
    ));
    assert!(matches!(
        journal.claim(&other).await,
        Err(Error::ParameterMismatch)
    ));
    let changed = ClassificationBinding {
        policy_digest: Digest32([9; 32]),
        ..w.classification.unwrap()
    };
    other.parameters_digest = params().digest_for(Some(changed));
    assert!(matches!(
        journal.claim(&other).await,
        Err(Error::ParameterMismatch)
    ));
}
#[test]
fn typed_binding_roundtrips_and_changes_signed_preimage() {
    let (_, registry, _) = fixture();
    let mut w = worker(registry.digest());
    let hash = w.digest();
    let json = serde_json::to_vec(&w).unwrap();
    let decoded: WorkerExecutionRecord = serde_json::from_slice(&json).unwrap();
    assert_eq!(decoded.digest(), hash);
    w.classification.as_mut().unwrap().classification_digest = Digest32([9; 32]);
    assert_ne!(w.digest(), hash);
    w.classification = None;
    let serialized = serde_json::to_value(&w).unwrap();
    assert!(serialized.get("classification").is_none());
}
#[test]
fn verified_profile_denies_other_intent_and_binding() {
    let (signed, registry, _) = fixture();
    let policy = VerifiedTriagePolicy::verify(signed, &registry, registry.digest()).unwrap();
    let w = worker(policy.classification_policy().digest());
    let mut i = intent(&w);
    let b = policy.binding();
    i.intent_type = WorkIntentType::Publish;
    assert!(matches!(policy.resolve(&i, &b), PolicyVerdict::Deny(_)));
}

#[test]
fn cli_verifies_detached_quorum_files_and_rejects_unsigned_candidate() {
    let (signed, registry, _) = fixture();
    let directory = std::env::temp_dir().join(format!("governance-cli-{}", uuid::Uuid::new_v4()));
    std::fs::create_dir(&directory).unwrap();
    let profile = directory.join("profile.json");
    let approvals = directory.join("profile.sig");
    let registry_file = directory.join("registry.json");
    std::fs::write(&profile, serde_json::to_vec(&signed.profile).unwrap()).unwrap();
    std::fs::write(&approvals,serde_json::to_vec(&serde_json::json!({"registry_digest":signed.registry_digest,"approvals":signed.approvals})).unwrap()).unwrap();
    std::fs::write(&registry_file, serde_json::to_vec(&registry).unwrap()).unwrap();
    let run = || {
        std::process::Command::new(env!("CARGO_BIN_EXE_triage_policy"))
            .arg("verify-files")
            .arg(&profile)
            .arg(&approvals)
            .arg(&registry_file)
            .arg(registry.digest().to_hex())
            .output()
            .unwrap()
    };
    let good = run();
    assert!(
        good.status.success(),
        "{}",
        String::from_utf8_lossy(&good.stderr)
    );
    let output: serde_json::Value = serde_json::from_slice(&good.stdout).unwrap();
    assert_eq!(output["profile_digest"], signed.profile.digest().to_hex());
    std::fs::write(
        &approvals,
        serde_json::to_vec(
            &serde_json::json!({"registry_digest":signed.registry_digest,"approvals":[]}),
        )
        .unwrap(),
    )
    .unwrap();
    assert!(!run().status.success());
    let digest = std::process::Command::new(env!("CARGO_BIN_EXE_triage_policy"))
        .arg("profile-digest")
        .arg(&profile)
        .output()
        .unwrap();
    assert!(digest.status.success());
    let output: serde_json::Value = serde_json::from_slice(&digest.stdout).unwrap();
    assert_eq!(output["profile_digest"], signed.profile.digest().to_hex());
}

#[derive(Default)]
struct TestStore(std::sync::Mutex<std::collections::HashMap<Digest32, WorkerExecutionRecord>>);
#[async_trait]
impl EvidenceReader for TestStore {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(self.0.lock().unwrap().get(&hash).map(|r| EvidenceEnvelope {
            record_hash: hash,
            kind: "WorkerExecutionRecord".into(),
            subject: r.input_digest,
            payload_digest: hash,
            policy_digest: None,
            causal_parents: r.evidence_refs.clone(),
        }))
    }
}
#[async_trait]
impl arkhe_bugbounty::Kernel for TestStore {
    async fn admit(&self, r: &WorkerExecutionRecord) -> Result<Digest32, String> {
        // Synthetic admission fixture; real signature coverage is tested in provenance.rs.
        let hash = r.digest();
        self.0.lock().unwrap().insert(hash, r.clone());
        Ok(hash)
    }
}
fn source() -> arkhe_bugbounty::ReportDetails {
    arkhe_bugbounty::ReportDetails {
        version: 1,
        report_id: "test-report".into(),
        severity: Severity::Low,
        title: "synthetic".into(),
        report_body: "synthetic fixture; no vulnerability attestation".into(),
        submitted_at: 1,
        affected_assets: vec![Digest32([42; 32])],
    }
}
struct TestAnalyzer(Option<ClassificationBinding>);
#[async_trait]
impl arkhe_bugbounty::LlmAnalyzer for TestAnalyzer {
    fn classification_evidence(&self) -> Option<ClassificationBinding> {
        self.0
    }
    async fn analyze(
        &self,
        report: &arkhe_bugbounty::ReportDetails,
        p: TriageParams,
    ) -> Result<WorkerExecutionRecord, String> {
        let mut w = worker(self.0.map(|b| b.policy_digest).unwrap_or(Digest32::ZERO));
        w.classification = self.0;
        w.input_digest = report.digest();
        w.output_digest = p.digest_for(self.0);
        Ok(w)
    }
}
struct TestClient(std::sync::Arc<std::sync::atomic::AtomicUsize>);
#[async_trait]
impl arkhe_bugbounty::HackenProofMcpClient for TestClient {
    async fn get_program_info(
        &self,
        _: &str,
    ) -> Result<arkhe_bugbounty::scope::ProgramScope, arkhe_bugbounty::HackenProofError> {
        Ok(arkhe_bugbounty::scope::ProgramScope {
            version: 1,
            program_id: "synthetic-program".into(),
            report_digest: source().digest(),
            included_assets: source().affected_assets,
            excluded_assets: vec![],
        })
    }

    async fn get_report_details(
        &self,
        _: &str,
    ) -> Result<arkhe_bugbounty::ReportDetails, arkhe_bugbounty::HackenProofError> {
        Ok(source())
    }
    async fn triage_report(
        &self,
        id: &str,
        _: TriageParams,
        _: Digest32,
    ) -> Result<arkhe_bugbounty::TriageResponse, arkhe_bugbounty::HackenProofError> {
        self.0.fetch_add(1, std::sync::atomic::Ordering::SeqCst);
        Ok(arkhe_bugbounty::TriageResponse {
            version: 1,
            report_id: id.into(),
            accepted_at: 1,
            transaction_digest: Digest32([7; 32]),
        })
    }
}
struct TestLog;
#[async_trait]
impl arkhe_bugbounty::OperationalLog for TestLog {
    async fn record(&self, _: &str, _: Option<Digest32>, _: &str, _: &str) -> Result<(), String> {
        Ok(())
    }
}
#[tokio::test]
async fn executor_verified_profile_blocks_legacy_and_conflicts_before_second_dispatch() {
    use std::sync::{
        atomic::{AtomicUsize, Ordering},
        Arc,
    };
    let (signed, registry, _) = fixture();
    let journal = Arc::new(OperationJournal::default());
    let calls = Arc::new(AtomicUsize::new(0));
    let make = |classification: Option<Digest32>| {
        let policy =
            VerifiedTriagePolicy::verify(signed.clone(), &registry, registry.digest()).unwrap();
        let binding = policy.binding();
        arkhe_bugbounty::TriageExecutor {
            client: TestClient(calls.clone()),
            analyzer: TestAnalyzer(classification.map(|hash| ClassificationBinding {
                classification_digest: hash,
                policy_digest: policy.classification_policy().digest(),
            })),
            kernel: TestStore::default(),
            operational_log: TestLog,
            gate: ContainmentGate::new(policy),
            policy: binding,
            requested_by: "triager".into(),
            journal: journal.clone(),
        }
    };
    let legacy = make(None);
    assert!(matches!(
        legacy
            .execute_triage(
                "test-report",
                params(),
                RequestIdentity::new(b"legacy-test")
            )
            .await,
        Err(Error::Rejected(_))
    ));
    assert_eq!(calls.load(Ordering::SeqCst), 0);
    let classified = make(Some(Digest32([3; 32])));
    let request = RequestIdentity::new(b"classified-test");
    let first = classified
        .execute_triage("test-report", params(), request)
        .await
        .unwrap();
    let replay = classified
        .execute_triage("test-report", params(), request)
        .await
        .unwrap();
    assert_eq!(first.digest(), replay.digest());
    assert_eq!(calls.load(Ordering::SeqCst), 1);
    let changed = make(Some(Digest32([8; 32])));
    assert!(matches!(
        changed
            .execute_triage("test-report", params(), request)
            .await,
        Err(Error::ParameterMismatch)
    ));
    assert_eq!(calls.load(Ordering::SeqCst), 1);
}

#[cfg(feature = "postgres-integration")]
#[tokio::test]
async fn postgres_typed_binding_survives_reconnect_and_classification_change_conflicts() {
    use arkhe_bugbounty::{
        postgres::{PgKernel, PgOperations, WorkerVerifier},
        Kernel,
    };
    use arkhe_core::CanonicalEncode;
    struct Pinned(Digest32);
    #[async_trait]
    impl WorkerVerifier for Pinned {
        async fn verify(&self, r: &WorkerExecutionRecord) -> Result<(), String> {
            if r.digest() == self.0 {
                Ok(())
            } else {
                Err("not the synthetic pinned fixture".into())
            }
        }
    }
    let url =
        std::env::var("ARKHE_TEST_DATABASE_URL").expect("real PostgreSQL runtime role required");
    let tenant = format!("classified-{}", uuid::Uuid::new_v4());
    let (signed, registry, _) = fixture();
    let policy = VerifiedTriagePolicy::verify(signed, &registry, registry.digest()).unwrap();
    let binding = policy.binding();
    let w = worker(policy.classification_policy().digest());
    let i = intent(&w);
    let hash = w.digest();
    let kernel = PgKernel::connect(&url, &tenant, Pinned(hash))
        .await
        .unwrap();
    assert_eq!(kernel.admit(&w).await.unwrap(), hash);
    drop(kernel);
    let kernel = PgKernel::connect(&url, &tenant, Pinned(hash))
        .await
        .unwrap();
    assert_eq!(
        kernel.canonical_worker(hash).await.unwrap().unwrap(),
        w.canonical_bytes()
    );
    assert!(matches!(
        ContainmentGate::new(policy)
            .authorize_admitted(&i, &w, &binding, &kernel)
            .await,
        AuthorizationDecision::Allow { .. }
    ));
    let journal = PgOperations::connect(&url, &tenant).await.unwrap();
    let owner = match journal.claim(&i).await.unwrap() {
        Claim::Acquired(owner) => owner,
        _ => panic!("new fixture expected"),
    };
    journal.mark_dispatched(&i, owner).await.unwrap();
    let mut response = w.clone();
    response.execution_id = i.operation_id().to_hex();
    journal.complete(&i, owner, &response).await.unwrap();
    drop(journal);
    let journal = PgOperations::connect(&url, &tenant).await.unwrap();
    let cached = match journal.claim(&i).await.unwrap() {
        Claim::Replay(record) => record,
        _ => panic!("persisted replay expected"),
    };
    assert_eq!(cached.classification, w.classification);
    let mut changed = i.clone();
    let mut b = w.classification.unwrap();
    b.classification_digest = Digest32([9; 32]);
    changed.parameters_digest = params().digest_for(Some(b));
    assert_eq!(changed.operation_id(), i.operation_id());
    assert!(matches!(
        journal.claim(&changed).await,
        Err(Error::ParameterMismatch)
    ));
    let other = PgKernel::connect(&url, &format!("other-{tenant}"), Pinned(hash))
        .await
        .unwrap();
    assert!(other.get(hash).await.unwrap().is_none());
}
