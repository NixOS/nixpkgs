use arkhe_verify_core::c2pa::signature::{
    signing_payload, verify, Envelope, SignatureVerification, TrustRoot, TrustRoots, PROFILE,
};
use ed25519_dalek::{Signer, SigningKey};
use serde_json::{json, Value};

fn key() -> SigningKey {
    SigningKey::from_bytes(&[7u8; 32])
}

fn claim() -> Value {
    json!({
        "instanceID": "urn:arkhe:test",
        "claim_generator_info": [],
        "signature": "sha256",
        "created_assertions": []
    })
}

fn envelope(claim: &Value, kid: &str, issuer: &str, alg: &str, signature_hex: &str) -> String {
    serde_json::to_string(&json!({
        "schema": 1,
        "profile": PROFILE,
        "claim": claim.clone(),
        "signer": {"kid": kid, "issuer": issuer, "alg": alg},
        "signature_hex": signature_hex,
    }))
    .unwrap()
}

fn roots(root: TrustRoot) -> String {
    serde_json::to_string(&TrustRoots {
        schema: 1,
        profile: PROFILE.into(),
        roots: vec![root],
    })
    .unwrap()
}

fn active_root() -> TrustRoot {
    TrustRoot {
        kid: "signer-1".into(),
        issuer: "arkhe.test".into(),
        public_key_hex: hex::encode(key().verifying_key().to_bytes()),
        status: "active".into(),
    }
}

fn signed(claim: &Value, kid: &str, issuer: &str, alg: &str) -> String {
    let payload = signing_payload(claim, kid, issuer, alg).unwrap();
    hex::encode(key().sign(&payload).to_bytes())
}

fn assert_status(result: SignatureVerification, status: &str, verified: bool) {
    assert_eq!(result.status, status);
    assert_eq!(result.signature_verified, verified);
    assert_equal_scope(&result);
}

fn assert_equal_scope(result: &SignatureVerification) {
    assert_eq!(result.profile, PROFILE);
    assert_eq!(result.provenance_verification, "NOT_PERFORMED");
    assert_eq!(result.c2pa_standard_validation, "NOT_PERFORMED");
    assert!(!result.authority);
}

#[test]
fn valid_signature_over_pinned_ed25519_root() {
    let claim = claim();
    let signature = signed(&claim, "signer-1", "arkhe.test", "Ed25519");
    let result = verify(
        &envelope(&claim, "signer-1", "arkhe.test", "Ed25519", &signature),
        &roots(active_root()),
    )
    .unwrap();
    assert_status(result.clone(), "SIGNATURE_VALID", true);
    assert_eq!(result.signer_kid.as_deref(), Some("signer-1"));
    assert_eq!(result.signer_issuer.as_deref(), Some("arkhe.test"));
    assert_eq!(result.trust_root_status, "ACTIVE");
    assert_eq!(result.claim_canonical_sha256.as_ref().unwrap().len(), 64);
    assert_eq!(result.signed_payload_sha256.as_ref().unwrap().len(), 64);
}

#[test]
fn tampered_claim_reuses_signature_and_fails() {
    let original = claim();
    let signature = signed(&original, "signer-1", "arkhe.test", "Ed25519");
    let mut tampered = original.clone();
    tampered["instanceID"] = json!("urn:arkhe:tampered");
    let result = verify(
        &envelope(&tampered, "signer-1", "arkhe.test", "Ed25519", &signature),
        &roots(active_root()),
    )
    .unwrap();
    assert_status(result, "SIGNATURE_INVALID", false);
}

#[test]
fn identity_binding_includes_kid_and_issuer() {
    let claim = claim();
    let signature = signed(&claim, "signer-1", "arkhe.test", "Ed25519");
    for (kid, issuer) in [("signer-2", "arkhe.test"), ("signer-1", "evil.test")] {
        let mut root = active_root();
        root.kid = kid.into();
        root.issuer = issuer.into();
        let result = verify(
            &envelope(&claim, kid, issuer, "Ed25519", &signature),
            &roots(root),
        )
        .unwrap();
        assert_status(result, "SIGNATURE_INVALID", false);
    }
}

