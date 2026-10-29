//! Versioned structural identity, not semantic deduplication or exploit inference.
use arkhe_core::{canonical::encode_value, Digest32};
use serde::{Deserialize, Serialize};
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum BugClass {
    Reentrancy,
    AccessControl,
    Arithmetic,
    OracleManipulation,
}
impl BugClass {
    /// Explicit vocabulary only; unknown labels require adjudication, never guessing.
    pub fn from_label(label: &str) -> Result<Self, String> {
        match label.trim().to_ascii_lowercase().as_str() {
            "reentrancy" | "reentrant call" => Ok(Self::Reentrancy),
            "access control" => Ok(Self::AccessControl),
            "arithmetic" => Ok(Self::Arithmetic),
            "oracle manipulation" => Ok(Self::OracleManipulation),
            _ => Err("unknown bug class; adjudication required".into()),
        }
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct VulnerabilityIdentity {
    pub version: u16,
    pub chain_id: u64,
    pub deployment: [u8; 32],
    pub code_revision: [u8; 32],
    pub function_selector: [u8; 4],
    pub bug_class: BugClass,
    /// Assigned by an approved root-cause adjudication process, not free-form trigger.
    pub adjudicated_root_cause: [u8; 32],
}
impl VulnerabilityIdentity {
    pub fn digest(&self) -> Result<Digest32, String> {
        if self.version != 1
            || self.chain_id == 0
            || self.deployment == [0; 32]
            || self.code_revision == [0; 32]
            || self.adjudicated_root_cause == [0; 32]
        {
            return Err("invalid vulnerability identity".into());
        }
        Ok(Digest32::blake3(
            b"AKG:BOUNTY:VULNERABILITY:v1\0",
            &encode_value(&serde_json::json!({
             "version":self.version,"chain_id":self.chain_id,"deployment":self.deployment,"code_revision":self.code_revision,"function_selector":self.function_selector,"bug_class":self.bug_class,"adjudicated_root_cause":self.adjudicated_root_cause
            })),
        ))
    }
}
