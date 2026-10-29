use arkhe_agent::budget_pco;
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    output_proof::{BudgetInput, BudgetOutput, BudgetProof, BudgetSpec, BUDGET_CHECKER},
    work::{ContextEntry, ContextKind, RequestIdentity, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_governance::{EvidenceKindRequirement, PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use async_trait::async_trait;

#[derive(Clone)]
struct Policy {
    spec: BudgetSpec,
    binding: PolicyBinding,
    allow: bool,
    review: bool,
}
impl PolicyResolver for Policy {
    fn required_budget_proof(&self, _: &WorkIntent, _: &PolicyBinding) -> Option<BudgetSpec> {
        Some(self.spec.clone())
    }
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec!["budget-inference".into()],
            allowed_operations: vec![CognitiveOperation::Analyze],
        })
    }
    fn review_routing_required(&self, _: &WorkIntent, _: &PolicyBinding) -> bool {
        self.review
    }
    fn human_review_modules(&self, _: &WorkIntent, _: &PolicyBinding) -> Vec<String> {
        vec!["budget-human-review".into()]
    }
    fn resolve(&self, _: &WorkIntent, p: &PolicyBinding) -> PolicyVerdict {
        if self.allow
            && p.policy_id == self.binding.policy_id
            && p.version == self.binding.version
            && p.policy_digest == self.binding.policy_digest
        {
            PolicyVerdict::Allow
        } else {
            PolicyVerdict::Deny("budget policy denied".into())
        }
    }
}

struct Store {
    analysis: EvidenceEnvelope,
    proof: Option<BudgetProof>,
    proof_envelope: Option<EvidenceEnvelope>,
    unavailable: bool,
    extra: Vec<EvidenceEnvelope>,
}
#[async_trait]
impl EvidenceReader for Store {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        if self.analysis.record_hash == hash {
            return Ok(Some(self.analysis.clone()));
        }
        if let Some(e) = self.extra.iter().find(|e| e.record_hash == hash) {
            return Ok(Some(e.clone()));
        }
        Ok(self
            .proof_envelope
            .as_ref()
            .filter(|e| e.record_hash == hash)
            .cloned())
    }
    async fn budget_proof(&self, _: Digest32) -> Result<Option<BudgetProof>, String> {
        if self.unavailable {
            Err("offline".into())
        } else {
            Ok(self.proof.clone())
        }
    }
}
fn fixture() -> (WorkIntent, WorkerExecutionRecord, Policy, Store) {
    let input = BudgetInput {
        costs: vec![20, 30, 50],
    };
    let spec = BudgetSpec {
        version: 1,
        limit: 100,
        max_items: 16,
    };
    let (output, _) = budget_pco::infer(&input, &spec).unwrap();
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Analyze),
        module_id: "budget-inference".into(),
        module_version: "1".into(),
        input_digest: input.digest(),
        output_digest: output.digest(),
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: "budget-1".into(),
    };
    let intent = WorkIntent {
        requested_by: "test-operator".into(),
        intent_type: WorkIntentType::ApproveExpense,
        target: Digest32([1; 32]),
        parameters_digest: output.digest(),
        context: vec![
            ContextEntry {
                kind: ContextKind::SourceReport,
                hash: input.digest(),
            },
            ContextEntry {
                kind: ContextKind::AnalysisRecord,
                hash: worker.digest(),
            },
        ],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"budget-test-1"),
        claimed_created_at: 0,
    };
    let policy = Policy {
        spec,
        binding: PolicyBinding {
            policy_id: "budget-test".into(),
            version: 1,
            policy_digest: Digest32([2; 32]),
        },
        allow: true,
        review: false,
    };
    let proof = budget_pco::prove(
        input,
        &policy.spec,
        policy.binding.policy_digest,
        &intent,
        &worker,
    )
    .unwrap();
    let envelope = EvidenceEnvelope {
        record_hash: proof.digest(),
        kind: "BudgetProof".into(),
        subject: worker.digest(),
        payload_digest: proof.digest(),
        policy_digest: Some(policy.binding.policy_digest),
        causal_parents: vec![worker.digest(), worker.input_digest],
    };
    let store = Store {
        analysis: EvidenceEnvelope {
            record_hash: worker.digest(),
            kind: "WorkerExecutionRecord".into(),
            subject: worker.input_digest,
            payload_digest: worker.digest(),
            policy_digest: Some(policy.binding.policy_digest),
            causal_parents: vec![],
        },
        proof: Some(proof),
        proof_envelope: Some(envelope),
        unavailable: false,
        extra: vec![],
    };
    (intent, worker, policy, store)
}
fn rejected(d: AuthorizationDecision) {
    assert!(matches!(d, AuthorizationDecision::Reject { .. }), "{d:?}");
}

