use arkhe_agent::license_pco;
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    formal_proof::*,
    work::*,
    worker::*,
    Digest32,
};
use arkhe_governance::{EvidenceKindRequirement, PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use arkhe_verify_core::{
    hash::sha256,
    mmr::{build_root_and_proof, profile::PROFILE_DIGEST_HEX},
    payment,
};
use async_trait::async_trait;
use ed25519_dalek::{Signer, SigningKey};
use std::collections::{BTreeMap, BTreeSet};

#[derive(Clone)]
struct Policy {
    spec: FormalPredicate,
    deny: bool,
}
impl PolicyResolver for Policy {
    fn required_formal_predicate(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<FormalPredicate> {
        Some(self.spec.clone())
    }
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec!["test-formal".into()],
            allowed_operations: vec![CognitiveOperation::Analyze],
        })
    }
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        if self.deny {
            PolicyVerdict::Deny("denied".into())
        } else {
            PolicyVerdict::Allow
        }
    }
}
struct Store {
    worker: WorkerExecutionRecord,
    proof: Option<ProofCarryingOutput>,
    admitted: bool,
}
#[async_trait]
impl EvidenceReader for Store {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        if hash == self.worker.digest() {
            return Ok(Some(EvidenceEnvelope {
                record_hash: hash,
                kind: "WorkerExecutionRecord".into(),
                subject: self.worker.input_digest,
                payload_digest: hash,
                policy_digest: None,
                causal_parents: vec![],
            }));
        }
        if let Some(p) = &self.proof {
            if self.admitted && hash == p.digest() {
                return Ok(Some(EvidenceEnvelope {
                    record_hash: hash,
                    kind: "FormalProof".into(),
                    subject: self.worker.digest(),
                    payload_digest: hash,
                    policy_digest: Some(binding().policy_digest),
                    causal_parents: vec![self.worker.digest(), self.worker.input_digest],
                }));
            }
        }
        Ok(None)
    }
    async fn formal_proof(&self, _: Digest32) -> Result<Option<ProofCarryingOutput>, String> {
        Ok(self.proof.clone())
    }
}
fn binding() -> PolicyBinding {
    PolicyBinding {
        policy_id: "test-formal".into(),
        version: 1,
        policy_digest: Digest32([7; 32]),
    }
}
fn base(
    input: Digest32,
    output: Digest32,
    target: Digest32,
    refs: Vec<Digest32>,
) -> (WorkIntent, WorkerExecutionRecord) {
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Analyze),
        module_id: "test-formal".into(),
        module_version: "1".into(),
        input_digest: input,
        output_digest: output,
        evidence_refs: refs,
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: "formal-1".into(),
    };
    let intent = WorkIntent {
        requested_by: "operator".into(),
        intent_type: WorkIntentType::ApproveExpense,
        target,
        parameters_digest: output,
        context: vec![
            ContextEntry {
                kind: ContextKind::SourceReport,
                hash: input,
            },
            ContextEntry {
                kind: ContextKind::AnalysisRecord,
                hash: worker.digest(),
            },
        ],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"formal-1"),
        claimed_created_at: 0,
    };
    (intent, worker)
}
async fn allowed(i: &WorkIntent, w: &WorkerExecutionRecord, p: &Policy, s: &Store) -> bool {
    matches!(
        ContainmentGate::new(p.clone())
            .authorize_admitted(i, w, &binding(), s)
            .await,
        AuthorizationDecision::Allow { .. }
    )
}
fn license_fixture(expr: &str) -> (WorkIntent, WorkerExecutionRecord, Policy, Store) {
    let artifact = b"test artifact".to_vec();
    let checksum: String = sha256(&artifact)
        .iter()
        .map(|b| format!("{b:02x}"))
        .collect();
    let json = serde_json::json!({"spdxVersion":"SPDX-2.3","dataLicense":"CC0-1.0","SPDXID":"SPDXRef-DOCUMENT","name":"test","documentNamespace":"https://example.test/spdx/1","creationInfo":{"creators":["Tool: test"],"created":"2026-10-22T00:00:00Z"},"documentDescribes":["SPDXRef-root"],"packages":[{"SPDXID":"SPDXRef-root","name":"test","downloadLocation":"NOASSERTION","filesAnalyzed":false,"licenseConcluded":expr,"licenseDeclared":expr,"copyrightText":"test copyright","checksums":[{"algorithm":"SHA256","checksumValue":checksum}]}]});
    let input = LicenseInput {
        spdx_json: json.to_string(),
        artifact,
    };
    let spec = LicensePolicy {
        version: 1,
        obligations: BTreeMap::from([
            (
                "MIT".into(),
                BTreeSet::from(["attribution".into(), "license-copy".into()]),
            ),
            (
                "BSD-2-Clause".into(),
                BTreeSet::from(["attribution".into()]),
            ),
            ("GPL-3.0-only".into(), BTreeSet::from(["source".into()])),
        ]),
        permitted_obligations: BTreeSet::from(["attribution".into(), "license-copy".into()]),
        require_zk: false,
    };
    let output = license_pco::propose_output(&input);
    let (i, w) = base(
        input.digest(),
        output.digest(),
        input.artifact_digest(),
        vec![input.sbom_digest()],
    );
    let proof = license_pco::prove_license(input, &spec, binding().policy_digest, &i, &w);
    let p = Policy {
        spec: FormalPredicate::License(spec),
        deny: false,
    };
    let s = Store {
        worker: w.clone(),
        proof: Some(proof),
        admitted: true,
    };
    (i, w, p, s)
}

