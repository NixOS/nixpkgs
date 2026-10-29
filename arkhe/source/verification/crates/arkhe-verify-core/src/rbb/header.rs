use super::{keccak, Error};
use serde::{Deserialize, Serialize};

pub const HEADER_LEN: usize = 27 * 32;
pub const ENVELOPE_LEN: usize = 3488;
pub const DOMAIN: &[u8] = b"AKG:CHECKPOINT:HEADER:v3\0";
pub const MLDSA_CONTEXT: &[u8] = b"ARKHE_RBB_EVIDENCE_V3";

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Header {
    pub protocol_version: u8,
    pub profile_id: u16,
    pub anchor_chain_id: [u8; 32],
    pub anchor_genesis_hash: [u8; 32],
    pub registry_address: [u8; 20],
    pub anchor_address: [u8; 20],
    pub org_id: [u8; 32],
    pub power: u8,
    pub stream_id: [u8; 32],
    pub sequence: u64,
    pub prev_checkpoint_id: [u8; 32],
    pub first_leaf_index: u64,
    pub batch_leaf_count: u64,
    pub total_leaf_count: u64,
    pub mmr_root: [u8; 32],
    pub batch_manifest_digest: [u8; 32],
    pub policy_digest: [u8; 32],
    pub declared_signed_at: u64,
    pub source_kind: u8,
    pub source_network_id: [u8; 32],
    pub source_manifest_digest: [u8; 32],
    pub ed25519_key_id: [u8; 32],
    pub mldsa_key_id: [u8; 32],
    pub keyset_version: u64,
    pub prev_present: bool,
    pub source_manifest_present: bool,
    pub mmr_profile_digest: [u8; 32],
}

impl Header {
    pub fn validate(&self) -> Result<(), Error> {
        if self.protocol_version != 3 {
            return Err(Error::Header("version"));
        }
        if self.profile_id != 1 {
            return Err(Error::Profile);
        }
        if !(1..=3).contains(&self.power) || !(1..=4).contains(&self.source_kind) {
            return Err(Error::Header("enum"));
        }
        if self.sequence == 0 || self.keyset_version == 0 || self.declared_signed_at == 0 {
            return Err(Error::Header("zero counter or timestamp"));
        }
        if self.batch_leaf_count == 0
            || self.first_leaf_index.checked_add(self.batch_leaf_count)
                != Some(self.total_leaf_count)
        {
            return Err(Error::Header("leaf interval"));
        }
        if self.prev_present != (self.sequence > 1)
            || self.prev_present != (self.prev_checkpoint_id != [0; 32])
            || (self.sequence == 1 && self.first_leaf_index != 0)
        {
            return Err(Error::Header("predecessor"));
        }
        if self.source_manifest_present != (self.source_manifest_digest != [0; 32])
            || (self.source_kind == 2 && !self.source_manifest_present)
        {
            return Err(Error::Header("source manifest"));
        }
        for id in [
            &self.anchor_chain_id,
            &self.anchor_genesis_hash,
            &self.org_id,
            &self.stream_id,
            &self.mmr_root,
            &self.batch_manifest_digest,
            &self.policy_digest,
            &self.source_network_id,
            &self.ed25519_key_id,
            &self.mldsa_key_id,
            &self.mmr_profile_digest,
        ] {
            if *id == [0; 32] {
                return Err(Error::Header("zero identifier"));
            }
        }
        if self.registry_address == [0; 20] || self.anchor_address == [0; 20] {
            return Err(Error::Header("zero address"));
        }
        Ok(())
    }

    pub fn encode(&self) -> Result<Vec<u8>, Error> {
        self.validate()?;
        let mut out = Vec::with_capacity(HEADER_LEN);
        out.extend(word(self.protocol_version as u64));
        out.extend(word(self.profile_id as u64));
        out.extend(self.anchor_chain_id);
        out.extend(self.anchor_genesis_hash);
        for address in [&self.registry_address, &self.anchor_address] {
            out.extend([0; 12]);
            out.extend(address);
        }
        out.extend(self.org_id);
        out.extend(word(self.power as u64));
        out.extend(self.stream_id);
        out.extend(word(self.sequence));
        out.extend(self.prev_checkpoint_id);
        out.extend(word(self.first_leaf_index));
        out.extend(word(self.batch_leaf_count));
        out.extend(word(self.total_leaf_count));
        out.extend(self.mmr_root);
        out.extend(self.batch_manifest_digest);
        out.extend(self.policy_digest);
        out.extend(word(self.declared_signed_at));
        out.extend(word(self.source_kind as u64));
        out.extend(self.source_network_id);
        out.extend(self.source_manifest_digest);
        out.extend(self.ed25519_key_id);
        out.extend(self.mldsa_key_id);
        out.extend(word(self.keyset_version));
        out.extend(word(self.prev_present as u64));
        out.extend(word(self.source_manifest_present as u64));
        out.extend(self.mmr_profile_digest);
        Ok(out)
    }

