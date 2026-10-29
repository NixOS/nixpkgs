use arkhe_core::Digest32;
#[path = "support/preview_fixture.rs"]
mod fixture;

#[tokio::test]
async fn only_authenticated_external_verdicts_reach_the_gate() {
    let root = SigningKey::from_bytes(&[31; 32]);
    let key = SigningKey::from_bytes(&[32; 32]);
    let identity = ExternalIdentity {
        source: "HSM_KMS".into(),
        issuer: "test-external-bridge".into(),
        subject: "fixture-key-version-1".into(),
        measurement: None,
    };
    let file = std::env::temp_dir().join(format!(
        "arkhe-authority-test-{}.json",
        uuid::Uuid::new_v4()
    ));
    let policy = AuthorityPolicy {
        root_key: root.verifying_key().to_bytes(),
        expected: identity.clone(),
        admission_file: file.clone(),
    };
    let mut a = AuthorityAdmission {
        version: 1,
        identity,
        qualification_key: key.verifying_key().to_bytes(),
        evidence_digest: Digest32([1; 32]),
        issued_at: 900,
        expires_at: 1100,
        signature: String::new(),
    };
    a.signature = hex::encode(root.sign(&a.signing_bytes()).to_bytes());
    std::fs::write(&file, serde_json::to_vec(&a).unwrap()).unwrap();
    let (request, _, _) = fixture::fixture(1000);
    assert!(arkhe_runtime::preview::authority::admit(
        &policy,
        key.verifying_key().to_bytes(),
        &request.spec,
        1000
    )
    .await
    .is_ok());
    assert!(arkhe_runtime::preview::authority::admit(
        &policy,
        key.verifying_key().to_bytes(),
        &request.spec,
        1100
    )
    .await
    .is_err());
    std::fs::remove_file(file).unwrap();
}
use arkhe_runtime::preview::authority::{AuthorityAdmission, AuthorityPolicy, ExternalIdentity};
use ed25519_dalek::{Signer, SigningKey};
#[test]
fn an_origin_label_or_self_signed_qualification_key_never_admits_an_authority() {
    let root = SigningKey::from_bytes(&[31; 32]);
    let key = SigningKey::from_bytes(&[32; 32]);
    let identity = ExternalIdentity {
        source: "COSIGN_SIGSTORE".into(),
        issuer: "https://token.actions.githubusercontent.com".into(),
        subject: "repo:example/release:ref:refs/tags/v1".into(),
        measurement: None,
    };
    let policy = AuthorityPolicy {
        root_key: root.verifying_key().to_bytes(),
        expected: identity.clone(),
        admission_file: "unused".into(),
    };
    let mut a = AuthorityAdmission {
        version: 1,
        identity,
        qualification_key: key.verifying_key().to_bytes(),
        evidence_digest: Digest32([1; 32]),
        issued_at: 900,
        expires_at: 1100,
        signature: String::new(),
    };
    a.signature = hex::encode(root.sign(&a.signing_bytes()).to_bytes());
    assert!(a
        .verify(&policy, key.verifying_key().to_bytes(), 1000)
        .is_ok());
    for mode in 0..5 {
        let mut changed = a.clone();
        match mode {
            0 => changed.identity.subject = "repo:attacker/release".into(),
            1 => changed.expires_at = 1000,
            2 => changed.qualification_key = [99; 32],
            3 => changed.signature = hex::encode(key.sign(&changed.signing_bytes()).to_bytes()),
            _ => changed.signature.clear(),
        }
        assert!(changed
            .verify(&policy, key.verifying_key().to_bytes(), 1000)
            .is_err());
    }
}
