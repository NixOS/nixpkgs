//! Restricted offline DSSE/Ed25519 SLSA profile; no keyless or log verification.
use anyhow::{ensure, Context};
use base64::{engine::general_purpose::STANDARD, Engine};
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::Value;
use sha2::{Digest, Sha256};

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Policy {
    pub trusted_public_key: String,
    pub builder_id: String,
    pub build_type: String,
    pub source_uri: String,
    pub source_digest_algorithm: String,
    pub source_digest: String,
}

#[derive(Deserialize)]
#[serde(rename_all = "camelCase", deny_unknown_fields)]
struct Envelope {
    payload_type: String,
    payload: String,
    signatures: Vec<EnvelopeSignature>,
}
#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct EnvelopeSignature {
    #[serde(default, rename = "keyid")]
    _keyid: Option<String>,
    sig: String,
}

#[derive(Debug, Serialize)]
pub struct VerifiedProvenance {
    pub profile: &'static str,
    pub artifact_sha256: String,
    pub builder_id: String,
    pub source_uri: String,
    pub skill_status: &'static str,
    pub scope: &'static str,
}

pub fn pae(payload_type: &str, payload: &[u8]) -> Vec<u8> {
    let mut result = format!(
        "DSSEv1 {} {} {} ",
        payload_type.len(),
        payload_type,
        payload.len()
    )
    .into_bytes();
    result.extend_from_slice(payload);
    result
}

pub fn verify(
    bytes: &[u8],
    artifact_sha256: &str,
    policy: &Policy,
) -> anyhow::Result<VerifiedProvenance> {
    ensure!(bytes.len() <= 4 * 1024 * 1024, "envelope exceeds 4 MiB");
    for value in [&policy.builder_id, &policy.build_type, &policy.source_uri] {
        ensure!(!value.trim().is_empty(), "empty policy identity");
    }
    let expected_len = match policy.source_digest_algorithm.as_str() {
        "sha1" | "gitCommit" => 20,
        "sha256" => 32,
        _ => anyhow::bail!("unsupported source digest algorithm"),
    };
    ensure!(
        hex::decode(&policy.source_digest)?.len() == expected_len,
        "invalid source digest length"
    );
    ensure!(
        hex::decode(artifact_sha256)?.len() == 32,
        "invalid artifact SHA-256"
    );
    let envelope: Envelope = serde_json::from_slice(bytes)?;
    ensure!(
        envelope.payload_type == "application/vnd.in-toto+json",
        "unsupported payload type"
    );
    ensure!(
        !envelope.signatures.is_empty() && envelope.signatures.len() <= 32,
        "invalid signature count"
    );
    let payload = STANDARD.decode(&envelope.payload)?;
    let trusted: [u8; 32] = hex::decode(&policy.trusted_public_key)?
        .try_into()
        .map_err(|_| anyhow::anyhow!("trusted key must be 32 bytes"))?;
    let key = VerifyingKey::from_bytes(&trusted)?;
    let signed = pae(&envelope.payload_type, &payload);
    // keyid is unauthenticated and never establishes trust.
    ensure!(
        envelope.signatures.iter().any(|s| {
            STANDARD
                .decode(&s.sig)
                .ok()
                .and_then(|b| Signature::from_slice(&b).ok())
                .is_some_and(|sig| key.verify_strict(&signed, &sig).is_ok())
        }),
        "no valid signature from trusted key"
    );
    let statement: Value = serde_json::from_slice(&payload)?;
    ensure!(
        statement["_type"] == "https://in-toto.io/Statement/v1",
        "unsupported statement"
    );
    ensure!(
        statement["predicateType"] == "https://slsa.dev/provenance/v1",
        "unsupported predicate"
    );
    let subjects = statement["subject"]
        .as_array()
        .context("missing subjects")?;
    ensure!(
        subjects
            .iter()
            .any(|s| s["digest"]["sha256"].as_str() == Some(artifact_sha256)),
        "artifact digest mismatch"
    );
    let predicate = &statement["predicate"];
    ensure!(
        predicate["buildDefinition"]["buildType"] == policy.build_type,
        "unexpected build type"
    );
    ensure!(
        predicate["buildDefinition"]["externalParameters"].is_object(),
        "missing external parameters"
    );
    ensure!(
        predicate["runDetails"]["builder"]["id"] == policy.builder_id,
        "untrusted builder"
    );
    let dependencies = predicate["buildDefinition"]["resolvedDependencies"]
        .as_array()
        .context("missing resolved dependencies")?;
    ensure!(
        dependencies.iter().any(|d| d["uri"] == policy.source_uri
            && d["digest"][&policy.source_digest_algorithm] == policy.source_digest),
        "source binding mismatch"
    );
    Ok(VerifiedProvenance {
        profile: "arkhe:twin:dsse-ed25519-slsa:v1", artifact_sha256: artifact_sha256.into(),
        builder_id: policy.builder_id.clone(), source_uri: policy.source_uri.clone(),
        skill_status: "PENDING",
        scope: "Pinned-key signature, artifact digest, builder, build type and source binding only; no SLSA level, freshness, revocation, transparency or skill validation",
    })
}

pub fn artifact_digest(reader: impl std::io::Read) -> anyhow::Result<String> {
    let mut hasher = Sha256::new();
    let mut reader = reader;
    std::io::copy(&mut reader, &mut hasher)?;
    Ok(hex::encode(hasher.finalize()))
}
