//! Independent Rust checks of the pinned Python public fixtures. Test-only,
//! restricted theta subset; no operational root provisioning or clock policy.
use super::*;
use base64::{engine::general_purpose::STANDARD, Engine};
use ed25519_dalek::{Signature, VerifyingKey};
use sha2::Sha256;
use std::collections::{BTreeMap, BTreeSet};

const ROOT: &[u8] = include_bytes!("../fixtures/gravit/signatures/trust_root.json");
const REGISTRY: &[u8] = include_bytes!("../fixtures/gravit/signatures/registry.json");
const REGISTRY_SIG: &str = include_str!("../fixtures/gravit/signatures/registry.json.sig");
const SIGNED_REQUEST: &[u8] = include_bytes!("../fixtures/gravit/signatures/signed-request.json");
const REPLAY_DECISION: &[u8] =
    include_bytes!("../fixtures/gravit/signatures/reference-decision.json");
const CASES: &str = include_str!("../fixtures/gravit/signatures/cases.json");
const TAMPERED_DECISION: &[u8] =
    include_bytes!("../fixtures/gravit/signatures/tampered-decision.json");
const PINNED_ROOT_SHA256: &str = "38bf337eadc5e565c32f26da16ce368fb1f88ada4758cd90ea529d53d14a3c3c";

fn sha256(bytes: &[u8]) -> String {
    Sha256::digest(bytes)
        .iter()
        .map(|b| format!("{b:02x}"))
        .collect()
}
fn parse(bytes: &[u8]) -> Result<Value, &'static str> {
    serde_json::from_slice(bytes).map_err(|_| "invalid JSON")
}
fn text<'a>(v: &'a Value, key: &str) -> Result<&'a str, &'static str> {
    v.get(key)
        .and_then(Value::as_str)
        .ok_or("missing text field")
}
fn b64<const N: usize>(s: &str) -> Result<[u8; N], &'static str> {
    let bytes = STANDARD.decode(s).map_err(|_| "invalid base64")?;
    if STANDARD.encode(&bytes) != s {
        return Err("noncanonical base64");
    }
    bytes.try_into().map_err(|_| "wrong base64 length")
}
fn keys(doc: &Value, field: &str) -> Result<BTreeMap<String, (VerifyingKey, Value)>, &'static str> {
    let entries = doc[field].as_array().ok_or("missing key list")?;
    let mut out = BTreeMap::new();
    for entry in entries {
        let pk = b64::<32>(text(entry, "public_key")?)?;
        let kid = text(entry, "key_id")?;
        if kid != &sha256(&pk)[..16] {
            return Err("key id mismatch");
        }
        let key = VerifyingKey::from_bytes(&pk).map_err(|_| "invalid public key")?;
        if out.insert(kid.into(), (key, entry.clone())).is_some() {
            return Err("duplicate key");
        }
    }
    Ok(out)
}
struct Registry {
    keys: BTreeMap<String, (VerifyingKey, Value)>,
    signers: BTreeSet<String>,
    root_sha256: String,
    registry_sha256: String,
}
fn verify_registry(
    root_bytes: &[u8],
    registry_bytes: &[u8],
    signatures: &str,
) -> Result<Registry, &'static str> {
    // Pin comes from trusted test configuration, never the supplied registry.
    if sha256(root_bytes) != PINNED_ROOT_SHA256 {
        return Err("untrusted root bytes");
    }
    let root = parse(root_bytes)?;
    if root["trust_root_version"].as_u64() != Some(1) {
        return Err("root version");
    }
    let roots = keys(&root, "root_keys")?;
    let threshold = root["threshold"].as_u64().ok_or("invalid threshold")? as usize;
    if threshold == 0 || threshold > roots.len() || 2 * threshold <= roots.len() {
        return Err("invalid majority");
    }
    let message = [b"gravit-registry-v1\n".as_slice(), registry_bytes].concat();
    let mut signers = BTreeSet::new();
    for raw in signatures.split('\n') {
        let line = raw.trim_matches([' ', '\t', '\r']);
        if line.is_empty() || line.starts_with('#') {
            continue;
        }
        let parts: Vec<_> = line.split(' ').collect();
        if parts.len() != 2 || parts[0].is_empty() || parts[1].is_empty() {
            return Err("malformed signature line");
        }
        let signature = Signature::from_bytes(&b64::<64>(parts[1])?);
        if let Some((key, _)) = roots.get(parts[0]) {
            if key.verify_strict(&message, &signature).is_ok() {
                signers.insert(parts[0].into());
            }
        }
    }
    if signers.len() < threshold {
        return Err("insufficient root signatures");
    }
    let registry = parse(registry_bytes)?;
    if registry["registry_version"].as_u64() != Some(1) {
        return Err("registry version");
    }
    let verifiers = keys(&registry, "verifiers")?;
    for (_, entry) in verifiers.values() {
        if text(entry, "operator")?.is_empty() {
            return Err("empty operator");
        }
        if entry.get("revoked").is_some_and(|v| !v.is_boolean()) {
            return Err("invalid revocation flag");
        }
    }
    Ok(Registry {
        keys: verifiers,
        signers,
        root_sha256: sha256(root_bytes),
        registry_sha256: sha256(registry_bytes),
    })
}

