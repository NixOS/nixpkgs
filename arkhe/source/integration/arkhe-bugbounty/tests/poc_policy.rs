use arkhe_bugbounty::bounty_evidence::{policy::*, PocMeasurement, PocPolicy, PocVerdict};
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    work::*,
    worker::*,
    Digest32,
};
use arkhe_governance::{PolicyBinding, PolicyResolver, PolicyVerdict};
use async_trait::async_trait;
struct Resolver(bool);
impl PolicyResolver for Resolver {
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        if self.0 {
            PolicyVerdict::Allow
        } else {
            PolicyVerdict::Deny("test deny".into())
        }
    }
}
struct Store(Option<EvidenceEnvelope>);
#[async_trait]
impl EvidenceReader for Store {
    async fn get(&self, _: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(self.0.clone())
    }
}
fn binding() -> PolicyBinding {
    PolicyBinding {
        policy_id: "TEST-NOT-RATIFIED".into(),
        version: 1,
        policy_digest: Digest32([4; 32]),
    }
}
fn artifact() -> ResolvedPocPolicyArtifact {
    ResolvedPocPolicyArtifact {
        version: 1,
        parent_policy_id: binding().policy_id,
        parent_policy_version: 1,
        parent_policy_digest: binding().policy_digest,
        poc: PocPolicy {
            chain_id: 1,
            fork_block: 100,
            max_block_drift: 10,
            in_scope_targets: vec![[1; 32]],
            asset_id: [2; 32],
            min_attacker_gain: 100,
        },
        allowed_modules: vec!["poc-harness-TEST".into()],
    }
}
fn intent() -> WorkIntent {
    WorkIntent {
        requested_by: "test-only".into(),
        intent_type: WorkIntentType::TriageReport,
        target: Digest32([9; 32]),
        parameters_digest: Digest32([8; 32]),
        context: vec![],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"request"),
        claimed_created_at: 1,
    }
}
fn measurement() -> PocMeasurement {
    PocMeasurement {
        chain_id: 1,
        fork_block: 100,
        submission_block: 110,
        target: [1; 32],
        asset_id: [2; 32],
        attacker_gain: 100,
    }
}
fn worker(p: &ResolvedPocPolicy, i: &WorkIntent, m: &PocMeasurement) -> WorkerExecutionRecord {
    WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Execute),
        module_id: "poc-harness-TEST".into(),
        module_version: "1".into(),
        input_digest: i.target,
        output_digest: p.measurement_digest(i, m),
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: i.operation_id().to_hex(),
    }
}
fn context(i: &mut WorkIntent, p: &ResolvedPocPolicy, w: &WorkerExecutionRecord) {
    i.context = vec![
        ContextEntry {
            kind: ContextKind::Named("PocPolicy".into()),
            hash: p.digest(),
        },
        ContextEntry {
            kind: ContextKind::Named("PocExecution".into()),
            hash: w.digest(),
        },
    ]
}
fn store(w: &WorkerExecutionRecord) -> Store {
    Store(Some(EvidenceEnvelope {
        record_hash: w.digest(),
        kind: "WorkerExecutionRecord".into(),
        subject: w.input_digest,
        payload_digest: w.digest(),
        policy_digest: None,
        causal_parents: vec![],
    }))
}
#[test]
fn artifact_requires_independent_pin_and_parent_and_binds_all_success_fields() {
    let a = artifact();
    let pin = a.digest();
    assert!(ResolvedPocPolicy::resolve(a.clone(), Digest32::ZERO, &binding()).is_err());
    let mut changed = a.clone();
    changed.poc.min_attacker_gain = 1;
    assert_ne!(changed.digest(), pin);
    assert!(ResolvedPocPolicy::resolve(changed, pin, &binding()).is_err());
    let mut b = binding();
    b.version = 2;
    assert!(ResolvedPocPolicy::resolve(a.clone(), pin, &b).is_err());
    let mut changed = a.clone();
    changed.allowed_modules.push("evil".into());
    assert_ne!(changed.digest(), pin);
    let mut changed = a.clone();
    changed.poc.min_attacker_gain = u128::MAX;
    assert_ne!(changed.digest(), pin);
    assert!(ResolvedPocPolicy::resolve(a, pin, &binding()).is_ok());
}
#[tokio::test]
async fn policy_evaluation_requires_admission_and_contextual_binding_and_never_authorizes() {
    let a = artifact();
    let p = ResolvedPocPolicy::resolve(a.clone(), a.digest(), &binding()).unwrap();
    let m = measurement();
    let mut i = intent();
    let w = worker(&p, &i, &m);
    context(&mut i, &p, &w);
    assert_eq!(
        p.evaluate_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&w),
            &w,
            &m,
            &Anchors
        )
        .await
        .unwrap(),
        PocVerdict::Pass
    );
    assert!(p
        .evaluate_admitted(
            &i,
            &binding(),
            &Resolver(false),
            &store(&w),
            &w,
            &m,
            &Anchors
        )
        .await
        .is_err());
    assert!(p
        .evaluate_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &Store(None),
            &w,
            &m,
            &Anchors
        )
        .await
        .is_err());
    let mut changed = m.clone();
    changed.attacker_gain = 999;
    assert!(p
        .evaluate_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&w),
            &w,
            &changed,
            &Anchors
        )
        .await
        .is_err());
    for mode in 0..5 {
        let mut changed = i.clone();
        match mode {
            0 => changed.parameters_digest = Digest32([7; 32]),
            1 => changed.requested_by = "other".into(),
            2 => changed.target = Digest32([6; 32]),
            3 => changed.context.push(changed.context[0].clone()),
            _ => changed.request_identity = RequestIdentity::new(b"other"),
        };
        assert!(p
            .evaluate_admitted(
                &changed,
                &binding(),
                &Resolver(true),
                &store(&w),
                &w,
                &m,
                &Anchors
            )
            .await
            .is_err());
    }
    let mut low = m.clone();
    low.attacker_gain = 99;
    let low_worker = worker(&p, &i, &low);
    context(&mut i, &p, &low_worker);
    assert_eq!(
        p.evaluate_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&low_worker),
            &low_worker,
            &low,
            &Anchors
        )
        .await
        .unwrap(),
        PocVerdict::GainBelowThreshold
    );
    let mut bad = store(&low_worker);
    bad.0.as_mut().unwrap().payload_digest = Digest32::ZERO;
    assert!(p
        .evaluate_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &bad,
            &low_worker,
            &low,
            &Anchors
        )
        .await
        .is_err());
}

