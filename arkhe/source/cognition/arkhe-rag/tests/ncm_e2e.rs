//! AKG-NCM-0001 e2e — the generate → verify → anchor cycle, mocked at both
//! ends: the generator is a static checkpoint and the anchor is an in-memory
//! log. Production swaps in the real NCM checkpoint and the WormGraph.

use std::collections::HashMap;
use std::sync::{Arc, Mutex};

use arkhe_cognition_sdk::Digest32;
use arkhe_rag::citation::{CitationError, Evidence, OverlapVerifier};
use arkhe_rag::ncm_harness::{
    compute_level_digest, AnchorProof, ClaimData, NcmError, NcmGenerator, NcmHarness, NcmLevel,
    NcmOutput, ProofAnchor,
};

fn policy_digest_from_signed_bundle() -> Digest32 {
    // In production: the digest from the `PolicyBinding` that
    // `SignedPolicyBundle::verify()` returns in `arkhe-governance`.
    // Here: a stable constant, because this test targets the NCM cycle.
    Digest32([0xAA; 32])
}

// ---- Mocks ----

struct MockNcmGenerator {
    responses: HashMap<String, NcmOutput>,
}

impl MockNcmGenerator {
    fn new() -> Self {
        let mut responses = HashMap::new();
        let claims = vec![ClaimData {
            text: "Sydney is the capital of Australia".into(),
            evidence_id: "e1".into(),
        }];
        let level = NcmLevel {
            level: 1,
            content_digest: compute_level_digest(&claims),
            claims,
        };
        responses.insert(
            "capital of Australia".into(),
            NcmOutput {
                levels: vec![level],
            },
        );
        Self { responses }
    }

    /// Inject a tampered output for a prompt. Used by negative tests.
    fn inject(&mut self, prompt: &str, output: NcmOutput) {
        self.responses.insert(prompt.to_string(), output);
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
        Digest32([0x42; 32])
    }
}

/// In-memory anchor whose log is shared, so a test can still count what was
/// anchored after the harness takes ownership of the anchor itself.
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
fn generate_verify_anchor_happy_path() {
    let (anchor, log) = MockAnchor::new();
    let harness = NcmHarness::new(
        MockNcmGenerator::new(),
        OverlapVerifier::default(),
        anchor,
        policy_digest_from_signed_bundle(),
    );

    let evidence = [Evidence {
        id: "e1",
        text: "Sydney is the capital of Australia.",
    }];

    let out = harness
        .generate_and_verify("capital of Australia", &evidence)
        .expect("should pass");

    assert_eq!(out.levels.len(), 1);
    assert_eq!(out.levels[0].level, 1);
    assert_eq!(out.model_digest, Digest32([0x42; 32]));
    assert_eq!(out.policy_digest, policy_digest_from_signed_bundle());
    assert_ne!(out.record_hash, Digest32::ZERO);
    assert_eq!(out.anchor_proof.record_hash, out.record_hash);
    assert_eq!(log.lock().unwrap().len(), 1);
}

#[test]
fn generate_verify_anchor_rejects_wrong_entity() {
    let (anchor, log) = MockAnchor::new();
    let harness = NcmHarness::new(
        MockNcmGenerator::new(),
        OverlapVerifier::default(),
        anchor,
        Digest32([0xAA; 32]),
    );

    let evidence = [Evidence {
        id: "e1",
        text: "Melbourne is the capital of Australia.",
    }];

    let err = harness
        .generate_and_verify("capital of Australia", &evidence)
        .expect_err("should reject");

    match err {
        NcmError::CitationRejected(CitationError::EntityNotInEvidence { entity, .. }) => {
            assert_eq!(entity, "Sydney");
        }
        other => panic!("expected CitationRejected(EntityNotInEvidence), got {other:?}"),
    }
    // A rejected output is never anchored.
    assert!(log.lock().unwrap().is_empty());
}

#[test]
fn tampered_digest_is_rejected_before_citation() {
    // Level with correct claims but a tampered digest: refused before any
    // citation check, even against evidence that would satisfy the claims.
    let mut generator = MockNcmGenerator::new();
    let mut out = generator
        .generate("capital of Australia")
        .expect("mock has the prompt");
    out.levels[0].content_digest = Digest32([0xFF; 32]);
    generator.inject("capital of Australia", out);

    let harness = NcmHarness::new(
        generator,
        OverlapVerifier::default(),
        MockAnchor::new().0,
        Digest32([0xAA; 32]),
    );
    let evidence = [Evidence {
        id: "e1",
        text: "Sydney is the capital.",
    }];

    let err = harness
        .generate_and_verify("capital of Australia", &evidence)
        .expect_err("digest mismatch");

    assert_eq!(err, NcmError::DigestMismatch { level: 1 });
}

#[test]
fn record_hash_binds_policy_and_levels() {
    // Same levels, different policy digest → different record hash: the
    // anchor cannot be replayed across policies.
    let claims = vec![ClaimData {
        text: "Sydney is the capital of Australia".into(),
        evidence_id: "e1".into(),
    }];
    let level = NcmLevel {
        level: 1,
        content_digest: compute_level_digest(&claims),
        claims,
    };
    let levels = vec![level];
    let a = arkhe_rag::ncm_harness::compute_record_hash(&levels, &Digest32([0xAA; 32]));
    let b = arkhe_rag::ncm_harness::compute_record_hash(&levels, &Digest32([0xBB; 32]));
    assert_ne!(a, b);
}
