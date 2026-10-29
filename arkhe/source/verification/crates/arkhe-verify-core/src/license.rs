//! Transparent, bounded SPDX-2.3 JSON policy compatibility. Not legal advice,
//! full SPDX conformance validation, SBOM completeness or proof of fulfillment.
use crate::hash::sha256;
use arkhe_core::{formal_proof::*, work::WorkIntent, worker::WorkerExecutionRecord, Digest32};
use serde::Deserialize;
use std::collections::HashSet;
pub const CHECKER: &str = "arkhe/spdx23-obligations/v1";

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct Document {
    spdx_version: String,
    data_license: String,
    #[serde(rename = "SPDXID")]
    id: String,
    name: String,
    document_namespace: String,
    creation_info: Creation,
    document_describes: Vec<String>,
    packages: Vec<Package>,
    #[serde(default)]
    files: Vec<File>,
    #[serde(default)]
    snippets: Vec<serde_json::Value>,
    #[serde(default)]
    external_document_refs: Vec<serde_json::Value>,
}
#[derive(Deserialize)]
struct Creation {
    creators: Vec<String>,
    created: String,
}
#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct Package {
    #[serde(rename = "SPDXID")]
    id: String,
    name: String,
    download_location: String,
    files_analyzed: bool,
    license_concluded: String,
    license_declared: String,
    copyright_text: String,
    #[serde(default)]
    checksums: Vec<Checksum>,
}
#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct File {
    #[serde(rename = "SPDXID")]
    id: String,
    file_name: String,
    license_concluded: String,
    license_info_in_files: Vec<String>,
    copyright_text: String,
    checksums: Vec<Checksum>,
}
#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
struct Checksum {
    algorithm: String,
    checksum_value: String,
}

fn expression_allowed(text: &str, policy: &LicensePolicy) -> Result<bool, &'static str> {
    if text.len() > 4096 {
        return Err("license expression too long");
    }
    let expr = spdx::Expression::parse(text).map_err(|_| "unsupported SPDX expression")?;
    Ok(expr.evaluate(|req| {
        policy
            .obligations
            .get(&req.to_string())
            .is_some_and(|required| required.is_subset(&policy.permitted_obligations))
    }))
}

pub fn evaluate(
    input: &LicenseInput,
    policy: &LicensePolicy,
) -> Result<LicenseOutput, &'static str> {
    if policy.version != 1 || policy.require_zk {
        return Err("unsupported license policy or required ZK backend unavailable");
    }
    if input.spdx_json.len() > 512 * 1024
        || input.artifact.len() > 16 * 1024 * 1024
        || input.artifact.is_empty()
        || policy.obligations.is_empty()
        || policy.obligations.len() > 256
    {
        return Err("license input or policy outside bounds");
    }
    // Struct deserialization rejects duplicate recognized fields. This parser
    // intentionally supports a strict subset, not arbitrary SPDX documents.
    let doc: Document =
        serde_json::from_str(&input.spdx_json).map_err(|_| "invalid SPDX document")?;
    if doc.spdx_version != "SPDX-2.3"
        || doc.data_license != "CC0-1.0"
        || doc.id != "SPDXRef-DOCUMENT"
        || doc.name.trim().is_empty()
        || !doc.document_namespace.starts_with("https://")
        || doc.creation_info.creators.is_empty()
        || doc.creation_info.created.trim().is_empty()
        || doc.document_describes.len() != 1
        || doc.packages.is_empty()
        || doc.packages.len() > 256
        || doc.files.len() > 4096
        || !doc.snippets.is_empty()
        || !doc.external_document_refs.is_empty()
    {
        return Err("SPDX document outside licensing subset");
    }
    let mut ids = HashSet::from([doc.id.as_str()]);
    let mut root_found = false;
    for p in &doc.packages {
        if !p.id.starts_with("SPDXRef-")
            || !ids.insert(&p.id)
            || p.name.trim().is_empty()
            || p.download_location.trim().is_empty()
            || p.copyright_text.trim().is_empty()
            || p.license_declared.trim().is_empty()
            || p.files_analyzed
            || !expression_allowed(&p.license_concluded, policy)?
        {
            return Err("package license obligations rejected or unsupported analyzed package");
        }
        if p.id == doc.document_describes[0] {
            let sums: Vec<_> = p
                .checksums
                .iter()
                .filter(|c| c.algorithm == "SHA256")
                .collect();
            if sums.len() != 1 || sums[0].checksum_value != hex::encode(sha256(&input.artifact)) {
                return Err("SPDX root package does not bind artifact SHA256");
            }
            root_found = true;
        }
    }
    for f in &doc.files {
        if !f.id.starts_with("SPDXRef-")
            || !ids.insert(&f.id)
            || f.file_name.trim().is_empty()
            || f.copyright_text.trim().is_empty()
            || f.checksums.is_empty()
            || f.license_info_in_files.is_empty()
            || !expression_allowed(&f.license_concluded, policy)?
        {
            return Err("file license obligations rejected");
        }
        // Do not discard separately discovered licensing information.
        for expr in &f.license_info_in_files {
            if !expression_allowed(expr, policy)? {
                return Err("file discovered license rejected");
            }
        }
    }
    if !root_found {
        return Err("missing described root package");
    }
    Ok(LicenseOutput {
        compatible: true,
        sbom_digest: input.sbom_digest(),
        artifact_digest: input.artifact_digest(),
    })
}

pub fn verify(
    proof: &LicenseProof,
    spec: &LicensePolicy,
    policy: Digest32,
    intent: &WorkIntent,
    worker: &WorkerExecutionRecord,
) -> Result<(), &'static str> {
    // Reject oversized untrusted transport before allocating its canonical hash.
    if proof.input.spdx_json.len() > 512 * 1024 || proof.input.artifact.len() > 16 * 1024 * 1024 {
        return Err("license proof input outside bounds");
    }
    if proof.checker != CHECKER
        || proof.policy_digest != policy
        || policy == Digest32::ZERO
        || proof.spec_digest != spec.digest()
        || proof.intent_digest != intent.digest()
        || proof.worker_digest != worker.digest()
        || proof.input.digest() != worker.input_digest
        || !worker.evidence_refs.contains(&proof.input.sbom_digest())
        || proof.output.digest() != worker.output_digest
        || proof.output.digest() != intent.parameters_digest
        || proof.input.artifact_digest() != intent.target
        || !proof.output.compatible
    {
        return Err("license proof binding mismatch");
    }
    let output = evaluate(&proof.input, spec)?;
    if output.digest() != proof.output.digest() {
        return Err("license certificate result mismatch");
    }
    Ok(())
}
