//! Authenticated lifecycle receipts from a verifier. Native government validation is a separate adapter.
use crate::{cbor::canonical::encode_json, error::VerifyError};
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub enum CredentialProfile {
    IcpBrasilCms,
    CinVio,
}
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub enum RevocationState {
    Good,
    Revoked,
    Unknown,
}
/// Only the synthetic qualification exists until native bridges are independently qualified.
#[derive(Debug, Clone, Serialize, Deserialize)]
pub enum Qualification {
    SyntheticReceipt,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct LifecycleReceipt {
    pub version: u16,
    pub qualification: Qualification,
    pub credential_profile: CredentialProfile,
    pub credential_digest: [u8; 32],
    pub issuer_key_digest: [u8; 32],
    pub policy_digest: [u8; 32],
    pub validation_material_digest: [u8; 32],
    pub audience: String,
    pub challenge: [u8; 32],
    pub valid_from: i64,
    pub expires_at: i64,
    pub verified_at: i64,
    pub revocation: RevocationState,
    pub status_this_update: i64,
    pub status_next_update: i64,
    pub signature_hex: String,
}
impl LifecycleReceipt {
    pub fn signing_bytes(&self) -> Result<Vec<u8>, VerifyError> {
        let mut value = serde_json::to_value(self)
            .map_err(|_| VerifyError::InvalidInput("invalid lifecycle".into()))?;
        value.as_object_mut().unwrap().remove("signature_hex");
        let mut bytes = b"AKG:GOV:LIFECYCLE-RECEIPT:v1\0".to_vec();
        bytes.extend(encode_json(&value)?);
        Ok(bytes)
    }
}
/// Trusted host inputs, not fields copied from the untrusted credential.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct LifecycleTrust {
    pub verifier_key: [u8; 32],
    pub credential_profile: CredentialProfile,
    pub issuer_key_digest: [u8; 32],
    pub policy_digest: [u8; 32],
    pub max_receipt_age: i64,
    pub max_status_age: i64,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct LifecycleContext {
    pub credential_digest: [u8; 32],
    pub audience: String,
    pub challenge: [u8; 32],
    /// Trusted Unix seconds. No clock is fetched inside the pure verifier.
    pub now: i64,
}
pub fn verify(
    receipt: &LifecycleReceipt,
    trust: &LifecycleTrust,
    context: &LifecycleContext,
) -> Result<bool, VerifyError> {
    let nonzero = |value: &[u8; 32]| *value != [0; 32];
    if context.now < 0
        || context.audience.is_empty()
        || context.audience.len() > 256
        || !nonzero(&context.challenge)
        || !nonzero(&context.credential_digest)
        || !nonzero(&trust.issuer_key_digest)
        || !nonzero(&trust.policy_digest)
        || trust.max_receipt_age <= 0
        || trust.max_status_age <= 0
        || receipt.signature_hex.len() != 128
    {
        return Err(VerifyError::InvalidInput(
            "invalid lifecycle trust/context/encoding".into(),
        ));
    }
    if receipt.version != 1
        || receipt.credential_profile != trust.credential_profile
        || receipt.credential_digest != context.credential_digest
        || receipt.issuer_key_digest != trust.issuer_key_digest
        || receipt.policy_digest != trust.policy_digest
        || !nonzero(&receipt.validation_material_digest)
        || receipt.audience != context.audience
        || receipt.challenge != context.challenge
        || receipt.valid_from < 0
        || receipt.valid_from > context.now
        || receipt.expires_at <= context.now
        || receipt.verified_at < receipt.valid_from
        || receipt.verified_at > context.now
        || context.now.saturating_sub(receipt.verified_at) > trust.max_receipt_age
        || receipt.revocation != RevocationState::Good
        || receipt.status_this_update < 0
        || receipt.status_this_update > receipt.verified_at
        || receipt.status_next_update <= context.now
        || receipt.status_next_update <= receipt.status_this_update
        || context.now.saturating_sub(receipt.status_this_update) > trust.max_status_age
    {
        return Ok(false);
    }
    let key = VerifyingKey::from_bytes(&trust.verifier_key)
        .map_err(|_| VerifyError::InvalidInput("invalid lifecycle key".into()))?;
    if key.is_weak() {
        return Ok(false);
    }
    let raw = hex::decode(&receipt.signature_hex)
        .map_err(|_| VerifyError::InvalidInput("invalid lifecycle signature".into()))?;
    let signature = Signature::from_slice(&raw)
        .map_err(|_| VerifyError::InvalidInput("invalid lifecycle signature length".into()))?;
    Ok(key
        .verify_strict(&receipt.signing_bytes()?, &signature)
        .is_ok())
}
