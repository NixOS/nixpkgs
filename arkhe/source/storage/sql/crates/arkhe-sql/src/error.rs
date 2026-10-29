use thiserror::Error;

#[derive(Debug, Error)]
pub enum ArkheSqlError {
    #[error(transparent)]
    Sqlx(#[from] sqlx::Error),

    #[error("tenant id must not be empty")]
    EmptyTenant,

    #[error("idempotency conflict: same key bound to different request digest")]
    IdempotencyConflict,

    #[error("invalid MMR checkpoint: {0}")]
    InvalidMmrCheckpoint(String),
}
