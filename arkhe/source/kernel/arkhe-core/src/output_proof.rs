//! Bounded arithmetic certificate data. No authority, proof checking or effects.
use crate::{canonical::encode_value, Digest32};
use serde::{Deserialize, Serialize};

pub const BUDGET_CHECKER: &str = "arkhe/budget-sum-checker/v1";
pub const MAX_BUDGET_ITEMS: usize = 256;

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BudgetSpec {
    pub version: u16,
    pub limit: u64,
    pub max_items: u16,
}
impl BudgetSpec {
    pub fn digest(&self) -> Digest32 {
        digest(b"AKG:PCO:BUDGET-SPEC:v1\0", &(BUDGET_CHECKER, self))
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BudgetInput {
    /// Integer minor units. The host authenticates their provenance separately.
    pub costs: Vec<u64>,
}
impl BudgetInput {
    pub fn digest(&self) -> Digest32 {
        digest(b"AKG:PCO:BUDGET-INPUT:v1\0", self)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BudgetOutput {
    pub total: u64,
}
impl BudgetOutput {
    pub fn digest(&self) -> Digest32 {
        digest(b"AKG:PCO:BUDGET-OUTPUT:v1\0", self)
    }
}

/// A finite arithmetic derivation: s[0]=0, s[i+1]=s[i]+cost[i], total=s[n]<=limit.
/// Bindings prevent transplanting a valid derivation to a different authorization.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct BudgetProof {
    pub checker: String,
    pub spec_digest: Digest32,
    pub policy_digest: Digest32,
    pub intent_digest: Digest32,
    pub worker_digest: Digest32,
    pub input: BudgetInput,
    pub output: BudgetOutput,
    pub prefix_totals: Vec<u64>,
}
impl BudgetProof {
    pub fn digest(&self) -> Digest32 {
        digest(b"AKG:PCO:BUDGET-PROOF:v1\0", self)
    }
}

fn digest(domain: &[u8], value: &impl Serialize) -> Digest32 {
    Digest32::blake3(
        domain,
        &encode_value(&serde_json::to_value(value).expect("typed integer proof data")),
    )
}
