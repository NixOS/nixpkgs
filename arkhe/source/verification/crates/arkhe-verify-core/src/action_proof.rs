//! Bounded local mandate profile, not an AP2 credential verifier or a payment rail.
use crate::{
    cbor::canonical::encode_json,
    mmr::{verify_proof_at, ProofStep},
};
use arkhe_core::{
    work::{WorkIntent, WorkIntentType},
    Digest32,
};
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};

pub const PROFILE: &str = "arkhe-action-mandate@1";

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Mandate {
    pub profile: String,
    pub requested_by: String,
    pub intent_type: WorkIntentType,
    pub operation_id: Digest32,
    pub target: Digest32,
    pub policy_digest: Digest32,
    /// Finite exact parameter commitments; no inferred natural-language scope.
    pub allowed_parameters: Vec<Digest32>,
    pub issued_at: i64,
    pub expires_at: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Checkpoint {
    pub profile_digest: String,
    pub root: [u8; 32],
    pub leaf_count: u32,
    pub issued_at: i64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ActionProof {
    pub mandate: Mandate,
    pub mandate_signature: Vec<u8>,
    pub checkpoint: Checkpoint,
    pub checkpoint_signature: Vec<u8>,
    pub leaf_index: u32,
    pub steps: Vec<ProofStep>,
}

/// Host-configured keys, policy, clock and retained checkpoint. Never trust these
/// merely because they appear next to a proof. Log time is a trusted attestation,
/// not a timestamp independently derived from MMR inclusion.
pub struct Trust {
    pub mandate_key: VerifyingKey,
    pub log_key: VerifyingKey,
    pub policy_digest: Digest32,
    pub checkpoint: Checkpoint,
    pub now: i64,
    pub max_checkpoint_age: i64,
}

fn bytes(domain: &[u8], value: &impl Serialize) -> Result<Vec<u8>, &'static str> {
    let value = serde_json::to_value(value).map_err(|_| "invalid mandate projection")?;
    let mut out = domain.to_vec();
    out.extend(encode_json(&value).map_err(|_| "invalid canonical mandate")?);
    Ok(out)
}
pub fn mandate_bytes(m: &Mandate) -> Result<Vec<u8>, &'static str> {
    bytes(b"AKG:ACTION:MANDATE:v1\0", m)
}
pub fn checkpoint_bytes(c: &Checkpoint) -> Result<Vec<u8>, &'static str> {
    bytes(b"AKG:ACTION:CHECKPOINT:v1\0", c)
}
fn check_signature(
    key: &VerifyingKey,
    payload: &[u8],
    signature: &[u8],
) -> Result<(), &'static str> {
    let signature = Signature::from_slice(signature).map_err(|_| "invalid signature length")?;
    key.verify_strict(payload, &signature)
        .map_err(|_| "invalid signature")
}

/// Checks a mandate before dispatch. Does not establish observed execution or
/// spend/replay state; the broker must reserve that state before invoking a rail.
pub fn verify(
    proof: &ActionProof,
    intent: &WorkIntent,
    trust: &Trust,
) -> Result<Digest32, &'static str> {
    let m = &proof.mandate;
    let c = &proof.checkpoint;
    if m.profile != PROFILE
        || c.profile_digest != crate::mmr::profile::PROFILE_DIGEST_HEX
        || m.requested_by != intent.requested_by
        || m.intent_type != intent.intent_type
        || m.operation_id != intent.operation_id()
        || m.target != intent.target
        || m.policy_digest == Digest32::ZERO
        || m.policy_digest != trust.policy_digest
        || m.allowed_parameters.is_empty()
        || m.allowed_parameters.len() > 256
        || !m.allowed_parameters.contains(&intent.parameters_digest)
    {
        return Err("mandate does not bind this action and policy");
    }
    let mut unique = std::collections::HashSet::new();
    if !m.allowed_parameters.iter().all(|p| unique.insert(*p)) {
        return Err("duplicate parameter commitment");
    }
    if trust.now < 0
        || trust.max_checkpoint_age < 0
        || m.issued_at < 0
        || m.issued_at > c.issued_at
        || c.issued_at >= trust.now
        || m.expires_at <= trust.now
        || trust
            .now
            .checked_sub(c.issued_at)
            .is_none_or(|age| age > trust.max_checkpoint_age)
        || checkpoint_bytes(c)? != checkpoint_bytes(&trust.checkpoint)?
    {
        return Err("mandate or checkpoint time/trust mismatch");
    }
    let payload = mandate_bytes(m)?;
    check_signature(&trust.mandate_key, &payload, &proof.mandate_signature)?;
    check_signature(
        &trust.log_key,
        &checkpoint_bytes(c)?,
        &proof.checkpoint_signature,
    )?;
    if !verify_proof_at(
        &payload,
        c.leaf_count as usize,
        proof.leaf_index as usize,
        &proof.steps,
        &c.root,
    )
    .map_err(|_| "invalid mandate inclusion proof")?
    {
        return Err("mandate absent from trusted checkpoint");
    }
    Ok(Digest32::blake3(b"AKG:ACTION:VERIFIED:v1\0", &payload))
}
