//! Synthetic credential evidence PoC. Does not validate CIN, VIO or government identity.
use crate::{
    error::VerifyError,
    hash::blake3_256,
    mmr::{verify_proof, ProofStep},
};
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
const PROFILE: &str = "arkhe-gov-synthetic-v1";
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Evidence {
    pub profile: String,
    pub jurisdiction: String,
    pub credential_type: String,
    pub credential_digest: [u8; 32],
    pub verifier: String,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Bundle {
    pub evidence: Evidence,
    pub leaf_index: u32,
    pub leaf_count: u32,
    pub proof: Vec<ProofStep>,
    pub checkpoint_root: [u8; 32],
    pub checkpoint_signature_hex: String,
}
fn invalid(message: &str) -> VerifyError {
    VerifyError::InvalidInput(message.into())
}
pub fn credential_digest(bytes: &[u8]) -> [u8; 32] {
    let mut input = b"AKG:GOV:SYNTHETIC-CREDENTIAL:v1\0".to_vec();
    input.extend_from_slice(bytes);
    blake3_256(&input)
}
pub fn evidence_leaf(record: &Evidence) -> Result<Vec<u8>, VerifyError> {
    if record.profile != PROFILE
        || record.jurisdiction != "BR"
        || record.credential_type != "CIN_SYNTHETIC"
        || record.verifier != "fixture-only-not-vio"
    {
        return Err(invalid("unsupported synthetic evidence profile"));
    }
    let mut bytes = b"AKG:GOV:SYNTHETIC-EVIDENCE:v1\0".to_vec();
    bytes.extend_from_slice(&record.credential_digest);
    Ok(blake3_256(&bytes).to_vec())
}
pub fn checkpoint_payload(root: &[u8; 32], count: u32) -> Vec<u8> {
    let mut bytes = b"AKG:GOV:SYNTHETIC-CHECKPOINT:v1\0".to_vec();
    bytes.extend_from_slice(&count.to_be_bytes());
    bytes.extend_from_slice(root);
    bytes
}
/// Trust key is supplied separately, never selected from the untrusted bundle.
/// Credential bytes are caller-local and are never retained by this pure verifier.
pub fn verify(bytes: &[u8], bundle: &Bundle, trusted_key: &[u8; 32]) -> Result<bool, VerifyError> {
    if bytes.is_empty()
        || bytes.len() > 32768
        || bundle.leaf_count != 4
        || bundle.leaf_index >= 4
        || bundle.proof.len() != 2
    {
        return Err(invalid("invalid four-leaf PoC shape"));
    }
    let mut index = bundle.leaf_index;
    for step in &bundle.proof {
        let direction = if index.is_multiple_of(2) {
            "right"
        } else {
            "left"
        };
        if step.kind != "node" || step.direction != direction {
            return Err(invalid("proof position mismatch"));
        }
        index /= 2;
    }
    let leaf = evidence_leaf(&bundle.evidence)?;
    if credential_digest(bytes) != bundle.evidence.credential_digest {
        return Ok(false);
    }
    let key = VerifyingKey::from_bytes(trusted_key).map_err(|_| invalid("invalid trusted key"))?;
    let signature = hex::decode(&bundle.checkpoint_signature_hex)
        .map_err(|_| invalid("invalid signature encoding"))?;
    let signature =
        Signature::from_slice(&signature).map_err(|_| invalid("invalid signature length"))?;
    if key
        .verify_strict(
            &checkpoint_payload(&bundle.checkpoint_root, bundle.leaf_count),
            &signature,
        )
        .is_err()
    {
        return Ok(false);
    }
    verify_proof(&leaf, 4, &bundle.proof, &bundle.checkpoint_root)
}
