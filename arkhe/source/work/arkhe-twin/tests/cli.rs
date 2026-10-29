use arkhe_twin::CareerRecord;
use ed25519_dalek::SigningKey;
use std::{fs, process::Command};

#[test]
fn record_verify_failure_and_overwrite() {
    let dir = std::env::temp_dir().join(format!("arkhe-twin-test-{}", uuid::Uuid::new_v4()));
    fs::create_dir(&dir).unwrap();
    let key = dir.join("seed");
    let artifact = dir.join("artifact");
    let out = dir.join("record.json");
    fs::write(&key, hex::encode([7; 32])).unwrap();
    fs::write(&artifact, b"artifact under test").unwrap();
    let trusted = hex::encode(SigningKey::from_bytes(&[7; 32]).verifying_key().as_bytes());
    for (exit, name) in [(0, "record.json"), (3, "failed.json")] {
        let path = dir.join(name);
        let mut command = Command::new(env!("CARGO_BIN_EXE_arkhe-twin"));
        command
            .args(["record", "--module", "rust-axum-api", "--key"])
            .arg(&key)
            .arg("--output")
            .arg(&artifact)
            .arg("--out")
            .arg(&path)
            .arg("--");
        if cfg!(windows) {
            command.args(["cmd", "/C", &format!("exit {exit}")]);
        } else {
            command.args(["sh", "-c", &format!("exit {exit}")]);
        }
        assert_eq!(command.output().unwrap().status.success(), exit == 0);
        let record: CareerRecord = serde_json::from_slice(&fs::read(&path).unwrap()).unwrap();
        record.verify(&trusted).unwrap();
        assert_eq!(record.test_run.passed, exit == 0);
        let original = fs::read(&path).unwrap();
        let store = dir.join(format!("store-{exit}"));
        let import = |public_key: &str, module: &str| {
            Command::new(env!("CARGO_BIN_EXE_arkhe-twin"))
                .arg("import-ci")
                .arg("--record")
                .arg(&path)
                .arg("--trusted-public-key")
                .arg(public_key)
                .arg("--expected-module")
                .arg(module)
                .arg("--store")
                .arg(&store)
                .output()
                .unwrap()
        };
        let other_key = hex::encode(SigningKey::from_bytes(&[8; 32]).verifying_key().as_bytes());
        assert!(!import(&other_key, "rust-axum-api").status.success());
        assert!(!import(&trusted, "other-module").status.success());
        assert!(!store.exists());
        assert!(import(&trusted, "rust-axum-api").status.success());
        assert!(!import(&trusted, "rust-axum-api").status.success());
        let imported = fs::read_dir(&store)
            .unwrap()
            .next()
            .unwrap()
            .unwrap()
            .path();
        assert_eq!(fs::read(imported).unwrap(), original);
        let mut tampered: serde_json::Value = serde_json::from_slice(&original).unwrap();
        tampered["wer"]["module_id"] = "other-module".into();
        fs::write(&path, serde_json::to_vec(&tampered).unwrap()).unwrap();
        assert!(!import(&trusted, "other-module").status.success());
        fs::write(&path, &original).unwrap();
        assert!(!command.output().unwrap().status.success());
        assert_eq!(fs::read(&path).unwrap(), original);
    }
    assert!(Command::new(env!("CARGO_BIN_EXE_arkhe-twin"))
        .arg("verify-record")
        .arg("--record")
        .arg(out)
        .arg("--trusted-public-key")
        .arg(trusted)
        .output()
        .unwrap()
        .status
        .success());
    fs::remove_dir_all(dir).unwrap();
}

#[test]
fn ontology_has_unique_fail_closed_definitions() {
    let ontology: serde_json::Value = serde_json::from_str(
        include_str!("../../../ontology/skills.json").trim_start_matches('\u{feff}'),
    )
    .unwrap();
    let skills = ontology["skills"].as_array().unwrap();
    assert_eq!(ontology["version"], 5);
    assert_eq!(skills.len(), 49);
    let ids: std::collections::HashSet<_> = skills
        .iter()
        .map(|s| s["skill_id"].as_str().unwrap())
        .collect();
    assert_eq!(ids.len(), skills.len());
    for skill in skills {
        assert_eq!(skill["evidence_status"], "PENDING");
        assert!(skill["min_evidence_count"].as_u64().unwrap() > 0);
        assert!(skill["requirements"]
            .as_array()
            .unwrap()
            .iter()
            .any(|r| r["require_trusted_verifier"] == true));
    }
}

#[test]
fn source_map_references_valid_skills_and_compatible_modules() {
    let ontology: serde_json::Value = serde_json::from_str(
        include_str!("../../../ontology/skills.json").trim_start_matches('\u{feff}'),
    )
    .unwrap();
    let map: serde_json::Value = serde_json::from_str(
        include_str!("../../../ontology/arkhe-sources.json").trim_start_matches('\u{feff}'),
    )
    .unwrap();
    assert_eq!(map["ontology_version"], ontology["version"]);
    let skills = ontology["skills"].as_array().unwrap();
    let mut accounted = std::collections::HashSet::new();
    for mapping in map["mappings"].as_array().unwrap() {
        let id = mapping["skill_id"].as_str().unwrap();
        let skill = skills.iter().find(|s| s["skill_id"] == id).unwrap();
        assert!(mapping["record_module"]
            .as_str()
            .unwrap()
            .starts_with(skill["requirements"][0]["module_prefix"].as_str().unwrap()));
        accounted.insert(id);
    }
    for unmapped in map["unmapped_skills"].as_array().unwrap() {
        let id = unmapped.as_str().unwrap();
        assert!(skills.iter().any(|s| s["skill_id"] == id));
        assert!(accounted.insert(id), "mapped skill listed as unmapped");
    }
    assert_eq!(accounted.len(), skills.len());
    let families: std::collections::HashSet<_> =
        skills.iter().filter_map(|s| s["family"].as_str()).collect();
    assert_eq!(families.len(), 7);
    for id in [
        "communication",
        "ownership",
        "systems-thinking",
        "prompt-engineering",
    ] {
        let skill_id = format!("skill:{id}:v1");
        let skill = skills.iter().find(|s| s["skill_id"] == skill_id).unwrap();
        assert!(skill["assessment_limit"].as_str().is_some());
    }
}
