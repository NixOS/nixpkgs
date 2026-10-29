//! Executable contract prototype only: no production adapter, trusted clock,
//! registry provisioning or journal writer. Signature checks in the child module
//! are restricted to public fixtures and an exact trusted replay pair.
use arkhe_core::{
    canonical::encode_map_with_bytes,
    evidence::{EvidenceEnvelope, EvidenceReader},
    work::{ContextEntry, ContextKind, RequestIdentity, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_governance::{EvidenceKindRequirement, PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use async_trait::async_trait;
use serde_json::{json, Value};
use sha3::{Digest, Sha3_256};

// v1 used CBOR integer arrays; v2 explicitly uses byte strings.
const DOMAIN: &[u8] = b"AKG:GRAVIT:EXTERNAL:v2\0";
const MODULE: &str = "gravit-contract-test-only";
const REQUEST: &[u8] = include_bytes!("fixtures/gravit/invalid-hash-request.json");
const DECISION: &[u8] = include_bytes!("fixtures/gravit/invalid-hash-decision.json");
const ARTIFACT: &[u8] = b"Arkhe external assessment contract test artifact\n";

#[path = "support/gravit_signatures.rs"]
mod signatures;

fn artifact_hash(bytes: &[u8]) -> String {
    Sha3_256::digest(bytes)
        .iter()
        .map(|b| format!("{b:02x}"))
        .collect()
}

struct Candidate {
    request: Vec<u8>,
    decision: Vec<u8>,
    artifact_digest: String,
    worker: WorkerExecutionRecord,
    intent: WorkIntent,
}

fn policy() -> PolicyBinding {
    PolicyBinding {
        policy_id: "gravit-digest-binding-test-only".into(),
        version: 1,
        policy_digest: Digest32::blake3(b"AKG:TEST:POLICY:v1\0", b"digest-binding-only"),
    }
}

// Embedded JSON (including theta/metrics) is captured as byte strings, never
// normalized or passed to AKG-CBOR's integer-only numeric encoder.
fn projection_bytes(request: &[u8], decision: &[u8], artifact_digest: &str) -> Vec<u8> {
    let projection = json!({
        "profile": "digest-binding-test-only-v2",
        "verifier_commit": "7887252fc84def69a794d2e32ce65721eb9a25d9",
        "artifact_sha3_256": artifact_digest,
        "subject": "arkhe-review-contract-probe",
        "parameters_digest": Digest32::blake3(b"AKG:TEST:PARAMS:v1\0", b"publish-fixture"),
        "policy_digest": policy().policy_digest,
    });
    encode_map_with_bytes(
        projection.as_object().unwrap(),
        &[("request_bytes", request), ("decision_bytes", decision)],
    )
    .unwrap()
}

fn commitment(request: &[u8], decision: &[u8], artifact_digest: &str) -> Digest32 {
    Digest32::blake3(
        DOMAIN,
        &projection_bytes(request, decision, artifact_digest),
    )
}

#[test]
fn projection_uses_byte_strings_for_captured_bytes_without_normalizing_numbers() {
    let projection = projection_bytes(&[0, 255], b"0.880000", "fixture-hash");
    // Literal CBOR: text key followed by a major-type-2 value and raw payload.
    let request = [vec![0x6d], b"request_bytes".to_vec(), vec![0x42, 0, 255]].concat();
    let decision = [
        vec![0x6e],
        b"decision_bytes".to_vec(),
        vec![0x48],
        b"0.880000".to_vec(),
    ]
    .concat();
    assert!(projection.windows(request.len()).any(|w| w == request));
    assert!(projection.windows(decision.len()).any(|w| w == decision));
    assert_ne!(
        Digest32::blake3(DOMAIN, &projection),
        Digest32::blake3(b"AKG:GRAVIT:EXTERNAL:v1\0", &projection)
    );
}

// Translation creates a candidate, never an admitted WER or an authorization.
fn translate(request: &[u8], decision: &[u8], artifact: &[u8]) -> Candidate {
    let artifact_digest = artifact_hash(artifact);
    let source = commitment(request, decision, &artifact_digest);
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Analyze),
        module_id: MODULE.into(),
        module_version: "contract-test-v2".into(),
        input_digest: source,
        output_digest: Digest32::blake3(b"AKG:TEST:PARAMS:v1\0", b"publish-fixture"),
        evidence_refs: vec![source],
        confidence_bps: None, // No theta -> authority conversion.
        uncertainty_note: Some("Digest-binding test; no production trust established".into()),
        execution_id: source.to_hex(), // Never the external decision_id.
    };
    let intent = WorkIntent {
        requested_by: "gravit-contract-test".into(),
        intent_type: WorkIntentType::Publish,
        target: Digest32::blake3(b"AKG:TEST:SUBJECT:v1\0", b"arkhe-review-contract-probe"),
        parameters_digest: worker.output_digest,
        context: vec![
            ContextEntry {
                kind: ContextKind::SourceReport,
                hash: source,
            },
            ContextEntry {
                kind: ContextKind::AnalysisRecord,
                hash: worker.digest(),
            },
        ],
        context_refs: vec![source],
        request_identity: RequestIdentity::new(b"gravit-contract-fixture"),
        claimed_created_at: 0,
    };
    Candidate {
        request: request.into(),
        decision: decision.into(),
        artifact_digest,
        worker,
        intent,
    }
}

#[derive(Default)]
struct TestAdmission(Option<EvidenceEnvelope>);
impl TestAdmission {
    // This deliberately checks only the digest-binding slice. A production
    // boundary would ALSO require signatures, trusted policy/roots and freshness.
    fn admit_digest_slice(
        &mut self,
        candidate: &Candidate,
        artifact: &[u8],
    ) -> Result<(), &'static str> {
        let request: Value =
            serde_json::from_slice(&candidate.request).map_err(|_| "request JSON")?;
        let decision: Value =
            serde_json::from_slice(&candidate.decision).map_err(|_| "decision JSON")?;
        if decision["status"] != "SUCCESS" || decision["final_epistemic_state"] != "Verified Fact" {
            return Err("unsupported decision");
        }
        if request["artifact_id"] != "arkhe-review-contract-probe"
            || decision["artifact_id"] != request["artifact_id"]
        {
            return Err("subject mismatch");
        }
        let actual = artifact_hash(artifact);
        let evidence = request["evidence"]
            .as_array()
            .filter(|a| !a.is_empty())
            .ok_or("missing evidence")?;
        if actual != candidate.artifact_digest
            || evidence
                .iter()
                .any(|r| r["integrity_hash"].as_str() != Some(actual.as_str()))
        {
            return Err("artifact digest mismatch");
        }
        if candidate.worker.input_digest
            != commitment(&candidate.request, &candidate.decision, &actual)
        {
            return Err("external commitment mismatch");
        }
        self.0 = Some(EvidenceEnvelope {
            record_hash: candidate.worker.digest(),
            kind: "WorkerExecutionRecord".into(),
            subject: candidate.worker.input_digest,
            payload_digest: candidate.worker.digest(),
            policy_digest: Some(policy().policy_digest),
            causal_parents: vec![candidate.worker.input_digest],
        });
        Ok(())
    }
}
#[async_trait]
impl EvidenceReader for TestAdmission {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(self.0.as_ref().filter(|e| e.record_hash == hash).cloned())
    }
}
struct TestPolicy(bool);
impl PolicyResolver for TestPolicy {
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec![MODULE.into()],
            allowed_operations: vec![CognitiveOperation::Analyze],
        })
    }
    fn resolve(&self, _: &WorkIntent, binding: &PolicyBinding) -> PolicyVerdict {
        if self.0
            && binding.policy_id == policy().policy_id
            && binding.version == policy().version
            && binding.policy_digest == policy().policy_digest
        {
            PolicyVerdict::Allow
        } else {
            PolicyVerdict::Deny("test governance denied".into())
        }
    }
}

