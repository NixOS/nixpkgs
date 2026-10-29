use crate::Digest32;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerExecutionRecord {
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub classification: Option<ClassificationBinding>,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub operation: Option<CognitiveOperation>,
    pub module_id: String,
    pub module_version: String,
    pub input_digest: Digest32,
    pub output_digest: Digest32,
    pub evidence_refs: Vec<Digest32>,
    #[serde(default, deserialize_with = "deserialize_confidence_bps")]
    pub confidence_bps: Option<u16>,
    pub uncertainty_note: Option<String>,
    pub execution_id: String,
}

fn deserialize_confidence_bps<'de, D: serde::Deserializer<'de>>(
    deserializer: D,
) -> Result<Option<u16>, D::Error> {
    let value = Option::<u16>::deserialize(deserializer)?;
    if value.is_some_and(|bps| bps > 10000) {
        return Err(serde::de::Error::custom("confidence_bps exceeds 10000"));
    }
    Ok(value)
}

/// Signed, typed bindings. Hashes identify content; admission establishes provenance.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ClassificationBinding {
    pub classification_digest: Digest32,
    pub policy_digest: Digest32,
}

impl WorkerExecutionRecord {
    pub fn digest(&self) -> Digest32 {
        crate::CanonicalEncode::object_digest(self)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum CognitiveOperation {
    Decide,
    Analyze,
    Execute,
}