// Restrict this prototype to nonnegative decimal theta in [0,1], at most six
// decimals. No binary-float formatting or claim of general Python equivalence.
fn theta_text(value: &Value) -> Result<String, &'static str> {
    let Value::Number(n) = value else {
        return Err("unsupported theta");
    };
    let s = n.to_string();
    if s.contains(['-', 'e', 'E']) {
        return Err("unsupported theta");
    }
    let (integer, fraction) = s.split_once('.').unwrap_or((&s, ""));
    if !matches!(integer, "0" | "1")
        || fraction.len() > 6
        || !fraction.bytes().all(|b| b.is_ascii_digit())
        || (integer == "1" && fraction.bytes().any(|b| b != b'0'))
    {
        return Err("unsupported theta");
    }
    Ok(format!(
        "{integer}.{fraction}{}",
        "0".repeat(6 - fraction.len())
    ))
}
fn signing_message(artifact_id: &str, record: &Value) -> Result<Vec<u8>, &'static str> {
    let fields = [
        artifact_id,
        text(record, "record_id")?,
        text(record, "timestamp")?,
        text(record, "provenance")?,
        text(record, "integrity_hash")?,
    ];
    if fields.iter().any(|s| s.contains(['\n', '\r'])) {
        return Err("line break in signed field");
    }
    let theta = theta_text(&record["theta"])?;
    let result = match record.get("result") {
        Some(Value::Bool(true)) => "true",
        Some(Value::Bool(false)) => "false",
        Some(Value::Null) => "null",
        _ => return Err("invalid result"),
    };
    Ok([
        "gravit-evidence-v1",
        fields[0],
        fields[1],
        &theta,
        result,
        fields[2],
        fields[3],
        fields[4],
    ]
    .join("\n")
    .into_bytes())
}
fn verify_evidence(registry: &Registry, request: &[u8]) -> Result<(), &'static str> {
    let request = parse(request)?;
    let artifact = text(&request, "artifact_id")?;
    let records = request["evidence"]
        .as_array()
        .filter(|a| !a.is_empty())
        .ok_or("missing evidence")?;
    for record in records {
        let (key, entry) = registry
            .keys
            .get(text(record, "key_id")?)
            .ok_or("unknown key")?;
        if entry["revoked"] == true {
            return Err("revoked key");
        }
        let message = signing_message(artifact, record)?;
        let signature = Signature::from_bytes(&b64::<64>(text(record, "signature")?)?);
        key.verify_strict(&message, &signature)
            .map_err(|_| "bad evidence signature")?;
    }
    Ok(())
}

