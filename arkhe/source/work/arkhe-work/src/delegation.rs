use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub enum DelegationScope {
    ExactTransition(String),
    TransitionSet(Vec<String>),
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Delegation {
    pub delegator: String,
    pub delegatee: String,
    pub scope: DelegationScope,
    pub not_before: i64,
    pub not_after: i64,
    pub signature: Vec<u8>,
}
