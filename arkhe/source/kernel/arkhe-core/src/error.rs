use thiserror::Error;

#[derive(Debug, Error)]
pub enum CoreError {
    #[error("invalid input: {0}")]
    InvalidInput(String),
    #[error("evidence unavailable")]
    EvidenceUnavailable,
    #[error("authorization rejected: {0}")]
    AuthorizationRejected(String),
}