// Only the exact reference pair is accepted here as the trusted REPLAY FIXTURE.
// This is NOT a proof that DecisionRecord was signed or generally recomputed.
fn admit_replay_fixture(
    request: &[u8],
    decision: &[u8],
) -> Result<(Candidate, TestAdmission), &'static str> {
    let registry = verify_registry(ROOT, REGISTRY, REGISTRY_SIG)?;
    verify_evidence(&registry, request)?;
    let candidate = translate(request, decision, ARTIFACT);
    let mut store = TestAdmission::default();
    store.admit_digest_slice(&candidate, ARTIFACT)?;
    if request != SIGNED_REQUEST || decision != REPLAY_DECISION {
        return Err("not the trusted replay fixture pair");
    }
    Ok((candidate, store))
}

#[tokio::test]
async fn signed_content_and_registry_pass_the_real_gate_under_test_policy_only() {
    let (candidate, store) = admit_replay_fixture(SIGNED_REQUEST, REPLAY_DECISION).unwrap();
    assert!(matches!(
        authorize(&candidate, &store, true).await,
        AuthorizationDecision::Allow { .. }
    ));
    assert!(matches!(
        authorize(&candidate, &store, false).await,
        AuthorizationDecision::Reject { .. }
    ));
}

#[test]
fn python_preimages_and_both_signature_layers_verify_in_rust() {
    let registry = verify_registry(ROOT, REGISTRY, REGISTRY_SIG).unwrap();
    assert_eq!(registry.signers.len(), 3);
    assert_eq!(registry.root_sha256, PINNED_ROOT_SHA256);
    assert_eq!(
        registry.registry_sha256,
        "65579301a6f35f5ca8d20c0b5a538934d3c48860e545a3355f571748fbb5d40c"
    );
    let cases: Value = serde_json::from_str(CASES).unwrap();
    for case in cases.as_array().unwrap() {
        for (i, record) in case["request"]["evidence"]
            .as_array()
            .unwrap()
            .iter()
            .enumerate()
        {
            let expected = STANDARD
                .decode(case["preimages_base64"][i].as_str().unwrap())
                .unwrap();
            assert_eq!(
                signing_message(text(&case["request"], "artifact_id").unwrap(), record).unwrap(),
                expected
            );
        }
        let result = verify_evidence(&registry, &serde_json::to_vec(&case["request"]).unwrap());
        match case["name"].as_str().unwrap() {
            "valid" => result.unwrap(),
            "revoked" => assert_eq!(result, Err("revoked key")),
            "unknown" => assert_eq!(result, Err("unknown key")),
            _ => panic!("unknown case"),
        }
    }
}

#[test]
fn changed_registry_missing_quorum_repeated_signer_and_root_swap_fail() {
    let mut changed = REGISTRY.to_vec();
    changed.push(b' ');
    assert!(matches!(
        verify_registry(ROOT, &changed, REGISTRY_SIG),
        Err("insufficient root signatures")
    ));
    let lines: Vec<_> = REGISTRY_SIG.lines().collect();
    assert!(matches!(
        verify_registry(ROOT, REGISTRY, &lines[..2].join("\n")),
        Err("insufficient root signatures")
    ));
    assert!(matches!(
        verify_registry(ROOT, REGISTRY, &vec![lines[0]; 5].join("\n")),
        Err("insufficient root signatures")
    ));
    let mut changed_root = ROOT.to_vec();
    changed_root.push(b' ');
    assert!(matches!(
        verify_registry(&changed_root, REGISTRY, REGISTRY_SIG),
        Err("untrusted root bytes")
    ));
    let bad = format!(
        "{} {}",
        lines[0].split(' ').next().unwrap(),
        STANDARD.encode([0; 64])
    );
    assert!(matches!(
        verify_registry(
            ROOT,
            REGISTRY,
            &format!("{}\n{}\n{bad}", lines[1], lines[2])
        ),
        Err("insufficient root signatures")
    ));
}