    pub fn decode(bytes: &[u8]) -> Result<Self, Error> {
        if bytes.len() != HEADER_LEN {
            return Err(Error::NonCanonical);
        }
        let d = |i: usize| -> [u8; 32] {
            bytes[i * 32..(i + 1) * 32]
                .try_into()
                .expect("fixed ABI word")
        };
        let n = |i| read_u64(&d(i));
        let a = |i| -> Result<[u8; 20], Error> {
            let w = d(i);
            if w[..12] != [0; 12] {
                return Err(Error::NonCanonical);
            }
            Ok(w[12..].try_into().expect("address length"))
        };
        let b = |i| match n(i)? {
            0 => Ok(false),
            1 => Ok(true),
            _ => Err(Error::NonCanonical),
        };
        let header = Self {
            protocol_version: n(0)?.try_into().map_err(|_| Error::NonCanonical)?,
            profile_id: n(1)?.try_into().map_err(|_| Error::NonCanonical)?,
            anchor_chain_id: d(2),
            anchor_genesis_hash: d(3),
            registry_address: a(4)?,
            anchor_address: a(5)?,
            org_id: d(6),
            power: n(7)?.try_into().map_err(|_| Error::NonCanonical)?,
            stream_id: d(8),
            sequence: n(9)?,
            prev_checkpoint_id: d(10),
            first_leaf_index: n(11)?,
            batch_leaf_count: n(12)?,
            total_leaf_count: n(13)?,
            mmr_root: d(14),
            batch_manifest_digest: d(15),
            policy_digest: d(16),
            declared_signed_at: n(17)?,
            source_kind: n(18)?.try_into().map_err(|_| Error::NonCanonical)?,
            source_network_id: d(19),
            source_manifest_digest: d(20),
            ed25519_key_id: d(21),
            mldsa_key_id: d(22),
            keyset_version: n(23)?,
            prev_present: b(24)?,
            source_manifest_present: b(25)?,
            mmr_profile_digest: d(26),
        };
        if header.encode()? != bytes {
            return Err(Error::NonCanonical);
        }
        Ok(header)
    }

    pub fn checkpoint_id(&self) -> Result<[u8; 32], Error> {
        let mut bytes = keccak(DOMAIN).to_vec();
        bytes.extend(self.encode()?);
        Ok(keccak(&bytes))
    }
}

pub(crate) fn word(value: u64) -> [u8; 32] {
    let mut w = [0; 32];
    w[24..].copy_from_slice(&value.to_be_bytes());
    w
}

fn read_u64(w: &[u8; 32]) -> Result<u64, Error> {
    if w[..24] != [0; 24] {
        return Err(Error::NonCanonical);
    }
    Ok(u64::from_be_bytes(w[24..].try_into().expect("u64 length")))
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Envelope {
    pub header: Header,
    pub ed25519_signature: Vec<u8>,
    pub mldsa_signature: Vec<u8>,
}

impl Envelope {
    pub fn encode(&self) -> Result<Vec<u8>, Error> {
        if self.ed25519_signature.len() != 64 || self.mldsa_signature.len() != 2420 {
            return Err(Error::SignatureLength);
        }
        let mut out = self.header.encode()?;
        out.extend(word(928));
        out.extend(word(1024));
        out.extend(word(64));
        out.extend(&self.ed25519_signature);
        out.extend(word(2420));
        out.extend(&self.mldsa_signature);
        out.extend([0; 12]);
        Ok(out)
    }

    pub fn decode(bytes: &[u8]) -> Result<Self, Error> {
        if bytes.len() != ENVELOPE_LEN {
            return Err(Error::NonCanonical);
        }
        let envelope = Self {
            header: Header::decode(&bytes[..HEADER_LEN])?,
            ed25519_signature: bytes[960..1024].to_vec(),
            mldsa_signature: bytes[1056..3476].to_vec(),
        };
        if envelope.encode()? != bytes {
            return Err(Error::NonCanonical);
        }
        Ok(envelope)
    }

    pub fn commitment(&self) -> Result<[u8; 32], Error> {
        Ok(keccak(&self.encode()?))
    }
}
