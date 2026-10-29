use crate::{
    types::{DePINProvider, NativeReceipt, ReceiptKind},
    Error,
};
use arkhe_core::Digest32;
use serde::{Deserialize, Serialize};

/// Proposed integration DTO; not a verified upstream Verde wire format.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct VerdeReceipt {
    pub task_id: String,
    pub providers: Vec<String>,
    pub divergent_provider: String,
    pub divergence_op: String,
    pub referee_decision: String,
    pub referee_signature: Vec<u8>,
    pub completed_at: i64,
}

impl VerdeReceipt {
    pub fn to_native_receipt(&self) -> Result<NativeReceipt, Error> {
        GensynAdapter::normalize(self)
    }
}

pub struct GensynAdapter;
impl GensynAdapter {
    /// Structural validation and deterministic typed JSON encoding only.
    /// The referee signature is preserved, not authenticated.
    pub fn normalize(receipt: &VerdeReceipt) -> Result<NativeReceipt, Error> {
        if receipt.task_id.trim().is_empty()
            || receipt.divergence_op.trim().is_empty()
            || receipt.referee_decision.trim().is_empty()
            || receipt.referee_signature.is_empty()
            || receipt.completed_at < 0
            || receipt.providers.len() < 2
            || receipt.providers.iter().any(|p| p.trim().is_empty())
            || !receipt.providers.contains(&receipt.divergent_provider)
            || receipt
                .providers
                .iter()
                .enumerate()
                .any(|(i, p)| receipt.providers[..i].contains(p))
        {
            return Err(Error::InvalidReceipt("invalid arbitration fields"));
        }
        let payload = serde_json::to_vec(receipt)?;
        Ok(NativeReceipt {
            provider: DePINProvider::Gensyn,
            kind: ReceiptKind::VerdeArbitration,
            receipt_hash: Digest32::blake3(b"ARKHE/DEPIN/RECEIPT/v1", &payload),
            payload,
            issued_at: receipt.completed_at,
        })
    }

    pub fn validate(receipt: &NativeReceipt) -> Result<(), Error> {
        let decoded: VerdeReceipt = serde_json::from_slice(&receipt.payload)?;
        let normalized = Self::normalize(&decoded)?;
        if normalized.receipt_hash != receipt.receipt_hash
            || normalized.payload != receipt.payload
            || normalized.issued_at != receipt.issued_at
            || normalized.provider != receipt.provider
            || normalized.kind != receipt.kind
        {
            return Err(Error::InvalidReceipt("normalization mismatch"));
        }
        Ok(())
    }
}