#[test]
fn tampering_each_signed_field_or_signature_fails() {
    let registry = verify_registry(ROOT, REGISTRY, REGISTRY_SIG).unwrap();
    let request = parse(SIGNED_REQUEST).unwrap();
    for field in ["record_id", "timestamp", "provenance", "integrity_hash"] {
        let mut altered = request.clone();
        altered["evidence"][0][field] = json!("changed");
        assert_eq!(
            verify_evidence(&registry, &serde_json::to_vec(&altered).unwrap()),
            Err("bad evidence signature"),
            "{field}"
        );
    }
    for (field, value) in [
        ("theta", json!(0.87)),
        ("result", json!(false)),
        ("signature", json!(STANDARD.encode([0; 64]))),
    ] {
        let mut altered = request.clone();
        altered["evidence"][0][field] = value;
        assert_eq!(
            verify_evidence(&registry, &serde_json::to_vec(&altered).unwrap()),
            Err("bad evidence signature"),
            "{field}"
        );
    }
    let mut altered = request;
    altered["artifact_id"] = json!("other-artifact");
    assert_eq!(
        verify_evidence(&registry, &serde_json::to_vec(&altered).unwrap()),
        Err("bad evidence signature")
    );
}

#[test]
fn malformed_preimages_and_noncanonical_base64_fail() {
    let mut record = parse(SIGNED_REQUEST).unwrap()["evidence"][0].clone();
    record["provenance"] = json!("injected\nfield");
    assert_eq!(
        signing_message("artifact", &record),
        Err("line break in signed field")
    );
    for theta in [json!(true), json!(0.1234567), json!(-0.1), json!(2)] {
        assert_eq!(theta_text(&theta), Err("unsupported theta"));
    }
    assert!(b64::<64>("not base64").is_err());
    assert!(b64::<64>(&STANDARD.encode([0; 63])).is_err());
    assert!(b64::<64>(STANDARD.encode([0; 64]).trim_end_matches('=')).is_err());
}

#[tokio::test]
async fn valid_signatures_do_not_make_a_wrong_content_hash_admissible() {
    let registry = verify_registry(ROOT, REGISTRY, REGISTRY_SIG).unwrap();
    // Original reproduced invalid-hash request was genuinely signed by test keys.
    verify_evidence(&registry, REQUEST).unwrap();
    assert!(matches!(
        admit_replay_fixture(REQUEST, DECISION),
        Err("artifact digest mismatch")
    ));
    let candidate = translate(REQUEST, DECISION, ARTIFACT);
    assert!(matches!(
        authorize(&candidate, &TestAdmission::default(), true).await,
        AuthorizationDecision::Reject { .. }
    ));
}

#[test]
fn record_signatures_do_not_authenticate_a_tampered_decision() {
    let registry = verify_registry(ROOT, REGISTRY, REGISTRY_SIG).unwrap();
    let altered = parse(TAMPERED_DECISION).unwrap();
    assert_eq!(altered["reason"], "forged unsigned conclusion");
    assert_ne!(
        altered["decision_id"],
        parse(REPLAY_DECISION).unwrap()["decision_id"]
    );
    // Deliberately demonstrate the absent binding: evidence still authenticates.
    verify_evidence(&registry, SIGNED_REQUEST).unwrap();
    assert!(matches!(
        admit_replay_fixture(SIGNED_REQUEST, TAMPERED_DECISION),
        Err("not the trusted replay fixture pair")
    ));
}

#[test]
fn identity_comes_from_registered_key_not_the_unsigned_verifier_label() {
    let registry = verify_registry(ROOT, REGISTRY, REGISTRY_SIG).unwrap();
    let mut request = parse(SIGNED_REQUEST).unwrap();
    request["evidence"][0]["verifier_id"] = json!("claimed-unrelated-operator");
    verify_evidence(&registry, &serde_json::to_vec(&request).unwrap()).unwrap();
    let alternate_key = registry
        .keys
        .iter()
        .find(|(kid, (_, entry))| {
            entry["revoked"] != true
                && kid.as_str() != request["evidence"][0]["key_id"].as_str().unwrap()
        })
        .unwrap()
        .0
        .clone();
    request["evidence"][0]["key_id"] = json!(alternate_key);
    assert_eq!(
        verify_evidence(&registry, &serde_json::to_vec(&request).unwrap()),
        Err("bad evidence signature")
    );
}
