//! Offline verification in TRUSTED_ATTESTATION mode. Trust is supplied by the host,
//! never bootstrapped from witness keys or configuration inside an untrusted bundle.
use super::{keccak, Envelope, Error, MLDSA_CONTEXT};
use ed25519_dalek::{Signature, VerifyingKey};
use fips204::{
    ml_dsa_44,
    traits::{SerDes, Verifier},
};
use serde::{Deserialize, Serialize};
use std::collections::HashSet;

pub const ATTEST_CONTEXT: &[u8] = b"ARKHE_RBB_ATTEST_V1";

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct HybridKey {
    pub ed25519: [u8; 32],
    pub mldsa: Vec<u8>,
}

pub fn verify_hybrid(
    key: &HybridKey,
    digest: &[u8; 32],
    ed: &[u8],
    ml: &[u8],
    ctx: &[u8],
) -> Result<(), Error> {
    if ed.len() != 64 || ml.len() != 2420 || key.mldsa.len() != 1312 {
        return Err(Error::SignatureLength);
    }
    let ed_key = VerifyingKey::from_bytes(&key.ed25519).map_err(|_| Error::Signature)?;
    let ed_sig = Signature::from_slice(ed).map_err(|_| Error::Signature)?;
    ed_key
        .verify_strict(digest, &ed_sig)
        .map_err(|_| Error::Signature)?;
    let pk = ml_dsa_44::PublicKey::try_from_bytes(
        key.mldsa
            .as_slice()
            .try_into()
            .map_err(|_| Error::SignatureLength)?,
    )
    .map_err(|_| Error::Signature)?;
    let sig: [u8; 2420] = ml.try_into().map_err(|_| Error::SignatureLength)?;
    if !pk.verify(digest, &sig, ctx) {
        return Err(Error::Signature);
    }
    Ok(())
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Keyset {
    pub org_id: [u8; 32],
    pub version: u64,
    pub key: HybridKey,
    pub registered_block: u64,
    pub valid_from: u64,
    pub valid_until: u64,
    pub revoked_at: Option<u64>,
}

// Small canonical-CBOR writer for the closed assessment schema. No generic map/float serialization.
fn uint(out: &mut Vec<u8>, major: u8, value: u64) {
    match value {
        0..=23 => out.push(major << 5 | value as u8),
        24..=255 => out.extend([major << 5 | 24, value as u8]),
        256..=65535 => {
            out.push(major << 5 | 25);
            out.extend((value as u16).to_be_bytes());
        }
        65536..=4294967295 => {
            out.push(major << 5 | 26);
            out.extend((value as u32).to_be_bytes());
        }
        _ => {
            out.push(major << 5 | 27);
            out.extend(value.to_be_bytes());
        }
    }
}
fn bytes(out: &mut Vec<u8>, value: &[u8]) {
    uint(out, 2, value.len() as u64);
    out.extend(value);
}
fn array(out: &mut Vec<u8>, n: u64) {
    uint(out, 4, n);
}
fn number(out: &mut Vec<u8>, n: u64) {
    uint(out, 0, n);
}
fn digest(domain: &[u8], payload: &[u8]) -> [u8; 32] {
    let mut h = blake3::Hasher::new();
    h.update(domain);
    h.update(payload);
    *h.finalize().as_bytes()
}

impl Keyset {
    pub fn digest(&self) -> Result<[u8; 32], Error> {
        if self.key.mldsa.len() != 1312 {
            return Err(Error::SignatureLength);
        }
        let mut out = Vec::new();
        array(&mut out, 8);
        bytes(&mut out, &self.org_id);
        number(&mut out, self.version);
        bytes(&mut out, &self.key.ed25519);
        bytes(&mut out, &self.key.mldsa);
        number(&mut out, self.registered_block);
        number(&mut out, self.valid_from);
        number(&mut out, self.valid_until);
        match self.revoked_at {
            Some(t) => number(&mut out, t),
            None => out.push(0xf6),
        }
        Ok(digest(b"AKG:KEYSET:SNAPSHOT:v1\0", &out))
    }
}

#[derive(Debug, Clone)]
pub struct Witness {
    pub id: [u8; 32],
    pub key: HybridKey,
}

/// All values in this structure must come from the application's pinned, authenticated configuration.
#[derive(Debug, Clone)]
pub struct Trust {
    pub config_digest: [u8; 32],
    pub epoch: u64,
    pub chain_id: [u8; 32],
    pub genesis: [u8; 32],
    pub registry: [u8; 20],
    pub anchor: [u8; 20],
    pub registry_code_hash: [u8; 32],
    pub anchor_code_hash: [u8; 32],
    pub policy_catalog_digest: [u8; 32],
    pub mmr_profile_digest: [u8; 32],
    pub witnesses: Vec<Witness>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Assessment {
    pub config_digest: [u8; 32],
    pub epoch: u64,
    pub block_number: u64,
    pub block_hash: [u8; 32],
    pub state_root: [u8; 32],
    pub registry_code_hash: [u8; 32],
    pub anchor_code_hash: [u8; 32],
    pub envelope_commitment: [u8; 32],
    pub evidence_manifest_digest: [u8; 32],
    pub keyset_digest: [u8; 32],
    pub policy_catalog_digest: [u8; 32],
    pub watermark: u64,
    pub expected_events: u64,
    pub present_events: u64,
    pub gaps: u64,
    /// Bits 0..5: institution, signatures, anchor, temporal evidence, policy binding, continuity.
    pub verified_properties: u8,
    pub issued_at: u64,
    pub expires_at: u64,
    pub first_anchored_at: u64,
    pub first_anchored_block: u64,
    pub previous_accepted_id: [u8; 32],
}

impl Assessment {
    pub fn canonical_cbor(&self, env: &Envelope) -> Result<Vec<u8>, Error> {
        let h = &env.header;
        let mut out = Vec::new();
        uint(&mut out, 5, 14);
        number(&mut out, 0);
        number(&mut out, 1);
        number(&mut out, 1);
        array(&mut out, 2);
        bytes(&mut out, &self.config_digest);
        number(&mut out, self.epoch);
        number(&mut out, 2);
        array(&mut out, 2);
        bytes(&mut out, &h.anchor_chain_id);
        bytes(&mut out, &h.anchor_genesis_hash);
        number(&mut out, 3);
        array(&mut out, 5);
        number(&mut out, self.block_number);
        bytes(&mut out, &self.block_hash);
        bytes(&mut out, &self.state_root);
        number(&mut out, self.first_anchored_at);
        number(&mut out, self.first_anchored_block);
        number(&mut out, 4);
        array(&mut out, 4);
        bytes(&mut out, &h.registry_address);
        bytes(&mut out, &h.anchor_address);
        bytes(&mut out, &self.registry_code_hash);
        bytes(&mut out, &self.anchor_code_hash);
        number(&mut out, 5);
        array(&mut out, 4);
        bytes(&mut out, &h.org_id);
        bytes(&mut out, &h.stream_id);
        number(&mut out, h.sequence);
        bytes(&mut out, &h.checkpoint_id()?);
        number(&mut out, 6);
        array(&mut out, 2);
        bytes(&mut out, &self.envelope_commitment);
        bytes(&mut out, &self.evidence_manifest_digest);
        number(&mut out, 7);
        bytes(&mut out, &self.keyset_digest);
        number(&mut out, 8);
        bytes(&mut out, &self.policy_catalog_digest);
        number(&mut out, 9);
        array(&mut out, 4);
        number(&mut out, self.watermark);
        number(&mut out, self.expected_events);
        number(&mut out, self.present_events);
        number(&mut out, self.gaps);
        number(&mut out, 10);
        number(&mut out, self.verified_properties as u64);
        number(&mut out, 11);
        array(&mut out, 2);
        number(&mut out, self.issued_at);
        number(&mut out, self.expires_at);
        number(&mut out, 12);
        number(&mut out, h.source_kind as u64);
        number(&mut out, 13);
        bytes(&mut out, &self.previous_accepted_id);
        Ok(out)
    }
    pub fn digest(&self, env: &Envelope) -> Result<[u8; 32], Error> {
        Ok(digest(b"AKG:ASSESSMENT:v1\0", &self.canonical_cbor(env)?))
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Vote {
    pub witness_id: [u8; 32],
    pub ed25519_signature: Vec<u8>,
    pub mldsa_signature: Vec<u8>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CheckpointReport {
    pub checkpoint_id: [u8; 32],
    pub reference_block: u64,
    pub fresh: Option<bool>,
    pub coverage_complete: bool,
    pub trust_mode: &'static str,
}

/// Verifies checkpoint identity, hybrid signatures and attested institutional/anchor binding.
/// Does not claim to verify a WER or MMR inclusion: use mmr::verify for those properties.
pub fn verify_attested_checkpoint(
    env: &Envelope,
    keyset: &Keyset,
    assessment: &Assessment,
    votes: &[Vote],
    trust: &Trust,
    now: Option<u64>,
) -> Result<CheckpointReport, Error> {
    let h = &env.header;
    h.validate()?;
    if trust.witnesses.len() != 4 || votes.len() > 4 {
        return Err(Error::Quorum);
    }
    let mut identities = HashSet::new();
    let mut ed_keys = HashSet::new();
    let mut ml_keys = HashSet::new();
    for witness in &trust.witnesses {
        if !identities.insert(witness.id)
            || !ed_keys.insert(witness.key.ed25519)
            || !ml_keys.insert(keccak(&witness.key.mldsa))
        {
            return Err(Error::Quorum);
        }
    }
    if h.anchor_chain_id != trust.chain_id
        || h.anchor_genesis_hash != trust.genesis
        || h.registry_address != trust.registry
        || h.anchor_address != trust.anchor
        || h.mmr_profile_digest != trust.mmr_profile_digest
        || assessment.config_digest != trust.config_digest
        || assessment.epoch != trust.epoch
        || assessment.registry_code_hash != trust.registry_code_hash
        || assessment.anchor_code_hash != trust.anchor_code_hash
        || assessment.policy_catalog_digest != trust.policy_catalog_digest
        || assessment.envelope_commitment != env.commitment()?
        || assessment.keyset_digest != keyset.digest()?
        || keyset.org_id != h.org_id
        || keyset.version != h.keyset_version
        || keccak(&keyset.key.ed25519) != h.ed25519_key_id
        || keccak(&keyset.key.mldsa) != h.mldsa_key_id
        || keyset.registered_block > assessment.first_anchored_block
        || assessment.first_anchored_block > assessment.block_number
        || assessment.previous_accepted_id != h.prev_checkpoint_id
        || assessment.verified_properties != 0x3f
        || assessment.block_hash == [0; 32]
        || assessment.state_root == [0; 32]
        || assessment.evidence_manifest_digest == [0; 32]
    {
        return Err(Error::Binding);
    }
    if keyset.valid_from > h.declared_signed_at
        || h.declared_signed_at >= keyset.valid_until
        || assessment.first_anchored_at < h.declared_signed_at
        || assessment.first_anchored_at >= keyset.valid_until
        || assessment.first_anchored_at > assessment.issued_at
        || keyset
            .revoked_at
            .is_some_and(|t| assessment.first_anchored_at >= t)
        || assessment.expires_at < assessment.issued_at
        || assessment.expires_at - assessment.issued_at > 86400
    {
        return Err(Error::Time);
    }
    if let Some(now) = now {
        if assessment.issued_at > now.saturating_add(300) {
            return Err(Error::Time);
        }
    }
    verify_hybrid(
        &keyset.key,
        &h.checkpoint_id()?,
        &env.ed25519_signature,
        &env.mldsa_signature,
        MLDSA_CONTEXT,
    )?;
    let digest = assessment.digest(env)?;
    let mut seen = HashSet::new();
    for vote in votes {
        if !seen.insert(vote.witness_id) {
            return Err(Error::Quorum);
        }
        let witness = trust
            .witnesses
            .iter()
            .find(|w| w.id == vote.witness_id)
            .ok_or(Error::Quorum)?;
        verify_hybrid(
            &witness.key,
            &digest,
            &vote.ed25519_signature,
            &vote.mldsa_signature,
            ATTEST_CONTEXT,
        )?;
    }
    if seen.len() < 3 {
        return Err(Error::Quorum);
    }
    Ok(CheckpointReport {
        checkpoint_id: h.checkpoint_id()?,
        reference_block: assessment.block_number,
        fresh: now.map(|n| n >= assessment.issued_at && n < assessment.expires_at),
        coverage_complete: assessment.gaps == 0
            && assessment.expected_events == assessment.present_events,
        trust_mode: "TRUSTED_ATTESTATION",
    })
}
