//! Catalog consistency only; this is not a runtime skill-proof verifier.
use serde_json::Value;
use std::{
    collections::HashSet,
    path::{Component, Path},
};

fn catalogs() -> (Value, Value) {
    (
        serde_json::from_str(
            include_str!("../../../ontology/skills.json").trim_start_matches('\u{feff}'),
        )
        .unwrap(),
        serde_json::from_str(
            include_str!("../../../ontology/arkhe-sources.json").trim_start_matches('\u{feff}'),
        )
        .unwrap(),
    )
}

fn validate(ontology: &Value, map: &Value) -> Result<(), String> {
    let fail = |message: &str| Err(message.to_owned());
    if ontology["schema"] != "arkhe:twin:ontology:v5"
        || ontology["version"] != 5
        || map["schema"] != "arkhe:twin:source-map:v3"
        || map["ontology_version"] != ontology["version"]
    {
        return fail("schema/version mismatch");
    }
    let skills = ontology["skills"].as_array().ok_or("missing skills")?;
    let root = Path::new(env!("CARGO_MANIFEST_DIR")).join("../..");
    let mut covered = HashSet::new();
    let mut present = HashSet::new();
    let mut mappings = HashSet::new();
    for mapping in map["mappings"].as_array().ok_or("missing mappings")? {
        let id = mapping["skill_id"].as_str().ok_or("missing skill ID")?;
        let skill = skills
            .iter()
            .find(|s| s["skill_id"] == id)
            .ok_or("unknown mapped skill")?;
        let path = mapping["path"].as_str().ok_or("missing path")?;
        if path.is_empty()
            || path.contains('\\')
            || path.contains(':')
            || Path::new(path)
                .components()
                .any(|c| !matches!(c, Component::Normal(_)))
        {
            return fail("source path must stay inside repository");
        }
        let exists = root.join(path).exists();
        if mapping["path_present"].as_bool() != Some(exists) {
            return fail("path presence disagrees with checkout");
        }
        let expected = if exists {
            "candidate-evidence-source"
        } else {
            "planned-evidence-source"
        };
        if mapping["status"] != expected {
            return fail("source status disagrees with presence");
        }
        let module = mapping["record_module"]
            .as_str()
            .ok_or("missing record module")?;
        let prefix = skill["requirements"][0]["module_prefix"]
            .as_str()
            .ok_or("missing prefix")?;
        if !module.starts_with(prefix) {
            return fail("module incompatible with predicate");
        }
        if !mappings.insert((id, path, module)) {
            return fail("duplicate source mapping");
        }
        covered.insert(id);
        if exists {
            present.insert(id);
        }
    }
    if !map["unmapped_skills"]
        .as_array()
        .ok_or("missing unmapped list")?
        .is_empty()
    {
        return fail("catalog requires a target for every skill");
    }
    let unavailable: HashSet<_> = map["skills_without_present_source"]
        .as_array()
        .ok_or("missing unavailable list")?
        .iter()
        .map(|s| s.as_str().ok_or("invalid unavailable ID"))
        .collect::<Result<_, _>>()?;
    let mut ids = HashSet::new();
    for skill in skills {
        let id = skill["skill_id"].as_str().ok_or("missing skill ID")?;
        if !ids.insert(id) || !covered.contains(id) {
            return fail("duplicate or uncovered skill");
        }
        if unavailable.contains(id) == present.contains(id) {
            return fail("incorrect availability summary");
        }
        if skill["evidence_status"] != "PENDING" {
            return fail("unevaluated catalog must remain PENDING");
        }
        for requirement in skill["requirements"]
            .as_array()
            .ok_or("missing requirements")?
        {
            if requirement["kind"] == "external_attestation"
                && (requirement["contract"] != ontology["attestation_contract"]["schema"]
                    || requirement["require_trusted_verifier"] != true)
            {
                return fail("missing trusted attestation contract");
            }
        }
    }
    if unavailable.iter().any(|id| !ids.contains(id)) {
        return fail("unknown unavailable skill");
    }
    Ok(())
}

#[test]
fn catalog_and_checkout_satisfy_stencil() {
    let (ontology, map) = catalogs();
    validate(&ontology, &map).unwrap();
}

#[test]
fn rejects_false_presence_incompatible_modules_and_missing_targets() {
    let (ontology, map) = catalogs();
    let mut bad = map.clone();
    bad["mappings"][0]["path_present"] = false.into();
    assert!(validate(&ontology, &bad).is_err());
    let mut bad = map.clone();
    bad["mappings"][0]["record_module"] = "unrelated".into();
    assert!(validate(&ontology, &bad).is_err());
    let mut bad = map.clone();
    bad["mappings"]
        .as_array_mut()
        .unwrap()
        .retain(|m| m["skill_id"] != "skill:dbt-transformations:v1");
    assert!(validate(&ontology, &bad).is_err());
    let mut bad = map.clone();
    bad["mappings"][0]["path"] = "../outside".into();
    assert!(validate(&ontology, &bad).is_err());
    let mut bad = ontology.clone();
    bad["skills"][0]["requirements"][1]["require_trusted_verifier"] = false.into();
    assert!(validate(&bad, &map).is_err());
    let mut bad = ontology.clone();
    bad["skills"][0]["evidence_status"] = "CHECKED".into();
    assert!(validate(&bad, &map).is_err());
}
