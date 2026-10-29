//! Receipt normalization and offline inclusion verification, without provider authentication.
pub mod adapters;
pub mod proof;
pub mod types;

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("invalid receipt: {0}")]
    InvalidReceipt(&'static str),
    #[error(transparent)]
    Serialization(#[from] serde_json::Error),
    #[error("MMR error: {0}")]
    Mmr(String),
    #[error("proof does not match the trusted checkpoint or committed content")]
    InvalidProof,
}
