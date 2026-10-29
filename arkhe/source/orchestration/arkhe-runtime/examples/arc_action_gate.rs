//! ARC local simulation bridge. Development policy, unsigned WER, ephemeral store.
use arkhe_core::{evidence::{EvidenceCommitter, EvidenceEnvelope, EvidenceReader},
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord}, CanonicalEncode, Digest32};
use arkhe_governance::{DevPolicyResolver, PolicyBinding};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use arkhe_wormgraph::WormGraph;
use serde::Deserialize;
use serde_json::{json, Value};
use std::io::{self, Read};

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Input {
    run_id: String, phase: String, observation: Value, action: Value,
    #[serde(default)] outcome: Option<Value>,
    #[serde(default)] emergency_stop: bool,
}

async fn evaluate(i: Input) -> Result<Value, String> {
    if i.run_id.is_empty() || !matches!(i.phase.as_str(), "preflight" | "record")
        || (i.phase == "record") != i.outcome.is_some() {
        return Err("invalid phase/outcome".into());
    }
    let action = i.action["id"].as_u64().ok_or("missing action id")?;
    if action > 7 { return Err("invalid action".into()); }
    if action == 6 && ["x", "y"].iter().any(|k| i.action[*k].as_u64().is_none_or(|v| v > 63)) {
        return Err("invalid click coordinates".into());
    }
    let parameters = arkhe_core::canonical::encode_value(&json!({
        "observation":i.observation, "action":i.action}));
    let intent = WorkIntent {
        requested_by:"arc-observation-agent".into(), intent_type:WorkIntentType::Simulate,
        target:Digest32::blake3(b"AKG:ARC:OBS:v1\0", &arkhe_core::canonical::encode_value(&i.observation)),
        parameters_digest:Digest32::blake3(b"AKG:ARC:ACTION:v1\0", &parameters),
        context:vec![], context_refs:vec![], request_identity:RequestIdentity::new(i.run_id.as_bytes()),
        claimed_created_at:0,
    };
    let worker = WorkerExecutionRecord {
        classification:None, operation:Some(CognitiveOperation::Analyze),
        module_id:"arc-observation-explorer".into(), module_version:env!("CARGO_PKG_VERSION").into(),
        input_digest:intent.digest(),
        output_digest:Digest32::blake3(b"AKG:ARC:OUTCOME:v1\0", &arkhe_core::canonical::encode_value(i.outcome.as_ref().unwrap_or(&Value::Null))),
        evidence_refs:vec![], confidence_bps:None,
        uncertainty_note:Some("unsigned host-reported ARC observation; no execution attestation".into()),
        execution_id:i.run_id,
    };
    let policy = PolicyBinding {policy_id:"arc-local-dev-unprotected-v1".into(),version:1,
        policy_digest:Digest32::blake3(b"AKG:ARC:POLICY:v1\0", b"DevPolicyResolver")};
    let mut gate = ContainmentGate::new(DevPolicyResolver);
    gate.set_emergency_stop(i.emergency_stop);
    let authorization_ref = match gate.authorize(&intent, (i.phase=="record").then_some(&worker), &policy) {
        AuthorizationDecision::Reject{reason} => return Ok(json!({"gate":"REJECT","reason":reason})),
        AuthorizationDecision::Allow{authorization_ref} => authorization_ref,
    };
    let mut result = json!({"gate":"ALLOW","phase":i.phase,"intent_digest":intent.digest().to_hex(),
        "authorization_ref":authorization_ref.to_hex(),"policy":"DEV_UNPROTECTED",
        "signature":"UNSIGNED","durable_admission":false});
    if i.phase=="record" {
        let store = WormGraph::new();
        let envelope = EvidenceEnvelope {record_hash:authorization_ref,kind:"arc-local-outcome".into(),
            subject:intent.digest(),payload_digest:worker.digest(),policy_digest:Some(policy.policy_digest),causal_parents:vec![]};
        store.append_verified(envelope.clone()).await?;
        if store.get(authorization_ref).await? != Some(envelope) { return Err("readback mismatch".into()); }
        result["worker_record"] = serde_json::to_value(&worker).map_err(|e|e.to_string())?;
        result["worker_digest"] = json!(worker.digest().to_hex());
        result["worker_cbor_hex"] = json!(hex::encode(worker.canonical_bytes()));
        result["wormgraph"] = json!("IN_MEMORY_READBACK_ONLY");
    }
    Ok(result)
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut bytes=vec![]; io::stdin().take(262145).read_to_end(&mut bytes)?;
    if bytes.len()>262144 {return Err("input too large".into());}
    let output=evaluate(serde_json::from_slice(&bytes)?).await.map_err(io::Error::other)?;
    println!("{}",serde_json::to_string(&output)?); Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    fn input(phase:&str)->Input {Input{run_id:"r1".into(),phase:phase.into(),observation:json!({"frame":[[0]]}),
        action:json!({"id":1}),outcome:None,emergency_stop:false}}
    #[tokio::test]
    async fn binds_and_records() {
        let pre=evaluate(input("preflight")).await.unwrap();
        let mut i=input("record"); i.outcome=Some(json!({"frame":[[1]]}));
        let post=evaluate(i).await.unwrap();
        assert_eq!(pre["intent_digest"],post["intent_digest"]);
        assert_eq!(post["wormgraph"],"IN_MEMORY_READBACK_ONLY");
        let mut other=input("preflight");other.action=json!({"id":2});
        assert_ne!(pre["intent_digest"],evaluate(other).await.unwrap()["intent_digest"]);
    }
    #[tokio::test]
    async fn rejects_stop_bad_click_and_missing_outcome() {
        let mut i=input("preflight"); i.emergency_stop=true;
        assert_eq!(evaluate(i).await.unwrap()["gate"],"REJECT");
        let mut i=input("preflight");i.action=json!({"id":6,"x":64,"y":0});
        assert!(evaluate(i).await.is_err()); assert!(evaluate(input("record")).await.is_err());
    }
}
