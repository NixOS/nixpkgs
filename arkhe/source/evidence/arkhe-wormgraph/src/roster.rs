//! AKG-IDENTITY-0002 v0.1 — verifier roster and identity-evidence admission.
//!
//! The `IdentityNode` (AKG-IDENTITY-0001) proves that *a key* read the chain
//! and verified the social proofs at `verified_at`. It cannot prove that the
//! key was *authorized* to say so. Trust in the verifier is a governance
//! decision, not a cryptographic property of the node. This module is that
//! decision: a `GovernanceRoster` maps `verifier_pubkey → role` under a
//! quorum, and `identity_proven` is the consumer that refuses nodes signed
//! outside the roster.
//!
//! Genesis is an out-of-band trust anchor: whoever configures the genesis
//! roster (and its approvals) decides the initial authority set. Succession
//! is on-chain: amendments require a quorum of the *previous* roster, and
//! each version chains to its parent through the envelope `causal_parents`,
//! so the WormGraph holds the full amendment history.
//!
//! This remains identity-side plumbing. Resolving a role is not granting an
//! authorization: `ProtectedTransitionAllowed ⇒ VerificationCompleted ∧
//! IdentityProven` — this module produces `IdentityProven`; the
//! ContainmentGate still decides the transition.

use crate::identity::{sig64, IdentityNode, InvariantViolation, ProofCheck, ThurinClaimReadout};
use arkhe_core::evidence::EvidenceEnvelope;
use arkhe_core::{CanonicalEncode, Digest32};
use ed25519_dalek::{Signature, Signer, SigningKey, Verifier, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::Value;

/// Roles a verifier key may hold in governance. Declarations, not
/// permissions: what a role may do is decided by consumers (ContainmentGate,
/// ReviewRouter), never here.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum VerifierRole {
    Operator,
    Auditor,
    Regulator,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct RosterEntry {
    pub verifier_public_key: [u8; 32],
    pub role: VerifierRole,
    /// unix seconds; the entry is active for `valid_from..=valid_until`
    pub valid_from: i64,
    /// None = no expiry
    pub valid_until: Option<i64>,
}

impl RosterEntry {
    pub fn covers(&self, at: i64) -> bool {
        self.valid_from <= at && self.valid_until.is_none_or(|u| at <= u)
    }
}

/// One quorum approval: an Ed25519 signature by a roster member over the
/// unsigned canonical roster bytes.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct RosterApproval {
    pub signer_public_key: [u8; 32],
    #[serde(with = "sig64")]
    pub signature: [u8; 64],
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum RosterViolation {
    EmptyRoster,
    MalformedEntry,
    MalformedVersion,
    SignatureInvalid,
    DuplicateSigner,
    SignerNotInAuthority,
    QuorumNotMet,
}

/// The authority a roster's approvals are checked against: the roster itself
/// (genesis, self-anchored) or its predecessor (succession).
enum Authority<'a> {
    GenesisSelf,
    Parent(&'a GovernanceRoster),
}

/// Quorum-signed verifier roster, anchored in the WormGraph.
///
/// Unsigned projection excludes `approvals` (AKG-CBOR-v1 doctrine).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct GovernanceRoster {
    /// strictly increasing; genesis is 1
    pub version: u32,
    /// distinct approvals required, checked against the authority set
    pub quorum_threshold: usize,
    pub entries: Vec<RosterEntry>,
    pub approvals: Vec<RosterApproval>,
}

impl CanonicalEncode for GovernanceRoster {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:ROSTER:v1\0";
    fn unsigned_projection(&self) -> Value {
        serde_json::json!({
            "version": self.version,
            "quorum_threshold": self.quorum_threshold,
            "entries": self.entries,
        })
    }
}

impl GovernanceRoster {
    /// Content digest over the unsigned canonical projection.
    pub fn digest(&self) -> Digest32 {
        CanonicalEncode::object_digest(self)
    }

