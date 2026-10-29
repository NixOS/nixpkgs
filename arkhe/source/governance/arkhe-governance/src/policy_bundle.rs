//! AKG-POLICY-0001 v0.1 — signed policy bundles and the deployment trust store.
//!
//! A `PolicyBinding` cites a policy by digest, but a digest alone cannot say
//! *which* policy version a deployment approved, or *who* approved it. This
//! module is that statement: a `SignedPolicyBundle` is a versioned policy
//! payload plus issuer metadata, signed with Ed25519 over its canonical
//! unsigned bytes.
//!
//! Runtime trust NEVER comes from the bundle. The verifying key is resolved
//! from a deployment-configured `TrustStore` (`key_id → VerifyingKey`), the
//! hlinor-registry doctrine ported to Rust: a bundle that ships its own trust
//! material verifies nothing. `SignaturePolicy::Required` is the production
//! posture — an empty trust store is a configuration error, not a pass.
//!
//! Rollback is refused twice: `version` must not be lower than the
//! deployment's `current_version`, and never lower than the bundle's own
//! `min_version` floor, so a retired policy cannot be reinstated by
//! re-presenting an old, still-validly-signed bundle.
//!
//! Signatures are checked with `verify_strict`, which also refuses small-order
//! (torsion) public keys and malleable `R` components — malformed keys die at
//! verification time even if they decode cleanly at admission time.
//!
//! This module authenticates policies; it does not interpret them. What the
//! policy allows is the `PolicyResolver`'s question, and what an operation may
//! do under it is the ContainmentGate's.

