//! Local adapter: binds an exact Intra content envelope to native AKG identities.
use arkhe_core::{
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::WorkerExecutionRecord,
    CanonicalEncode, Digest32,
};
use serde::Deserialize;
use serde_json::json;
use std::io::{self, Read};

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Input {
    actor: String,
    content: String,
    created_at: i64,
}
fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut bytes = Vec::new();
    io::stdin().take(262145).read_to_end(&mut bytes)?;
    if bytes.len() > 262144 {
        return Err("input too large".into());
    }
    let input: Input = serde_json::from_slice(&bytes)?;
    if input.actor.trim().is_empty() || input.actor.len() > 256 || input.created_at < 0 {
        return Err("invalid actor or timestamp".into());
    }
    let content: serde_json::Value = serde_json::from_str(&input.content)?;
    if content["domain"] != "arkhe-intra/document/v1"
        || content["revision"].as_u64().is_none_or(|v| v == 0)
        || ["id", "title", "department", "body", "authorId"]
            .iter()
            .any(|key| content[key].as_str().is_none_or(|v| v.is_empty()))
    {
        return Err("invalid Intra content envelope".into());
    }
    // Preserve the application's raw BLAKE3 identity. Do not relabel it as AKG CBOR.
    let target = Digest32::blake3(b"", input.content.as_bytes());
    let binding = serde_json::to_vec(&json!({
        "domain": "arkhe-intra/native-draft/v1", "actor": input.actor,
        "document_id": content["id"], "revision": content["revision"],
        "content_digest": target.to_hex()
    }))?;
    let intent = WorkIntent {
        requested_by: input.actor,
        intent_type: WorkIntentType::DraftDocument,
        target,
        parameters_digest: Digest32::blake3(b"ARKHE:INTRA:DRAFT:v1\0", &binding),
        context: vec![],
        context_refs: vec![],
        request_identity: RequestIdentity::new(&binding),
        claimed_created_at: input.created_at,
    };
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "arkhe-intra/document-snapshot".into(),
        module_version: "1".into(),
        input_digest: intent.digest(),
        output_digest: target,
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: Some(
            "Local document snapshot; no publication authorization or external effect.".into(),
        ),
        execution_id: intent.request_identity.0.to_hex(),
    };
    println!(
        "{}",
        json!({
            "proposal": {"intent": intent, "worker_record": worker},
            "intent_digest": intent.digest().to_hex(), "worker_digest": worker.digest().to_hex(),
            "intent_cbor": hex(&intent.canonical_bytes()), "worker_cbor": hex(&worker.canonical_bytes())
        })
    );
    Ok(())
}
