//! Offline primitive runner. Never imports or executes Gravit implementation code.
use arkhe_verify_core::gguf::supply_chain::verify_inclusion;
use ed25519_dalek::{Signature, VerifyingKey};
use serde_json::{json, Value};
use std::{collections::BTreeSet, env, fs};

fn bytes(v: &Value, k: &str) -> Option<Vec<u8>> {
    hex::decode(v[k].as_str()?).ok()
}
fn signature(v: &Value) -> Option<bool> {
    let key: [u8; 32] = bytes(v, "key_hex")?.try_into().ok()?;
    let key = VerifyingKey::from_bytes(&key).ok()?;
    let sig = Signature::from_slice(&bytes(v, "signature_hex")?).ok()?;
    Some(key.verify_strict(&bytes(v, "message_hex")?, &sig).is_ok())
}
fn check(v: &Value) -> Option<bool> {
    match v["kind"].as_str()? {
        "signature" => signature(v),
        "inclusion" => {
            let root: [u8; 32] = bytes(v, "root_hex")?.try_into().ok()?;
            let path: Option<Vec<[u8; 32]>> = v["path"]
                .as_array()?
                .iter()
                .map(|h| hex::decode(h.as_str()?).ok()?.try_into().ok())
                .collect();
            Some(
                verify_inclusion(
                    &bytes(v, "leaf_hex")?,
                    v["index"].as_u64()?,
                    v["size"].as_u64()?,
                    &path?,
                    root,
                )
                .is_ok(),
            )
        }
        // Proposed interop profile; this is not an existing Arkhe production quorum API.
        "quorum" => {
            let threshold = v["threshold"].as_u64()?;
            if threshold == 0 {
                return Some(false);
            }
            let mut keys = BTreeSet::new();
            let mut operators = BTreeSet::new();
            for w in v["witnesses"].as_array()? {
                let id = w["id"].as_str()?;
                let Some(t) = v["trusted"].as_array()?.iter().find(|t| t["id"] == id) else {
                    return Some(false);
                };
                let key = t["key_hex"].as_str()?;
                let operator = t["operator"].as_str()?;
                if operator.is_empty()
                    || !keys.insert(key.to_owned())
                    || !operators.insert(operator.to_owned())
                {
                    return Some(false);
                }
                if !signature(&json!({"key_hex":key,"message_hex":v["message_hex"],"signature_hex":w["signature_hex"]})).unwrap_or(false) {
                    return Some(false);
                }
            }
            Some(operators.len() as u64 >= threshold)
        }
        _ => None,
    }
}
fn main() {
    let input = fs::read(env::args().nth(1).expect("jobs.json")).expect("read jobs");
    let jobs: Vec<Value> = serde_json::from_slice(&input).expect("parse jobs");
    let results: Vec<Value> = jobs
        .iter()
        .map(|v| json!({"id":v["id"],"accepted":check(v).unwrap_or(false)}))
        .collect();
    println!("{}", serde_json::to_string_pretty(&results).unwrap());
}
