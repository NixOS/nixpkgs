//! Export core vectors only after checking the independent reference.
//! cargo run -p arkhe-core --example golden-vectors-v1 > golden-vectors-v1.json
use arkhe_core::{
    match_summary::MatchSummary, work::WorkIntent, worker::WorkerExecutionRecord, CanonicalEncode,
};
use serde::de::DeserializeOwned;
use serde_json::Value;

fn hex(bytes: &[u8]) -> String {
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}

fn generate<T: CanonicalEncode + DeserializeOwned>(
    row: &mut Value,
    validate: impl Fn(&T) -> Result<(), String>,
) {
    assert_eq!(hex(T::DOMAIN_OBJECT), row["domain_hex"], "domain mismatch");
    let parsed = serde_json::from_value::<T>(row["input"].clone())
        .map_err(|error| error.to_string())
        .and_then(|object| validate(&object).map(|()| object));
    if row["expected"] == "REJECT" {
        assert!(parsed.is_err(), "accepted rejection vector: {}", row["id"]);
        assert!(
            row.get("expected_output").is_none(),
            "rejection must not have encoded output"
        );
        row["status"] = "READY".into();
        return;
    }
    assert_eq!(row["expected"], "ACCEPT", "unknown vector expectation");
    let object = parsed.expect("valid reference input");
    let expected = serde_json::json!({
        "canonical_cbor_hex": hex(&object.canonical_bytes()),
        "object_digest_hex": object.object_digest().to_hex(),
    });
    for key in ["canonical_cbor_hex", "object_digest_hex"] {
        assert_eq!(
            expected[key], row["expected_output"][key],
            "reference mismatch: {} / {key}",
            row["id"]
        );
    }
    row["expected_output"] = expected;
    row["status"] = "READY".into();
}

fn main() {
    let mut document: Value =
        serde_json::from_str(include_str!("../../../tests/golden_vectors.json")).unwrap();
    let classifications: Value =
        serde_json::from_str(include_str!("../../../tests/classification_vectors.json")).unwrap();
    let rows = document["vectors"].as_array_mut().unwrap();
    rows.extend(
        classifications["vectors"]
            .as_array()
            .unwrap()
            .iter()
            .cloned(),
    );
    let conformance: Value =
        serde_json::from_str(include_str!("../../../tests/core_conformance_vectors.json")).unwrap();
    rows.extend(conformance["vectors"].as_array().unwrap().iter().cloned());
    assert!(!rows.is_empty(), "empty reference corpus");
    let mut ids = std::collections::BTreeSet::new();
    for row in rows {
        if row.get("expected").is_none() {
            row["expected"] = "ACCEPT".into();
        }
        assert!(
            ids.insert(row["id"].as_str().unwrap().to_owned()),
            "duplicate vector ID"
        );
        match row["component"].as_str().unwrap() {
            "WorkIntent" => generate::<WorkIntent>(row, |_| Ok(())),
            "WorkerExecutionRecord" => generate::<WorkerExecutionRecord>(row, |_| Ok(())),
            "MatchSummary" => {
                generate::<MatchSummary>(row, |summary| summary.validate().map_err(str::to_owned))
            }
            component => panic!("unsupported component: {component}"),
        }
    }
    document["generated_by"] = "arkhe-core; checked against independent Python vectors".into();
    document["validated_by"] =
        "arkhe-core::golden-vectors-v1 (asserted against independent reference; ACCEPT and REJECT)"
            .into();
    println!("{}", serde_json::to_string_pretty(&document).unwrap());
}

#[cfg(test)]
mod tests {
    use super::*;

    fn reference(id: &str) -> Value {
        let data: Value =
            serde_json::from_str(include_str!("../../../tests/core_conformance_vectors.json"))
                .unwrap();
        data["vectors"]
            .as_array()
            .unwrap()
            .iter()
            .find(|row| row["id"] == id)
            .unwrap()
            .clone()
    }

    #[test]
    fn all_references_and_rejections_match() {
        main();
    }

    #[test]
    #[should_panic(expected = "reference mismatch")]
    fn altered_expected_digest_fails() {
        let mut row = reference("MatchSummary-minimal");
        row["expected_output"]["object_digest_hex"] = "00".repeat(32).into();
        generate::<MatchSummary>(&mut row, |s| s.validate().map_err(str::to_owned));
    }

    #[test]
    #[should_panic(expected = "accepted rejection vector")]
    fn falsely_labelled_rejection_fails() {
        let mut row = reference("MatchSummary-minimal");
        row["expected"] = "REJECT".into();
        row.as_object_mut().unwrap().remove("expected_output");
        generate::<MatchSummary>(&mut row, |s| s.validate().map_err(str::to_owned));
    }

    #[test]
    fn large_array_has_exactly_ten_thousand_references() {
        let mut row = reference("WER-large-refs-10k");
        assert_eq!(
            row["input"]["evidence_refs"].as_array().unwrap().len(),
            10000
        );
        generate::<WorkerExecutionRecord>(&mut row, |_| Ok(()));
    }
}