#[tokio::test]
async fn spdx_obligations_support_and_or_and_reject_unknown_or_disallowed_terms() {
    for (expr, pass) in [
        ("MIT AND BSD-2-Clause", true),
        ("GPL-3.0-only OR MIT", true),
        ("MIT AND GPL-3.0-only", false),
        ("GPL-3.0-only", false),
        ("NOASSERTION", false),
        ("NONE", false),
        ("Unknown-License", false),
        ("MIT WITH LLVM-exception", false),
    ] {
        let (i, w, p, s) = license_fixture(expr);
        assert_eq!(allowed(&i, &w, &p, &s).await, pass, "{expr}");
    }
}
#[tokio::test]
async fn license_tampering_policy_swap_and_replay_are_rejected() {
    let (i, w, p, mut s) = license_fixture("MIT");
    assert!(allowed(&i, &w, &p, &s).await);
    let Some(ProofCarryingOutput::License(proof)) = &mut s.proof else {
        unreachable!()
    };
    proof.input.artifact[0] ^= 1;
    assert!(!allowed(&i, &w, &p, &s).await);
    let (i, w, mut p, s) = license_fixture("MIT");
    let FormalPredicate::License(spec) = &mut p.spec else {
        unreachable!()
    };
    spec.permitted_obligations.clear();
    assert!(!allowed(&i, &w, &p, &s).await);
    let (mut i, w, p, s) = license_fixture("MIT");
    i.request_identity = RequestIdentity::new(b"different");
    assert!(!allowed(&i, &w, &p, &s).await);
}
#[tokio::test]
async fn absent_unadmitted_or_wrong_kind_formal_proof_never_authorizes() {
    let (i, w, p, mut s) = license_fixture("MIT");
    s.admitted = false;
    assert!(!allowed(&i, &w, &p, &s).await);
    s.proof = None;
    assert!(!allowed(&i, &w, &p, &s).await);
    assert!(matches!(
        ContainmentGate::new(p).authorize(&i, Some(&w), &binding()),
        AuthorizationDecision::Reject { .. }
    ));
}
#[tokio::test]
async fn zk_requirement_and_governance_denial_cannot_be_bypassed() {
    let (i, w, mut p, s) = license_fixture("MIT");
    p.deny = true;
    assert!(!allowed(&i, &w, &p, &s).await);
    let (i, w, mut p, mut s) = license_fixture("MIT");
    let FormalPredicate::License(spec) = &mut p.spec else {
        unreachable!()
    };
    spec.require_zk = true;
    let Some(ProofCarryingOutput::License(proof)) = &mut s.proof else {
        unreachable!()
    };
    proof.spec_digest = spec.digest();
    assert!(!allowed(&i, &w, &p, &s).await);
}

