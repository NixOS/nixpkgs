use arkhe_core::Digest32;

pub struct PrivateData {
    pub owner: String,
    pub ciphertext: Vec<u8>,
    pub key_ref: String,
    pub plaintext_digest: Digest32,
    pub expires_at: i64,
}

// Deliberately no conversion to EvidenceEnvelope exists here.
