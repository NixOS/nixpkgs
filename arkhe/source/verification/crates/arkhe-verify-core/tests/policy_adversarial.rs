#[path = "support/policy_cases.rs"]
mod cases;
use arkhe_verify_core::policy::*;
use ed25519_dalek::{Signer, SigningKey};

#[test]
fn adversarial_vectors_reject_every_attack_with_valid_positive_control() {
    let vectors = cases::vectors();
    assert!(vectors.len() >= 11);
    for v in &vectors {
        assert_eq!(
            evaluate(&v.request, &v.context).is_ok(),
            v.expected_allow,
            "{}",
            v.name
        );
    }
    if let Ok(path) = std::env::var("ARKHE_POLICY_VECTORS_OUT") {
        std::fs::write(path, serde_json::to_vec_pretty(&vectors).unwrap()).unwrap();
    }
}

#[test]
fn scenario_10_digest_replay_is_rejected() {
    let mut r = cases::base();
    assert!(evaluate(&r, &cases::context()).is_ok());
    r.parameters_digest[0] ^= 1;
    assert_eq!(
        evaluate(&r, &cases::context()),
        Err(Rejection::IntentBinding)
    );
}

#[test]
fn worker_a_key_cannot_claim_worker_b() {
    let mut r = cases::base();
    r.worker_record.worker_id = "worker-b".into();
    cases::resign_record(&mut r);
    assert_eq!(
        evaluate(&r, &cases::context()),
        Err(Rejection::WorkerSignature)
    );
}

#[test]
fn unknown_principal_cannot_authorize_itself() {
    let mut r = cases::base();
    r.signed_intent.intent.principal_id = "attacker".into();
    r.signed_intent.signature = SigningKey::from_bytes(&[10; 32])
        .sign(&r.signed_intent.intent.signed_message())
        .to_bytes()
        .to_vec();
    assert_eq!(evaluate(&r, &cases::context()), Err(Rejection::Principal));
}

#[test]
fn delimiter_ambiguity_and_signing_domains_are_separated() {
    let mut a = cases::base().action;
    let mut b = a.clone();
    a.module_id = "a|b".into();
    a.module_version = "c".into();
    b.module_id = "a".into();
    b.module_version = "b|c".into();
    assert_ne!(a.canonical_bytes(), b.canonical_bytes());
    let r = cases::base();
    assert_ne!(
        r.worker_record.signed_message(),
        r.signed_intent.intent.signed_message()
    );
}
