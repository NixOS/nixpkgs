use arkhe_twin::provenance::{artifact_digest, pae, verify, Policy};
use base64::{engine::general_purpose::STANDARD, Engine};
use ed25519_dalek::{Signer, SigningKey};
use serde_json::{json, Value};

fn fixture() -> (Value, Policy, String) {
    let key = SigningKey::from_bytes(&[9; 32]);
    let digest = artifact_digest(&b"real artifact"[..]).unwrap();
    let policy = Policy {
        trusted_public_key: hex::encode(key.verifying_key().as_bytes()),
        builder_id: "https://ci.example/builder".into(),
        build_type: "https://ci.example/build/v1".into(),
        source_uri: "git+https://example/repo".into(),
        source_digest_algorithm: "gitCommit".into(),
        source_digest: "ab".repeat(20),
    };
    let statement = json!({
        "_type":"https://in-toto.io/Statement/v1", "subject":[{"name":"artifact","digest":{"sha256":digest}}],
        "predicateType":"https://slsa.dev/provenance/v1",
        "predicate":{
            "buildDefinition":{"buildType":policy.build_type,"externalParameters":{},
                "resolvedDependencies":[{"uri":policy.source_uri,"digest":{"gitCommit":policy.source_digest}}]},
            "runDetails":{"builder":{"id":policy.builder_id}}
        }
    });
    (statement, policy, digest)
}

fn envelope(statement: &Value, raw_signature: bool) -> Vec<u8> {
    let payload = serde_json::to_vec(statement).unwrap();
    let signed = if raw_signature {
        payload.clone()
    } else {
        pae("application/vnd.in-toto+json", &payload)
    };
    let sig = SigningKey::from_bytes(&[9; 32]).sign(&signed);
    serde_json::to_vec(
        &json!({"payloadType":"application/vnd.in-toto+json", "payload":STANDARD.encode(payload),
        "signatures":[{"keyid":"untrusted-hint", "sig":STANDARD.encode(sig.to_bytes())}]}),
    )
    .unwrap()
}

#[test]
fn verifies_pae_and_real_artifact_without_awarding_skill() {
    assert_eq!(pae("t", b"abc"), b"DSSEv1 1 t 3 abc");
    assert_eq!(pae("é", b"a"), "DSSEv1 2 é 1 a".as_bytes());
    let (statement, policy, digest) = fixture();
    let result = verify(&envelope(&statement, false), &digest, &policy).unwrap();
    assert_eq!(result.skill_status, "PENDING");
    assert!(verify(&envelope(&statement, true), &digest, &policy).is_err());
    let changed = artifact_digest(&b"different artifact"[..]).unwrap();
    assert!(verify(&envelope(&statement, false), &changed, &policy).is_err());
}

#[test]
fn rejects_trust_source_builder_type_and_payload_substitution() {
    let (statement, mut policy, digest) = fixture();
    let bytes = envelope(&statement, false);
    policy.trusted_public_key =
        hex::encode(SigningKey::from_bytes(&[10; 32]).verifying_key().as_bytes());
    assert!(verify(&bytes, &digest, &policy).is_err());
    let (_, policy, _) = fixture();
    for pointer in [
        "/predicate/runDetails/builder/id",
        "/predicate/buildDefinition/buildType",
        "/predicate/buildDefinition/resolvedDependencies/0/uri",
        "/predicateType",
        "/predicate/buildDefinition/resolvedDependencies/0/digest/gitCommit",
    ] {
        let mut altered = statement.clone();
        *altered.pointer_mut(pointer).unwrap() = "unexpected".into();
        assert!(verify(&envelope(&altered, false), &digest, &policy).is_err());
    }
    let mut altered: Value = serde_json::from_slice(&bytes).unwrap();
    altered["payloadType"] = "application/json".into();
    assert!(verify(&serde_json::to_vec(&altered).unwrap(), &digest, &policy).is_err());
    altered["payload"] = "invalid base64!".into();
    assert!(verify(&serde_json::to_vec(&altered).unwrap(), &digest, &policy).is_err());
}

#[test]
fn cli_checks_the_actual_file() {
    let (statement, policy, _) = fixture();
    let dir = std::env::temp_dir().join(format!("twin-provenance-{}", uuid::Uuid::new_v4()));
    std::fs::create_dir(&dir).unwrap();
    std::fs::write(dir.join("envelope.json"), envelope(&statement, false)).unwrap();
    std::fs::write(dir.join("policy.json"), serde_json::to_vec(&json!({
        "trusted_public_key":policy.trusted_public_key,"builder_id":policy.builder_id,"build_type":policy.build_type,
        "source_uri":policy.source_uri,"source_digest_algorithm":policy.source_digest_algorithm,"source_digest":policy.source_digest
    })).unwrap()).unwrap();
    std::fs::write(dir.join("artifact"), b"real artifact").unwrap();
    let run = || {
        std::process::Command::new(env!("CARGO_BIN_EXE_arkhe-twin"))
            .arg("verify-provenance")
            .arg("--envelope")
            .arg(dir.join("envelope.json"))
            .arg("--policy")
            .arg(dir.join("policy.json"))
            .arg("--artifact")
            .arg(dir.join("artifact"))
            .output()
            .unwrap()
    };
    assert!(run().status.success());
    std::fs::write(dir.join("artifact"), b"tampered").unwrap();
    assert!(!run().status.success());
    std::fs::remove_dir_all(dir).unwrap();
}
