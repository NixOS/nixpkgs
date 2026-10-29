use arkhe_core::Digest32;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum DePINProvider {
    Gensyn,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ReceiptKind {
    VerdeArbitration,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct NativeReceipt {
    pub provider: DePINProvider,
    pub kind: ReceiptKind,
    pub receipt_hash: Digest32,
    pub payload: Vec<u8>,
    /// Unix seconds in the proposed integration schema.
    pub issued_at: i64,
}

/// Opaque evidence committed by the proof. No TEE validation is implied.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct HardwareAttestation {
    pub nras_jwt: Option<String>,
    pub ppcie_report: Option<String>,
    pub nonce: [u8; 32],
    pub gpu_measurement: Option<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct AttestedReceipt {
    pub receipt: NativeReceipt,
    pub hardware_attestation: Option<HardwareAttestation>,
}
