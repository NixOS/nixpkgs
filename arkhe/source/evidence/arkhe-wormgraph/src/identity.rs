//! AKG-IDENTITY-0001 v0.1 — Thurin-backed identity evidence nodes.
//!
//! Identity answers "who holds this key"; it does not answer "what may this
//! key do". Authorization stays with the ContainmentGate and IntentBinding:
//! `ProtectedTransitionAllowed ⇒ VerificationCompleted ∧ IdentityProven`.
//! This module only produces the `IdentityProven` input, as a WormGraph
//! evidence envelope whose payload binds a Thurin on-chain claim
//! (PGP key ↔ Ethereum address ↔ social proofs) to an Arkhe verifier's
//! Ed25519 attestation.
//!
//! Sources of truth at the admission boundary (all untrusted until checked):
//! - `ThurinClaimReadout` — what an `eth_call` to PGPRegistry returned
//!   (`armoredKey(owner, index)`, fingerprint, records). The contract does
//!   not verify PGP on-chain; readers do.
//! - `ProofCheck` — the client-side bidirectional check of one
//!   `proof@thurin.id` notation against the platform content
//!   (`thurin-id=openpgp4fpr:FINGERPRINT`), as performed by openpgp.js.
//!
//! Everything the node stores is either recomputed from those inputs at
//! admission (digests) or set by the verifier itself (timestamp, signature).
//! `invariant_holds` re-derives all of it and is the predicate the Kani
//! harnesses prove `admit` establishes.

use arkhe_core::evidence::EvidenceEnvelope;
use arkhe_core::{CanonicalEncode, Digest32};
use ed25519_dalek::{Signature, Signer, SigningKey, Verifier, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::Value;

/// Thurin social-proof providers, per docs.thurin.id/guides/proofs.md.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum SocialProvider {
    GitHub,
    Dns,
    Farcaster,
    Mastodon,
    Codeberg,
}

impl SocialProvider {
    fn domain_tag(self) -> &'static [u8] {
        match self {
            SocialProvider::GitHub => b"github\0",
            SocialProvider::Dns => b"dns\0",
            SocialProvider::Farcaster => b"farcaster\0",
            SocialProvider::Mastodon => b"mastodon\0",
            SocialProvider::Codeberg => b"codeberg\0",
        }
    }
}

/// One verified bidirectional social proof, as recorded in the node.
/// `bidirectional_digest` covers the notation line on the key AND the
/// platform line naming the fingerprint.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct SocialProof {
    pub provider: SocialProvider,
    /// e.g. "github:user", "dns:example.com", "farcaster:0xhash"
    pub account_id: String,
    pub bidirectional_digest: Digest32,
}

/// A Thurin record mirrored on the identity node (thurin.security,
/// thurin.successor, thurin.canary, thurin.affiliation, thurin.releases...).
/// Records are declarations by the claim owner; they carry no enforcement.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct ThurinRecord {
    pub name: String,
    pub value_digest: Digest32,
}

/// The identity evidence payload anchored in the WormGraph.
///
/// Unsigned projection excludes `verifier_signature` (canonical.rs doctrine:
/// hashes identify content, admission establishes provenance).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct IdentityNode {
    /// v4 (40 hex) or v6 (64 hex) PGP fingerprint claimed on-chain.
    pub key_fingerprint: String,
    /// 0x-prefixed 20-byte Ethereum address owning the claim.
    pub ethereum_address: String,
    /// Claim index within PGPRegistry for the owner.
    pub registry_index: u32,
    /// BLAKE3(AKG:IDENTITY:ARMORED:v1, armoredKey(address, index)).
    pub armored_key_digest: Digest32,
    pub social_proofs: Vec<SocialProof>,
    pub records: Vec<ThurinRecord>,
    /// Verifier clock at admission (unix seconds), not a chain-claimed value.
    pub verified_at: i64,
    /// BLAKE3 over the bundle of per-proof bidirectional digests.
    pub proof_digest: Digest32,
    /// Ed25519 public key of the Arkhe-side verifier (governance roster).
    pub verifier_public_key: [u8; 32],
    /// Ed25519 signature over the unsigned canonical bytes.
    #[serde(with = "sig64")]
    pub verifier_signature: [u8; 64],
}