struct Anchors;
#[async_trait]
impl arkhe_bugbounty::bounty_evidence::priority::AnchorSource for Anchors {
    async fn verified_anchor(
        &self,
        report: [u8; 32],
    ) -> Result<arkhe_bugbounty::bounty_evidence::priority::AnchoredClaim, String> {
        Ok(arkhe_bugbounty::bounty_evidence::priority::AnchoredClaim {
            log_id: [1; 32],
            commitment: [2; 32],
            report_digest: report,
            recipient: [3; 32],
            anchored_at: 1,
            log_position: 1,
            chain_id: 1,
            submission_block: 110,
        })
    }
    async fn verified_priority_snapshot(
        &self,
        _: [u8; 32],
    ) -> Result<arkhe_bugbounty::bounty_evidence::priority::PrioritySnapshot, String> {
        Err("no snapshot fixture".into())
    }
}

#[tokio::test]
async fn researcher_submission_block_is_rejected_even_with_matching_admitted_wer() {
    let a = artifact();
    let p = ResolvedPocPolicy::resolve(a.clone(), a.digest(), &binding()).unwrap();
    let mut m = measurement();
    m.submission_block = 101;
    let mut i = intent();
    let w = worker(&p, &i, &m);
    context(&mut i, &p, &w);
    assert!(p
        .evaluate_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&w),
            &w,
            &m,
            &Anchors
        )
        .await
        .unwrap_err()
        .contains("forged submission"));
}

struct BlockAnchors(u64);
#[async_trait]
impl arkhe_bugbounty::bounty_evidence::priority::AnchorSource for BlockAnchors {
    async fn verified_anchor(
        &self,
        report: [u8; 32],
    ) -> Result<arkhe_bugbounty::bounty_evidence::priority::AnchoredClaim, String> {
        let mut a = Anchors.verified_anchor(report).await?;
        a.submission_block = self.0;
        Ok(a)
    }
    async fn verified_priority_snapshot(
        &self,
        _: [u8; 32],
    ) -> Result<arkhe_bugbounty::bounty_evidence::priority::PrioritySnapshot, String> {
        Err("unused".into())
    }
}
#[tokio::test]
async fn anchor_block_outside_window_cannot_be_replaced_by_forged_in_window_height() {
    let a = artifact();
    let p = ResolvedPocPolicy::resolve(a.clone(), a.digest(), &binding()).unwrap();
    let m = measurement();
    let mut i = intent();
    let w = worker(&p, &i, &m);
    context(&mut i, &p, &w);
    assert!(p
        .evaluate_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&w),
            &w,
            &m,
            &BlockAnchors(111)
        )
        .await
        .is_err());
    let mut actual = m;
    actual.submission_block = 111;
    let w = worker(&p, &i, &actual);
    context(&mut i, &p, &w);
    assert_eq!(
        p.evaluate_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&w),
            &w,
            &actual,
            &BlockAnchors(111)
        )
        .await
        .unwrap(),
        PocVerdict::ForkOutsideWindow
    );
}

