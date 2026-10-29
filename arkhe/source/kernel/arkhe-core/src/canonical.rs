//! AKG-CBOR-v1: RFC 8949 core deterministic encoding, definite lengths,
//! shortest integers, UTF-8 unchanged, byte digests, encoded-key ordered maps.
//! Unsigned projections contain all current fields (neither type has signatures).
use crate::{work::WorkIntent, worker::WorkerExecutionRecord, Digest32};
use serde_json::Value;

pub trait CanonicalEncode {
    const DOMAIN_OBJECT: &'static [u8];
    fn unsigned_projection(&self) -> Value;
    fn canonical_bytes(&self) -> Vec<u8> {
        encode(&self.unsigned_projection(), None)
    }
    fn object_digest(&self) -> Digest32 {
        Digest32::blake3(Self::DOMAIN_OBJECT, &self.canonical_bytes())
    }
}
fn head(major: u8, n: u64, out: &mut Vec<u8>) {
    let base = major << 5;
    match n {
        0..=23 => out.push(base | n as u8),
        24..=255 => out.extend([base | 24, n as u8]),
        256..=65535 => {
            out.push(base | 25);
            out.extend((n as u16).to_be_bytes());
        }
        65536..=4294967295 => {
            out.push(base | 26);
            out.extend((n as u32).to_be_bytes());
        }
        _ => {
            out.push(base | 27);
            out.extend(n.to_be_bytes());
        }
    }
}
pub fn encode_value(value: &Value) -> Vec<u8> {
    encode(value, None)
}

/// Encode a top-level map with explicitly typed byte strings, without treating
/// ordinary JSON arrays as bytes. Existing `encode_value` encodings are unchanged.
/// Byte keys must be unique and must not occur in `fields`.
pub fn encode_map_with_bytes(
    fields: &serde_json::Map<String, Value>,
    bytes: &[(&str, &[u8])],
) -> Result<Vec<u8>, &'static str> {
    let mut pairs: Vec<_> = fields
        .iter()
        .map(|(k, v)| (encode(&Value::String(k.clone()), None), encode(v, Some(k))))
        .collect();
    for (key, value) in bytes {
        let key = encode(&Value::String((*key).into()), None);
        if pairs.iter().any(|(existing, _)| *existing == key) {
            return Err("duplicate canonical map key");
        }
        let mut encoded = Vec::new();
        head(2, value.len() as u64, &mut encoded);
        encoded.extend_from_slice(value);
        pairs.push((key, encoded));
    }
    pairs.sort_by(|a, b| a.0.cmp(&b.0));
    let mut out = Vec::new();
    head(5, pairs.len() as u64, &mut out);
    for (key, value) in pairs {
        out.extend(key);
        out.extend(value);
    }
    Ok(out)
}

fn encode(v: &Value, field: Option<&str>) -> Vec<u8> {
    let mut out = Vec::new();
    match v {
        Value::Null => out.push(0xf6),
        Value::Bool(false) => out.push(0xf4),
        Value::Bool(true) => out.push(0xf5),
        Value::String(s) => {
            head(3, s.len() as u64, &mut out);
            out.extend(s.as_bytes());
        }
        Value::Number(n) => {
            if let Some(n) = n.as_u64() {
                head(0, n, &mut out);
            } else {
                head(
                    1,
                    (-1 - n.as_i64().expect("integer projection")) as u64,
                    &mut out,
                );
            }
        }
        Value::Array(a)
            if matches!(
                field,
                Some(
                    "hash"
                        | "target"
                        | "parameters_digest"
                        | "request_identity"
                        | "input_digest"
                        | "output_digest"
                        | "digest_element"
                        | "classification_digest"
                        | "policy_digest"
                        // AKG-IDENTITY-0001: digests and verifier key/signature
                        // material as byte strings; no existing field changes.
                        | "armored_key_digest"
                        | "bidirectional_digest"
                        | "value_digest"
                        | "proof_digest"
                        | "verifier_public_key"
                        | "verifier_signature"
                )
            ) =>
        {
            head(2, a.len() as u64, &mut out);
            out.extend(a.iter().map(|v| v.as_u64().expect("digest byte") as u8));
        }
        Value::Array(a) => {
            head(4, a.len() as u64, &mut out);
            let child = if matches!(field, Some("context_refs" | "evidence_refs")) {
                Some("digest_element")
            } else {
                None
            };
            for v in a {
                out.extend(encode(v, child));
            }
        }
        Value::Object(m) => {
            let mut pairs: Vec<_> = m
                .iter()
                .map(|(k, v)| (encode(&Value::String(k.clone()), None), encode(v, Some(k))))
                .collect();
            pairs.sort_by(|a, b| a.0.cmp(&b.0));
            head(5, pairs.len() as u64, &mut out);
            for (k, v) in pairs {
                out.extend(k);
                out.extend(v);
            }
        }
    }
    out
}
impl CanonicalEncode for WorkIntent {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:WORKINTENT:v1\0";
    fn unsigned_projection(&self) -> Value {
        let mut projection = serde_json::json!({"requested_by": self.requested_by, "intent_type": self.intent_type, "target": self.target, "parameters_digest": self.parameters_digest, "context_refs": self.context_refs, "request_identity": self.request_identity, "claimed_created_at": self.claimed_created_at});
        if !self.context.is_empty() {
            projection["context"] = serde_json::to_value(&self.context).expect("typed context");
        }
        projection
    }
}
impl CanonicalEncode for WorkerExecutionRecord {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:WER:v1\0";
    fn unsigned_projection(&self) -> Value {
        let mut projection = serde_json::json!({"module_id": self.module_id, "module_version": self.module_version, "input_digest": self.input_digest, "output_digest": self.output_digest, "evidence_refs": self.evidence_refs, "confidence_bps": self.confidence_bps, "uncertainty_note": self.uncertainty_note, "execution_id": self.execution_id});
        if let Some(operation) = self.operation {
            projection["operation"] = serde_json::to_value(operation).expect("operation");
        }
        if let Some(binding) = self.classification {
            projection["classification"] =
                serde_json::to_value(binding).expect("classification binding");
        }
        projection
    }
}