fn synthetic_matching_request() -> Vec<u8> {
    // Only a digest-positive control: changing a signed field invalidates the
    // original signatures. This MUST NOT be called a valid signed Gravit result.
    let mut request: Value = serde_json::from_slice(REQUEST).unwrap();
    for record in request["evidence"].as_array_mut().unwrap() {
        record["integrity_hash"] = json!(artifact_hash(ARTIFACT));
    }
    serde_json::to_vec(&request).unwrap()
}

async fn authorize(c: &Candidate, store: &TestAdmission, allow: bool) -> AuthorizationDecision {
    ContainmentGate::new(TestPolicy(allow))
        .authorize_admitted(&c.intent, &c.worker, &policy(), store)
        .await
}

#[tokio::test]
async fn reproduced_success_with_invalid_hash_is_not_admitted_and_gate_rejects() {
    let decision: Value = serde_json::from_slice(DECISION).unwrap();
    assert_eq!(decision["status"], "SUCCESS");
    let candidate = translate(REQUEST, DECISION, ARTIFACT);
    let mut store = TestAdmission::default();
    assert_eq!(
        store.admit_digest_slice(&candidate, ARTIFACT),
        Err("artifact digest mismatch")
    );
    assert!(matches!(authorize(&candidate, &store, true).await,
        AuthorizationDecision::Reject { reason } if reason == "missing admitted analysis evidence"));
}

