//! AKG-NCM e2e — the full four-layer cycle against an XSum-style fixture:
//!
//! policy (real `SignedPolicyBundle` from arkhe-governance)
//! → structure (real llguidance matcher over the level schema)
//! → support (real `CitationVerifier`)
//! → execution (mock generator/anchor — the real NCM checkpoint stays
//!   PENDING on the VQ-VAE `TokenizerEnv` extraction, AKG-NCM-0003).
//!
//! The mock generator stands for the XSum checkpoint: same claims shape the
//! real checkpoint would emit for a summarization level.

use std::collections::HashMap;
use std::sync::{Arc, Mutex};

use arkhe_cognition_sdk::Digest32;
use arkhe_governance::policy_bundle::{
    sign_policy_bundle, PolicyBundleError, PolicyPayload, SignaturePolicy, TrustStore,
};
use arkhe_rag::citation::{Evidence, OverlapVerifier};
use arkhe_rag::decoder::{ConstrainedDecoder, Target};
use arkhe_rag::ncm_harness::{
    compute_level_digest, AnchorProof, ClaimData, NcmError, NcmGenerator, NcmHarness, NcmLevel,
    NcmOutput, ProofAnchor,
};
use ed25519_dalek::SigningKey;
use llguidance::toktrie::ApproximateTokEnv;

const NOW: i64 = 1_800_000_000;

fn level_schema() -> serde_json::Value {
    serde_json::json!({
        "type": "object",
        "properties": {
            "claims": {
                "type": "array",
                "items": {
                    "type": "object",
                    "properties": {
                        "text": {"type": "string"},
                        "evidence_id": {"type": "string"}
                    },
                    "required": ["text", "evidence_id"]
                }
            }
        },
        "required": ["claims"]
    })
}

fn xsum_claims() -> Vec<ClaimData> {
    vec![ClaimData {
        text: "Sydney is the capital of Australia".into(),
        evidence_id: "e1".into(),
    }]
}

// ---- Mocks (execution layer stand-ins) ----

struct MockNcmGenerator {
    responses: HashMap<String, NcmOutput>,
}

impl MockNcmGenerator {
    fn new() -> Self {
        let claims = xsum_claims();
        let level = NcmLevel {
            level: 1,
            content_digest: compute_level_digest(&claims),
            claims,
        };
        let mut responses = HashMap::new();
        responses.insert(
            "capital of Australia".into(),
            NcmOutput {
                levels: vec![level],
            },
        );
        Self { responses }
    }
}

impl NcmGenerator for MockNcmGenerator {
    fn generate(&self, prompt: &str) -> Result<NcmOutput, NcmError> {
        self.responses
            .get(prompt)
            .cloned()
            .ok_or_else(|| NcmError::GeneratorFailed(format!("no mock for {prompt:?}")))
    }

    fn model_digest(&self) -> Digest32 {
        // In production: BLAKE3 over generator.pt + config.yaml + tokenizer.pt.
        Digest32([0x42; 32])
    }
}

struct MockAnchor {
    log: Arc<Mutex<Vec<Digest32>>>,
}

impl MockAnchor {
    fn new() -> (Self, Arc<Mutex<Vec<Digest32>>>) {
        let log = Arc::new(Mutex::new(Vec::new()));
        (
            Self {
                log: Arc::clone(&log),
            },
            log,
        )
    }
}

impl ProofAnchor for MockAnchor {
    fn anchor(&self, record_hash: Digest32) -> Result<AnchorProof, NcmError> {
        self.log.lock().unwrap().push(record_hash);
        Ok(AnchorProof {
            record_hash,
            anchored_at: 0,
        })
    }
}

// ---- Tests ----

#[test]
fn xsum_full_cycle_policy_structure_support_execution() {
    // 1. Policy layer: a real signed bundle, verified against a real trust
    //    store. The binding's digest is what everything downstream cites.
    let signer = SigningKey::from_bytes(&[9u8; 32]);
    let mut store = TrustStore::new();
    store.insert_signing("ncm-policy", &signer).expect("anchor");
    let bundle = sign_policy_bundle(
        PolicyPayload {
            policy_id: "ncm.xsum.level".into(),
            statements: serde_json::json!({"max_levels": 3, "entity_check": "exact"}),
        },
        7,
        7,
        "arkhe-governance",
        "ncm-policy",
        NOW - 1000,
        NOW + 1000,
        &signer,
    );
    let binding = bundle
        .verify(&store, 7, SignaturePolicy::Required, NOW)
        .expect("policy bundle verifies");

    // 2. Structure layer: the level payload must conform to the level
    //    schema under a real llguidance matcher.
    let env = ApproximateTokEnv::single_byte_env();
    let decoder = ConstrainedDecoder::for_schema(&level_schema(), Target::Server, &env)
        .expect("decoder builds");
    let ConstrainedDecoder::LlGuidance(mut matcher) = decoder else {
        panic!("expected LlGuidance")
    };
    let payload_json =
        serde_json::to_string(&serde_json::json!({ "claims": xsum_claims() })).unwrap();
    matcher
        .consume_tokens(&env.tokenize_bytes(payload_json.as_bytes()))
        .expect("level payload conforms to schema");
    assert!(matcher.is_accepting().unwrap());

    // 3+4. Support and execution: the harness runs with the *verified*
    //    policy digest — the one line of glue between governance and the
    //    NCM cycle that was still a conjecture.
    let (anchor, log) = MockAnchor::new();
    let harness = NcmHarness::new(
        MockNcmGenerator::new(),
        OverlapVerifier::default(),
        anchor,
        binding.policy_digest,
    );
    let evidence = [Evidence {
        id: "e1",
        text: "Sydney is the capital of Australia.",
    }];

    let out = harness
        .generate_and_verify("capital of Australia", &evidence)
        .expect("cycle closes");

    assert_eq!(out.levels.len(), 1);
    assert_eq!(out.policy_digest, binding.policy_digest);
    assert_ne!(out.record_hash, Digest32::ZERO);
    assert_eq!(out.anchor_proof.record_hash, out.record_hash);
    assert_eq!(log.lock().unwrap().len(), 1);
}

#[test]
fn invalid_policies_never_reach_the_harness() {
    let signer = SigningKey::from_bytes(&[9u8; 32]);
    let mut store = TrustStore::new();
    store.insert_signing("ncm-policy", &signer).unwrap();
    let payload = PolicyPayload {
        policy_id: "ncm.xsum.level".into(),
        statements: serde_json::json!({"max_levels": 3}),
    };

    // Expired bundle: refused at verification, so the harness never runs.
    let expired = sign_policy_bundle(
        payload.clone(),
        8,
        7,
        "arkhe-governance",
        "ncm-policy",
        NOW - 2000,
        NOW - 1000,
        &signer,
    );
    assert_eq!(
        expired
            .verify(&store, 8, SignaturePolicy::Required, NOW)
            .err(),
        Some(PolicyBundleError::Expired)
    );

    // Rolled-back bundle: version above its own floor but below the
    // deployment's current (6 with floor 7 would be MalformedVersion —
    // below its own floor — and is covered in policy_bundle's own tests).
    let rolled_back = sign_policy_bundle(
        payload,
        7,
        7,
        "arkhe-governance",
        "ncm-policy",
        NOW - 1000,
        NOW + 1000,
        &signer,
    );
    assert_eq!(
        rolled_back
            .verify(&store, 8, SignaturePolicy::Required, NOW)
            .err(),
        Some(PolicyBundleError::RollbackDetected)
    );
}
