use arkhe_core::{
    work::{WorkIntent, WorkIntentType},
    CanonicalEncode, Digest32,
};
use arkhe_governance::{PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
fn intent() -> WorkIntent {
    WorkIntent {
        requested_by: "test".into(),
        intent_type: WorkIntentType::Publish,
        target: Digest32::ZERO,
        parameters_digest: Digest32::ZERO,
        context: vec![],
        context_refs: vec![],
        request_identity: arkhe_core::work::RequestIdentity(Digest32::ZERO),
        claimed_created_at: 0,
    }
}
struct Resolver(PolicyVerdict);
impl PolicyResolver for Resolver {
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        self.0.clone()
    }
}
#[test]
fn real_modules_and_containment_rejections() {
    let intent = intent();
    let policy = PolicyBinding {
        policy_id: "test".into(),
        version: 1,
        policy_digest: Digest32::ZERO,
    };
    let (obs, perception) = arkhe_perception::observe(b"observation", Some(intent.digest()));
    let (response, rag) = arkhe_rag::build_response(
        b"query",
        b"answer",
        vec![arkhe_rag::Citation {
            source_ref: perception.digest(),
            chunk_digest: obs.representation_digest,
        }],
    );
    let (_, meta) =
        arkhe_metacognition::assess(rag.input_digest, response.answer_digest, vec![rag.digest()]);
    let (forecast, world) = arkhe_world_model::simulate(b"scenario");
    let learning = arkhe_learning::propose(arkhe_learning::Proposal {
        baseline_ref: world.digest(),
        candidate_ref: forecast.forecast_digest,
        evaluation_ref: meta.digest(),
        rollback_ref: perception.digest(),
    });
    let (_, agent) = arkhe_agent::plan(
        &intent,
        vec![arkhe_agent::PlanStep {
            step_id: "1".into(),
            action: "publish".into(),
            protected: true,
        }],
    );
    assert_eq!(agent.input_digest, intent.digest());
    assert_eq!(meta.output_digest, rag.output_digest);
    assert_eq!(rag.evidence_refs, vec![perception.digest()]);
    assert_eq!(
        learning.evidence_refs,
        vec![meta.digest(), perception.digest()]
    );
    for record in [perception, rag, meta, world, learning, agent] {
        assert_eq!(record.digest(), record.object_digest());
        assert_ne!(record.digest(), Digest32::ZERO);
        let allow = ContainmentGate::new(Resolver(PolicyVerdict::Allow));
        assert!(matches!(
            allow.authorize(&intent, None, &policy),
            AuthorizationDecision::Reject { .. }
        ));
        assert!(matches!(
            allow.authorize(&intent, Some(&record), &policy),
            AuthorizationDecision::Reject { reason }
                if reason == "integration requires admitted evidence lookup"
        ));
        for verdict in [
            PolicyVerdict::Deny("denied".into()),
            PolicyVerdict::Inconclusive("unknown".into()),
        ] {
            let gate = ContainmentGate::new(Resolver(verdict));
            assert!(matches!(
                gate.authorize(&intent, Some(&record), &policy),
                AuthorizationDecision::Reject { .. }
            ));
        }
        let mut stopped = ContainmentGate::new(Resolver(PolicyVerdict::Allow));
        stopped.set_emergency_stop(true);
        assert!(matches!(
            stopped.authorize(&intent, Some(&record), &policy),
            AuthorizationDecision::Reject { .. }
        ));
    }
}
