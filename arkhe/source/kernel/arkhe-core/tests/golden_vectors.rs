use arkhe_core::{work::WorkIntent, worker::WorkerExecutionRecord, CanonicalEncode};
fn check<T: CanonicalEncode + serde::de::DeserializeOwned>(v: &serde_json::Value) {
    let x: T = serde_json::from_value(v["input"].clone()).unwrap();
    let hex = |b: &[u8]| b.iter().map(|b| format!("{b:02x}")).collect::<String>();
    assert_eq!(
        hex(&x.canonical_bytes()),
        v["expected_output"]["canonical_cbor_hex"],
        "{}",
        v["id"]
    );
    assert_eq!(hex(T::DOMAIN_OBJECT), v["domain_hex"]);
    assert_eq!(
        x.object_digest().to_hex(),
        v["expected_output"]["object_digest_hex"],
        "{}",
        v["id"]
    );
}
#[test]
fn independent_python_vectors() {
    let vectors: serde_json::Value =
        serde_json::from_str(include_str!("../../../tests/golden_vectors.json")).unwrap();
    for v in vectors["vectors"].as_array().unwrap() {
        match v["component"].as_str().unwrap() {
            "WorkIntent" => {
                check::<WorkIntent>(v);
                let x: WorkIntent = serde_json::from_value(v["input"].clone()).unwrap();
                assert_eq!(x.digest(), x.object_digest());
            }
            "WorkerExecutionRecord" => {
                check::<WorkerExecutionRecord>(v);
                let x: WorkerExecutionRecord = serde_json::from_value(v["input"].clone()).unwrap();
                assert_eq!(x.digest(), x.object_digest());
            }
            _ => panic!("unknown vector"),
        }
    }
}

#[test]
fn optional_classification_matches_independent_python_vectors() {
    let vectors: serde_json::Value =
        serde_json::from_str(include_str!("../../../tests/classification_vectors.json")).unwrap();
    for vector in vectors["vectors"].as_array().unwrap() {
        check::<WorkerExecutionRecord>(vector);
    }
}

#[test]
fn worker_unsigned_fields_and_reference_order_are_digest_bound() {
    let vectors: serde_json::Value =
        serde_json::from_str(include_str!("../../../tests/golden_vectors.json")).unwrap();
    let fixture = &vectors["vectors"]
        .as_array()
        .unwrap()
        .iter()
        .find(|v| v["component"] == "WorkerExecutionRecord")
        .unwrap()["input"];
    let baseline: WorkerExecutionRecord = serde_json::from_value(fixture.clone()).unwrap();
    for (field, value) in [
        ("module_id", serde_json::json!("changed")),
        ("module_version", serde_json::json!("changed")),
        ("input_digest", serde_json::json!(vec![9u8; 32])),
        ("output_digest", serde_json::json!(vec![9u8; 32])),
        ("evidence_refs", serde_json::json!([vec![9u8; 32]])),
        ("confidence_bps", serde_json::json!(10000)),
        ("uncertainty_note", serde_json::json!("changed")),
        ("execution_id", serde_json::json!("changed")),
    ] {
        let mut projection = fixture.clone();
        projection[field] = value;
        let mutated: WorkerExecutionRecord = serde_json::from_value(projection).unwrap();
        assert_ne!(
            mutated.digest(),
            baseline.digest(),
            "unbound unsigned field {field}"
        );
    }
    let mut ordered = baseline.clone();
    ordered.evidence_refs = vec![arkhe_core::Digest32([8; 32]), arkhe_core::Digest32([9; 32])];
    let original = ordered.digest();
    ordered.evidence_refs.reverse();
    assert_ne!(ordered.digest(), original);
}
#[test]
fn canonical_booleans_for_opt_in_formal_predicates() {
    assert_eq!(
        arkhe_core::canonical::encode_value(&serde_json::json!(false)),
        vec![0xf4]
    );
    assert_eq!(
        arkhe_core::canonical::encode_value(&serde_json::json!(true)),
        vec![0xf5]
    );
}