fn payment_fixture(autonomous: bool) -> (WorkIntent, WorkerExecutionRecord, Policy, Store) {
    // Raw tokens are opaque mock fixtures. These tests qualify the authenticated
    // role bridge, not the external role's SD-JWT/credential implementation.
    let closed = "mock.closed.ap2~disclosure~".to_owned();
    let open = autonomous.then(|| "mock.open.ap2~disclosure~".to_owned());
    let checkout = "mock.checkout.jwt".to_owned();
    let execution = PaymentExecution {
        network: "testnet".into(),
        payee: "merchant".into(),
        currency: "BRL".into(),
        amount_minor: 100,
        instrument_digest: Digest32([8; 32]),
        checkout_sha256: sha256(checkout.as_bytes()),
    };
    let (mut i, _) = base(
        Digest32::ZERO,
        execution.digest(),
        payment::closed_digest(&closed),
        vec![],
    );
    let role = Ap2RoleAttestation {
        bridge_profile: payment::BRIDGE.into(),
        ap2_version: "0.2".into(),
        role_id: "trusted-role".into(),
        flow: if autonomous {
            Ap2Flow::Autonomous
        } else {
            Ap2Flow::Direct
        },
        principal: i.requested_by.clone(),
        operation_id: i.operation_id(),
        policy_digest: binding().policy_digest,
        closed_sha256: sha256(closed.as_bytes()),
        closed_mandate_id: Digest32([25; 32]),
        open_sha256: open.as_ref().map(|s| sha256(s.as_bytes())),
        execution,
        signatures_validated: true,
        constraints_validated: true,
        checkout_binding_validated: true,
        open_issued_at: autonomous.then_some(5),
        closed_issued_at: 30,
        validated_at: 38,
        expires_at: 100,
    };
    let token = open.as_ref().unwrap_or(&closed);
    let (root, steps) = build_root_and_proof(&[token.as_bytes().to_vec()], 0).unwrap();
    let checkpoint = PaymentCheckpoint {
        profile_digest: PROFILE_DIGEST_HEX.into(),
        root,
        leaf_count: 1,
        issued_at: if autonomous { 20 } else { 35 },
    };
    let key = SigningKey::from_bytes(&[23; 32]);
    let log = SigningKey::from_bytes(&[24; 32]);
    let proof = PaymentProof {
        role_signature: key.sign(&role.digest().0).to_bytes().to_vec(),
        role,
        closed_sd_jwt: closed,
        open_sd_jwt: open,
        checkout_jwt: checkout,
        checkpoint_signature: log.sign(&checkpoint.digest().0).to_bytes().to_vec(),
        leaf_index: 0,
        steps: steps
            .into_iter()
            .map(|s| PaymentStep {
                kind: s.kind,
                direction: s.direction,
                hash: s.hash,
            })
            .collect(),
    };
    let spec = PaymentPolicy {
        version: 1,
        role_id: "trusted-role".into(),
        role_public_key: key.verifying_key().to_bytes(),
        log_public_key: log.verifying_key().to_bytes(),
        retained_checkpoint: checkpoint,
        now: 40,
        max_role_age: 10,
        max_checkpoint_age: 30,
    };
    let (_, w) = base(
        proof.role.digest(),
        proof.role.execution.digest(),
        i.target,
        vec![],
    );
    i.context = vec![
        ContextEntry {
            kind: ContextKind::SourceReport,
            hash: w.input_digest,
        },
        ContextEntry {
            kind: ContextKind::AnalysisRecord,
            hash: w.digest(),
        },
    ];
    let s = Store {
        worker: w.clone(),
        proof: Some(ProofCarryingOutput::PaymentMandate(Box::new(proof))),
        admitted: true,
    };
    (
        i,
        w,
        Policy {
            spec: FormalPredicate::PaymentMandate(spec),
            deny: false,
        },
        s,
    )
}
#[tokio::test]
async fn ap2_direct_and_autonomous_role_results_bind_exact_execution() {
    for autonomous in [false, true] {
        let (i, w, p, s) = payment_fixture(autonomous);
        assert!(allowed(&i, &w, &p, &s).await);
    }
}
#[tokio::test]
async fn ap2_tampering_and_false_role_results_fail_closed() {
    for case in 0..9 {
        let (i, w, p, mut s) = payment_fixture(true);
        let Some(ProofCarryingOutput::PaymentMandate(proof)) = &mut s.proof else {
            unreachable!()
        };
        match case {
            0 => proof.closed_sd_jwt.push('x'),
            1 => proof.open_sd_jwt = Some("other".into()),
            2 => proof.role_signature[0] ^= 1,
            3 => proof.role.constraints_validated = false,
            4 => proof.role.execution.amount_minor = 101,
            5 => proof.checkout_jwt.push('x'),
            6 => proof.checkpoint_signature[0] ^= 1,
            7 => proof.leaf_index = 1,
            _ => proof.role.ap2_version = "0.1".into(),
        }
        assert!(!allowed(&i, &w, &p, &s).await, "case {case}");
    }
}
#[tokio::test]
async fn ap2_retained_checkpoint_time_and_kind_are_enforced() {
    let (i, w, mut p, s) = payment_fixture(true);
    let FormalPredicate::PaymentMandate(spec) = &mut p.spec else {
        unreachable!()
    };
    spec.retained_checkpoint.issued_at = 31;
    assert!(!allowed(&i, &w, &p, &s).await);
    let (i, w, mut p, s) = payment_fixture(false);
    let FormalPredicate::PaymentMandate(spec) = &mut p.spec else {
        unreachable!()
    };
    spec.now = 100;
    assert!(!allowed(&i, &w, &p, &s).await);
    let (i, w, p, mut s) = payment_fixture(false);
    s.proof = license_fixture("MIT").3.proof;
    assert!(!allowed(&i, &w, &p, &s).await);
}