use crate::PolicyBinding;
use arkhe_core::{CanonicalEncode, Digest32};
use ed25519_dalek::{Signature, Signer, SigningKey, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::Value;

/// Deployment signature posture. Chosen by the deployment, never by the
/// bundle — a bundle cannot demote itself to development mode.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum SignaturePolicy {
    /// Development: unsigned bundles verify without crypto (loudly
    /// documented escape hatch for local work only).
    Auto,
    /// Production: trust store required, signature required, no exceptions.
    Required,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum TrustStoreError {
    EmptyKeyId,
    DuplicateKeyId,
    MalformedKey,
}

/// Deployment-configured key set: `key_id → Ed25519 public key`.
///
/// Admission validates that each key decodes; torsion keys are caught later,
/// by `verify_strict`, at the only place they can be refused with certainty.
#[derive(Debug, Clone, Default)]
pub struct TrustStore {
    anchors: Vec<TrustAnchor>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct TrustAnchor {
    pub key_id: String,
    pub public_key: [u8; 32],
}

impl TrustStore {
    pub fn new() -> TrustStore {
        TrustStore::default()
    }

    pub fn insert(
        &mut self,
        key_id: impl Into<String>,
        public_key: [u8; 32],
    ) -> Result<&TrustAnchor, TrustStoreError> {
        let key_id = key_id.into();
        if key_id.is_empty() {
            return Err(TrustStoreError::EmptyKeyId);
        }
        if self.anchors.iter().any(|a| a.key_id == key_id) {
            return Err(TrustStoreError::DuplicateKeyId);
        }
        VerifyingKey::from_bytes(&public_key).map_err(|_| TrustStoreError::MalformedKey)?;
        self.anchors.push(TrustAnchor { key_id, public_key });
        Ok(self.anchors.last().expect("just pushed"))
    }

    /// Convenience: insert the verifying half of a signing key (tests, tooling).
    pub fn insert_signing(
        &mut self,
        key_id: impl Into<String>,
        signer: &SigningKey,
    ) -> Result<&TrustAnchor, TrustStoreError> {
        self.insert(key_id, signer.verifying_key().to_bytes())
    }

    pub fn get(&self, key_id: &str) -> Option<VerifyingKey> {
        let anchor = self.anchors.iter().find(|a| a.key_id == key_id)?;
        VerifyingKey::from_bytes(&anchor.public_key).ok()
    }

    pub fn is_empty(&self) -> bool {
        self.anchors.is_empty()
    }

    pub fn len(&self) -> usize {
        self.anchors.len()
    }
}

/// The policy body. Opaque here: consumers (`PolicyResolver`) interpret the
/// statements; this module only authenticates them.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct PolicyPayload {
    pub policy_id: String,
    pub statements: Value,
}

impl CanonicalEncode for PolicyPayload {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:POLICY:PAYLOAD:v1\0";
    fn unsigned_projection(&self) -> Value {
        serde_json::json!({
            "policy_id": self.policy_id,
            "statements": self.statements,
        })
    }
}

impl PolicyPayload {
    /// Digest a `PolicyBinding` cites.
    pub fn digest(&self) -> Digest32 {
        CanonicalEncode::object_digest(self)
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum PolicyBundleError {
    /// `Required` posture with no trust store configured.
    TrustStoreRequired,
    /// `Required` posture and the bundle carries no signature.
    UnsignedBundle,
    /// `version` is 0, or below the bundle's own `min_version` floor.
    MalformedVersion,
    /// Self-inconsistent validity window (`issued_at > expires_at`).
    MalformedWindow,
    /// `version < current_version` or `version < min_version`.
    RollbackDetected,
    /// `key_id` resolves to no deployment anchor.
    UnknownKey,
    /// Signature fails `verify_strict` (bad, malleable, or torsion).
    InvalidSignature,
    /// `now < issued_at`.
    NotYetValid,
    /// `now >= expires_at`.
    Expired,
}

/// Versioned policy payload with issuer metadata and an Ed25519 signature
/// over the canonical unsigned projection (which excludes the signature —
/// AKG-CBOR-v1 doctrine, as in `GovernanceRoster` approvals).
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct SignedPolicyBundle {
    pub payload: PolicyPayload,
    /// strictly increasing; first policy version is 1
    pub version: u64,
    /// rollback floor: versions below this are refused even when signed
    pub min_version: u64,
    pub issuer: String,
    pub key_id: String,
    /// unix seconds, inclusive
    pub issued_at: i64,
    /// unix seconds, exclusive
    pub expires_at: i64,
    /// `None` only verifies under `SignaturePolicy::Auto` (development)
    #[serde(default, with = "opt_sig64")]
    pub signature: Option<[u8; 64]>,
}

impl CanonicalEncode for SignedPolicyBundle {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:POLICY:BUNDLE:v1\0";
    fn unsigned_projection(&self) -> Value {
        serde_json::json!({
            "payload": self.payload,
            "version": self.version,
            "min_version": self.min_version,
            "issuer": self.issuer,
            "key_id": self.key_id,
            "issued_at": self.issued_at,
            "expires_at": self.expires_at,
        })
    }
}

impl SignedPolicyBundle {
    /// Digest over the whole unsigned bundle (anchoring, envelopes).
    pub fn digest(&self) -> Digest32 {
        CanonicalEncode::object_digest(self)
    }

    /// Digest over the policy payload alone — what a `PolicyBinding` cites.
    pub fn payload_digest(&self) -> Digest32 {
        self.payload.digest()
    }

    /// Re-derive everything a reader of a stored bundle must check. Fail
    /// closed: any unchecked condition is an error, never a pass. On success
    /// returns the binding the policy digest in a gate decision should cite.
    pub fn verify(
        &self,
        trust_store: &TrustStore,
        current_version: u64,
        policy: SignaturePolicy,
        now: i64,
    ) -> Result<PolicyBinding, PolicyBundleError> {
        if policy == SignaturePolicy::Required && trust_store.is_empty() {
            return Err(PolicyBundleError::TrustStoreRequired);
        }
        if self.version == 0 || self.version < self.min_version {
            return Err(PolicyBundleError::MalformedVersion);
        }
        if self.issued_at > self.expires_at {
            return Err(PolicyBundleError::MalformedWindow);
        }
        if self.version < current_version {
            return Err(PolicyBundleError::RollbackDetected);
        }
        if now < self.issued_at {
            return Err(PolicyBundleError::NotYetValid);
        }
        if now >= self.expires_at {
            return Err(PolicyBundleError::Expired);
        }
        let signature = match self.signature {
            None => return match policy {
                SignaturePolicy::Required => Err(PolicyBundleError::UnsignedBundle),
                SignaturePolicy::Auto => Ok(self.binding()),
            },
            Some(sig) => sig,
        };
        let key = trust_store
            .get(&self.key_id)
            .ok_or(PolicyBundleError::UnknownKey)?;
        key.verify_strict(&self.canonical_bytes(), &Signature::from_bytes(&signature))
            .map_err(|_| PolicyBundleError::InvalidSignature)?;
        Ok(self.binding())
    }

    fn binding(&self) -> PolicyBinding {
        PolicyBinding {
            policy_id: self.payload.policy_id.clone(),
            version: self.version,
            policy_digest: self.payload_digest(),
        }
    }
}

/// Convenience for building a signed bundle in tests and tooling. The
/// signature covers the canonical bytes of everything but itself.
pub fn sign_policy_bundle(
    payload: PolicyPayload,
    version: u64,
    min_version: u64,
    issuer: &str,
    key_id: &str,
    issued_at: i64,
    expires_at: i64,
    signer: &SigningKey,
) -> SignedPolicyBundle {
    let mut bundle = SignedPolicyBundle {
        payload,
        version,
        min_version,
        issuer: issuer.into(),
        key_id: key_id.into(),
        issued_at,
        expires_at,
        signature: None,
    };
    let signature = signer.sign(&bundle.canonical_bytes());
    bundle.signature = Some(signature.to_bytes());
    bundle
}

mod opt_sig64 {
    use serde::{de, Deserialize, Deserializer, Serialize, Serializer};
    pub fn serialize<S: Serializer>(v: &Option<[u8; 64]>, s: S) -> Result<S::Ok, S::Error> {
        v.map(|sig| sig.to_vec()).serialize(s)
    }
    pub fn deserialize<'de, D: Deserializer<'de>>(d: D) -> Result<Option<[u8; 64]>, D::Error> {
        let v = Option::<Vec<u8>>::deserialize(d)?;
        v.map(|bytes| {
            bytes
                .try_into()
                .map_err(|_| de::Error::custom("signature must be exactly 64 bytes"))
        })
        .transpose()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    const NOW: i64 = 1_800_000_000;
    const ISSUED_AT: i64 = 1_700_000_000;
    const EXPIRES_AT: i64 = 1_900_000_000;
    const CURRENT_VERSION: u64 = 5;

    fn signer() -> SigningKey {
        SigningKey::from_bytes(&[7u8; 32])
    }

    fn store() -> TrustStore {
        let mut store = TrustStore::new();
        store
            .insert_signing("policy-issuer", &signer())
            .expect("anchor admits");
        store
    }

    fn payload() -> PolicyPayload {
        PolicyPayload {
            policy_id: "arkhe.constitution".into(),
            statements: serde_json::json!({
                "transitions": "fail-closed",
                "evidence": "worker-execution-record"
            }),
        }
    }

    fn bundle(version: u64) -> SignedPolicyBundle {
        sign_policy_bundle(
            payload(),
            version,
            1,
            "arkhe-governance",
            "policy-issuer",
            ISSUED_AT,
            EXPIRES_AT,
            &signer(),
        )
    }

    #[test]
    fn valid_bundle_verifies_and_binds() {
        let binding = bundle(CURRENT_VERSION)
            .verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, NOW)
            .expect("valid bundle verifies");
        assert_eq!(binding.policy_id, "arkhe.constitution");
        assert_eq!(binding.version, CURRENT_VERSION);
        assert_eq!(binding.policy_digest, payload().digest());
    }

    #[test]
    fn rollback_is_rejected() {
        // older than the deployment's current version
        assert_eq!(
            bundle(CURRENT_VERSION - 1)
                .verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::RollbackDetected)
        );
        // below the bundle's own floor: never acceptable, at any deployment
        let floored = sign_policy_bundle(
            payload(),
            3,
            4, // floor above its own version
            "arkhe-governance",
            "policy-issuer",
            ISSUED_AT,
            EXPIRES_AT,
            &signer(),
        );
        assert_eq!(
            floored.verify(&store(), u64::MAX, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::MalformedVersion)
        );
        // floor equal to version is well-formed and verifies
        assert!(
            sign_policy_bundle(
                payload(),
                4,
                4,
                "arkhe-governance",
                "policy-issuer",
                ISSUED_AT,
                EXPIRES_AT,
                &signer(),
            )
            .verify(&store(), 4, SignaturePolicy::Required, NOW)
            .is_ok()
        );
    }

    #[test]
    fn unknown_key_is_rejected() {
        let mut signed = bundle(CURRENT_VERSION);
        signed.key_id = "ghost".into();
        assert_eq!(
            signed.verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::UnknownKey)
        );
    }

    #[test]
    fn expired_and_not_yet_valid_are_rejected() {
        assert_eq!(
            bundle(CURRENT_VERSION)
                .verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, EXPIRES_AT),
            Err(PolicyBundleError::Expired)
        );
        assert_eq!(
            bundle(CURRENT_VERSION)
                .verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, ISSUED_AT - 1),
            Err(PolicyBundleError::NotYetValid)
        );
        // window edges: issued_at inclusive, expires_at exclusive
        assert!(
            bundle(CURRENT_VERSION)
                .verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, ISSUED_AT)
                .is_ok()
        );
    }

    #[test]
    fn required_without_trust_store_is_rejected() {
        let empty = TrustStore::new();
        assert_eq!(
            bundle(CURRENT_VERSION)
                .verify(&empty, CURRENT_VERSION, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::TrustStoreRequired)
        );
    }

    #[test]
    fn unsigned_bundle_is_dev_only() {
        let mut unsigned = bundle(CURRENT_VERSION);
        unsigned.signature = None;
        // Auto (development): verifies without crypto
        assert!(
            unsigned
                .verify(&store(), CURRENT_VERSION, SignaturePolicy::Auto, NOW)
                .is_ok()
        );
        // Required (production): refused
        assert_eq!(
            unsigned.verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::UnsignedBundle)
        );
        // even in Auto, structural checks still bind
        let mut rolled_back = unsigned.clone();
        rolled_back.version = CURRENT_VERSION - 1;
        assert_eq!(
            rolled_back.verify(&store(), CURRENT_VERSION, SignaturePolicy::Auto, NOW),
            Err(PolicyBundleError::RollbackDetected)
        );
    }

    #[test]
    fn tampered_payload_is_rejected() {
        let mut tampered = bundle(CURRENT_VERSION);
        tampered.payload.statements = serde_json::json!({
            "transitions": "fail-open", // the attack every other check would miss
            "evidence": "worker-execution-record"
        });
        assert_eq!(
            tampered.verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::InvalidSignature)
        );
    }

    #[test]
    fn tampered_signature_is_rejected() {
        let mut tampered = bundle(CURRENT_VERSION);
        let mut sig = tampered.signature.expect("signed fixture");
        sig[0] ^= 1;
        tampered.signature = Some(sig);
        assert_eq!(
            tampered.verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::InvalidSignature)
        );
    }

    #[test]
    fn malformed_versions_and_windows_are_refused() {
        // version 0
        assert_eq!(
            bundle(0).verify(&store(), 0, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::MalformedVersion)
        );
        // inverted window
        let inverted = sign_policy_bundle(
            payload(),
            CURRENT_VERSION,
            1,
            "arkhe-governance",
            "policy-issuer",
            EXPIRES_AT,
            ISSUED_AT,
            &signer(),
        );
        assert_eq!(
            inverted.verify(&store(), CURRENT_VERSION, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::MalformedWindow)
        );
    }

    /// A torsion (small-order) public key decodes cleanly but can never
    /// verify strictly: no legitimate signer exists for it. The all-zero
    /// encoding is an order-2 point, so this exercises the `verify_strict`
    /// torsion refusal path deterministically.
    #[test]
    fn torsion_anchor_never_verifies() {
        let mut store = TrustStore::new();
        let torsion = [0u8; 32];
        let inserted = store.insert("torsion", torsion);
        if inserted.is_err() {
            // Admission refused the torsion key outright: also fail-closed,
            // and the bundle below cannot resolve its anchor.
            assert_eq!(
                bundle(CURRENT_VERSION)
                    .verify(&store, CURRENT_VERSION, SignaturePolicy::Required, NOW)
                    .err(),
                Some(PolicyBundleError::UnknownKey)
            );
            return;
        }
        let mut claiming = bundle(CURRENT_VERSION);
        claiming.key_id = "torsion".into();
        assert_eq!(
            claiming.verify(&store, CURRENT_VERSION, SignaturePolicy::Required, NOW),
            Err(PolicyBundleError::InvalidSignature)
        );
    }

    #[test]
    fn trust_store_admission_is_strict() {
        let mut store = TrustStore::new();
        assert_eq!(
            store.insert("", signer().verifying_key().to_bytes()).err(),
            Some(TrustStoreError::EmptyKeyId)
        );
        store.insert_signing("issuer", &signer()).unwrap();
        assert_eq!(
            store
                .insert("issuer", signer().verifying_key().to_bytes())
                .err(),
            Some(TrustStoreError::DuplicateKeyId)
        );
        // non-decompressible point: y=2 admits no x on the curve
        let mut off_curve = [0u8; 32];
        off_curve[0] = 2;
        assert_eq!(
            store.insert("bad", off_curve).err(),
            Some(TrustStoreError::MalformedKey)
        );
        assert_eq!(store.len(), 1);
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
        fn below(&mut self, n: u64) -> u64 {
            self.next_u64() % n
        }
    }

    /// Property-style check: every seeded corruption of a valid signed
    /// bundle is refused by `verify` under `Required` (never silently
    /// accepted). Every mutated field is covered by the signature or is the
    /// signature, so no corruption can slip through as a different-but-valid
    /// bundle.
    #[test]
    fn corrupted_bundles_are_refused() {
        let store = store();
        let mut rng = Rng::new(0x0FF1CE);
        for _ in 0..256 {
            let mut b = bundle(CURRENT_VERSION);
            match rng.below(6) {
                0 => {
                    let mut sig = b.signature.expect("signed fixture");
                    let bit = rng.below(512) as usize;
                    sig[bit / 8] ^= 1 << (bit % 8);
                    b.signature = Some(sig);
                }
                1 => {
                    b.version = rng.next_u64();
                }
                2 => {
                    b.min_version = rng.next_u64();
                }
                3 => {
                    b.issuer = format!("issuer-{}", rng.next_u64());
                }
                4 => {
                    b.payload.statements =
                        serde_json::json!({ "clause": rng.next_u64().to_string() });
                }
                _ => {
                    b.expires_at = rng.below(4_000_000_000) as i64;
                }
            }
            let verdict = b.verify(&store, CURRENT_VERSION, SignaturePolicy::Required, NOW);
            assert!(verdict.is_err(), "corruption accepted: {verdict:?}");
        }
    }
}

