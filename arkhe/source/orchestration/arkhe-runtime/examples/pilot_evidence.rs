//! Local unprotected pilot bridge. Unsigned WER, in-memory evidence, no checkpoint.
#[path = "support/retrieval_citations.rs"]
mod retrieval_citations;
use arkhe_core::{
    evidence::{EvidenceCommitter, EvidenceEnvelope, EvidenceReader},
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    CanonicalEncode, Digest32,
};
use arkhe_governance::{DevPolicyResolver, PolicyBinding};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use arkhe_rag::citation::{CitationVerifier, Claim, Evidence, OverlapVerifier};
use arkhe_wormgraph::WormGraph;
use serde::Deserialize;
use serde_json::{json, Value};
use std::io::{self, Read};

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Input {
    run_id: String,
    arm: String,
    prompt: String,
    memory: String,
    model_digest: String,
    manifest_sha256: String,
    answer: String,
    phase: String,
    intent_type: WorkIntentType,
    emergency_stop: bool,
    #[serde(default)]
    verify_citations: bool,
    #[serde(default)]
    external_citation_report: Option<Value>,
    #[serde(default)]
    citation_context: Option<Value>,
}

async fn evaluate(input: Input) -> Result<Value, String> {
    if input.citation_context.is_some() && (input.arm != "B" || input.verify_citations) {
        return Err("structured citation context requires B without whole-response mode".into());
    }
    if input.external_citation_report.is_some() && input.citation_context.is_none() {
        return Err("host report requires context for native recomputation".into());
    }
    if input.citation_context.is_some()
        && input.phase == "record"
        && input.external_citation_report.is_none()
    {
        return Err("structured mode requires the helper report for comparison".into());
    }
    if let Some(report) = &input.external_citation_report {
        if report["phase"] != "structured_citation_diagnostic"
            || report["verifier"] != "arkhe_rag::citation::OverlapVerifier"
            || report["semantic_entailment"] != "NOT_MEASURED"
            || !matches!(
                report["status"].as_str(),
                Some("PASS_LEXICAL" | "FAIL_LEXICAL")
            )
        {
            return Err("invalid host citation report".into());
        }
        fn integral_json(value: &Value) -> bool {
            match value {
                Value::Number(n) => n.is_i64() || n.is_u64(),
                Value::Array(a) => a.iter().all(integral_json),
                Value::Object(o) => o.values().all(integral_json),
                _ => true,
            }
        }
        if !integral_json(report) {
            return Err("citation report requires canonical integer-only JSON".into());
        }
    }
    if !matches!(input.arm.as_str(), "B" | "C")
        || !matches!(input.phase.as_str(), "preflight" | "record")
        || input.run_id.is_empty()
        || input.prompt.is_empty()
        || input.model_digest.len() != 64
        || !input.model_digest.bytes().all(|b| b.is_ascii_hexdigit())
        || input.manifest_sha256.len() != 64
        || !input.manifest_sha256.bytes().all(|b| b.is_ascii_hexdigit())
        || (input.arm == "C" && !input.memory.is_empty())
        || (input.arm == "C" && input.verify_citations)
        || (input.arm == "C" && input.external_citation_report.is_some())
        || (input.phase == "preflight" && input.external_citation_report.is_some())
        || (input.verify_citations && input.external_citation_report.is_some())
        || (input.phase == "preflight" && !input.answer.is_empty())
    {
        return Err("invalid pilot bridge input".into());
    }
    let prompt = Digest32::blake3(b"AKG:PILOT:PROMPT:v1\0", input.prompt.as_bytes());
    let memory = Digest32::blake3(b"AKG:PILOT:MEMORY:v1\0", input.memory.as_bytes());
    let output = Digest32::blake3(b"AKG:PILOT:ANSWER:v1\0", input.answer.as_bytes());
    let mut parameter_fields = json!({
        "arm": input.arm, "prompt": prompt, "memory": memory,
        "model_digest": input.model_digest,
        "manifest_sha256": input.manifest_sha256,
    });
    if input.verify_citations {
        parameter_fields["citation_mode"] = json!("whole-response-vs-memory-lexical-v1");
    }
    let recomputed = if let Some(context) = &input.citation_context {
        let mut request = context.clone();
        if !request.is_object() || request.get("response_json").is_some() {
            return Err("citation context cannot contain an answer".into());
        }
        request["response_json"] = json!(if input.phase == "record" {
            input.answer.as_str()
        } else {
            ""
        });
        let checked = retrieval_citations::verify_value(request)?;
        parameter_fields["citation_context_digest"] = json!(Digest32::blake3(
            b"AKG:PILOT:CITATION-CONTEXT:v1\0",
            &arkhe_core::canonical::encode_value(context)
        ));
        if input.phase == "record" {
            if Some(&checked) != input.external_citation_report.as_ref() {
                return Err("host citation report differs from native recomputation".into());
            }
            Some(checked)
        } else {
            if checked["phase"] != "authorized_retrieval"
                || checked["chunks"].as_array().is_none_or(|v| v.is_empty())
            {
                return Err("preflight has no authorized retrieved evidence".into());
            }
            None
        }
    } else {
        None
    };
    let parameters = arkhe_core::canonical::encode_value(&parameter_fields);
    let intent = WorkIntent {
        requested_by: "pilot-local-host".into(),
        intent_type: input.intent_type,
        target: prompt,
        parameters_digest: Digest32::blake3(b"AKG:PILOT:PARAMETERS:v1\0", &parameters),
        context: vec![],
        context_refs: vec![],
        request_identity: RequestIdentity::new(input.run_id.as_bytes()),
        claimed_created_at: 0,
    };
    let citation_report = if recomputed.is_some() {
        recomputed
    } else if input.verify_citations && input.phase == "record" {
        let mut report = json!({"verifier":"arkhe_rag::citation::OverlapVerifier",
            "scope":"WHOLE_RESPONSE_AS_ONE_HOST_ASSIGNED_CLAIM", "semantic_entailment":"NOT_MEASURED",
            "model_citations":"NOT_REQUIRED_OR_EXTRACTED", "threshold_bps":5000,
            "evidence_id":"frozen-memory", "claims_checked":0});
        if input.answer.trim().is_empty() || input.memory.trim().is_empty() {
            report["status"] = json!("NOT_EVALUATED");
            report["reason"] = json!("empty answer or memory");
        } else {
            let claims = [Claim {
                text: &input.answer,
                evidence_id: "frozen-memory",
            }];
            let evidence = [Evidence {
                id: "frozen-memory",
                text: &input.memory,
            }];
            report["claims_checked"] = json!(1);
            match OverlapVerifier::default().verify(&claims, &evidence) {
                Ok(()) => report["status"] = json!("PASS_LEXICAL"),
                Err(error) => {
                    report["status"] = json!("FAIL_LEXICAL");
                    report["reason"] = json!(format!("{error:?}"));
                }
            }
        }
        Some(report)
    } else {
        None
    };
    let citation_digest = citation_report.as_ref().map(|report| {
        Digest32::blake3(
            b"AKG:PILOT:CITATION-REPORT:v1\0",
            &arkhe_core::canonical::encode_value(report),
        )
    });
    let mut uncertainty = "unsigned host observation; no model execution attestation".to_string();
    if let Some(digest) = citation_digest {
        uncertainty.push_str(&format!("; lexical_citation_report={}", digest.to_hex()));
    }
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Analyze),
        module_id: "pilot-local-ollama".into(),
        module_version: format!("{}+model.{}", env!("CARGO_PKG_VERSION"), input.model_digest),
        input_digest: intent.digest(),
        output_digest: output,
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: Some(uncertainty),
        execution_id: input.run_id,
    };
    let policy = PolicyBinding {
        policy_id: "pilot-local-dev-unprotected-v1".into(),
        version: 1,
        policy_digest: Digest32::blake3(b"AKG:PILOT:DEV-POLICY:v1\0", b"DevPolicyResolver"),
    };
    let mut gate = ContainmentGate::new(DevPolicyResolver);
    gate.set_emergency_stop(input.emergency_stop);
    let record = (input.phase == "record").then_some(&worker);
    let authorization_ref = match gate.authorize(&intent, record, &policy) {
        AuthorizationDecision::Reject { reason } => {
            return Ok(json!({"gate":"REJECT", "reason":reason,
                             "phase":input.phase, "persisted":false}));
        }
        AuthorizationDecision::Allow { authorization_ref } => authorization_ref,
    };
    if input.phase == "preflight" {
        return Ok(json!({"gate":"ALLOW", "phase":"preflight",
            "intent":intent, "intent_digest":intent.digest().to_hex(),
            "authorization_ref":authorization_ref.to_hex(), "persisted":false,
            "scope":"local unprotected simulation only"}));
    }
    let store = WormGraph::new();
    let envelope = EvidenceEnvelope {
        record_hash: authorization_ref,
        kind: "pilot-local-unprotected-observation".into(),
        subject: intent.digest(),
        payload_digest: worker.digest(),
        policy_digest: Some(policy.policy_digest),
        causal_parents: vec![],
    };
    store.append_verified(envelope.clone()).await?;
    if store.get(authorization_ref).await? != Some(envelope.clone()) {
        return Err("in-memory evidence readback mismatch".into());
    }
    Ok(json!({"gate":"ALLOW", "phase":"record", "intent":intent,
        "intent_digest":intent.digest().to_hex(), "intent_cbor_hex":hex::encode(intent.canonical_bytes()),
        "worker_record":worker, "worker_digest":worker.digest().to_hex(),
        "worker_cbor_hex":hex::encode(worker.canonical_bytes()), "memory_digest":memory.to_hex(),
        "digest_contract":{"algorithm":"BLAKE3", "encoding":"UTF-8 bytes",
            "memory_domain":"AKG:PILOT:MEMORY:v1\u{0000}",
            "prompt_domain":"AKG:PILOT:PROMPT:v1\u{0000}",
            "answer_domain":"AKG:PILOT:ANSWER:v1\u{0000}"},
        "prompt_digest":prompt.to_hex(), "answer_digest":output.to_hex(),
        "envelope":envelope, "authorization_ref":authorization_ref.to_hex(),
        "worker_signature":"UNSIGNED", "policy_profile":"DEV_UNPROTECTED",
        "wormgraph":"IN_MEMORY_READBACK_ONLY", "wormgraph_anchor":"NOT_INTEGRATED",
        "durable_admission":"NOT_INTEGRATED",
        "citation_verification":citation_report.as_ref().map(|v| v["status"].clone()).unwrap_or(json!("NOT_PERFORMED")),
        "citation_report":citation_report, "citation_report_digest":citation_digest.map(|d| d.to_hex()),
        "citation_report_trust":if input.citation_context.is_some() {"RECOMPUTED_IN_BRIDGE_SAME_IMPLEMENTATION"} else {"COMPUTED_IN_BRIDGE"},
        "persisted":false}))
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut bytes = vec![];
    io::stdin().take(262145).read_to_end(&mut bytes)?;
    if bytes.len() > 262144 {
        return Err("bridge input too large".into());
    }
    let input = serde_json::from_slice(&bytes)?;
    let output = evaluate(input).await.map_err(io::Error::other)?;
    println!("{}", serde_json::to_string(&output)?);
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    fn input() -> Input {
        Input {
            run_id: "test-run".into(),
            arm: "B".into(),
            prompt: "prompt".into(),
            memory: "memory".into(),
            model_digest: "a".repeat(64),
            manifest_sha256: "b".repeat(64),
            answer: "answer".into(),
            phase: "record".into(),
            intent_type: WorkIntentType::Simulate,
            emergency_stop: false,
            verify_citations: false,
            external_citation_report: None,
            citation_context: None,
        }
    }
    #[tokio::test]
    async fn binds_native_wer_and_reads_back() {
        let value = evaluate(input()).await.unwrap();
        let wer: WorkerExecutionRecord =
            serde_json::from_value(value["worker_record"].clone()).unwrap();
        let intent: WorkIntent = serde_json::from_value(value["intent"].clone()).unwrap();
        assert_eq!(wer.input_digest, intent.digest());
        assert_eq!(value["worker_digest"], wer.digest().to_hex());
        assert_eq!(value["worker_cbor_hex"], hex::encode(wer.canonical_bytes()));
        assert_eq!(value["worker_signature"], "UNSIGNED");
    }
    #[tokio::test]
    async fn protects_publish_and_emergency_stop() {
        let mut publish = input();
        publish.intent_type = WorkIntentType::Publish;
        assert_eq!(evaluate(publish).await.unwrap()["gate"], "REJECT");
        let mut stop = input();
        stop.emergency_stop = true;
        assert_eq!(evaluate(stop).await.unwrap()["gate"], "REJECT");
    }
    #[tokio::test]
    async fn memory_changes_intent_and_wer() {
        let first = evaluate(input()).await.unwrap();
        let mut other = input();
        other.memory = "different".into();
        let second = evaluate(other).await.unwrap();
        assert_ne!(first["intent_digest"], second["intent_digest"]);
        assert_ne!(first["worker_digest"], second["worker_digest"]);
    }
    #[tokio::test]
    async fn c_refuses_memory_and_preflight_refuses_answer() {
        let mut c = input();
        c.arm = "C".into();
        assert!(evaluate(c).await.is_err());
        let mut pre = input();
        pre.phase = "preflight".into();
        assert!(evaluate(pre).await.is_err());
    }
    #[tokio::test]
    async fn citations_detect_entity_change_and_bind_report() {
        let mut valid = input();
        valid.verify_citations = true;
        valid.memory = "Sydney has 5 offices.".into();
        valid.answer = valid.memory.clone();
        let passed = evaluate(valid).await.unwrap();
        assert_eq!(passed["citation_verification"], "PASS_LEXICAL");
        let wer: WorkerExecutionRecord =
            serde_json::from_value(passed["worker_record"].clone()).unwrap();
        assert!(wer
            .uncertainty_note
            .unwrap()
            .contains(passed["citation_report_digest"].as_str().unwrap()));
        let mut invalid = input();
        invalid.verify_citations = true;
        invalid.memory = "Sydney has 5 offices.".into();
        invalid.answer = "Melbourne has 5 offices.".into();
        let failed = evaluate(invalid).await.unwrap();
        assert_eq!(failed["citation_verification"], "FAIL_LEXICAL");
        assert_eq!(failed["gate"], "ALLOW"); // diagnostic does not grant or deny authority
    }
    #[tokio::test]
    async fn empty_citation_input_cannot_pass_vacuously() {
        let mut empty = input();
        empty.verify_citations = true;
        empty.memory.clear();
        assert_eq!(
            evaluate(empty).await.unwrap()["citation_verification"],
            "NOT_EVALUATED"
        );
    }
    #[tokio::test]
    async fn lexical_pass_is_not_semantic_entailment() {
        let mut example = input();
        example.verify_citations = true;
        example.memory = "Sydney has 5 offices.".into();
        example.answer = "Sydney has not 5 offices.".into();
        let value = evaluate(example).await.unwrap();
        assert_eq!(value["citation_verification"], "PASS_LEXICAL");
        assert_eq!(
            value["citation_report"]["semantic_entailment"],
            "NOT_MEASURED"
        );
    }
    fn structured_input() -> Input {
        let mut value = input();
        value.answer = "Sydney has 5 offices.".into();
        let context = json!({"tenant":"one","subject":"reader","query":"Sydney offices","top_k":2,
            "chunks":[{"id":"one","tenant":"one","readers":["reader"],"text":value.answer,
                "expected_digest_hex":Digest32::blake3(b"AKG:RAG:CHUNK:v1\0",value.answer.as_bytes()).to_hex(),
                "source_ref_hex":"ab".repeat(32)}]});
        let mut request = context.clone();
        request["response_json"] =
            json!("{\"claims\":[{\"text\":\"Sydney has 5 offices.\",\"evidence_id\":\"one\"}]}");
        value.answer = request["response_json"].as_str().unwrap().into();
        value.external_citation_report = Some(retrieval_citations::verify_value(request).unwrap());
        value.citation_context = Some(context);
        value
    }
    #[tokio::test]
    async fn native_recomputation_accepts_exact_report_and_rejects_tampering() {
        let checked = evaluate(structured_input()).await.unwrap();
        assert_eq!(checked["citation_verification"], "PASS_LEXICAL");
        assert_eq!(
            checked["citation_report_trust"],
            "RECOMPUTED_IN_BRIDGE_SAME_IMPLEMENTATION"
        );
        let mut altered = structured_input();
        altered.external_citation_report.as_mut().unwrap()["status"] = json!("FAIL_LEXICAL");
        assert!(evaluate(altered).await.unwrap_err().contains("differs"));
        let mut swapped = structured_input();
        swapped.answer = swapped.answer.replace("Sydney", "Melbourne");
        assert!(evaluate(swapped).await.unwrap_err().contains("differs"));
    }
    #[tokio::test]
    async fn report_without_context_and_context_without_report_are_rejected() {
        let mut missing = structured_input();
        missing.citation_context = None;
        assert!(evaluate(missing).await.is_err());
        let mut missing = structured_input();
        missing.external_citation_report = None;
        assert!(evaluate(missing).await.is_err());
    }
    #[tokio::test]
    async fn context_is_bound_to_preflight_intent() {
        let mut original = structured_input();
        original.phase = "preflight".into();
        original.answer.clear();
        original.external_citation_report = None;
        let first = evaluate(original).await.unwrap();
        let mut changed = structured_input();
        changed.phase = "preflight".into();
        changed.answer.clear();
        changed.external_citation_report = None;
        changed.citation_context.as_mut().unwrap()["top_k"] = json!(1);
        assert_ne!(
            first["intent_digest"],
            evaluate(changed).await.unwrap()["intent_digest"]
        );
    }
}