#[test]
fn missing_and_revoked_roots_are_rejected() {
    let claim = claim();
    let signature = signed(&claim, "signer-1", "arkhe.test", "Ed25519");
    let signed_envelope = envelope(&claim, "signer-1", "arkhe.test", "Ed25519", &signature);

    let missing = verify(
        &signed_envelope,
        &roots(TrustRoot {
            kid: "other".into(),
            ..active_root()
        }),
    )
    .unwrap();
    assert_status(missing.clone(), "TRUST_ROOT_REJECTED", false);
    assert_eq!(missing.trust_root_status, "MISSING");

    let mut revoked_root = active_root();
    revoked_root.status = "revoked".into();
    let revoked = verify(&signed_envelope, &roots(revoked_root)).unwrap();
    assert_status(revoked.clone(), "TRUST_ROOT_REJECTED", false);
    assert_eq!(revoked.trust_root_status, "REVOKED");
}

#[test]
fn matching_identity_with_rogue_key_fails_signature() {
    let claim = claim();
    let signature = signed(&claim, "signer-1", "arkhe.test", "Ed25519");
    let rogue = SigningKey::from_bytes(&[9u8; 32]);
    let result = verify(
        &envelope(&claim, "signer-1", "arkhe.test", "Ed25519", &signature),
        &roots(TrustRoot {
            public_key_hex: hex::encode(rogue.verifying_key().to_bytes()),
            ..active_root()
        }),
    )
    .unwrap();
    assert_status(result, "SIGNATURE_INVALID", false);
}

#[test]
fn unsupported_algorithm_never_reports_verification() {
    let claim = claim();
    let signature = signed(&claim, "signer-1", "arkhe.test", "ML-DSA-65");
    let result = verify(
        &envelope(&claim, "signer-1", "arkhe.test", "ML-DSA-65", &signature),
        &roots(active_root()),
    )
    .unwrap();
    assert_status(result, "SIGNATURE_UNSUPPORTED", false);
}

#[test]
fn malformed_profiles_duplicates_and_fields_are_errors() {
    let claim = claim();
    let signature = signed(&claim, "signer-1", "arkhe.test", "Ed25519");
    let signed_envelope = envelope(&claim, "signer-1", "arkhe.test", "Ed25519", &signature);

    let mut wrong_profile: TrustRoots = serde_json::from_str(&roots(active_root())).expect("roots");
    wrong_profile.profile = "other".into();
    assert!(verify(
        &signed_envelope,
        &serde_json::to_string(&wrong_profile).unwrap()
    )
    .is_err());

    let duplicate = serde_json::to_string(&json!({
        "schema": 1,
        "profile": PROFILE,
        "roots": [active_root_json(), active_root_json()]
    }))
    .unwrap();
    assert!(verify(&signed_envelope, &duplicate).is_err());

    let unknown = serde_json::to_string(&json!({
        "schema": 1,
        "profile": PROFILE,
        "claim": claim.clone(),
        "signer": {"kid": "signer-1", "issuer": "arkhe.test", "alg": "Ed25519"},
        "signature_hex": signature,
        "extra": true
    }))
    .unwrap();
    assert!(verify(&unknown, &roots(active_root())).is_err());

    let short_signature = envelope(&claim, "signer-1", "arkhe.test", "Ed25519", "00");
    assert!(verify(&short_signature, &roots(active_root())).is_err());
}

fn active_root_json() -> Value {
    json!({
        "kid": "signer-1",
        "issuer": "arkhe.test",
        "public_key_hex": hex::encode(key().verifying_key().to_bytes()),
        "status": "active"
    })
}

#[test]
fn signing_payload_is_deterministic_and_domain_separated() {
    let first = signing_payload(&claim(), "signer-1", "arkhe.test", "Ed25519").unwrap();
    let second = signing_payload(&claim(), "signer-1", "arkhe.test", "Ed25519").unwrap();
    assert_eq!(first, second);
    assert!(first.starts_with(arkhe_verify_core::c2pa::signature::DOMAIN));
    let changed = signing_payload(&claim(), "signer-1", "arkhe.test", "RSA").unwrap();
    assert_ne!(first, changed);
}

#[test]
fn envelope_deserialization_rejects_unknown_fields() {
    let raw = r#"{"schema":1,"profile":"arkhe-c2pa-claim-signature-v1","claim":{},"signer":{"kid":"a","issuer":"b","alg":"Ed25519"},"signature_hex":"","unexpected":1}"#;
    let parsed: Result<Envelope, _> = serde_json::from_str(raw);
    assert!(parsed.is_err());
}
