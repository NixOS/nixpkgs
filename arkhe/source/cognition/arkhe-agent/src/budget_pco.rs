//! First bounded proof-producing inference. Not an LLM or a Rocq/ZK prover.
use arkhe_cognition_sdk::{
    output_proof::{
        BudgetInput, BudgetOutput, BudgetProof, BudgetSpec, BUDGET_CHECKER, MAX_BUDGET_ITEMS,
    },
    work::WorkIntent,
    worker::WorkerExecutionRecord,
    Digest32,
};

/// Generates the result and its derivation together. No partial output on failure.
pub fn infer(
    input: &BudgetInput,
    spec: &BudgetSpec,
) -> Result<(BudgetOutput, Vec<u64>), &'static str> {
    if spec.version != 1
        || spec.max_items == 0
        || usize::from(spec.max_items) > MAX_BUDGET_ITEMS
        || input.costs.is_empty()
        || input.costs.len() > usize::from(spec.max_items)
    {
        return Err("unsupported budget specification or input size");
    }
    let mut total = 0u64;
    let mut derivation = vec![0];
    for cost in &input.costs {
        total = total.checked_add(*cost).ok_or("budget sum overflow")?;
        if total > spec.limit {
            return Err("budget exceeded");
        }
        derivation.push(total);
    }
    Ok((BudgetOutput { total }, derivation))
}

/// Bind the generated pair to a proposal after its WER and intent are assembled.
/// Producer checks are convenience only; the independent checker is authoritative.
pub fn prove(
    input: BudgetInput,
    spec: &BudgetSpec,
    policy_digest: Digest32,
    intent: &WorkIntent,
    worker: &WorkerExecutionRecord,
) -> Result<BudgetProof, &'static str> {
    let (output, prefix_totals) = infer(&input, spec)?;
    if input.digest() != worker.input_digest
        || output.digest() != worker.output_digest
        || output.digest() != intent.parameters_digest
        || policy_digest == Digest32::ZERO
    {
        return Err("budget proposal binding mismatch");
    }
    Ok(BudgetProof {
        checker: BUDGET_CHECKER.into(),
        spec_digest: spec.digest(),
        policy_digest,
        intent_digest: intent.digest(),
        worker_digest: worker.digest(),
        input,
        output,
        prefix_totals,
    })
}