#[cfg(kani)]
mod kani_proofs {
    use super::*;

    fn fixture_bundle(version: u64, min_version: u64, issued_at: i64, expires_at: i64) -> SignedPolicyBundle {
        let signer = SigningKey::from_bytes(&[7u8; 32]);
        sign_policy_bundle(
            PolicyPayload {
                policy_id: "kani".into(),
                statements: serde_json::json!({"k": 1}),
            },
            version,
            min_version,
            "kani",
            "kani",
            issued_at,
            expires_at,
            &signer,
        )
    }

    /// Genuinely symbolic: for every version/floor/current triple, the
    /// rollback refusal is exactly the floor predicate — no version below the
    /// floor or the deployment current ever verifies, and the check fires
    /// before any crypto. No crypto on this path.
    #[kani::proof]
    fn rollback_floor_is_total() {
        let version: u64 = kani::any();
        let min_version: u64 = kani::any();
        let current: u64 = kani::any();
        let b = fixture_bundle(version, min_version, 0, i64::MAX);
        let empty = TrustStore::new();
        let out = b.verify(&empty, current, SignaturePolicy::Auto, 0).err();
        let malformed = version == 0 || version < min_version;
        let rollback = !malformed && version < current;
        assert_eq!(out == Some(PolicyBundleError::MalformedVersion), malformed);
        assert_eq!(out == Some(PolicyBundleError::RollbackDetected), rollback);
    }
}