/// Untrusted readout of one PGPRegistry claim via free `eth_call`s.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ThurinClaimReadout {
    pub ethereum_address: String,
    pub registry_index: u32,
    pub armored_key: Vec<u8>,
    pub key_fingerprint: String,
    /// (record name, raw on-chain value ≤ 1 KB per Thurin records.md)
    pub records: Vec<(String, Vec<u8>)>,
}

/// Client-side verification result for one social proof. `notation_line` is
/// the `proof@thurin.id=URL` material from the key; `platform_line` is the
/// `thurin-id=openpgp4fpr:FPR` material from the account. `verified == false`
/// means the bidirectional check failed and admission must refuse it.
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ProofCheck {
    pub provider: SocialProvider,
    pub account_id: String,
    pub notation_line: Vec<u8>,
    pub platform_line: Vec<u8>,
    pub verified: bool,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum IdentityAdmissionError {
    MalformedAddress,
    MalformedFingerprint,
    NoProofs,
    UnverifiedProof { provider: SocialProvider },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum InvariantViolation {
    WellFormed,
    ClaimBinding,
    ArmoredBinding,
    ProofsVerified,
    ProofBundleBinding,
    RecordsBinding,
    Freshness,
    VerifierBinding,
    SignatureInvalid,
}

fn is_hex(s: &str) -> bool {
    !s.is_empty() && s.chars().all(|c| c.is_ascii_hexdigit())
}

/// serde only derives arrays up to 32 elements; signatures are 64 bytes.
pub(crate) mod sig64 {
    use serde::{de, Deserialize, Deserializer, Serialize, Serializer};
    pub fn serialize<S: Serializer>(v: &[u8; 64], s: S) -> Result<S::Ok, S::Error> {
        v.to_vec().serialize(s)
    }
    pub fn deserialize<'de, D: Deserializer<'de>>(d: D) -> Result<[u8; 64], D::Error> {
        let v = Vec::<u8>::deserialize(d)?;
        v.try_into()
            .map_err(|_| de::Error::custom("signature must be exactly 64 bytes"))
    }
}

/// v4 fingerprints are 40 hex chars, v6 are 64 (contracts.md).
fn fingerprint_ok(fp: &str) -> bool {
    is_hex(fp) && (fp.len() == 40 || fp.len() == 64)
}

fn address_ok(addr: &str) -> bool {
    addr.len() == 42 && addr.starts_with("0x") && is_hex(&addr[2..])
}

pub fn bidirectional_digest(check: &ProofCheck) -> Digest32 {
    let mut buf = Vec::new();
    buf.extend_from_slice(check.provider.domain_tag());
    buf.extend_from_slice(&check.notation_line);
    buf.push(0);
    buf.extend_from_slice(&check.platform_line);
    Digest32::blake3(b"AKG:IDENTITY:BIDIRECTIONAL:v1\0", &buf)
}

impl CanonicalEncode for IdentityNode {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:IDENTITY:v1\0";
    fn unsigned_projection(&self) -> Value {
        serde_json::json!({
            "key_fingerprint": self.key_fingerprint,
            "ethereum_address": self.ethereum_address,
            "registry_index": self.registry_index,
            "armored_key_digest": self.armored_key_digest,
            "social_proofs": self.social_proofs,
            "records": self.records,
            "verified_at": self.verified_at,
            "proof_digest": self.proof_digest,
            "verifier_public_key": self.verifier_public_key,
        })
    }
}

impl IdentityNode {
    /// Content digest over the unsigned canonical projection.
    pub fn digest(&self) -> Digest32 {
        CanonicalEncode::object_digest(self)
    }

    /// The admission boundary. Fails closed: any unverified proof, malformed
    /// claim field, or empty proof set refuses the node. On success every
    /// stored field is either derived from `readout`/`checks` or set here.
    pub fn admit(
        readout: &ThurinClaimReadout,
        checks: &[ProofCheck],
        verifier: &SigningKey,
        now: i64,
    ) -> Result<IdentityNode, IdentityAdmissionError> {
        if !address_ok(&readout.ethereum_address) {
            return Err(IdentityAdmissionError::MalformedAddress);
        }
        if !fingerprint_ok(&readout.key_fingerprint) {
            return Err(IdentityAdmissionError::MalformedFingerprint);
        }
        if checks.is_empty() {
            return Err(IdentityAdmissionError::NoProofs);
        }
        for check in checks {
            if !check.verified {
                return Err(IdentityAdmissionError::UnverifiedProof {
                    provider: check.provider,
                });
            }
        }

        let social_proofs: Vec<SocialProof> = checks
            .iter()
            .map(|check| SocialProof {
                provider: check.provider,
                account_id: check.account_id.clone(),
                bidirectional_digest: bidirectional_digest(check),
            })
            .collect();
        let mut bundle = Vec::new();
        for proof in &social_proofs {
            bundle.extend_from_slice(&proof.bidirectional_digest.0);
        }
        let proof_digest = Digest32::blake3(b"AKG:IDENTITY:PROOFBUNDLE:v1\0", &bundle);
        let records = readout
            .records
            .iter()
            .map(|(name, value)| ThurinRecord {
                name: name.clone(),
                value_digest: Digest32::blake3(b"AKG:IDENTITY:RECORDVALUE:v1\0", value),
            })
            .collect();

        let mut node = IdentityNode {
            key_fingerprint: readout.key_fingerprint.clone(),
            ethereum_address: readout.ethereum_address.clone(),
            registry_index: readout.registry_index,
            armored_key_digest: Digest32::blake3(
                b"AKG:IDENTITY:ARMORED:v1\0",
                &readout.armored_key,
            ),
            social_proofs,
            records,
            verified_at: now,
            proof_digest,
            verifier_public_key: verifier.verifying_key().to_bytes(),
            verifier_signature: [0u8; 64],
        };
        let signature = verifier.sign(&node.canonical_bytes());
        node.verifier_signature = signature.to_bytes();
        Ok(node)
    }

    /// AKG-IDENTITY-0001 §4 invariant, re-derived from the same untrusted
    /// inputs plus the expected verifier key (governance roster). A node
    /// present in the WormGraph must satisfy this against the readout it
    /// claims to summarise.
    pub fn invariant_holds(
        &self,
        readout: &ThurinClaimReadout,
        checks: &[ProofCheck],
        expected_verifier: &VerifyingKey,
        now: i64,
    ) -> Result<(), InvariantViolation> {
        if !address_ok(&self.ethereum_address) || !fingerprint_ok(&self.key_fingerprint) {
            return Err(InvariantViolation::WellFormed);
        }
        // (0) the node names the exact claim it summarises
        if self.key_fingerprint != readout.key_fingerprint
            || self.ethereum_address != readout.ethereum_address
            || self.registry_index != readout.registry_index
        {
            return Err(InvariantViolation::ClaimBinding);
        }
        // (1) armored key digest binds to the on-chain bytes
        if self.armored_key_digest
            != Digest32::blake3(b"AKG:IDENTITY:ARMORED:v1\0", &readout.armored_key)
        {
            return Err(InvariantViolation::ArmoredBinding);
        }
        // (2) every recorded proof was checked and matches its evidence lines
        if checks.is_empty() || self.social_proofs.len() != checks.len() {
            return Err(InvariantViolation::ProofsVerified);
        }
        for (proof, check) in self.social_proofs.iter().zip(checks) {
            if !check.verified
                || proof.provider != check.provider
                || proof.account_id != check.account_id
                || proof.bidirectional_digest != bidirectional_digest(check)
            {
                return Err(InvariantViolation::ProofsVerified);
            }
        }
        let mut bundle = Vec::new();
        for proof in &self.social_proofs {
            bundle.extend_from_slice(&proof.bidirectional_digest.0);
        }
        if self.proof_digest != Digest32::blake3(b"AKG:IDENTITY:PROOFBUNDLE:v1\0", &bundle) {
            return Err(InvariantViolation::ProofBundleBinding);
        }
        // records mirror the readout exactly
        if self.records.len() != readout.records.len() {
            return Err(InvariantViolation::RecordsBinding);
        }
        for (record, (name, value)) in self.records.iter().zip(&readout.records) {
            if record.name != *name
                || record.value_digest != Digest32::blake3(b"AKG:IDENTITY:RECORDVALUE:v1\0", value)
            {
                return Err(InvariantViolation::RecordsBinding);
            }
        }
        // (3) not attested in the future
        if self.verified_at > now {
            return Err(InvariantViolation::Freshness);
        }
        // (4) attested by the expected verifier, signature over unsigned bytes
        if self.verifier_public_key != expected_verifier.to_bytes() {
            return Err(InvariantViolation::VerifierBinding);
        }
        let signature = Signature::from_bytes(&self.verifier_signature);
        if expected_verifier
            .verify(&self.canonical_bytes(), &signature)
            .is_err()
        {
            return Err(InvariantViolation::SignatureInvalid);
        }
        Ok(())
    }
}

/// Envelope kind for identity evidence nodes.
pub const IDENTITY_KIND: &str = "ArkheIdentityNode";

/// Subject digest binds fingerprint ∥ address: successive claims (key
/// rotation, `thurin.successor`) share a subject and chain through
/// `causal_parents`.
fn identity_subject(node: &IdentityNode) -> Digest32 {
    let mut buf = Vec::new();
    buf.extend_from_slice(node.key_fingerprint.as_bytes());
    buf.extend_from_slice(node.ethereum_address.as_bytes());
    Digest32::blake3(b"AKG:IDENTITY:SUBJECT:v1\0", &buf)
}

pub fn identity_envelope(node: &IdentityNode, causal_parents: Vec<Digest32>) -> EvidenceEnvelope {
    let hash = node.digest();
    EvidenceEnvelope {
        record_hash: hash,
        kind: IDENTITY_KIND.into(),
        subject: identity_subject(node),
        payload_digest: hash,
        policy_digest: None,
        causal_parents,
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn verifier() -> SigningKey {
        SigningKey::from_bytes(&[7u8; 32])
    }

    fn other_verifier() -> SigningKey {
        SigningKey::from_bytes(&[9u8; 32])
    }

    fn readout() -> ThurinClaimReadout {
        ThurinClaimReadout {
            ethereum_address: "0x1234567890abcdef1234567890abcdef12345678".into(),
            registry_index: 0,
            armored_key: b"-----BEGIN PGP PUBLIC KEY BLOCK-----\n...\n".to_vec(),
            key_fingerprint: "ABCD1234ABCD1234ABCD1234ABCD1234ABCD1234".into(),
            records: vec![(
                "thurin.successor".into(),
                b"EFGH5678EFGH5678EFGH5678EFGH5678EFGH5678".to_vec(),
            )],
        }
    }

    fn checks() -> Vec<ProofCheck> {
        vec![
            ProofCheck {
                provider: SocialProvider::GitHub,
                account_id: "github:someone".into(),
                notation_line: b"proof@thurin.id=https://gist.github.com/someone/abc".to_vec(),
                platform_line: b"thurin-id=openpgp4fpr:ABCD1234ABCD1234ABCD1234ABCD1234ABCD1234"
                    .to_vec(),
                verified: true,
            },
            ProofCheck {
                provider: SocialProvider::Dns,
                account_id: "dns:example.com".into(),
                notation_line: b"proof@thurin.id=dns:example.com?type=TXT".to_vec(),
                platform_line: b"thurin-id=openpgp4fpr:ABCD1234ABCD1234ABCD1234ABCD1234ABCD1234"
                    .to_vec(),
                verified: true,
            },
        ]
    }

    const NOW: i64 = 1_800_000_000;

    fn admitted() -> IdentityNode {
        IdentityNode::admit(&readout(), &checks(), &verifier(), NOW).expect("valid fixture admits")
    }

    #[test]
    fn admit_ok_satisfies_invariant() {
        let node = admitted();
        node.invariant_holds(&readout(), &checks(), &verifier().verifying_key(), NOW)
            .expect("admitted node satisfies the invariant");
    }

    #[test]
    fn admit_is_deterministic_and_input_sensitive() {
        let a = admitted();
        let b = IdentityNode::admit(&readout(), &checks(), &verifier(), NOW).unwrap();
        assert_eq!(a.digest(), b.digest());
        let mut other = readout();
        other.armored_key.push(b'x');
        let c = IdentityNode::admit(&other, &checks(), &verifier(), NOW).unwrap();
        assert_ne!(a.digest(), c.digest());
    }

    #[test]
    fn admit_fails_closed() {
        assert_eq!(
            IdentityNode::admit(&readout(), &[], &verifier(), NOW),
            Err(IdentityAdmissionError::NoProofs)
        );
        let mut unverified = checks();
        unverified[1].verified = false;
        assert_eq!(
            IdentityNode::admit(&readout(), &unverified, &verifier(), NOW),
            Err(IdentityAdmissionError::UnverifiedProof {
                provider: SocialProvider::Dns
            })
        );
        let mut bad_address = readout();
        bad_address.ethereum_address = "0xZZ".into();
        assert_eq!(
            IdentityNode::admit(&bad_address, &checks(), &verifier(), NOW),
            Err(IdentityAdmissionError::MalformedAddress)
        );
        let mut bad_fp = readout();
        bad_fp.key_fingerprint = "short".into();
        assert_eq!(
            IdentityNode::admit(&bad_fp, &checks(), &verifier(), NOW),
            Err(IdentityAdmissionError::MalformedFingerprint)
        );
    }

    #[test]
    fn tampered_nodes_are_detected() {
        let expected = &verifier().verifying_key();

        let mut swap = admitted();
        swap.armored_key_digest = Digest32::ZERO;
        assert_eq!(
            swap.invariant_holds(&readout(), &checks(), expected, NOW),
            Err(InvariantViolation::ArmoredBinding)
        );

        let mut future = admitted();
        future.verified_at = NOW + 1;
        assert_eq!(
            future.invariant_holds(&readout(), &checks(), expected, NOW),
            Err(InvariantViolation::Freshness)
        );

        let mut forged = admitted();
        forged.verifier_signature[0] ^= 1;
        assert_eq!(
            forged.invariant_holds(&readout(), &checks(), expected, NOW),
            Err(InvariantViolation::SignatureInvalid)
        );

        let foreign = admitted();
        assert_eq!(
            foreign.invariant_holds(
                &readout(),
                &checks(),
                &other_verifier().verifying_key(),
                NOW
            ),
            Err(InvariantViolation::VerifierBinding)
        );

        let mut one_less = admitted();
        one_less.social_proofs.pop();
        assert_eq!(
            one_less.invariant_holds(&readout(), &checks(), expected, NOW),
            Err(InvariantViolation::ProofsVerified)
        );

        // stale proof set: the chain readout rotated but the node did not
        let node = admitted();
        let mut rotated = checks();
        rotated[0].notation_line = b"proof@thurin.id=https://gist.github.com/someon2/xyz".to_vec();
        assert_eq!(
            node.invariant_holds(&readout(), &rotated, expected, NOW),
            Err(InvariantViolation::ProofsVerified)
        );
    }

    #[test]
    fn envelope_binds_payload_and_subject() {
        let node = admitted();
        let envelope = identity_envelope(&node, vec![]);
        assert_eq!(envelope.kind, IDENTITY_KIND);
        assert_eq!(envelope.record_hash, node.digest());
        assert_eq!(envelope.payload_digest, node.digest());
        assert_eq!(envelope.subject, identity_subject(&node));
        assert!(envelope.causal_parents.is_empty());
        let parent = Digest32::ZERO;
        assert_eq!(
            identity_envelope(&node, vec![parent]).causal_parents,
            vec![parent]
        );
    }

    #[tokio::test]
    async fn wormgraph_anchors_identity_evidence() {
        use crate::{EvidenceCommitter, EvidenceReader, WormGraph};
        let graph = WormGraph::new();
        let node = admitted();
        let envelope = identity_envelope(&node, vec![]);
        let id = graph.append_verified(envelope.clone()).await.unwrap();
        assert_eq!(id, envelope.record_hash);
        // idempotent re-append of the identical envelope
        graph.append_verified(envelope.clone()).await.unwrap();
        // same record_hash bound to a different envelope is refused
        let mut conflicting = envelope.clone();
        conflicting.subject = Digest32::ZERO;
        assert!(graph.append_verified(conflicting).await.is_err());
        let stored = graph.get(envelope.record_hash).await.unwrap().unwrap();
        assert_eq!(stored, envelope);
    }

    /// xorshift64* — deterministic, dependency-free property-test randomness.
    struct Rng(u64);
    impl Rng {
        fn new(seed: u64) -> Self {
            Rng(seed | 1)
        }
        fn next_u64(&mut self) -> u64 {
            let mut x = self.0;
            x ^= x >> 12;
            x ^= x << 25;
            x ^= x >> 27;
            self.0 = x;
            x.wrapping_mul(0x2545F4914F6CDD1D)
        }
        fn below(&mut self, n: usize) -> usize {
            (self.next_u64() % n as u64) as usize
        }
        fn flip_byte(&mut self, bytes: &mut [u8]) {
            let i = self.below(bytes.len());
            bytes[i] ^= 1 << self.below(8);
        }
    }

    /// Property-style coverage of the invariant clauses (interim stand-in
    /// for the Kani harnesses, which need the Kani toolchain): every seeded
    /// semantic mutation of the untrusted inputs is either refused by
    /// `admit` or produces a node that fails `invariant_holds` against the
    /// untampered context; every seeded corruption of a valid node is
    /// detected.
    #[test]
    fn property_mutations_never_yield_an_accepted_false_node() {
        let mut rng = Rng::new(0x1DE7F1);
        for _ in 0..512 {
            let mut input_readout = readout();
            let mut input_checks = checks();
            match rng.below(7) {
                0 => rng.flip_byte(&mut input_readout.armored_key),
                1 => rng.flip_byte(&mut input_readout.records[0].1),
                2 => {
                    let i = rng.below(input_checks.len());
                    rng.flip_byte(&mut input_checks[i].notation_line);
                }
                3 => {
                    let i = rng.below(input_checks.len());
                    rng.flip_byte(&mut input_checks[i].platform_line);
                }
                4 => {
                    let i = rng.below(input_checks.len());
                    input_checks[i].verified = false;
                }
                5 => {
                    // hex-preserving content change on the fingerprint,
                    // guaranteed to differ from the original character
                    let i = rng.below(input_readout.key_fingerprint.len());
                    let original = input_readout.key_fingerprint.as_bytes()[i] as char;
                    let chars: Vec<char> = "0123456789abcdefABCDEF"
                        .chars()
                        .filter(|c| *c != original)
                        .collect();
                    input_readout
                        .key_fingerprint
                        .replace_range(i..i + 1, &chars[rng.below(chars.len())].to_string());
                }
                _ => input_readout.registry_index = input_readout.registry_index.wrapping_add(1),
            }
            if let Ok(node) = IdentityNode::admit(&input_readout, &input_checks, &verifier(), NOW) {
                // format-valid mutations still admit; the node must now
                // disagree with the untampered context
                assert!(node
                    .invariant_holds(&readout(), &checks(), &verifier().verifying_key(), NOW)
                    .is_err());
            }
        }
    }

    #[test]
    fn property_node_corruptions_are_detected() {
        let mut rng = Rng::new(0xC0FFEE);
        for _ in 0..512 {
            let mut node = admitted();
            match rng.below(6) {
                0 => node.armored_key_digest.0[rng.below(32)] ^= 1 << rng.below(8),
                1 => node.verified_at = NOW + 1 + rng.below(1000) as i64,
                2 => node.verifier_signature[rng.below(64)] ^= 1 << rng.below(8),
                3 => node.verifier_public_key[rng.below(32)] ^= 1 << rng.below(8),
                4 => {
                    let i = rng.below(node.social_proofs.len());
                    node.social_proofs[i].bidirectional_digest.0[rng.below(32)] ^=
                        1 << rng.below(8);
                }
                _ => {
                    let i = rng.below(node.records.len());
                    node.records[i].value_digest.0[rng.below(32)] ^= 1 << rng.below(8);
                }
            }
            assert!(node
                .invariant_holds(&readout(), &checks(), &verifier().verifying_key(), NOW)
                .is_err());
        }
    }
}

#[cfg(kani)]
mod kani_proofs {
    use super::*;

    /// Tamper selector explored symbolically. Crypto artifacts are concrete
    /// (executed concretely under Kani); the selector enumerates every way
    /// the untrusted inputs or the resulting node can deviate.
    #[derive(Debug, Clone, Copy, PartialEq, Eq)]
    enum Tamper {
        None,
        MalformedAddress,
        UnverifiedProof,
        EmptyProofs,
        SwapArmoredDigest,
        SwapFingerprint,
        FutureTimestamp,
        CorruptSignature,
        ForeignVerifierKey,
        DropLastProof,
    }

    fn fixture_verifier() -> SigningKey {
        SigningKey::from_bytes(&[7u8; 32])
    }

    fn fixture_readout() -> ThurinClaimReadout {
        ThurinClaimReadout {
            ethereum_address: "0x1234567890abcdef1234567890abcdef12345678".into(),
            registry_index: 0,
            armored_key: b"-----BEGIN PGP PUBLIC KEY BLOCK-----\n...\n".to_vec(),
            key_fingerprint: "ABCD1234ABCD1234ABCD1234ABCD1234ABCD1234".into(),
            records: vec![(
                "thurin.security".into(),
                b"mailto:security@example.com".to_vec(),
            )],
        }
    }

    fn fixture_checks() -> Vec<ProofCheck> {
        vec![
            ProofCheck {
                provider: SocialProvider::GitHub,
                account_id: "github:someone".into(),
                notation_line: b"proof@thurin.id=https://gist.github.com/someone/abc".to_vec(),
                platform_line: b"thurin-id=openpgp4fpr:ABCD".to_vec(),
                verified: true,
            },
            ProofCheck {
                provider: SocialProvider::Dns,
                account_id: "dns:example.com".into(),
                notation_line: b"proof@thurin.id=dns:example.com?type=TXT".to_vec(),
                platform_line: b"thurin-id=openpgp4fpr:ABCD".to_vec(),
                verified: true,
            },
        ]
    }

    const NOW: i64 = 1_800_000_000;

    fn tampered_readout(tamper: Tamper) -> ThurinClaimReadout {
        let mut readout = fixture_readout();
        if tamper == Tamper::MalformedAddress {
            readout.ethereum_address = "0xnothex".into();
        }
        readout
    }

    fn tampered_checks(tamper: Tamper) -> Vec<ProofCheck> {
        let mut checks = fixture_checks();
        match tamper {
            Tamper::UnverifiedProof => checks[1].verified = false,
            Tamper::EmptyProofs => checks.clear(),
            _ => {}
        }
        checks
    }

    /// Soundness + fail-closed admission: `admit` returns a node only on the
    /// untampered path, and any node it returns satisfies the invariant
    /// against the untampered context (readout, checks, expected key, now).
    #[kani::proof]
    fn admit_is_sound_and_fails_closed() {
        let tamper: Tamper = kani::any();
        let verifier = fixture_verifier();
        let expected = verifier.verifying_key();
        match IdentityNode::admit(
            &tampered_readout(tamper),
            &tampered_checks(tamper),
            &verifier,
            NOW,
        ) {
            Ok(node) => {
                assert_eq!(tamper, Tamper::None, "only untampered inputs admit");
                assert!(node
                    .invariant_holds(&fixture_readout(), &fixture_checks(), &expected, NOW)
                    .is_ok());
            }
            Err(_) => {
                assert_ne!(tamper, Tamper::None, "untampered inputs must admit");
            }
        }
    }

    /// Tamper detection: every deviation of a valid node from the context it
    /// claims to summarise is caught by `invariant_holds`.
    #[kani::proof]
    fn tampered_nodes_violate_the_invariant() {
        let tamper: Tamper = kani::any();
        let verifier = fixture_verifier();
        let expected = verifier.verifying_key();
        let mut node = IdentityNode::admit(&fixture_readout(), &fixture_checks(), &verifier, NOW)
            .expect("fixture admits");
        let mut node_tampered = true;
        match tamper {
            Tamper::SwapArmoredDigest => node.armored_key_digest = Digest32::ZERO,
            Tamper::SwapFingerprint => {
                // format-valid but names a different claim
                node.key_fingerprint = "FFFF1234ABCD1234ABCD1234ABCD1234ABCD1234".into();
            }
            Tamper::FutureTimestamp => node.verified_at = NOW + 1,
            Tamper::CorruptSignature => node.verifier_signature[0] ^= 1,
            Tamper::ForeignVerifierKey => node.verifier_public_key = [9u8; 32],
            Tamper::DropLastProof => {
                node.social_proofs.pop();
            }
            // input-level tampers leave the admitted node intact; they are
            // covered by `admit_is_sound_and_fails_closed`
            Tamper::None
            | Tamper::MalformedAddress
            | Tamper::UnverifiedProof
            | Tamper::EmptyProofs => node_tampered = false,
        }
        if node_tampered {
            assert!(node
                .invariant_holds(&fixture_readout(), &fixture_checks(), &expected, NOW)
                .is_err());
        } else {
            assert!(node
                .invariant_holds(&fixture_readout(), &fixture_checks(), &expected, NOW)
                .is_ok());
        }
    }

    /// Envelope binding: record_hash and payload_digest both equal the node
    /// digest, so the WormGraph's content-addressed key is the identity node.
    #[kani::proof]
    fn envelope_binds_identity_payload() {
        let verifier = fixture_verifier();
        let node =
            IdentityNode::admit(&fixture_readout(), &fixture_checks(), &verifier, NOW).unwrap();
        let parent = Digest32::ZERO;
        let envelope = identity_envelope(&node, vec![parent]);
        assert_eq!(envelope.record_hash, node.digest());
        assert_eq!(envelope.payload_digest, node.digest());
        assert_eq!(envelope.causal_parents, vec![parent]);
        assert_eq!(envelope.kind, IDENTITY_KIND);
    }
}
