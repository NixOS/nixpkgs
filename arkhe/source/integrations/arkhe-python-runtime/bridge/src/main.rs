//! Local development adapter. Production profiles must supply trusted governance.
use arkhe_core::{
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    Digest32,
};
use arkhe_governance::{DevPolicyResolver, PolicyBinding};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use serde::Deserialize;
use std::io::{self, Read};

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Request {
    tool: String,
    intent_type: WorkIntentType,
    arguments_json: String,
    request_id: String,
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut input = String::new();
    io::stdin().take(65_537).read_to_string(&mut input)?;
    if input.len() > 65_536 {
        return Err("request too large".into());
    }
    let request: Request = serde_json::from_str(&input)?;
    // Validate JSON, but hash the exact bytes supplied by the Python guard.
    let _: serde_json::Value = serde_json::from_str(&request.arguments_json)?;
    let intent = WorkIntent {
        requested_by: "python-local-dev".into(),
        intent_type: request.intent_type,
        target: Digest32::blake3(b"AKG:PYTHON:TOOL:v1\0", request.tool.as_bytes()),
        parameters_digest: Digest32::blake3(
            b"AKG:PYTHON:ARGS:v1\0",
            request.arguments_json.as_bytes(),
        ),
        context: vec![],
        context_refs: vec![],
        request_identity: RequestIdentity::new(request.request_id.as_bytes()),
        claimed_created_at: 0,
    };
    let policy = PolicyBinding {
        policy_id: "python-local-dev".into(),
        version: 1,
        policy_digest: Digest32::blake3(b"AKG:PYTHON:POLICY:v1\0", b"DevPolicyResolver"),
    };
    let decision = ContainmentGate::new(DevPolicyResolver).authorize(&intent, None, &policy);
    let response = match decision {
        AuthorizationDecision::Allow { authorization_ref } => serde_json::json!({
            "decision": "Allow", "authorization_ref": authorization_ref.to_hex(),
            "operation_id": intent.operation_id().to_hex(),
        }),
        AuthorizationDecision::Reject { reason } => {
            serde_json::json!({"decision": "Reject", "reason": reason})
        }
    };
    println!("{response}");
    Ok(())
}