#[tokio::test]
async fn valid_human_review_and_budget_proof_are_both_required() {
    use arkhe_core::review::{
        HumanReviewEvidence, HumanReviewRecord, HumanVerdict, ReviewDecision, ReviewVerdict,
    };
    let (mut i, w, mut p, mut s) = fixture();
    p.review = true;
    let route = ReviewDecision {
        verdict: ReviewVerdict::ReviewRequired,
        reasons: vec![],
        review_policy_digest: p.binding.policy_digest,
    };
    let review = HumanReviewRecord {
        requested_by: i.requested_by.clone(),
        operation_id: i.operation_id(),
        parameters_digest: i.parameters_digest,
        analysis_digest: w.digest(),
        policy_digest: p.binding.policy_digest,
        routing_digest: route.digest(),
        reviewer: "trusted-reviewer".into(),
        verdict: HumanVerdict::Approve,
        reviewed_at: 10,
        expires_at: 30,
    };
    let attestation = WorkerExecutionRecord {
        module_id: "budget-human-review".into(),
        input_digest: w.digest(),
        output_digest: review.digest(),
        evidence_refs: vec![w.digest()],
        operation: Some(CognitiveOperation::Decide),
        ..w.clone()
    };
    i.context.push(ContextEntry {
        kind: ContextKind::ReviewDecision,
        hash: route.digest(),
    });
    i.context.push(ContextEntry {
        kind: ContextKind::HumanReview,
        hash: attestation.digest(),
    });
    let proof = budget_pco::prove(
        s.proof.as_ref().unwrap().input.clone(),
        &p.spec,
        p.binding.policy_digest,
        &i,
        &w,
    )
    .unwrap();
    let e = s.proof_envelope.as_mut().unwrap();
    e.record_hash = proof.digest();
    e.payload_digest = proof.digest();
    s.proof = Some(proof);
    s.extra.push(EvidenceEnvelope {
        record_hash: attestation.digest(),
        kind: "WorkerExecutionRecord".into(),
        subject: w.digest(),
        payload_digest: attestation.digest(),
        policy_digest: Some(p.binding.policy_digest),
        causal_parents: vec![w.digest()],
    });
    let human = HumanReviewEvidence {
        review,
        attestation,
    };
    let gate = ContainmentGate::new(p.clone());
    assert!(matches!(
        gate.authorize_routed_admitted(&i, &w, &p.binding, &s, &route, Some(&human), 20)
            .await,
        AuthorizationDecision::Allow { .. }
    ));
    rejected(
        gate.authorize_routed_admitted(&i, &w, &p.binding, &s, &route, None, 20)
            .await,
    );
    rejected(
        gate.authorize_routed_admitted(&i, &w, &p.binding, &s, &route, Some(&human), 30)
            .await,
    );
    s.proof = None;
    rejected(
        gate.authorize_routed_admitted(&i, &w, &p.binding, &s, &route, Some(&human), 20)
            .await,
    );
}

#[tokio::test]
async fn specification_change_during_evidence_lookup_rejects_old_certificate() {
    use std::sync::atomic::{AtomicUsize, Ordering};
    struct ChangingPolicy {
        initial: Policy,
        reads: AtomicUsize,
    }
    impl PolicyResolver for ChangingPolicy {
        fn required_budget_proof(&self, _: &WorkIntent, _: &PolicyBinding) -> Option<BudgetSpec> {
            let mut spec = self.initial.spec.clone();
            if self.reads.fetch_add(1, Ordering::SeqCst) > 0 {
                spec.limit -= 1;
            }
            Some(spec)
        }
        fn required_worker_evidence(
            &self,
            i: &WorkIntent,
            p: &PolicyBinding,
        ) -> Option<EvidenceKindRequirement> {
            self.initial.required_worker_evidence(i, p)
        }
        fn resolve(&self, i: &WorkIntent, p: &PolicyBinding) -> PolicyVerdict {
            self.initial.resolve(i, p)
        }
    }
    let (i, w, p, s) = fixture();
    let gate = ContainmentGate::new(ChangingPolicy {
        initial: p.clone(),
        reads: AtomicUsize::new(0),
    });
    rejected(gate.authorize_admitted(&i, &w, &p.binding, &s).await);
}

