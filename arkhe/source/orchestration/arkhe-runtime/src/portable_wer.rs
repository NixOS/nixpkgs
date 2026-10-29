//! Local signed WER journal. Trust and rollback floors come from the verifier.
//! A host signature is not model/TEE attestation or a trusted wall-clock timestamp.
use arkhe_core::{
    canonical::encode_value, work::WorkIntent, worker::WorkerExecutionRecord, CanonicalEncode,
    Digest32,
};
use arkhe_verify_core::mmr::{
    inclusion::{build_root_and_proof, verify_proof_at, ProofStep},
    profile::PROFILE_DIGEST_HEX,
};
use arkhe_wormgraph::{
    anchor::{CheckpointTrust, SignedCheckpoint},
    regenerate::{rebuild, CheckpointBinding},
};
use ed25519_dalek::{Signature, Signer, SigningKey, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::{
    fs::{self, OpenOptions},
    io::Write,
    path::{Path, PathBuf},
};

type Result<T> = std::result::Result<T, String>;
const DOMAIN: &[u8] = b"AKG:WER:SIGNATURE:v1\0";
const MAX_LOG_BYTES: u64 = 64 * 1024 * 1024;
const MAX_LEAVES: usize = 100_000;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct WerTrust {
    pub worker_public_key: [u8; 32],
    pub checkpoint: CheckpointTrust,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SignedWer {
    pub intent: WorkIntent,
    pub worker: WorkerExecutionRecord,
    pub signature_hex: String,
}

impl SignedWer {
    fn signing_bytes(&self) -> Vec<u8> {
        let mut bytes = DOMAIN.to_vec();
        bytes.extend(self.worker.canonical_bytes());
        bytes
    }

    pub fn record_hash(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:WER:SIGNED-RECORD:v1\0",
            &encode_value(&json!({
                "intent_digest": self.intent.digest(), "worker_digest": self.worker.digest(),
                "worker_signature_hex": self.signature_hex,
            })),
        )
    }

    pub fn verify(&self, public_key: &[u8; 32]) -> Result<()> {
        if self.worker.input_digest != self.intent.digest() || self.worker.execution_id.is_empty() {
            return Err("WER/intent binding rejected".into());
        }
        let key = VerifyingKey::from_bytes(public_key).map_err(|e| e.to_string())?;
        if key.is_weak() {
            return Err("weak worker key".into());
        }
        let raw = hex::decode(&self.signature_hex).map_err(|e| e.to_string())?;
        let sig = Signature::from_slice(&raw).map_err(|e| e.to_string())?;
        key.verify_strict(&self.signing_bytes(), &sig)
            .map_err(|e| e.to_string())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PortableWer {
    pub signed_wer: SignedWer,
    pub record_hash: Digest32,
    pub leaf_index: usize,
    pub proof: Vec<ProofStep>,
    pub checkpoint: SignedCheckpoint,
}

impl PortableWer {
    pub fn verify(&self, trust: &WerTrust) -> Result<()> {
        self.signed_wer.verify(&trust.worker_public_key)?;
        if self.record_hash != self.signed_wer.record_hash() {
            return Err("signed record hash mismatch".into());
        }
        self.checkpoint
            .verify(&self.checkpoint.binding(), &trust.checkpoint)
            .map_err(|e| e.0)?;
        let count = usize::try_from(self.checkpoint.leaf_count).map_err(|e| e.to_string())?;
        if count > MAX_LEAVES {
            return Err("journal leaf limit exceeded".into());
        }
        if !verify_proof_at(
            &self.record_hash.0,
            count,
            self.leaf_index,
            &self.proof,
            &self.checkpoint.root,
        )
        .map_err(|e| e.to_string())?
        {
            return Err("MMR inclusion rejected".into());
        }
        Ok(())
    }
}

struct Lock(PathBuf);
impl Drop for Lock {
    fn drop(&mut self) {
        let _ = fs::remove_file(&self.0);
    }
}

fn read_log(path: &Path, trust: &WerTrust) -> Result<Vec<PortableWer>> {
    if !path.exists() {
        return Ok(vec![]);
    }
    if fs::metadata(path).map_err(|e| e.to_string())?.len() > MAX_LOG_BYTES {
        return Err("journal too large".into());
    }
    let raw = fs::read_to_string(path).map_err(|e| e.to_string())?;
    if !raw.is_empty() && !raw.ends_with('\n') {
        return Err("partial journal tail; manual recovery required".into());
    }
    let mut rows: Vec<PortableWer> = Vec::new();
    let mut hashes = Vec::new();
    let mut historical_trust = trust.clone();
    historical_trust.checkpoint.minimum_leaf_count = 1;
    for line in raw.lines() {
        if rows.len() >= MAX_LEAVES {
            return Err("journal leaf limit exceeded".into());
        }
        let row: PortableWer = serde_json::from_str(line).map_err(|e| e.to_string())?;
        row.verify(&historical_trust)?;
        if row.leaf_index != rows.len() || row.checkpoint.leaf_count != rows.len() as u64 + 1 {
            return Err("journal sequence mismatch".into());
        }
        if rows
            .iter()
            .any(|old| old.signed_wer.worker.execution_id == row.signed_wer.worker.execution_id)
        {
            return Err("duplicate execution ID".into());
        }
        if rows
            .last()
            .is_some_and(|old| old.checkpoint.issued_at > row.checkpoint.issued_at)
        {
            return Err("checkpoint time regression".into());
        }
        hashes.push(row.record_hash);
        let mmr = rebuild(&hashes).map_err(|e| format!("{e:?}"))?;
        if row.checkpoint.root != mmr.root.0
            || row.checkpoint.peaks != mmr.peaks.iter().map(|p| p.0).collect::<Vec<_>>()
            || row.checkpoint.covered_up_to != row.record_hash.0
        {
            return Err("journal prefix mismatch".into());
        }
        rows.push(row);
    }
    // An externally retained floor detects removal of a previously observed tail.
    if let Some(last) = rows.last() {
        last.verify(trust)?;
    } else if trust.checkpoint.minimum_leaf_count > 1 {
        return Err("journal below retained floor".into());
    }
    Ok(rows)
}

/// Append only after host-side validation. This records observations, not authority.
/// A crashed writer can leave a lock/partial tail; neither is repaired automatically.
pub fn append(
    path: &Path,
    intent: WorkIntent,
    worker: WorkerExecutionRecord,
    worker_key: &SigningKey,
    log_key: &SigningKey,
    trust: &WerTrust,
    issued_at: u64,
) -> Result<PortableWer> {
    if worker_key.verifying_key().to_bytes() != trust.worker_public_key
        || log_key.verifying_key().to_bytes() != trust.checkpoint.public_key
    {
        return Err("signer is not pinned in supplied trust policy".into());
    }
    let lock_path = path.with_extension("lock");
    let _handle = OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(&lock_path)
        .map_err(|e| format!("journal lock: {e}"))?;
    let _lock = Lock(lock_path);
    let old = read_log(path, trust)?;
    if old.len() >= MAX_LEAVES
        || old
            .iter()
            .any(|r| r.signed_wer.worker.execution_id == worker.execution_id)
    {
        return Err("duplicate execution ID or full journal".into());
    }
    if old
        .last()
        .is_some_and(|r| issued_at < r.checkpoint.issued_at)
    {
        return Err("checkpoint time regression".into());
    }
    let mut signed_wer = SignedWer {
        intent,
        worker,
        signature_hex: String::new(),
    };
    signed_wer.signature_hex = hex::encode(worker_key.sign(&signed_wer.signing_bytes()).to_bytes());
    signed_wer.verify(&trust.worker_public_key)?;
    let record_hash = signed_wer.record_hash();
    let mut hashes: Vec<Digest32> = old.iter().map(|r| r.record_hash).collect();
    hashes.push(record_hash);
    let mmr = rebuild(&hashes).map_err(|e| format!("{e:?}"))?;
    let binding = CheckpointBinding {
        tenant_id: trust.checkpoint.tenant_id.clone(),
        stream_id: trust.checkpoint.stream_id.clone(),
        leaf_count: mmr.leaf_count,
        mmr_size: mmr.mmr_size,
        root: mmr.root,
        peaks: mmr.peaks,
        profile_digest: Digest32(hex::decode(PROFILE_DIGEST_HEX).unwrap().try_into().unwrap()),
        covered_up_to: record_hash,
    };
    let mut checkpoint =
        SignedCheckpoint::from_binding(&binding, trust.checkpoint.log_id, issued_at, String::new());
    checkpoint.signature_hex = hex::encode(log_key.sign(&checkpoint.signing_bytes()).to_bytes());
    let leaves: Vec<Vec<u8>> = hashes.iter().map(|h| h.0.to_vec()).collect();
    let (root, proof) = build_root_and_proof(&leaves, old.len()).map_err(|e| e.to_string())?;
    if root != checkpoint.root {
        return Err("MMR implementations disagree".into());
    }
    let bundle = PortableWer {
        signed_wer,
        record_hash,
        leaf_index: old.len(),
        proof,
        checkpoint,
    };
    bundle.verify(trust)?;
    let mut bytes = serde_json::to_vec(&bundle).map_err(|e| e.to_string())?;
    bytes.push(b'\n');
    let existing_len = fs::metadata(path).map(|m| m.len()).unwrap_or(0);
    if existing_len + bytes.len() as u64 > MAX_LOG_BYTES {
        return Err("journal too large".into());
    }
    let mut file = OpenOptions::new()
        .create(true)
        .append(true)
        .open(path)
        .map_err(|e| e.to_string())?;
    file.write_all(&bytes)
        .and_then(|_| file.sync_all())
        .map_err(|e| e.to_string())?;
    // Read back the durable bytes before returning success.
    let rows = read_log(path, trust)?;
    if rows.last().map(|r| r.record_hash) != Some(record_hash) {
        return Err("journal readback mismatch".into());
    }
    Ok(bundle)
}
