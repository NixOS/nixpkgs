//! Arkhe-RBB v3 candidate revision 2. Isolated from the existing frozen MMR profile.
mod header;
pub mod mmr;
#[cfg(feature = "rbb-pqc")]
pub mod trust;

pub use header::*;

#[derive(Debug, Clone, PartialEq, Eq, thiserror::Error)]
pub enum Error {
    #[error("non-canonical ABI")]
    NonCanonical,
    #[error("invalid header: {0}")]
    Header(&'static str),
    #[error("unsupported cryptographic profile")]
    Profile,
    #[error("invalid signature length")]
    SignatureLength,
    #[error("invalid hybrid signature")]
    Signature,
    #[error("untrusted or mismatched institutional binding")]
    Binding,
    #[error("insufficient or conflicting witness votes")]
    Quorum,
    #[error("invalid temporal evidence")]
    Time,
    #[error("invalid MMR proof")]
    Mmr,
    #[error("resource limit exceeded")]
    ResourceLimit,
}

pub fn keccak(data: &[u8]) -> [u8; 32] {
    use sha3::{Digest, Keccak256};
    Keccak256::digest(data).into()
}