#[tokio::test]
async fn matching_digest_control_passes_only_with_explicit_test_governance() {
    let candidate = translate(&synthetic_matching_request(), DECISION, ARTIFACT);
    let mut store = TestAdmission::default();
    store.admit_digest_slice(&candidate, ARTIFACT).unwrap();
    assert!(matches!(
        authorize(&candidate, &store, true).await,
        AuthorizationDecision::Allow { .. }
    ));
    assert!(matches!(authorize(&candidate, &store, false).await,
        AuthorizationDecision::Reject { reason } if reason == "test governance denied"));
    assert!(matches!(ContainmentGate::new(TestPolicy(true)).authorize(
        &candidate.intent, Some(&candidate.worker), &policy()),
        AuthorizationDecision::Reject { reason } if reason == "integration requires admitted evidence lookup"));
}

#[tokio::test]
async fn well_formed_wrong_hash_and_changed_artifact_fail_closed() {
    let mut request: Value = serde_json::from_slice(&synthetic_matching_request()).unwrap();
    request["evidence"][0]["integrity_hash"] = json!("0".repeat(64));
    let wrong = translate(&serde_json::to_vec(&request).unwrap(), DECISION, ARTIFACT);
    let mut store = TestAdmission::default();
    assert_eq!(
        store.admit_digest_slice(&wrong, ARTIFACT),
        Err("artifact digest mismatch")
    );
    assert!(matches!(
        authorize(&wrong, &store, true).await,
        AuthorizationDecision::Reject { .. }
    ));
    let candidate = translate(&synthetic_matching_request(), DECISION, ARTIFACT);
    assert_eq!(
        store.admit_digest_slice(&candidate, b"substituted content"),
        Err("artifact digest mismatch")
    );
}

#[tokio::test]
async fn admitted_translation_cannot_be_replayed_with_changed_parameters() {
    let mut candidate = translate(&synthetic_matching_request(), DECISION, ARTIFACT);
    let mut store = TestAdmission::default();
    store.admit_digest_slice(&candidate, ARTIFACT).unwrap();
    candidate.intent.parameters_digest = Digest32([9; 32]);
    assert!(matches!(authorize(&candidate, &store, true).await,
        AuthorizationDecision::Reject { reason } if reason == "analysis evidence does not bind this proposal"));
}

#[test]
fn exact_bytes_and_domain_bind_inputs_even_when_external_id_is_unchanged() {
    let a = translate(REQUEST, DECISION, ARTIFACT);
    let mut changed = REQUEST.to_vec();
    changed.push(b' '); // Semantically identical JSON, different captured bytes.
    let b = translate(&changed, DECISION, ARTIFACT);
    assert_ne!(a.worker.input_digest, b.worker.input_digest);
    assert_ne!(a.worker.digest(), b.worker.digest());
    assert_eq!(a.decision, b.decision);
    assert_ne!(
        a.worker.execution_id,
        serde_json::from_slice::<Value>(DECISION).unwrap()["decision_id"]
            .as_str()
            .unwrap()
    );
    assert_ne!(
        Digest32::blake3(DOMAIN, b"same bytes"),
        Digest32::blake3(b"AKG:KYA:RECORD:v1\0", b"same bytes")
    );
    assert_eq!(a.worker.confidence_bps, None);
}

#[test]
fn substitution_of_captured_bytes_cannot_reuse_the_worker_commitment() {
    let mut candidate = translate(&synthetic_matching_request(), DECISION, ARTIFACT);
    candidate.decision.push(b' ');
    assert_eq!(
        TestAdmission::default().admit_digest_slice(&candidate, ARTIFACT),
        Err("external commitment mismatch")
    );
}

#[test]
fn success_alone_and_a_different_subject_are_not_accepted() {
    let request = synthetic_matching_request();
    let mut decision: Value = serde_json::from_slice(DECISION).unwrap();
    decision["final_epistemic_state"] = json!("Probabilistic Assessment");
    let candidate = translate(&request, &serde_json::to_vec(&decision).unwrap(), ARTIFACT);
    assert_eq!(
        TestAdmission::default().admit_digest_slice(&candidate, ARTIFACT),
        Err("unsupported decision")
    );
    decision["final_epistemic_state"] = json!("Verified Fact");
    decision["artifact_id"] = json!("another-subject");
    let candidate = translate(&request, &serde_json::to_vec(&decision).unwrap(), ARTIFACT);
    assert_eq!(
        TestAdmission::default().admit_digest_slice(&candidate, ARTIFACT),
        Err("subject mismatch")
    );
}
