use thiserror::Error;

#[derive(Debug, Error, Clone, PartialEq, Eq)]
pub enum VerifyError {
    #[error("invalid input: {0}")]
    InvalidInput(String),
    #[error("profile mismatch")]
    ProfileMismatch,
    #[error("unsupported algorithm or profile: {0}")]
    Unsupported(String),
    #[error("verification failed: {0}")]
    VerificationFailed(String),
}
