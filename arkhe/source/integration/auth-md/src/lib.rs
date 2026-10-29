//! Local auth.md building blocks. Trust roots and authenticated user sessions are host inputs.
//! This crate does not fetch keys or infer trust from a DID or Markdown document.
#[cfg(feature = "host")]
pub mod claims;
pub mod protocol;
#[cfg(feature = "host")]
pub mod service;
pub mod token;

use arkhe_core::{
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};

#[derive(Debug, thiserror::Error, PartialEq, Eq)]
pub enum Error {
    #[error("invalid token or signature")]
    InvalidToken,
    #[error("untrusted issuer, audience, client or key")]
    Untrusted,
    #[error("expired or invalid time window")]
    Expired,
    #[error("replayed assertion")]
    Replay,
    #[error("revoked credential or registration")]
    Revoked,
    #[error("insufficient scope")]
    Scope,
    #[error("claim pending, expired, locked or already consumed")]
    Claim,
    #[error("invalid discovery configuration")]
    Discovery,
}

/// Candidate only: a host must sign and admit this through its WorkerVerifier/kernel.
/// Credentials never enter the record; only a domain-separated token digest does.
pub fn registration_record(
    request: Digest32,
    token: &token::VerifiedToken,
    execution_id: String,
) -> Result<WorkerExecutionRecord, Error> {
    if !token.is_access() {
        return Err(Error::InvalidToken);
    }
    Ok(WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Execute),
        module_id: "auth-md-registration-v1".into(),
        module_version: env!("CARGO_PKG_VERSION").into(),
        input_digest: request,
        output_digest: token.digest(),
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id,
    })
}