#[cfg(feature = "sqlite-broker")]
#[tokio::test]
async fn ap2_broker_persists_receipt_and_rejects_second_operation_for_same_closed_mandate() {
    use arkhe_kernel::{
        broker::{CapabilityBroker, CapabilityExecutor},
        broker_sqlite::SqliteDispatchJournal,
    };
    use std::sync::{
        atomic::{AtomicUsize, Ordering},
        Arc,
    };
    struct Executor(Arc<AtomicUsize>);
    impl CapabilityExecutor for Executor {
        fn execute(&mut self, _: &WorkIntent) -> Result<Vec<u8>, String> {
            self.0.fetch_add(1, Ordering::SeqCst);
            Ok(b"paid".to_vec())
        }
    }
    let path = std::env::temp_dir().join(format!("arkhe-ap2-{}.sqlite", uuid::Uuid::new_v4()));
    let (i, w, p, s) = payment_fixture(false);
    let count = Arc::new(AtomicUsize::new(0));
    {
        let mut broker = CapabilityBroker::new(
            ContainmentGate::new(p.clone()),
            SqliteDispatchJournal::open(&path).unwrap(),
            Executor(count.clone()),
        );
        assert_eq!(
            broker
                .execute_payment(&i, &w, &binding(), &s)
                .await
                .unwrap(),
            b"paid"
        );
    }
    let mut broker = CapabilityBroker::new(
        ContainmentGate::new(p),
        SqliteDispatchJournal::open(&path).unwrap(),
        Executor(count.clone()),
    );
    assert_eq!(
        broker
            .execute_payment(&i, &w, &binding(), &s)
            .await
            .unwrap(),
        b"paid"
    );
    let (mut i, _, p, mut s) = payment_fixture(false);
    i.request_identity = RequestIdentity::new(b"another-operation");
    let Some(ProofCarryingOutput::PaymentMandate(proof)) = &mut s.proof else {
        unreachable!()
    };
    proof.role.operation_id = i.operation_id();
    proof.role_signature = SigningKey::from_bytes(&[23; 32])
        .sign(&proof.role.digest().0)
        .to_bytes()
        .to_vec();
    let (_, w) = base(
        proof.role.digest(),
        proof.role.execution.digest(),
        i.target,
        vec![],
    );
    i.context = vec![
        ContextEntry {
            kind: ContextKind::SourceReport,
            hash: w.input_digest,
        },
        ContextEntry {
            kind: ContextKind::AnalysisRecord,
            hash: w.digest(),
        },
    ];
    s.worker = w.clone();
    assert!(allowed(&i, &w, &p, &s).await); // Even valid fresh role evidence cannot spend the same closed mandate twice.
    assert!(broker
        .execute_payment(&i, &w, &binding(), &s)
        .await
        .is_err());
    assert_eq!(count.load(Ordering::SeqCst), 1);
    drop(broker);
    // A different SD-JWT presentation may disclose different claims while the
    // trusted role identifies the SAME closed credential. It must not spend again.
    let (mut i, _, mut p, mut s) = payment_fixture(false);
    let Some(ProofCarryingOutput::PaymentMandate(proof)) = &mut s.proof else {
        unreachable!()
    };
    proof.closed_sd_jwt.push_str("alternate-disclosure~");
    proof.role.closed_sha256 = sha256(proof.closed_sd_jwt.as_bytes());
    i.target = payment::closed_digest(&proof.closed_sd_jwt);
    i.request_identity = RequestIdentity::new(b"alternate-presentation");
    proof.role.operation_id = i.operation_id();
    proof.role_signature = SigningKey::from_bytes(&[23; 32])
        .sign(&proof.role.digest().0)
        .to_bytes()
        .to_vec();
    let FormalPredicate::PaymentMandate(spec) = &mut p.spec else {
        unreachable!()
    };
    spec.retained_checkpoint.root =
        build_root_and_proof(&[proof.closed_sd_jwt.as_bytes().to_vec()], 0)
            .unwrap()
            .0;
    proof.checkpoint_signature = SigningKey::from_bytes(&[24; 32])
        .sign(&spec.retained_checkpoint.digest().0)
        .to_bytes()
        .to_vec();
    let (_, w) = base(
        proof.role.digest(),
        proof.role.execution.digest(),
        i.target,
        vec![],
    );
    i.context = vec![
        ContextEntry {
            kind: ContextKind::SourceReport,
            hash: w.input_digest,
        },
        ContextEntry {
            kind: ContextKind::AnalysisRecord,
            hash: w.digest(),
        },
    ];
    s.worker = w.clone();
    assert!(allowed(&i, &w, &p, &s).await);
    let mut broker = CapabilityBroker::new(
        ContainmentGate::new(p),
        SqliteDispatchJournal::open(&path).unwrap(),
        Executor(count.clone()),
    );
    assert!(broker
        .execute_payment(&i, &w, &binding(), &s)
        .await
        .is_err());
    assert_eq!(count.load(Ordering::SeqCst), 1);
    drop(broker);
    std::fs::remove_file(path).unwrap();
}
