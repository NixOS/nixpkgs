use crate::c2pa::claim::canonicalize_claim_v2;
use crate::cbor::canonical::encode_json;
use crate::error::VerifyError;
use crate::hash::blake3_256;
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};

pub const PROFILE: &str = "arkhe-c2pa-claim-signature-v1";
pub const DOMAIN: &[u8] = b"AKG:C2PA-CLAIM-SIG:v1\0";

#[derive(Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Signer {
    pub kid: String,
    pub issuer: String,
    pub alg: String,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Envelope {
    pub schema: u32,
    pub profile: String,
    pub claim: Value,
    pub signer: Signer,
    pub signature_hex: String,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TrustRoot {
    pub kid: String,
    pub issuer: String,
    pub public_key_hex: String,
    pub status: String,
}

#[derive(Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TrustRoots {
    pub schema: u32,
    pub profile: String,
    pub roots: Vec<TrustRoot>,
}

#[derive(Debug, Clone, Serialize)]
pub struct SignatureVerification {
    pub schema: u32,
    pub profile: String,
    pub status: String,
    pub signature_verified: bool,
    pub signer_kid: Option<String>,
    pub signer_issuer: Option<String>,
    pub trust_root_status: String,
    pub claim_canonical_sha256: Option<String>,
    pub signed_payload_sha256: Option<String>,
    pub provenance_verification: String,
    pub c2pa_standard_validation: String,
    pub authority: bool,
    pub findings: Vec<String>,
}

fn parse_key(text: &str) -> Result<VerifyingKey, VerifyError> {
    let bytes = hex::decode(text)
        .map_err(|_| VerifyError::InvalidInput("trust root public key is not hex".into()))?;
    let bytes: [u8; 32] = bytes
        .try_into()
        .map_err(|_| VerifyError::InvalidInput("trust root public key must be 32 bytes".into()))?;
    VerifyingKey::from_bytes(&bytes)
        .map_err(|_| VerifyError::InvalidInput("trust root public key is invalid".into()))
}

pub fn signing_payload(
    claim: &Value,
    kid: &str,
    issuer: &str,
    alg: &str,
) -> Result<Vec<u8>, VerifyError> {
    if kid.is_empty() || issuer.is_empty() || kid.len() > 256 || issuer.len() > 256 {
        return Err(VerifyError::InvalidInput(
            "signer kid/issuer must be non-empty and at most 256 bytes".into(),
        ));
    }
    let canonical = canonicalize_claim_v2(claim)?;
    let digest = hex::encode(blake3_256(&canonical));
    let message = json!({
        "profile": PROFILE,
        "kid": kid,
        "issuer": issuer,
        "alg": alg,
        "claim_sha256": digest,
    });
    let encoded = encode_json(&message)?;
    let mut payload = Vec::with_capacity(DOMAIN.len() + encoded.len());
    payload.extend_from_slice(DOMAIN);
    payload.extend_from_slice(&encoded);
    Ok(payload)
}

fn rejected(
    status: &str,
    trust_root_status: &str,
    envelope: Option<&Envelope>,
    claim_digest: Option<String>,
    payload_digest: Option<String>,
    findings: Vec<String>,
) -> SignatureVerification {
    SignatureVerification {
        schema: 1,
        profile: PROFILE.into(),
        status: status.into(),
        signature_verified: false,
        signer_kid: envelope.map(|e| e.signer.kid.clone()),
        signer_issuer: envelope.map(|e| e.signer.issuer.clone()),
        trust_root_status: trust_root_status.into(),
        claim_canonical_sha256: claim_digest,
        signed_payload_sha256: payload_digest,
        provenance_verification: "NOT_PERFORMED".into(),
        c2pa_standard_validation: "NOT_PERFORMED".into(),
        authority: false,
        findings,
    }
}

