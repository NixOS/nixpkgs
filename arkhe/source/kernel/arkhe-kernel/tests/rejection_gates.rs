use arkhe_core::{
    work::{WorkIntent, WorkIntentType},
    worker::WorkerExecutionRecord,
    Digest32,
};
use arkhe_governance::{PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
fn intent() -> WorkIntent {
    WorkIntent {
        requested_by: "gate-test".into(),
        intent_type: WorkIntentType::Publish,
        target: Digest32::ZERO,
        parameters_digest: Digest32::ZERO,
        context: vec![],
        context_refs: vec![],
        request_identity: arkhe_core::work::RequestIdentity(Digest32::ZERO),
        claimed_created_at: 0,
    }
}
fn policy() -> PolicyBinding {
    PolicyBinding {
        policy_id: "test".into(),
        version: 1,
        policy_digest: Digest32::ZERO,
    }
}
fn worker(intent: &WorkIntent) -> WorkerExecutionRecord {
    WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "test".into(),
        module_version: "1".into(),
        input_digest: intent.digest(),
        output_digest: Digest32::ZERO,
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: "1".into(),
    }
}
struct NeverResolve;
impl PolicyResolver for NeverResolve {
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        panic!("rejected gate must not consult policy")
    }
}
struct Deny;
struct Allow;
impl PolicyResolver for Allow {
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        PolicyVerdict::Allow
    }
}
#[test]
fn unprotected_intents_still_follow_governance_without_worker_evidence() {
    let gate = ContainmentGate::new(Allow);
    for kind in [
        WorkIntentType::DraftDocument,
        WorkIntentType::QueryKnowledgeBase,
        WorkIntentType::Simulate,
    ] {
        let mut intent = intent();
        intent.intent_type = kind;
        assert!(matches!(
            gate.authorize(&intent, None, &policy()),
            AuthorizationDecision::Allow { .. }
        ));
    }
}
impl PolicyResolver for Deny {
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        PolicyVerdict::Deny("policy-denied-test".into())
    }
}
#[test]
fn every_protected_intent_requires_admitted_evidence_before_policy() {
    use WorkIntentType::*;
    let gate = ContainmentGate::new(NeverResolve);
    for kind in [
        Publish,
        ApproveExpense,
        Hire,
        Fire,
        SignContract,
        ReleaseSoftware,
        TriageReport,
        AgentRegistration,
        CommunityJoin,
        CommunityPost,
        Implement,
    ] {
        let mut intent = intent();
        intent.intent_type = kind;
        assert!(matches!(
            gate.authorize(&intent, Some(&worker(&intent)), &policy()),
            AuthorizationDecision::Reject { reason }
                if reason == "integration requires admitted evidence lookup"
        ));
    }
}
#[test]
fn no_evidence_missing_wer_rejects_before_policy() {
    let gate = ContainmentGate::new(NeverResolve);
    assert!(
        matches!(gate.authorize(&intent(),None,&policy()),AuthorizationDecision::Reject {reason} if reason.contains("missing WorkerExecutionRecord"))
    );
}
#[test]
fn emergency_stop_rejects_before_policy() {
    let mut gate = ContainmentGate::new(NeverResolve);
    gate.set_emergency_stop(true);
    let intent = intent();
    assert!(
        matches!(gate.authorize(&intent,Some(&worker(&intent)),&policy()),AuthorizationDecision::Reject {reason} if reason=="emergency stop")
    );
}
#[test]
fn policy_denied_rejects_even_with_worker_evidence() {
    let gate = ContainmentGate::new(Deny);
    let mut intent = intent();
    intent.intent_type = WorkIntentType::DraftDocument;
    assert!(
        matches!(gate.authorize(&intent,Some(&worker(&intent)),&policy()),AuthorizationDecision::Reject {reason} if reason=="policy-denied-test")
    );
}
