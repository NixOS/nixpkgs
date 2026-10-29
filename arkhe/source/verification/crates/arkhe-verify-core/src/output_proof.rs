//! Independent finite arithmetic proof checker. Never invokes the producer.
use arkhe_core::{
    output_proof::{BudgetProof, BudgetSpec, BUDGET_CHECKER, MAX_BUDGET_ITEMS},
    work::WorkIntent,
    worker::WorkerExecutionRecord,
    Digest32,
};

/// Trusted spec and policy come from governance, never from the certificate.
pub fn verify_budget_proof(
    proof: &BudgetProof,
    spec: &BudgetSpec,
    policy_digest: Digest32,
    intent: &WorkIntent,
    worker: &WorkerExecutionRecord,
) -> Result<Digest32, &'static str> {
    let n = proof.input.costs.len();
    if spec.version != 1
        || spec.max_items == 0
        || usize::from(spec.max_items) > MAX_BUDGET_ITEMS
        || n == 0
        || n > usize::from(spec.max_items)
        || proof.prefix_totals.len() != n + 1
        || proof.checker != BUDGET_CHECKER
        || policy_digest == Digest32::ZERO
        || proof.spec_digest != spec.digest()
        || proof.policy_digest != policy_digest
        || proof.intent_digest != intent.digest()
        || proof.worker_digest != worker.digest()
        || proof.input.digest() != worker.input_digest
        || proof.output.digest() != worker.output_digest
        || proof.output.digest() != intent.parameters_digest
    {
        return Err("budget proof profile, size or binding mismatch");
    }
    if proof.prefix_totals[0] != 0 {
        return Err("budget proof invalid base case");
    }
    // Use wider arithmetic, independently of the producer's checked u64 sum.
    for (cost, step) in proof.input.costs.iter().zip(proof.prefix_totals.windows(2)) {
        if u128::from(step[0]) + u128::from(*cost) != u128::from(step[1]) {
            return Err("budget proof invalid arithmetic step");
        }
    }
    if proof.prefix_totals[n] != proof.output.total || proof.output.total > spec.limit {
        return Err("budget proof conclusion rejected");
    }
    Ok(proof.digest())
}