pub fn verify(
    envelope_json: &str,
    trust_roots_json: &str,
) -> Result<SignatureVerification, VerifyError> {
    let envelope: Envelope = serde_json::from_str(envelope_json)
        .map_err(|_| VerifyError::InvalidInput("signature envelope is malformed".into()))?;
    let roots: TrustRoots = serde_json::from_str(trust_roots_json)
        .map_err(|_| VerifyError::InvalidInput("trust roots are malformed".into()))?;

    if envelope.schema != 1 || roots.schema != 1 {
        return Err(VerifyError::InvalidInput(
            "signature envelope and trust roots require schema 1".into(),
        ));
    }
    if envelope.profile != PROFILE || roots.profile != PROFILE {
        return Err(VerifyError::Unsupported(format!(
            "signature profile must be {PROFILE}"
        )));
    }

    let canonical = canonicalize_claim_v2(&envelope.claim)?;
    let claim_digest = hex::encode(blake3_256(&canonical));
    let payload = signing_payload(
        &envelope.claim,
        &envelope.signer.kid,
        &envelope.signer.issuer,
        &envelope.signer.alg,
    )?;
    let payload_digest = hex::encode(blake3_256(&payload));

    if envelope.signer.alg != "Ed25519" {
        return Ok(rejected(
            "SIGNATURE_UNSUPPORTED",
            "NOT_EVALUATED",
            Some(&envelope),
            Some(claim_digest),
            Some(payload_digest),
            vec!["only the Ed25519 signature algorithm is implemented".into()],
        ));
    }

    let mut seen = std::collections::BTreeSet::new();
    for root in &roots.roots {
        if !seen.insert((root.kid.clone(), root.issuer.clone())) {
            return Err(VerifyError::InvalidInput(
                "trust roots contain a duplicate kid/issuer".into(),
            ));
        }
        if root.issuer.is_empty() || root.kid.is_empty() {
            return Err(VerifyError::InvalidInput(
                "trust root kid/issuer must be non-empty".into(),
            ));
        }
    }

    let root = roots
        .roots
        .iter()
        .find(|root| root.kid == envelope.signer.kid && root.issuer == envelope.signer.issuer);
    let Some(root) = root else {
        return Ok(rejected(
            "TRUST_ROOT_REJECTED",
            "MISSING",
            Some(&envelope),
            Some(claim_digest),
            Some(payload_digest),
            vec!["signer is not present in the supplied trust roots".into()],
        ));
    };
    if root.status != "active" {
        return Ok(rejected(
            "TRUST_ROOT_REJECTED",
            "REVOKED",
            Some(&envelope),
            Some(claim_digest),
            Some(payload_digest),
            vec![format!("trust root status is {}", root.status)],
        ));
    }

    let key = parse_key(&root.public_key_hex)?;
    let signature_bytes = hex::decode(&envelope.signature_hex)
        .map_err(|_| VerifyError::InvalidInput("signature is not hex".into()))?;
    let signature_bytes: [u8; 64] = signature_bytes
        .try_into()
        .map_err(|_| VerifyError::InvalidInput("signature must be 64 bytes".into()))?;
    let signature = Signature::from_bytes(&signature_bytes);

    if key.verify_strict(&payload, &signature).is_err() {
        return Ok(rejected(
            "SIGNATURE_INVALID",
            "ACTIVE",
            Some(&envelope),
            Some(claim_digest),
            Some(payload_digest),
            vec!["Ed25519 signature does not verify over the Arkhe signing payload".into()],
        ));
    }

    Ok(SignatureVerification {
        schema: 1,
        profile: PROFILE.into(),
        status: "SIGNATURE_VALID".into(),
        signature_verified: true,
        signer_kid: Some(envelope.signer.kid),
        signer_issuer: Some(envelope.signer.issuer),
        trust_root_status: "ACTIVE".into(),
        claim_canonical_sha256: Some(claim_digest),
        signed_payload_sha256: Some(payload_digest),
        provenance_verification: "NOT_PERFORMED".into(),
        c2pa_standard_validation: "NOT_PERFORMED".into(),
        authority: false,
        findings: vec![
            "signature verified against a pinned Ed25519 trust root".into(),
            "trust root authenticity, revocation freshness and signer intent remain host obligations"
                .into(),
        ],
    })
}
