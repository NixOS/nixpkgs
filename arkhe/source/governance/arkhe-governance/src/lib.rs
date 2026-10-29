use arkhe_core::{work::WorkIntent, Digest32};
pub mod authenticated;
pub mod policy_bundle;

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct PolicyBinding {
    pub policy_id: String,
    pub version: u64,
    pub policy_digest: Digest32,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PolicyVerdict {
    Allow,
    Deny(String),
    Inconclusive(String),
}

#[derive(Debug, Clone)]
pub struct EvidenceKindRequirement {
    pub allowed_modules: Vec<String>,
    pub allowed_operations: Vec<arkhe_core::worker::CognitiveOperation>,
}

pub trait PolicyResolver: Send + Sync {
    /// Host-owned migration profile. Required proofs fail closed when unavailable.
    fn authenticated_context(
        &self,
        _intent: &WorkIntent,
        _binding: &PolicyBinding,
    ) -> Option<arkhe_verify_core::policy::Context> {
        None
    }
    fn required_formal_predicate(
        &self,
        _intent: &WorkIntent,
        _binding: &PolicyBinding,
    ) -> Option<arkhe_core::formal_proof::FormalPredicate> {
        None
    }
    /// Trusted, opt-in decidable output predicate. Legacy policies are unchanged.
    fn required_budget_proof(
        &self,
        _intent: &WorkIntent,
        _binding: &PolicyBinding,
    ) -> Option<arkhe_core::output_proof::BudgetSpec> {
        None
    }
    fn review_routing_required(&self, _intent: &WorkIntent, _binding: &PolicyBinding) -> bool {
        false
    }
    fn human_review_modules(&self, _intent: &WorkIntent, _binding: &PolicyBinding) -> Vec<String> {
        vec![]
    }
    fn automatic_review_approved(&self, _intent: &WorkIntent, _binding: &PolicyBinding) -> bool {
        false
    }
    /// A trusted profile can require typed classification evidence for triage.
    fn required_classification_policy(
        &self,
        _intent: &WorkIntent,
        _binding: &PolicyBinding,
    ) -> Option<Digest32> {
        None
    }
    /// No default authority for external triage. Governance must opt in.
    fn required_worker_evidence(
        &self,
        _intent: &WorkIntent,
        _binding: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        None
    }

    fn resolve(&self, intent: &WorkIntent, binding: &PolicyBinding) -> PolicyVerdict;
}

/// Development policy: only explicitly unprotected intents may pass.
/// Protected-transition policy must be supplied by a real governance profile.
pub struct DevPolicyResolver;

impl PolicyResolver for DevPolicyResolver {
    fn resolve(&self, intent: &WorkIntent, _binding: &PolicyBinding) -> PolicyVerdict {
        use arkhe_core::work::WorkIntentType::*;
        match intent.intent_type {
            DraftDocument | QueryKnowledgeBase | Simulate => PolicyVerdict::Allow,
            _ => PolicyVerdict::Deny("no protected-transition rule in dev profile".into()),
        }
    }
}

pub mod constitution_graph;
pub mod er_backend;
pub mod fellegi_sunter;
pub mod invariant_resolver;
pub mod ontology_snapshot;
pub mod resolution_binding;
