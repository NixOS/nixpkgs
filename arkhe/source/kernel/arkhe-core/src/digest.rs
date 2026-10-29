use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
pub struct Digest32(pub [u8; 32]);

impl Digest32 {
    pub const ZERO: Self = Self([0u8; 32]);

    pub fn blake3(domain: &[u8], payload: &[u8]) -> Self {
        let mut h = blake3::Hasher::new();
        h.update(domain);
        h.update(payload);
        Self(*h.finalize().as_bytes())
    }

    pub fn to_hex(self) -> String {
        self.0.iter().map(|b| format!("{b:02x}")).collect()
    }
}