    /// Self-anchored genesis. Every approval signer must be one of the
    /// entries being admitted; the initial authority set is therefore
    /// whatever the bootstrap configuration says it is. This is the
    /// documented out-of-band trust anchor, not a derived truth.
    pub fn genesis(
        entries: Vec<RosterEntry>,
        quorum_threshold: usize,
        approvals: &[RosterApproval],
    ) -> Result<GovernanceRoster, RosterViolation> {
        let roster = GovernanceRoster {
            version: 1,
            quorum_threshold,
            entries,
            approvals: approvals.to_vec(),
        };
        roster.verify_inner(&Authority::GenesisSelf)?;
        Ok(roster)
    }

    /// Amendment: requires a quorum of the *current* roster, active at
    /// `now`. The new roster's version is `self.version + 1`.
    pub fn succeed(
        &self,
        entries: Vec<RosterEntry>,
        quorum_threshold: usize,
        approvals: &[RosterApproval],
        now: i64,
    ) -> Result<GovernanceRoster, RosterViolation> {
        if self.quorum_threshold > self.approvals_len_distinct() {
            return Err(RosterViolation::QuorumNotMet);
        }
        let roster = GovernanceRoster {
            version: self
                .version
                .checked_add(1)
                .ok_or(RosterViolation::MalformedVersion)?,
            quorum_threshold,
            entries,
            approvals: approvals.to_vec(),
        };
        roster.verify_inner(&Authority::Parent(self))?;
        // quorum of the OLD roster: threshold from self, signers active in
        // self at `now`
        if roster
            .approvals
            .iter()
            .filter(|a| {
                self.entries
                    .iter()
                    .any(|e| e.verifier_public_key == a.signer_public_key && e.covers(now))
            })
            .count()
            < self.quorum_threshold
        {
            return Err(RosterViolation::QuorumNotMet);
        }
        Ok(roster)
    }

    /// Re-derive everything a reader of a stored roster must check:
    /// well-formed entries, valid approvals by the authority set, no
    /// duplicate signers, quorum met, and version succession when a parent
    /// is known.
    pub fn verify(
        &self,
        parent: Option<&GovernanceRoster>,
        now: i64,
    ) -> Result<(), RosterViolation> {
        match parent {
            None => self.verify_inner(&Authority::GenesisSelf),
            Some(parent) => {
                let out = self.verify_inner(&Authority::Parent(parent));
                if out.is_ok() && self.version != parent.version.wrapping_add(1) {
                    return Err(RosterViolation::MalformedVersion);
                }
                if out.is_ok()
                    && self
                        .approvals
                        .iter()
                        .filter(|a| {
                            parent.entries.iter().any(|e| {
                                e.verifier_public_key == a.signer_public_key && e.covers(now)
                            })
                        })
                        .count()
                        < parent.quorum_threshold
                {
                    return Err(RosterViolation::QuorumNotMet);
                }
                out
            }
        }
    }

    fn verify_inner(&self, authority: &Authority) -> Result<(), RosterViolation> {
        if self.entries.is_empty() {
            return Err(RosterViolation::EmptyRoster);
        }
        if self.version == 0 {
            return Err(RosterViolation::MalformedVersion);
        }
        for entry in &self.entries {
            if let Some(until) = entry.valid_until {
                if entry.valid_from > until {
                    return Err(RosterViolation::MalformedEntry);
                }
            }
        }
        for (i, a) in self.entries.iter().enumerate() {
            if self.entries[i + 1..]
                .iter()
                .any(|b| b.verifier_public_key == a.verifier_public_key)
            {
                return Err(RosterViolation::MalformedEntry);
            }
        }
        let bytes = self.canonical_bytes();
        for (i, approval) in self.approvals.iter().enumerate() {
            if self.approvals[i + 1..]
                .iter()
                .any(|b| b.signer_public_key == approval.signer_public_key)
            {
                return Err(RosterViolation::DuplicateSigner);
            }
            let key = VerifyingKey::from_bytes(&approval.signer_public_key)
                .map_err(|_| RosterViolation::SignerNotInAuthority)?;
            if key
                .verify(&bytes, &Signature::from_bytes(&approval.signature))
                .is_err()
            {
                return Err(RosterViolation::SignatureInvalid);
            }
            let authorized = match authority {
                Authority::GenesisSelf => self
                    .entries
                    .iter()
                    .any(|e| e.verifier_public_key == approval.signer_public_key),
                Authority::Parent(parent) => parent
                    .entries
                    .iter()
                    .any(|e| e.verifier_public_key == approval.signer_public_key),
            };
            if !authorized {
                return Err(RosterViolation::SignerNotInAuthority);
            }
        }
        if self.approvals.len() < self.quorum_threshold {
            return Err(RosterViolation::QuorumNotMet);
        }
        Ok(())
    }

