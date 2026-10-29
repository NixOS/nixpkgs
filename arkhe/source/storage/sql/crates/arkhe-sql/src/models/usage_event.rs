use chrono::{DateTime, Utc};
use uuid::Uuid;

#[derive(Debug, Clone)]
pub struct UsageEvent {
    pub request_id: Uuid,
    pub operation_id: Uuid,
    pub tenant_id: String,
    pub tool_name: String,
    pub started_at: DateTime<Utc>,
    pub duration_ms: i64,
    pub result: String,
    pub policy_digest: Option<Vec<u8>>,
    pub evidence_hash: Option<Vec<u8>>,
    pub estimated_cost_usd: String,
    pub billable_units: i64,
}
