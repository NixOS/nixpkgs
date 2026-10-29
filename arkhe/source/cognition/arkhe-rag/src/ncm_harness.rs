//! AKG-NCM-0001 — NCM harness without constrained decoding.
//!
//! Cycle: generate → verify level digest → verify citations → anchor.
//!
//! The generator is a trait (`NcmGenerator`); tests use a static-checkpoint
//! mock, production wraps the real NCM checkpoint. The verifier is the
//! `CitationVerifier` already in `arkhe-rag` (AKG-CITE-0001). The anchor is
//! a trait (`ProofAnchor`); production wraps the WormGraph. No `llguidance`,
//! no `xgrammar`, no NCM checkpoint download — this is the execution layer
//! before the structure layer exists.
//!
//! Every digest is BLAKE3 with domain separation (`Digest32`), as everywhere
//! else in the workspace. The `policy_digest` is decoupled: it arrives as a
//! parameter and, in production, is the digest from the `PolicyBinding` that
//! `SignedPolicyBundle::verify()` returns in `arkhe-governance`; this module
//! does not depend on governance.
//!
//! Ordering is fail-closed: a level whose recomputed digest does not match
//! its declared one is refused before any citation check, and nothing is
//! anchored unless every level passed.

use crate::citation::{CitationError, CitationVerifier, Claim, Evidence};
use arkhe_cognition_sdk::Digest32;

#[derive(Debug, Clone, PartialEq)]
pub enum NcmError {
    GeneratorFailed(String),
    DigestMismatch { level: u8 },
    CitationRejected(CitationError),
    AnchorFailed(String),
}

#[derive(Debug, Clone, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
pub struct ClaimData {
    pub text: String,
    pub evidence_id: String,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NcmLevel {
    pub level: u8,
    pub claims: Vec<ClaimData>,
    pub content_digest: Digest32,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct NcmOutput {
    pub levels: Vec<NcmLevel>,
}

pub trait NcmGenerator: Send + Sync {
    fn generate(&self, prompt: &str) -> Result<NcmOutput, NcmError>;
    fn model_digest(&self) -> Digest32;
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AnchorProof {
    pub record_hash: Digest32,
    pub anchored_at: u64,
}

pub trait ProofAnchor: Send + Sync {
    fn anchor(&self, record_hash: Digest32) -> Result<AnchorProof, NcmError>;
}

#[derive(Debug, Clone, PartialEq)]
pub struct VerifiedNcmOutput {
    pub levels: Vec<NcmLevel>,
    pub model_digest: Digest32,
    pub policy_digest: Digest32,
    pub record_hash: Digest32,
    pub anchor_proof: AnchorProof,
}

pub struct NcmHarness<G, V, A> {
    generator: G,
    verifier: V,
    anchor: A,
    policy_digest: Digest32,
}

impl<G, V, A> NcmHarness<G, V, A>
where
    G: NcmGenerator,
    V: CitationVerifier,
    A: ProofAnchor,
{
    pub fn new(generator: G, verifier: V, anchor: A, policy_digest: Digest32) -> Self {
        Self {
            generator,
            verifier,
            anchor,
            policy_digest,
        }
    }

    pub fn generate_and_verify(
        &self,
        prompt: &str,
        evidence: &[Evidence<'_>],
    ) -> Result<VerifiedNcmOutput, NcmError> {
        // 1. Generate.
        let output = self.generator.generate(prompt)?;

        // 2. Per level: digest first, then citation verification.
        let mut verified = Vec::with_capacity(output.levels.len());
        for level in &output.levels {
            let computed = compute_level_digest(&level.claims);
            if computed != level.content_digest {
                return Err(NcmError::DigestMismatch { level: level.level });
            }

            let claims: Vec<Claim<'_>> = level
                .claims
                .iter()
                .map(|c| Claim {
                    text: &c.text,
                    evidence_id: &c.evidence_id,
                })
                .collect();

            self.verifier
                .verify(&claims, evidence)
                .map_err(NcmError::CitationRejected)?;

            verified.push(level.clone());
        }

        // 3. Anchor — only reached when every level passed.
        let record_hash = compute_record_hash(&verified, &self.policy_digest);
        let anchor_proof = self.anchor.anchor(record_hash)?;

        Ok(VerifiedNcmOutput {
            levels: verified,
            model_digest: self.generator.model_digest(),
            policy_digest: self.policy_digest,
            record_hash,
            anchor_proof,
        })
    }
}

/// Digest over one level's claims: length-prefixed text and evidence ids in
/// order, under the level domain.
pub fn compute_level_digest(claims: &[ClaimData]) -> Digest32 {
    let mut buf = Vec::new();
    for c in claims {
        buf.extend_from_slice(&(c.text.len() as u64).to_be_bytes());
        buf.extend_from_slice(c.text.as_bytes());
        buf.extend_from_slice(&(c.evidence_id.len() as u64).to_be_bytes());
        buf.extend_from_slice(c.evidence_id.as_bytes());
    }
    Digest32::blake3(b"AKG:NCM:LEVEL:v1\0", &buf)
}

/// Digest over the whole verified output: policy digest plus each level's
/// number and content digest, under the record domain.
pub fn compute_record_hash(levels: &[NcmLevel], policy_digest: &Digest32) -> Digest32 {
    let mut buf = Vec::new();
    buf.extend_from_slice(&policy_digest.0);
    for l in levels {
        buf.push(l.level);
        buf.extend_from_slice(&l.content_digest.0);
    }
    Digest32::blake3(b"AKG:NCM:RECORD:v1\0", &buf)
}
