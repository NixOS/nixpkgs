//! Offline Stage 10 laboratory profile. Not a Sigstore/Fulcio verifier.
use crate::{
    cbor::canonical::encode_json,
    error::VerifyError,
    hash::{blake3_256, sha256},
};
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::{json, Map, Value};
use std::collections::HashSet;

pub const PROFILE: &str = "arkhe-gguf-lab@1";
pub const MAX_ARTIFACT_BYTES: usize = 16 * 1024 * 1024;

fn reject(gate: u8, reason: &str) -> VerifyError {
    VerifyError::VerificationFailed(format!("gate {gate}: {reason}"))
}

struct Reader<'a> {
    bytes: &'a [u8],
    offset: usize,
}
impl<'a> Reader<'a> {
    fn take(&mut self, count: usize) -> Result<&'a [u8], VerifyError> {
        let end = self
            .offset
            .checked_add(count)
            .ok_or_else(|| reject(1, "offset overflow"))?;
        let bytes = self
            .bytes
            .get(self.offset..end)
            .ok_or_else(|| reject(1, "truncated GGUF"))?;
        self.offset = end;
        Ok(bytes)
    }
    fn u32(&mut self) -> Result<u32, VerifyError> {
        Ok(u32::from_le_bytes(self.take(4)?.try_into().unwrap()))
    }
    fn u64(&mut self) -> Result<u64, VerifyError> {
        Ok(u64::from_le_bytes(self.take(8)?.try_into().unwrap()))
    }
    fn text(&mut self) -> Result<String, VerifyError> {
        let count = self.u64()?;
        if count > 4096 {
            return Err(reject(1, "string limit exceeded"));
        }
        let text = std::str::from_utf8(self.take(count as usize)?)
            .map_err(|_| reject(1, "invalid UTF-8"))?;
        if text.is_empty() || text.chars().any(char::is_control) {
            return Err(reject(1, "empty string or control character"));
        }
        Ok(text.into())
    }
}