    fn approvals_len_distinct(&self) -> usize {
        self.approvals.len()
    }

    /// The entry for an exact verifier key, if present.
    pub fn entry_for(&self, verifier_public_key: &[u8; 32]) -> Option<&RosterEntry> {
        self.entries
            .iter()
            .find(|e| &e.verifier_public_key == verifier_public_key)
    }

    /// Role of a verifier key at time `at`, if the entry covers `at`.
    pub fn resolve(&self, verifier_public_key: &[u8; 32], at: i64) -> Option<VerifierRole> {
        let entry = self.entry_for(verifier_public_key)?;
        entry.covers(at).then_some(entry.role)
    }
}

/// Envelope kind for roster versions.
pub const ROSTER_KIND: &str = "ArkheGovernanceRoster";

/// One lineage: every version shares this subject and chains to its
/// predecessor through `causal_parents`.
pub fn roster_lineage_subject() -> Digest32 {
    Digest32::blake3(b"AKG:ROSTER:LINEAGE:v1\0", b"arkhe-verifier-roster")
}

pub fn roster_envelope(
    roster: &GovernanceRoster,
    causal_parents: Vec<Digest32>,
) -> EvidenceEnvelope {
    let hash = roster.digest();
    EvidenceEnvelope {
        record_hash: hash,
        kind: ROSTER_KIND.into(),
        subject: roster_lineage_subject(),
        payload_digest: hash,
        policy_digest: None,
        causal_parents,
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum IdentityProvenanceError {
    RosterInvalid(RosterViolation),
    NotInRoster,
    MembershipWindow,
    NodeInvariant(InvariantViolation),
}

/// The consumer end of AKG-IDENTITY-0001: `IdentityProven`.
///
/// Verifies the roster (against its parent when known — the parent comes
/// from the envelope's `causal_parents` in the WormGraph), resolves the
/// node's verifier key to a role, and only then accepts the node's own
/// invariant. A node signed by a key outside the roster, or by a verifier
/// outside its active window, is refused. Returns the verifier's role: what
/// that role authorizes is the ContainmentGate's question, not this one.
pub fn identity_proven(
    node: &IdentityNode,
    readout: &ThurinClaimReadout,
    checks: &[ProofCheck],
    roster: &GovernanceRoster,
    parent_roster: Option<&GovernanceRoster>,
    now: i64,
) -> Result<VerifierRole, IdentityProvenanceError> {
    roster
        .verify(parent_roster, now)
        .map_err(IdentityProvenanceError::RosterInvalid)?;
    let entry = roster
        .entry_for(&node.verifier_public_key)
        .ok_or(IdentityProvenanceError::NotInRoster)?;
    if !entry.covers(now) {
        return Err(IdentityProvenanceError::MembershipWindow);
    }
    let expected = VerifyingKey::from_bytes(&node.verifier_public_key)
        .expect("32-byte key from a roster entry");
    node.invariant_holds(readout, checks, &expected, now)
        .map_err(IdentityProvenanceError::NodeInvariant)?;
    Ok(entry.role)
}

/// Convenience for building a valid approval in tests and tooling.
pub fn sign_roster_approval(roster_bytes: &[u8], signer: &SigningKey) -> RosterApproval {
    let signature = signer.sign(roster_bytes);
    RosterApproval {
        signer_public_key: signer.verifying_key().to_bytes(),
        signature: signature.to_bytes(),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::identity::{SocialProvider, ThurinClaimReadout};

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
        fn below(&mut self, n: u64) -> u64 {
            self.next_u64() % n
        }
    }

    fn key(i: u8) -> SigningKey {
        SigningKey::from_bytes(&[i; 32])
    }

    const NOW: i64 = 1_800_000_000;
    const VALID_FROM: i64 = 1_700_000_000;

    fn entries() -> Vec<RosterEntry> {
        vec![
            RosterEntry {
                verifier_public_key: key(1).verifying_key().to_bytes(),
                role: VerifierRole::Operator,
                valid_from: VALID_FROM,
                valid_until: None,
            },
            RosterEntry {
                verifier_public_key: key(2).verifying_key().to_bytes(),
                role: VerifierRole::Auditor,
                valid_from: VALID_FROM,
                valid_until: Some(NOW + 1000),
            },
            RosterEntry {
                verifier_public_key: key(3).verifying_key().to_bytes(),
                role: VerifierRole::Regulator,
                valid_from: VALID_FROM,
                valid_until: None,
            },
        ]
    }

    fn approve(bytes: &[u8], signers: &[u8]) -> Vec<RosterApproval> {
        signers
            .iter()
            .map(|&i| sign_roster_approval(bytes, &key(i)))
            .collect()
    }

    fn genesis() -> GovernanceRoster {
        let mut roster = GovernanceRoster {
            version: 1,
            quorum_threshold: 2,
            entries: entries(),
            approvals: vec![],
        };
        roster.approvals = approve(&roster.canonical_bytes(), &[1, 2]);
        GovernanceRoster::genesis(entries(), 2, &roster.approvals).unwrap()
    }

    #[test]
    fn genesis_admits_with_quorum_and_resolves_roles() {
        let roster = genesis();
        roster.verify(None, NOW).unwrap();
        assert_eq!(
            roster.resolve(&key(1).verifying_key().to_bytes(), NOW),
            Some(VerifierRole::Operator)
        );
        assert_eq!(
            roster.resolve(&key(4).verifying_key().to_bytes(), NOW),
            None
        );
    }

    #[test]
    fn genesis_fails_closed() {
        // below quorum
        let mut roster = GovernanceRoster {
            version: 1,
            quorum_threshold: 2,
            entries: entries(),
            approvals: vec![],
        };
        roster.approvals = approve(&roster.canonical_bytes(), &[1]);
        assert_eq!(
            GovernanceRoster::genesis(entries(), 2, &roster.approvals),
            Err(RosterViolation::QuorumNotMet)
        );
        // foreign signer
        roster.approvals = approve(&roster.canonical_bytes(), &[1, 4]);
        assert_eq!(
            GovernanceRoster::genesis(entries(), 2, &roster.approvals),
            Err(RosterViolation::SignerNotInAuthority)
        );
        // corrupted signature
        roster.approvals = approve(&roster.canonical_bytes(), &[1, 2]);
        let mut bad = roster.approvals[0].clone();
        bad.signature[0] ^= 1;
        assert_eq!(
            GovernanceRoster::genesis(entries(), 2, &[roster.approvals[1].clone(), bad]),
            Err(RosterViolation::SignatureInvalid)
        );
    }

    #[test]
    fn succession_requires_old_quorum_and_versions_chain() {
        let parent = genesis();
        // entry 2 expires at NOW+1000; drop it, keep 1 and 3, add 4
        let mut next_entries = entries();
        next_entries.remove(1);
        next_entries.push(RosterEntry {
            verifier_public_key: key(4).verifying_key().to_bytes(),
            role: VerifierRole::Auditor,
            valid_from: NOW,
            valid_until: None,
        });
        let mut draft = GovernanceRoster {
            version: parent.version + 1,
            quorum_threshold: 2,
            entries: next_entries.clone(),
            approvals: vec![],
        };
        // quorum of signers from the OLD roster
        draft.approvals = approve(&draft.canonical_bytes(), &[1, 3]);
        let child = parent
            .succeed(next_entries.clone(), 2, &draft.approvals, NOW)
            .unwrap();
        assert_eq!(child.version, 2);
        child.verify(Some(&parent), NOW).unwrap();
        assert_eq!(
            child.resolve(&key(4).verifying_key().to_bytes(), NOW),
            Some(VerifierRole::Auditor)
        );
        // removed key no longer resolves
        assert_eq!(child.resolve(&key(2).verifying_key().to_bytes(), NOW), None);

        // signers from outside the old roster are refused
        draft.approvals = approve(&draft.canonical_bytes(), &[1, 4]);
        assert_eq!(
            parent.succeed(next_entries, 2, &draft.approvals, NOW),
            Err(RosterViolation::SignerNotInAuthority)
        );
    }

    fn identity_fixture(
        verifier: &SigningKey,
    ) -> (IdentityNode, ThurinClaimReadout, Vec<ProofCheck>) {
        let readout = ThurinClaimReadout {
            ethereum_address: "0x1234567890abcdef1234567890abcdef12345678".into(),
            registry_index: 0,
            armored_key: b"-----BEGIN PGP PUBLIC KEY BLOCK-----\n...\n".to_vec(),
            key_fingerprint: "ABCD1234ABCD1234ABCD1234ABCD1234ABCD1234".into(),
            records: vec![(
                "thurin.security".into(),
                b"mailto:security@example.com".to_vec(),
            )],
        };
        let checks = vec![ProofCheck {
            provider: SocialProvider::GitHub,
            account_id: "github:someone".into(),
            notation_line: b"proof@thurin.id=https://gist.github.com/someone/abc".to_vec(),
            platform_line: b"thurin-id=openpgp4fpr:ABCD".to_vec(),
            verified: true,
        }];
        let node = IdentityNode::admit(&readout, &checks, verifier, NOW).unwrap();
        (node, readout, checks)
    }

    #[test]
    fn node_signed_outside_roster_is_rejected() {
        let roster = genesis();
        let (node, readout, checks) = identity_fixture(&key(9)); // not in roster
        assert_eq!(
            identity_proven(&node, &readout, &checks, &roster, None, NOW),
            Err(IdentityProvenanceError::NotInRoster)
        );
    }

    #[test]
    fn node_by_expired_verifier_is_rejected() {
        let roster = genesis();
        // entry 2 expires at NOW+1000
        let (node, readout, checks) = identity_fixture(&key(2));
        assert_eq!(
            identity_proven(&node, &readout, &checks, &roster, None, NOW + 2000),
            Err(IdentityProvenanceError::MembershipWindow)
        );
    }

    #[test]
    fn node_by_active_verifier_resolves_role() {
        let roster = genesis();
        let (node, readout, checks) = identity_fixture(&key(3));
        assert_eq!(
            identity_proven(&node, &readout, &checks, &roster, None, NOW),
            Ok(VerifierRole::Regulator)
        );
    }

    #[test]
    fn tampered_node_is_rejected_through_consumer() {
        let roster = genesis();
        let (mut node, readout, checks) = identity_fixture(&key(1));
        node.verifier_signature[7] ^= 1;
        assert_eq!(
            identity_proven(&node, &readout, &checks, &roster, None, NOW),
            Err(IdentityProvenanceError::NodeInvariant(
                InvariantViolation::SignatureInvalid
            ))
        );
    }

    #[test]
    fn roster_envelope_chains_lineage() {
        let roster = genesis();
        let parent_hash = Digest32::ZERO;
        let envelope = roster_envelope(&roster, vec![parent_hash]);
        assert_eq!(envelope.kind, ROSTER_KIND);
        assert_eq!(envelope.record_hash, roster.digest());
        assert_eq!(envelope.subject, roster_lineage_subject());
        assert_eq!(envelope.causal_parents, vec![parent_hash]);
    }

    /// Property-style check: `resolve` is exactly the membership window.
    /// 512 symbolic-ish times from a seeded generator, cross-checked
    /// against a direct scan of the entries.
    #[test]
    fn resolve_equals_membership_window() {
        let roster = genesis();
        let mut rng = Rng::new(0xA11CE);
        for _ in 0..512 {
            let at = (rng.next_u64() % 4_000_000_000) as i64 - 1_000_000_000;
            for i in 1..=4u8 {
                let key_bytes = key(i).verifying_key().to_bytes();
                let direct = roster
                    .entries
                    .iter()
                    .find(|e| e.verifier_public_key == key_bytes)
                    .map(|e| e.covers(at));
                match direct {
                    Some(true) => assert!(roster.resolve(&key_bytes, at).is_some()),
                    _ => assert_eq!(roster.resolve(&key_bytes, at), None),
                }
            }
        }
    }

    /// Property-style check: every seeded corruption of a valid roster is
    /// refused by `verify` (never silently accepted).
    #[test]
    fn corrupted_rosters_are_refused() {
        let mut rng = Rng::new(0x5EED);
        for _ in 0..256 {
            let mut roster = genesis();
            match rng.below(4) {
                0 => {
                    let i = rng.below(roster.approvals.len() as u64) as usize;
                    let bit = rng.below(64) as usize;
                    roster.approvals[i].signature[bit / 8] ^= 1 << (bit % 8);
                }
                1 => {
                    let i = rng.below(roster.approvals.len() as u64) as usize;
                    roster.approvals[i].signer_public_key = key(9).verifying_key().to_bytes();
                }
                2 => {
                    // swap an entry's role so signers fall out of authority
                    roster.entries[0].verifier_public_key = key(9).verifying_key().to_bytes();
                }
                _ => {
                    roster.approvals.pop();
                    if roster.approvals.len() >= roster.quorum_threshold {
                        continue;
                    }
                }
            }
            assert!(roster.verify(None, NOW).is_err(), "corruption accepted");
        }
    }
}

#[cfg(kani)]
mod kani_proofs {
    use super::*;

    fn concrete_roster() -> GovernanceRoster {
        // concrete signing; see identity.rs kani_proofs for the pattern
        let k1 = SigningKey::from_bytes(&[1u8; 32]);
        let k2 = SigningKey::from_bytes(&[2u8; 32]);
        let entries = vec![
            RosterEntry {
                verifier_public_key: k1.verifying_key().to_bytes(),
                role: VerifierRole::Operator,
                valid_from: 100,
                valid_until: None,
            },
            RosterEntry {
                verifier_public_key: k2.verifying_key().to_bytes(),
                role: VerifierRole::Auditor,
                valid_from: 200,
                valid_until: Some(300),
            },
        ];
        let mut draft = GovernanceRoster {
            version: 1,
            quorum_threshold: 2,
            entries: entries.clone(),
            approvals: vec![],
        };
        let bytes = draft.canonical_bytes();
        draft.approvals = vec![
            sign_roster_approval(&bytes, &k1),
            sign_roster_approval(&bytes, &k2),
        ];
        GovernanceRoster::genesis(entries, 2, &draft.approvals).expect("fixture admits")
    }

    /// Genuinely symbolic: for every i64 time, `resolve` answers membership
    /// exactly (open/closed window edges included). No crypto on this path.
    #[kani::proof]
    fn resolve_is_exactly_the_membership_window() {
        let roster = concrete_roster();
        let k1 = SigningKey::from_bytes(&[1u8; 32])
            .verifying_key()
            .to_bytes();
        let k2 = SigningKey::from_bytes(&[2u8; 32])
            .verifying_key()
            .to_bytes();
        let at: i64 = kani::any();
        assert_eq!(roster.resolve(&k1, at).is_some(), at >= 100);
        assert_eq!(roster.resolve(&k2, at).is_some(), at >= 200 && at <= 300);
        let absent = [42u8; 32];
        assert_eq!(roster.resolve(&absent, at), None);
    }
}