#[tokio::test]
async fn generated_certificate_roundtrips_and_authorizes_only_after_admission() {
    let (intent, worker, policy, mut store) = fixture();
    let json = serde_json::to_string(store.proof.as_ref().unwrap()).unwrap();
    store.proof = Some(serde_json::from_str(&json).unwrap());
    let gate = ContainmentGate::new(policy.clone());
    let first = gate
        .authorize_admitted(&intent, &worker, &policy.binding, &store)
        .await;
    let AuthorizationDecision::Allow { authorization_ref } = first else {
        panic!("{first:?}");
    };
    // Authorization commits the checked certificate, with its own protocol domain.
    let mut bytes = intent.digest().0.to_vec();
    bytes.extend(policy.binding.policy_digest.0);
    bytes.extend(worker.digest().0);
    bytes.extend(store.proof.as_ref().unwrap().digest().0);
    assert_eq!(
        authorization_ref,
        Digest32::blake3(b"AKG:AUTHZ:PCO:v1\0", &bytes)
    );
    store.proof_envelope = None;
    rejected(
        gate.authorize_admitted(&intent, &worker, &policy.binding, &store)
            .await,
    );
}

#[tokio::test]
async fn missing_offline_or_wrong_proof_provenance_fails_closed() {
    for mutation in 0..8 {
        let (i, w, p, mut s) = fixture();
        match mutation {
            0 => s.proof = None,
            1 => s.unavailable = true,
            2 => s.proof_envelope.as_mut().unwrap().subject = Digest32::ZERO,
            3 => s.proof_envelope.as_mut().unwrap().payload_digest = Digest32::ZERO,
            4 => s.proof_envelope.as_mut().unwrap().policy_digest = None,
            5 => s.proof_envelope.as_mut().unwrap().kind = "Unverified".into(),
            6 => s.proof_envelope.as_mut().unwrap().causal_parents.clear(),
            _ => s.analysis.record_hash = Digest32::ZERO,
        }
        rejected(
            ContainmentGate::new(p.clone())
                .authorize_admitted(&i, &w, &p.binding, &s)
                .await,
        );
    }
}

#[tokio::test]
async fn malicious_certificates_are_rejected_even_when_admitted() {
    for mutation in 0..12 {
        let (i, w, p, mut s) = fixture();
        let proof = s.proof.as_mut().unwrap();
        match mutation {
            0 => proof.prefix_totals[1] = 0,
            1 => proof.prefix_totals[0] = 1,
            2 => proof.prefix_totals.pop().map(|_| ()).unwrap(),
            3 => proof.input.costs[0] += 1,
            4 => proof.output.total -= 1,
            5 => proof.policy_digest = Digest32::ZERO,
            6 => proof.spec_digest = Digest32::ZERO,
            7 => proof.intent_digest = Digest32::ZERO,
            8 => proof.worker_digest = Digest32::ZERO,
            9 => proof.checker = "unknown-checker".into(),
            10 => proof.input.costs = vec![0; 257],
            _ => proof.input.costs.clear(),
        }
        // Re-anchor the adversarial bytes: admission alone must never suffice.
        let envelope = s.proof_envelope.as_mut().unwrap();
        envelope.record_hash = proof.digest();
        envelope.payload_digest = proof.digest();
        rejected(
            ContainmentGate::new(p.clone())
                .authorize_admitted(&i, &w, &p.binding, &s)
                .await,
        );
    }
}

#[tokio::test]
async fn all_gate_entry_points_reject_proof_bypass_and_review_still_applies() {
    let (i, w, mut p, s) = fixture();
    let gate = ContainmentGate::new(p.clone());
    rejected(gate.authorize(&i, Some(&w), &p.binding));
    let mut draft = i.clone();
    draft.intent_type = WorkIntentType::DraftDocument;
    rejected(gate.authorize(&draft, Some(&w), &p.binding));
    rejected(gate.authorize(&draft, None, &p.binding));
    p.review = true;
    let gate = ContainmentGate::new(p.clone());
    rejected(gate.authorize_admitted(&i, &w, &p.binding, &s).await);
    let route = arkhe_core::review::ReviewDecision {
        verdict: arkhe_core::review::ReviewVerdict::ReviewRequired,
        reasons: vec![],
        review_policy_digest: p.binding.policy_digest,
    };
    rejected(
        gate.authorize_routed_admitted(&i, &w, &p.binding, &s, &route, None, 0)
            .await,
    );
}

