//! AP2 v0.2 Payment Mandate leg: consumes authenticated results of a role's
//! verifier. It never interprets raw SD-JWT as an authenticated mandate.
use crate::{
    hash::sha256,
    mmr::{profile::PROFILE_DIGEST_HEX, verify_proof_at, ProofStep},
};
use arkhe_core::{formal_proof::*, work::WorkIntent, worker::WorkerExecutionRecord, Digest32};
use ed25519_dalek::{Signature, VerifyingKey};

pub const BRIDGE: &str = "arkhe-ap2-payment-role@1";
pub fn closed_digest(token: &str) -> Digest32 {
    Digest32::blake3(b"AKG:AP2:CLOSED:v1\0", token.as_bytes())
}
fn signature(key: &[u8; 32], digest: Digest32, sig: &[u8]) -> Result<(), &'static str> {
    let key = VerifyingKey::from_bytes(key).map_err(|_| "invalid AP2 bridge trust key")?;
    let sig = Signature::from_slice(sig).map_err(|_| "invalid AP2 bridge signature")?;
    key.verify_strict(&digest.0, &sig)
        .map_err(|_| "AP2 role/checkpoint signature rejected")
}
pub fn verify(
    proof: &PaymentProof,
    spec: &PaymentPolicy,
    policy: Digest32,
    intent: &WorkIntent,
    worker: &WorkerExecutionRecord,
) -> Result<(), &'static str> {
    let r = &proof.role;
    let c = &spec.retained_checkpoint;
    if proof.steps.len() > 64
        || proof.closed_sd_jwt.is_empty()
        || proof.closed_sd_jwt.len() > 65536
        || proof.checkout_jwt.is_empty()
        || proof.checkout_jwt.len() > 65536
        || proof
            .open_sd_jwt
            .as_ref()
            .is_some_and(|v| v.is_empty() || v.len() > 65536)
        || spec.version != 1
        || spec.role_id.is_empty()
        || r.bridge_profile != BRIDGE
        || r.ap2_version != "0.2"
        || r.role_id != spec.role_id
        || r.principal != intent.requested_by
        || r.operation_id != intent.operation_id()
        || policy == Digest32::ZERO
        || r.policy_digest != policy
        || !r.signatures_validated
        || !r.constraints_validated
        || !r.checkout_binding_validated
        || r.closed_mandate_id == Digest32::ZERO
        || r.closed_sha256 != sha256(proof.closed_sd_jwt.as_bytes())
        || r.execution.checkout_sha256 != sha256(proof.checkout_jwt.as_bytes())
        || closed_digest(&proof.closed_sd_jwt) != intent.target
        || r.digest() != worker.input_digest
        || r.execution.digest() != worker.output_digest
        || r.execution.digest() != intent.parameters_digest
        || r.execution.payee.trim().is_empty()
        || r.execution.network.trim().is_empty()
        || r.execution.currency.len() != 3
        || !r.execution.currency.bytes().all(|b| b.is_ascii_uppercase())
        || r.execution.instrument_digest == Digest32::ZERO
        || r.execution.amount_minor == 0
    {
        return Err("AP2 role result does not bind the exact execution and mandate");
    }
    if spec.now < 0
        || spec.max_role_age < 0
        || spec.max_checkpoint_age < 0
        || c.issued_at < 0
        || r.closed_issued_at < 0
        || r.validated_at < r.closed_issued_at
        || r.validated_at > spec.now
        || r.expires_at <= spec.now
        || spec
            .now
            .checked_sub(r.validated_at)
            .is_none_or(|n| n > spec.max_role_age)
        || c.issued_at >= spec.now
        || spec
            .now
            .checked_sub(c.issued_at)
            .is_none_or(|n| n > spec.max_checkpoint_age)
        || c.profile_digest != PROFILE_DIGEST_HEX
    {
        return Err("AP2 role/checkpoint freshness rejected");
    }
    signature(&spec.role_public_key, r.digest(), &proof.role_signature)?;
    let token = match (&r.flow, &proof.open_sd_jwt, r.open_sha256, r.open_issued_at) {
        (Ap2Flow::Direct, None, None, None) if c.issued_at >= r.closed_issued_at => {
            &proof.closed_sd_jwt
        }
        (Ap2Flow::Autonomous, Some(open), Some(hash), Some(issued))
            if issued >= 0
                && issued <= c.issued_at
                && c.issued_at < r.closed_issued_at
                && hash == sha256(open.as_bytes()) =>
        {
            open
        }
        _ => return Err("AP2 flow or open-before-closed binding rejected"),
    };
    signature(
        &spec.log_public_key,
        c.digest(),
        &proof.checkpoint_signature,
    )?;
    let steps: Vec<_> = proof
        .steps
        .iter()
        .map(|p| ProofStep {
            kind: p.kind.clone(),
            direction: p.direction.clone(),
            hash: p.hash,
        })
        .collect();
    if !verify_proof_at(
        token.as_bytes(),
        c.leaf_count as usize,
        proof.leaf_index as usize,
        &steps,
        &c.root,
    )
    .map_err(|_| "AP2 mandate inclusion rejected")?
    {
        return Err("AP2 mandate absent from retained checkpoint");
    }
    Ok(())
}
