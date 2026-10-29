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
fn main() {
    let (receipt, trust, context) = fixture();
    println!("{}",serde_json::to_string_pretty(&serde_json::json!({"scope":"synthetic receipt; native government verification NOT_PERFORMED","receipt":receipt,"trust":trust,"context":context})).unwrap());
}