#[tokio::test]
async fn signed_profile_rejects_signature_tampering_and_keeps_admission_checks() {
    use arkhe_bugbounty::bounty_evidence::{
        signed_poc::*, AttestationLevel, VerifierEntry, VerifierRegistry,
    };
    use ed25519_dalek::{Signer, SigningKey};
    let a = artifact();
    let p = ResolvedPocPolicy::resolve(a.clone(), a.digest(), &binding()).unwrap();
    let m = measurement();
    let mut i = intent();
    let w = worker(&p, &i, &m);
    context(&mut i, &p, &w);
    let sk = SigningKey::from_bytes(&[7; 32]);
    let mut signed = SignedPocMeasurement {
        version: 1,
        measurement: m,
        context: PocContext {
            report_digest: i.target.0,
            policy_digest: p.digest().0,
            operation_id: i.operation_id().0,
            parameters_digest: i.parameters_digest.0,
        },
        verifier_id: [1; 32],
        public_key: sk.verifying_key().to_bytes(),
        signed_at: 40,
        signature_hex: String::new(),
    };
    signed.signature_hex = hex::encode(sk.sign(&signed.signing_bytes()).to_bytes());
    let mut registry = VerifierRegistry::default();
    registry
        .insert(VerifierEntry {
            verifier_id: [1; 32],
            operator_id: [2; 32],
            key_id: key_id(&signed.public_key),
            level: AttestationLevel::Workload,
            not_before: 10,
            not_after: 100,
            revoked: false,
        })
        .unwrap();
    let trust = PocSignatureTrust {
        registry: &registry,
        at: 50,
        max_age: 20,
        min_level: AttestationLevel::Workload,
    };
    assert_eq!(
        p.evaluate_signed_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&w),
            &w,
            &signed,
            &trust,
            &Anchors
        )
        .await
        .unwrap(),
        PocVerdict::Pass
    );
    assert!(p
        .evaluate_signed_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &Store(None),
            &w,
            &signed,
            &trust,
            &Anchors
        )
        .await
        .is_err());
    signed.measurement.attacker_gain += 1;
    assert!(p
        .evaluate_signed_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&w),
            &w,
            &signed,
            &trust,
            &Anchors
        )
        .await
        .is_err());
}

#[tokio::test]
async fn v2_signed_policy_keeps_admission_and_checks_commitment_before_normalization() {
    use arkhe_bugbounty::bounty_evidence::{
        signed_poc::{key_id, PocContext, PocSignatureTrust},
        v2, AttestationLevel, VerifierEntry, VerifierRegistry,
    };
    use ed25519_dalek::{Signer, SigningKey};
    let a = artifact();
    let p = ResolvedPocPolicy::resolve(a.clone(), a.digest(), &binding()).unwrap();
    let old = measurement();
    let mut i = intent();
    let w = worker(&p, &i, &old);
    context(&mut i, &p, &w);
    let sk = SigningKey::from_bytes(&[7; 32]);
    let mut signed = v2::SignedPocMeasurement {
        version: 2,
        measurement: v2::PocMeasurement {
            chain_id: old.chain_id,
            fork_block: old.fork_block,
            target: old.target,
            asset_id: old.asset_id,
            attacker_gain: old.attacker_gain,
            report_commitment: [2; 32],
        },
        context: PocContext {
            report_digest: i.target.0,
            policy_digest: p.digest().0,
            operation_id: i.operation_id().0,
            parameters_digest: i.parameters_digest.0,
        },
        verifier_id: [1; 32],
        public_key: sk.verifying_key().to_bytes(),
        signed_at: 40,
        signature_hex: String::new(),
    };
    signed.signature_hex = hex::encode(sk.sign(&signed.signing_bytes()).to_bytes());
    let mut registry = VerifierRegistry::default();
    registry
        .insert(VerifierEntry {
            verifier_id: [1; 32],
            operator_id: [2; 32],
            key_id: key_id(&signed.public_key),
            level: AttestationLevel::Workload,
            not_before: 10,
            not_after: 100,
            revoked: false,
        })
        .unwrap();
    let trust = PocSignatureTrust {
        registry: &registry,
        at: 50,
        max_age: 20,
        min_level: AttestationLevel::Workload,
    };
    assert_eq!(
        p.evaluate_signed_v2_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&w),
            &w,
            &signed,
            &trust,
            &Anchors
        )
        .await
        .unwrap(),
        PocVerdict::Pass
    );
    assert!(p
        .evaluate_signed_v2_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &Store(None),
            &w,
            &signed,
            &trust,
            &Anchors
        )
        .await
        .is_err());
    signed.measurement.report_commitment = [9; 32];
    signed.signature_hex = hex::encode(sk.sign(&signed.signing_bytes()).to_bytes());
    assert!(p
        .evaluate_signed_v2_admitted(
            &i,
            &binding(),
            &Resolver(true),
            &store(&w),
            &w,
            &signed,
            &trust,
            &Anchors
        )
        .await
        .unwrap_err()
        .contains("commitment"));
}
