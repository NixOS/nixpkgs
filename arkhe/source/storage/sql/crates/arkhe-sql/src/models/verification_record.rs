use chrono::{DateTime, Utc};

#[derive(Debug, Clone)]
pub struct VerificationRecord {
    pub record_hash: Vec<u8>,
    pub tenant_id: String,
    pub intent_digest: Vec<u8>,
    pub policy_digest: Vec<u8>,
    pub result: String,
    pub canonical_bytes: Vec<u8>,
    pub created_at: DateTime<Utc>,
}
