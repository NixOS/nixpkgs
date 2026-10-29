//! Wrap existing governance, retaining every original admission requirement.
use crate::*;
use arkhe_verify_core::policy::Context;
pub struct AuthenticatedResolver<R> {
    inner: R,
    context: Context,
}
impl<R> AuthenticatedResolver<R> {
    pub fn new(inner: R, context: Context) -> Self {
        Self { inner, context }
    }
}
impl<R: PolicyResolver> PolicyResolver for AuthenticatedResolver<R> {
    fn authenticated_context(&self, _: &WorkIntent, _: &PolicyBinding) -> Option<Context> {
        let mut c = self.context.clone();
        c.now = std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)
            .ok()
            .and_then(|d| i64::try_from(d.as_secs()).ok())
            .unwrap_or(-1);
        Some(c)
    }
    fn resolve(&self, i: &WorkIntent, b: &PolicyBinding) -> PolicyVerdict {
        self.inner.resolve(i, b)
    }
    fn required_formal_predicate(
        &self,
        i: &WorkIntent,
        b: &PolicyBinding,
    ) -> Option<arkhe_core::formal_proof::FormalPredicate> {
        self.inner.required_formal_predicate(i, b)
    }
    fn required_budget_proof(
        &self,
        i: &WorkIntent,
        b: &PolicyBinding,
    ) -> Option<arkhe_core::output_proof::BudgetSpec> {
        self.inner.required_budget_proof(i, b)
    }
    fn review_routing_required(&self, i: &WorkIntent, b: &PolicyBinding) -> bool {
        self.inner.review_routing_required(i, b)
    }
    fn human_review_modules(&self, i: &WorkIntent, b: &PolicyBinding) -> Vec<String> {
        self.inner.human_review_modules(i, b)
    }
    fn automatic_review_approved(&self, i: &WorkIntent, b: &PolicyBinding) -> bool {
        self.inner.automatic_review_approved(i, b)
    }
    fn required_classification_policy(
        &self,
        i: &WorkIntent,
        b: &PolicyBinding,
    ) -> Option<Digest32> {
        self.inner.required_classification_policy(i, b)
    }
    fn required_worker_evidence(
        &self,
        i: &WorkIntent,
        b: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        self.inner.required_worker_evidence(i, b)
    }
}