#[tokio::test]
async fn proof_cannot_override_denial_stop_or_transfer_between_requests() {
    for mutation in 0..7 {
        let (mut i, w, mut p, s) = fixture();
        match mutation {
            0 => p.allow = false,
            1 => p.spec.limit = 99,
            2 => p.binding.policy_digest = Digest32([3; 32]),
            3 => i.request_identity = RequestIdentity::new(b"new-request"),
            4 => i.requested_by = "other-operator".into(),
            5 => i.target = Digest32([4; 32]),
            _ => (),
        }
        let mut gate = ContainmentGate::new(p.clone());
        if mutation == 6 {
            gate.set_emergency_stop(true);
        }
        rejected(gate.authorize_admitted(&i, &w, &p.binding, &s).await);
    }
}

#[test]
fn checker_rejects_false_arithmetic_and_over_budget_conclusion_without_producer() {
    let (i, w, p, s) = fixture();
    let mut proof = s.proof.unwrap();
    // All commitments match a forged statement with overflow wrapping to zero.
    proof.input.costs = vec![u64::MAX, 1];
    proof.output = BudgetOutput { total: 0 };
    proof.prefix_totals = vec![0, u64::MAX, 0];
    let mut w = w;
    w.input_digest = proof.input.digest();
    w.output_digest = proof.output.digest();
    let mut i = i;
    i.parameters_digest = proof.output.digest();
    proof.intent_digest = i.digest();
    proof.worker_digest = w.digest();
    assert!(arkhe_verify_core::output_proof::verify_budget_proof(
        &proof,
        &p.spec,
        p.binding.policy_digest,
        &i,
        &w
    )
    .is_err());
    // An arithmetically valid statement above the trusted cap still fails.
    proof.input.costs = vec![101];
    proof.output.total = 101;
    proof.prefix_totals = vec![0, 101];
    w.input_digest = proof.input.digest();
    w.output_digest = proof.output.digest();
    i.parameters_digest = proof.output.digest();
    proof.intent_digest = i.digest();
    proof.worker_digest = w.digest();
    assert!(arkhe_verify_core::output_proof::verify_budget_proof(
        &proof,
        &p.spec,
        p.binding.policy_digest,
        &i,
        &w
    )
    .is_err());
    assert_eq!(proof.checker, BUDGET_CHECKER);
}

#[test]
fn producer_has_bounded_fail_closed_domain() {
    let spec = BudgetSpec {
        version: 1,
        limit: u64::MAX,
        max_items: 256,
    };
    assert!(budget_pco::infer(
        &BudgetInput {
            costs: vec![u64::MAX, 1]
        },
        &spec
    )
    .is_err());
    assert!(budget_pco::infer(&BudgetInput { costs: vec![] }, &spec).is_err());
    assert!(budget_pco::infer(
        &BudgetInput {
            costs: vec![0; 257]
        },
        &spec
    )
    .is_err());
    assert!(budget_pco::infer(
        &BudgetInput { costs: vec![1] },
        &BudgetSpec {
            version: 2,
            ..spec.clone()
        }
    )
    .is_err());
    assert!(budget_pco::infer(
        &BudgetInput { costs: vec![1] },
        &BudgetSpec {
            max_items: 257,
            ..spec.clone()
        }
    )
    .is_err());
    assert_eq!(
        budget_pco::infer(
            &BudgetInput {
                costs: vec![u64::MAX]
            },
            &spec
        )
        .unwrap()
        .0
        .total,
        u64::MAX
    );
    assert_eq!(
        budget_pco::infer(
            &BudgetInput {
                costs: vec![0; 256]
            },
            &spec
        )
        .unwrap()
        .1
        .len(),
        257
    );
    assert!(budget_pco::infer(
        &BudgetInput { costs: vec![101] },
        &BudgetSpec { limit: 100, ..spec }
    )
    .is_err());
}
