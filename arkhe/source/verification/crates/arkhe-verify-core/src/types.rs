use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub struct VerificationResult {
    pub valid: bool,
    pub profile: String,
    pub digest_hex: Option<String>,
    pub findings: Vec<String>,
}
