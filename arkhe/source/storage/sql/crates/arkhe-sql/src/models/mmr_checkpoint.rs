use chrono::{DateTime, Utc};

#[derive(Debug, Clone)]
pub struct MmrCheckpoint {
    pub tenant_id: String,
    pub stream_id: String,
    pub leaf_count: i64,
    pub mmr_size: i64,
    pub mmr_root: Vec<u8>,
    pub peaks: Vec<Vec<u8>>,
    pub profile_digest: Vec<u8>,
    pub covered_up_to_hash: Vec<u8>,
    pub created_at: DateTime<Utc>,
}
