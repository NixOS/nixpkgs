//! Review routing is not authorization. Human claims require independently admitted attestation.
use crate::{canonical::encode_value, worker::WorkerExecutionRecord, Digest32};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ReviewVerdict {
    AutoAccept,
    ReviewRequired,
    AutoReject,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ReviewReason {
    PolicyException,
    Irreversible,
    HighImpact,
    LowConfidence,
    UnknownConfidence,
    Ambiguity,
    UnknownAmbiguity,
    Disagreement,
    ModelRejects,
    UncalibratedPolicy,
}
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReviewDecision {
    pub verdict: ReviewVerdict,
    pub reasons: Vec<ReviewReason>,
    pub review_policy_digest: Digest32,
}
impl ReviewDecision {
    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:REVIEW:ROUTE:v1\0",
            &encode_value(&serde_json::to_value(self).expect("review route projection")),
        )
    }
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum HumanVerdict {
    Approve,
    Reject,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct HumanReviewRecord {
    pub requested_by: String,
    pub operation_id: Digest32,
    pub parameters_digest: Digest32,
    pub analysis_digest: Digest32,
    pub policy_digest: Digest32,
    pub routing_digest: Digest32,
    pub reviewer: String,
    pub verdict: HumanVerdict,
    pub reviewed_at: i64,
    pub expires_at: i64,
}
impl HumanReviewRecord {
    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:REVIEW:HUMAN:v1\0",
            &encode_value(&serde_json::to_value(self).expect("human review projection")),
        )
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct HumanReviewEvidence {
    pub review: HumanReviewRecord,
    /// Signed/admitted by a separately trusted human-review verification worker.
    /// That worker must verify actual reviewer identity/approval before attesting.
    pub attestation: WorkerExecutionRecord,
}
