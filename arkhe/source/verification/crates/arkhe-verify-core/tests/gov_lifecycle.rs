use arkhe_verify_core::gov_lifecycle::*;
use ed25519_dalek::{Signer, SigningKey};
fn fixture() -> (LifecycleReceipt, LifecycleTrust, LifecycleContext) {
    let key = SigningKey::from_bytes(&[73; 32]);
    let r = LifecycleReceipt {
        version: 1,
        qualification: Qualification::SyntheticReceipt,
        credential_profile: CredentialProfile::CinVio,
        credential_digest: [1; 32],
        issuer_key_digest: [2; 32],
        policy_digest: [3; 32],
        validation_material_digest: [4; 32],
        audience: "gov-poc-test".into(),
        challenge: [5; 32],
        valid_from: 800,
        expires_at: 1100,
        verified_at: 990,
        revocation: RevocationState::Good,
        status_this_update: 980,
        status_next_update: 1050,
        signature_hex: String::new(),
    };
    let t = LifecycleTrust {
        verifier_key: key.verifying_key().to_bytes(),
        credential_profile: CredentialProfile::CinVio,
        issuer_key_digest: [2; 32],
        policy_digest: [3; 32],
        max_receipt_age: 120,
        max_status_age: 120,
    };
    let c = LifecycleContext {
        credential_digest: [1; 32],
        audience: "gov-poc-test".into(),
        challenge: [5; 32],
        now: 1000,
    };
    (sign(r), t, c)
}
fn sign(mut r: LifecycleReceipt) -> LifecycleReceipt {
    r.signature_hex = hex::encode(
        SigningKey::from_bytes(&[73; 32])
            .sign(&r.signing_bytes().unwrap())
            .to_bytes(),
    );
    r
}
#[test]
fn expiry_revocation_and_freshness_reject_even_authentic_stale_receipts() {
    let (r, t, c) = fixture();
    assert!(verify(&r, &t, &c).unwrap());
    for mode in 0..9 {
        let mut bad = r.clone();
        match mode {
            0 => bad.expires_at = 1000,
            1 => bad.valid_from = 1001,
            2 => bad.revocation = RevocationState::Revoked,
            3 => bad.revocation = RevocationState::Unknown,
            4 => bad.status_next_update = 1000,
            5 => bad.status_this_update = 1001,
            6 => bad.verified_at = 799,
            7 => bad.verified_at = 1001,
            _ => bad.status_this_update = 1,
        }
        assert!(!verify(&sign(bad), &t, &c).unwrap(), "mode {mode}");
    }
}
#[test]
fn receipt_context_cannot_be_replayed_for_another_credential_or_challenge() {
    let (r, t, c) = fixture();
    for mode in 0..5 {
        let mut other = c.clone();
        let mut trust = t.clone();
        match mode {
            0 => other.challenge = [6; 32],
            1 => other.audience = "other".into(),
            2 => other.credential_digest = [9; 32],
            3 => trust.credential_profile = CredentialProfile::IcpBrasilCms,
            _ => trust.policy_digest = [7; 32],
        }
        assert!(!verify(&r, &trust, &other).unwrap());
    }
    let mut bad = r.clone();
    bad.expires_at += 1;
    assert!(!verify(&bad, &t, &c).unwrap());
    let mut expired = c.clone();
    expired.now = 1100;
    assert!(!verify(&r, &t, &expired).unwrap());
    let mut stale = c.clone();
    stale.now = 1040;
    let mut trust = t.clone();
    trust.max_receipt_age = 10;
    assert!(!verify(&r, &trust, &stale).unwrap());
}
#[test]
fn real_qualification_and_untrusted_empty_challenge_cannot_be_enabled() {
    let (receipt, trust, mut context) = fixture();
    let mut value = serde_json::to_value(&receipt).unwrap();
    value["qualification"] = serde_json::json!("GovernmentValidated");
    assert!(serde_json::from_value::<LifecycleReceipt>(value).is_err());
    context.challenge = [0; 32];
    assert!(verify(&receipt, &trust, &context).is_err());
}
#[test]
fn both_profile_contracts_require_the_matching_host_trust() {
    for profile in [CredentialProfile::CinVio, CredentialProfile::IcpBrasilCms] {
        let (mut receipt, mut trust, context) = fixture();
        receipt.credential_profile = profile.clone();
        trust.credential_profile = profile;
        assert!(verify(&sign(receipt.clone()), &trust, &context).unwrap());
        trust.credential_profile = match trust.credential_profile {
            CredentialProfile::CinVio => CredentialProfile::IcpBrasilCms,
            CredentialProfile::IcpBrasilCms => CredentialProfile::CinVio,
        };
        assert!(!verify(&sign(receipt), &trust, &context).unwrap());
    }
}
