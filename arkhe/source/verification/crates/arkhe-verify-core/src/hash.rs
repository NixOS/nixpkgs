use sha2::{Digest, Sha256};

pub fn blake3_256(data: &[u8]) -> [u8; 32] {
    *blake3::hash(data).as_bytes()
}

pub fn sha256(data: &[u8]) -> [u8; 32] {
    let mut h = Sha256::new();
    h.update(data);
    h.finalize().into()
}