/// Strict little-endian v3 subset: string metadata, uint32 alignment, F32 tensors.
/// No model is loaded and no metadata/template is executed.
pub fn inspect(bytes: &[u8]) -> Result<Value, VerifyError> {
    if bytes.len() > MAX_ARTIFACT_BYTES {
        return Err(reject(1, "artifact limit exceeded"));
    }
    let mut r = Reader { bytes, offset: 0 };
    if r.take(4)? != b"GGUF" || r.u32()? != 3 {
        return Err(reject(1, "expected GGUF v3 little-endian"));
    }
    let tensors = r.u64()?;
    let entries = r.u64()?;
    if tensors == 0 || tensors > 256 || entries > 128 {
        return Err(reject(1, "tensor/metadata count outside profile"));
    }
    let mut metadata = Map::new();
    let mut alignment = 32usize;
    for _ in 0..entries {
        let name = r.text()?;
        if name.len() > 128
            || !name
                .bytes()
                .all(|c| c.is_ascii_alphanumeric() || b"._".contains(&c))
        {
            return Err(reject(1, "invalid metadata key"));
        }
        let value_type = r.u32()?;
        let value = if name == "general.alignment" && value_type == 4 {
            alignment = r.u32()? as usize;
            if alignment > 4096 || !alignment.is_power_of_two() {
                return Err(reject(1, "invalid alignment"));
            }
            json!(alignment)
        } else if value_type == 8 && name != "general.alignment" {
            json!(r.text()?)
        } else {
            return Err(reject(1, "unsupported metadata type"));
        };
        if metadata.insert(name, value).is_some() {
            return Err(reject(1, "duplicate metadata key"));
        }
    }
    if !metadata
        .get("general.architecture")
        .is_some_and(Value::is_string)
    {
        return Err(reject(1, "missing architecture"));
    }
    let mut names = HashSet::new();
    let mut ranges = Vec::new();
    for _ in 0..tensors {
        if !names.insert(r.text()?) {
            return Err(reject(1, "duplicate tensor name"));
        }
        let dimensions = r.u32()?;
        if !(1..=4).contains(&dimensions) {
            return Err(reject(1, "invalid tensor dimension count"));
        }
        let mut size = 4u64;
        for _ in 0..dimensions {
            let dimension = r.u64()?;
            if dimension == 0 {
                return Err(reject(1, "zero tensor dimension"));
            }
            size = size
                .checked_mul(dimension)
                .ok_or_else(|| reject(1, "tensor size overflow"))?;
        }
        if r.u32()? != 0 {
            return Err(reject(1, "only F32 tensors supported"));
        }
        let offset = r.u64()?;
        if offset % alignment as u64 != 0 {
            return Err(reject(1, "unaligned tensor"));
        }
        let end = offset
            .checked_add(size)
            .ok_or_else(|| reject(1, "tensor offset overflow"))?;
        ranges.push((offset, end));
    }
    let start = r.offset.div_ceil(alignment) * alignment;
    if start > bytes.len() || bytes[r.offset..start].iter().any(|b| *b != 0) {
        return Err(reject(1, "invalid padding"));
    }
    ranges.sort_unstable();
    let mut end = 0;
    for (offset, next) in ranges {
        if offset < end || next > (bytes.len() - start) as u64 {
            return Err(reject(1, "overlapping or truncated tensor"));
        }
        end = next;
    }
    if end != (bytes.len() - start) as u64 {
        return Err(reject(1, "unexpected trailing data"));
    }
    Ok(Value::Object(metadata))
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Statement {
    pub profile: String,
    pub builder_id: String,
    pub artifact_sha256: String,
    pub artifact_blake3: String,
    pub metadata_sha256: String,
}

pub fn statement(bytes: &[u8], builder_id: String) -> Result<Statement, VerifyError> {
    let metadata = inspect(bytes)?;
    Ok(Statement {
        profile: PROFILE.into(),
        builder_id,
        artifact_sha256: hex::encode(sha256(bytes)),
        artifact_blake3: hex::encode(blake3_256(bytes)),
        metadata_sha256: hex::encode(sha256(&super::canonical::canonicalize_metadata(&metadata)?)),
    })
}

pub fn statement_bytes(statement: &Statement) -> Result<Vec<u8>, VerifyError> {
    let mut bytes = b"ARKHE:GGUF:PROVENANCE:v1\0".to_vec();
    bytes.extend(encode_json(
        &serde_json::to_value(statement).map_err(|_| reject(3, "invalid statement"))?,
    )?);
    Ok(bytes)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Checkpoint {
    pub log_id: String,
    pub tree_size: u64,
    pub root_hex: String,
    pub issued_at: u64,
    pub signature_hex: String,
}
pub fn checkpoint_bytes(checkpoint: &Checkpoint) -> Result<Vec<u8>, VerifyError> {
    let mut bytes = b"ARKHE:GGUF:LOG:v1\0".to_vec();
    bytes.extend(encode_json(
        &json!({"log_id": checkpoint.log_id, "tree_size": checkpoint.tree_size,
        "root_hex": checkpoint.root_hex, "issued_at": checkpoint.issued_at}),
    )?);
    Ok(bytes)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Bundle {
    pub statement: Statement,
    pub builder_signature_hex: String,
    pub checkpoint: Checkpoint,
    pub leaf_index: u64,
    pub inclusion_path: Vec<String>,
}

/// Must arrive through an independent trusted channel, never from the bundle.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Trust {
    pub builder_id: String,
    pub builder_public_key_hex: String,
    pub log_id: String,
    pub log_public_key_hex: String,
    pub minimum_tree_size: u64,
    pub earliest_issued_at: u64,
    pub latest_issued_at: u64,
}

fn digest(value: &str, gate: u8) -> Result<[u8; 32], VerifyError> {
    hex::decode(value)
        .map_err(|_| reject(gate, "invalid hex"))?
        .try_into()
        .map_err(|_| reject(gate, "expected 32 bytes"))
}
fn signature(public: &str, bytes: &[u8], sig: &str, gate: u8) -> Result<(), VerifyError> {
    let key = VerifyingKey::from_bytes(&digest(public, gate)?)
        .map_err(|_| reject(gate, "invalid key"))?;
    if key.is_weak() {
        return Err(reject(gate, "weak key"));
    }
    let raw = hex::decode(sig).map_err(|_| reject(gate, "invalid signature hex"))?;
    let sig = Signature::from_slice(&raw).map_err(|_| reject(gate, "invalid signature length"))?;
    key.verify_strict(bytes, &sig)
        .map_err(|_| reject(gate, "signature rejected"))
}

/// The leaf binds both the signed statement and its builder signature.
pub fn log_leaf(bundle: &Bundle) -> Result<Vec<u8>, VerifyError> {
    encode_json(
        &json!({"statement": bundle.statement, "builder_signature_hex": bundle.builder_signature_hex}),
    )
}
pub fn leaf_hash(leaf: &[u8]) -> [u8; 32] {
    sha256(&[&[0u8][..], leaf].concat())
}
pub fn node_hash(left: &[u8; 32], right: &[u8; 32]) -> [u8; 32] {
    sha256(&[&[1u8][..], left, right].concat())
}

/// RFC 6962 section 2.1.1, including unbalanced trees and exact path consumption.
pub fn verify_inclusion(
    leaf: &[u8],
    index: u64,
    size: u64,
    path: &[[u8; 32]],
    root: [u8; 32],
) -> Result<(), VerifyError> {
    if size == 0 || index >= size || path.len() > 64 {
        return Err(reject(4, "invalid inclusion bounds"));
    }
    let (mut position, mut last) = (index, size - 1);
    let mut hash = leaf_hash(leaf);
    for sibling in path {
        if last == 0 {
            return Err(reject(4, "excess inclusion nodes"));
        }
        if position & 1 == 1 || position == last {
            hash = node_hash(sibling, &hash);
            while position != 0 && position & 1 == 0 {
                position >>= 1;
                last >>= 1;
            }
        } else {
            hash = node_hash(&hash, sibling);
        }
        position >>= 1;
        last >>= 1;
    }
    if last != 0 || hash != root {
        return Err(reject(4, "inclusion proof rejected"));
    }
    Ok(())
}

#[derive(Debug, Serialize)]
pub struct Report {
    pub profile: String,
    pub gates_passed: [String; 4],
    pub artifact_sha256: String,
    pub artifact_blake3: String,
    pub metadata_sha256: String,
    pub builder_id: String,
    pub log_id: String,
    pub tree_size: u64,
}

pub fn verify(bytes: &[u8], bundle: &Bundle, trust: &Trust) -> Result<Report, VerifyError> {
    let actual = statement(bytes, trust.builder_id.clone())?;
    let s = &bundle.statement;
    if s.profile != PROFILE {
        return Err(reject(2, "unsupported profile"));
    }
    if s.artifact_sha256 != actual.artifact_sha256
        || s.artifact_blake3 != actual.artifact_blake3
        || s.metadata_sha256 != actual.metadata_sha256
    {
        return Err(reject(2, "digest mismatch"));
    }
    if trust.builder_id.is_empty() || s.builder_id != trust.builder_id {
        return Err(reject(3, "builder identity rejected"));
    }
    signature(
        &trust.builder_public_key_hex,
        &statement_bytes(s)?,
        &bundle.builder_signature_hex,
        3,
    )?;
    let cp = &bundle.checkpoint;
    if trust.log_id.is_empty()
        || cp.log_id != trust.log_id
        || trust.minimum_tree_size == 0
        || cp.tree_size < trust.minimum_tree_size
        || trust.earliest_issued_at > trust.latest_issued_at
        || cp.issued_at < trust.earliest_issued_at
        || cp.issued_at > trust.latest_issued_at
    {
        return Err(reject(4, "checkpoint trust bounds rejected"));
    }
    signature(
        &trust.log_public_key_hex,
        &checkpoint_bytes(cp)?,
        &cp.signature_hex,
        4,
    )?;
    let path = bundle
        .inclusion_path
        .iter()
        .map(|p| digest(p, 4))
        .collect::<Result<Vec<_>, _>>()?;
    verify_inclusion(
        &log_leaf(bundle)?,
        bundle.leaf_index,
        cp.tree_size,
        &path,
        digest(&cp.root_hex, 4)?,
    )?;
    Ok(Report {
        profile: PROFILE.into(),
        gates_passed: [
            "gguf_subset",
            "dual_digest",
            "pinned_builder_signature",
            "rfc6962_local_log",
        ]
        .map(String::from),
        artifact_sha256: actual.artifact_sha256,
        artifact_blake3: actual.artifact_blake3,
        metadata_sha256: actual.metadata_sha256,
        builder_id: trust.builder_id.clone(),
        log_id: cp.log_id.clone(),
        tree_size: cp.tree_size,
    })
}
