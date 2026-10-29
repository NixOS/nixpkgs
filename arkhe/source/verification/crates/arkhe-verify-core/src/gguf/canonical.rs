use crate::{cbor::canonical::encode_json, error::VerifyError};
use serde_json::Value;

pub fn canonicalize_metadata(metadata: &Value) -> Result<Vec<u8>, VerifyError> {
    match metadata {
        Value::Object(_) => encode_json(metadata),
        _ => Err(VerifyError::InvalidInput(
            "GGUF metadata must be a map".into(),
        )),
    }
}
