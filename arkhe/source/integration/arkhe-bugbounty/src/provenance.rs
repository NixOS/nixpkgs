//! Detached Ed25519 receipts; neither signature nor receipt enters the WER preimage.
use crate::postgres::WorkerVerifier;
use arkhe_core::{
    canonical::encode_value,
    evidence::EvidenceReader,
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use async_trait::async_trait;
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

pub const RECEIPT_DOMAIN: &[u8] = b"AKG:WORKER:RECEIPT:v1\0";
#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub enum ExecutionOutcome {
    Succeeded,
    Failed,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SignedWorkerReceipt {
    pub version: u16,
    pub tenant: String,
    pub key_id: String,
    pub record_hash: Digest32,
    pub completed_at_ms: i64,
    pub outcome: ExecutionOutcome,
    pub signature_hex: String,
}
impl SignedWorkerReceipt {
    /// Includes tenant, key identity, result, timestamp and the entire unsigned WER hash.
    pub fn signing_bytes(&self) -> Vec<u8> {
        let mut bytes = RECEIPT_DOMAIN.to_vec();
        bytes.extend(encode_value(&serde_json::json!({"version":self.version,"tenant":self.tenant,"key_id":self.key_id,"record_hash":self.record_hash.to_hex(),"completed_at_ms":self.completed_at_ms,"outcome":self.outcome})));
        bytes
    }
}
#[derive(Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TrustedWorkerKey {
    pub key_id: String,
    pub public_key: [u8; 32],
    pub module_id: String,
    pub module_version: String,
    pub allowed_operations: Vec<CognitiveOperation>,
    /// Execution modules should require an admitted analysis as their input.
    /// Analysis may explicitly accept a raw observation; a signature never makes it proof.
    pub require_admitted_input: bool,
    pub active: bool,
}
#[async_trait]
pub trait ReceiptReader: Send + Sync {
    async fn receipts(&self, record: Digest32) -> Result<Vec<SignedWorkerReceipt>, String>;
}
pub struct SignedWorkerVerifier<S, E> {
    tenant: String,
    keys: HashMap<String, TrustedWorkerKey>,
    receipts: S,
    evidence: E,
}
impl<S: ReceiptReader, E: EvidenceReader> SignedWorkerVerifier<S, E> {
    pub fn new(
        tenant: String,
        keys: Vec<TrustedWorkerKey>,
        receipts: S,
        evidence: E,
    ) -> Result<Self, String> {
        if tenant.trim().is_empty() {
            return Err("tenant required".into());
        }
        let mut map = HashMap::new();
        for key in keys {
            let vk = VerifyingKey::from_bytes(&key.public_key).map_err(|_| "invalid public key")?;
            if vk.is_weak()
                || key.key_id.is_empty()
                || key.module_id.is_empty()
                || key.module_version.is_empty()
                || key.allowed_operations.is_empty()
            {
                return Err("invalid worker trust binding".into());
            }
            if map.insert(key.key_id.clone(), key).is_some() {
                return Err("duplicate trusted key identifier".into());
            }
        }
        Ok(Self {
            tenant,
            keys: map,
            receipts,
            evidence,
        })
    }
    pub async fn verify_detached(
        &self,
        record: &WorkerExecutionRecord,
        receipt: &SignedWorkerReceipt,
    ) -> Result<(), String> {
        if receipt.signature_hex.len() != 128
            || receipt.version != 1
            || receipt.tenant != self.tenant
            || receipt.record_hash != record.digest()
            || receipt.outcome != ExecutionOutcome::Succeeded
            || receipt.completed_at_ms < 0
        {
            return Err("receipt does not bind successful execution in this tenant".into());
        }
        let key = self
            .keys
            .get(&receipt.key_id)
            .ok_or("untrusted signing key")?;
        if !key.active
            || key.module_id != record.module_id
            || key.module_version != record.module_version
            || !record
                .operation
                .is_some_and(|op| key.allowed_operations.contains(&op))
        {
            return Err("worker key is not authorized for this module/version/operation".into());
        }
        let raw = hex::decode(&receipt.signature_hex).map_err(|_| "invalid signature encoding")?;
        let sig = Signature::from_slice(&raw).map_err(|_| "invalid signature length")?;
        VerifyingKey::from_bytes(&key.public_key)
            .map_err(|_| "invalid public key")?
            .verify_strict(&receipt.signing_bytes(), &sig)
            .map_err(|_| "worker signature rejected")?;
        let mut parents = record.evidence_refs.clone();
        if key.require_admitted_input {
            if !parents.contains(&record.input_digest) {
                return Err("execution input must be an explicit admitted parent".into());
            }
            parents.push(record.input_digest);
        }
        parents.sort_by_key(|h| h.to_hex());
        parents.dedup();
        for hash in parents {
            let envelope = self
                .evidence
                .get(hash)
                .await?
                .ok_or("missing admitted input evidence")?;
            if envelope.record_hash != hash {
                return Err("input evidence hash mismatch".into());
            }
        }
        Ok(())
    }
}
#[async_trait]
impl<S: ReceiptReader, E: EvidenceReader> WorkerVerifier for SignedWorkerVerifier<S, E> {
    async fn verify(&self, record: &WorkerExecutionRecord) -> Result<(), String> {
        let receipts = self.receipts.receipts(record.digest()).await?;
        if receipts.is_empty() || receipts.len() > 16 {
            return Err("missing or excessive worker receipts".into());
        }
        for receipt in receipts {
            if self.verify_detached(record, &receipt).await.is_ok() {
                return Ok(());
            }
        }
        Err("no trusted successful worker receipt with admitted inputs".into())
    }
}

#[async_trait]
impl<S: ReceiptReader, E: EvidenceReader> crate::workload::WorkloadReceiptVerifier
    for SignedWorkerVerifier<S, E>
{
    async fn verify_with_key(
        &self,
        record: &WorkerExecutionRecord,
        key: [u8; 32],
    ) -> Result<(), String> {
        let receipts = self.receipts.receipts(record.digest()).await?;
        if receipts.is_empty() || receipts.len() > 16 {
            return Err("missing or excessive workload receipts".into());
        }
        for receipt in receipts {
            if self
                .keys
                .get(&receipt.key_id)
                .is_some_and(|trusted| trusted.public_key == key)
                && self.verify_detached(record, &receipt).await.is_ok()
            {
                return Ok(());
            }
        }
        Err("no successful receipt from the attested workload key".into())
    }
}
