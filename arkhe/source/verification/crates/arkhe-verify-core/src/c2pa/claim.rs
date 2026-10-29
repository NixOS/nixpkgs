use crate::{cbor::canonical::encode_json, error::VerifyError};
use serde_json::Value;

const REQUIRED: &[&str] = &[
    "instanceID",
    "claim_generator_info",
    "signature",
    "created_assertions",
];

pub fn canonicalize_claim_v2(claim: &Value) -> Result<Vec<u8>, VerifyError> {
    let obj = claim
        .as_object()
        .ok_or_else(|| VerifyError::InvalidInput("C2PA claim must be a map".into()))?;

    for field in REQUIRED {
        if !obj.contains_key(*field) {
            return Err(VerifyError::InvalidInput(format!(
                "missing C2PA field {field}"
            )));
        }
    }

    if obj.get("alg").and_then(Value::as_str) == Some("Ed25519") {
        return Err(VerifyError::InvalidInput(
            "C2PA claim alg is a hash algorithm, not Ed25519".into(),
        ));
    }

    encode_json(claim)
}
