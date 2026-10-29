use arkhe_verify_core::gov::{self, Bundle};
use serde_json::Value;
fn fixture() -> (Vec<String>, Vec<Bundle>, [u8; 32]) {
    let data: Value = serde_json::from_str(include_str!(
        "../../../../integration/arkhe-gov/fixtures/cin-synthetic.json"
    ))
    .unwrap();
    let credentials = serde_json::from_value(data["credentialPayloads"].clone()).unwrap();
    let bundles = serde_json::from_value(data["bundles"].clone()).unwrap();
    let key = ed25519_dalek::SigningKey::from_bytes(&[71; 32])
        .verifying_key()
        .to_bytes();
    (credentials, bundles, key)
}
#[test]
fn four_synthetic_credentials_verify_against_signed_checkpoint() {
    let (c, b, k) = fixture();
    for i in 0..4 {
        assert!(gov::verify(c[i].as_bytes(), &b[i], &k).unwrap());
    }
}
#[test]
fn tampering_replay_and_untrusted_checkpoint_fail_closed() {
    let (c, b, k) = fixture();
    let mut changed = c[0].as_bytes().to_vec();
    changed[0] ^= 1;
    assert!(!gov::verify(&changed, &b[0], &k).unwrap());
    assert!(!gov::verify(c[1].as_bytes(), &b[0], &k).unwrap());
    let mut sibling = b[0].clone();
    sibling.proof[0].hash[0] ^= 1;
    assert!(!gov::verify(c[0].as_bytes(), &sibling, &k).unwrap());
    let mut root = b[0].clone();
    root.checkpoint_root[0] ^= 1;
    assert!(!gov::verify(c[0].as_bytes(), &root, &k).unwrap());
    let wrong = ed25519_dalek::SigningKey::from_bytes(&[72; 32])
        .verifying_key()
        .to_bytes();
    assert!(!gov::verify(c[0].as_bytes(), &b[0], &wrong).unwrap());
    let mut position = b[0].clone();
    position.leaf_index = 1;
    assert!(gov::verify(c[0].as_bytes(), &position, &k).is_err());
    let mut count = b[0].clone();
    count.leaf_count = 5;
    assert!(gov::verify(c[0].as_bytes(), &count, &k).is_err());
    let mut signature = b[0].clone();
    signature.checkpoint_signature_hex = "00".repeat(64);
    assert!(!gov::verify(c[0].as_bytes(), &signature, &k).unwrap());
}
