use crate::Digest32;
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub enum WorkIntentType {
    Publish,
    ApproveExpense,
    Hire,
    Fire,
    SignContract,
    ReleaseSoftware,
    DraftDocument,
    QueryKnowledgeBase,
    Simulate,
    TriageReport,
    AgentRegistration,
    CommunityJoin,
    CommunityPost,
    /// Implement one spec task (arkhe-sdd). Protected: classified by the kernel default.
    Implement,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct WorkIntent {
    pub requested_by: String,
    pub intent_type: WorkIntentType,
    pub target: Digest32,
    pub parameters_digest: Digest32,
    #[serde(default, skip_serializing_if = "Vec::is_empty")]
    pub context: Vec<ContextEntry>,
    pub context_refs: Vec<Digest32>,
    pub request_identity: RequestIdentity,
    pub claimed_created_at: i64,
}

impl WorkIntent {
    pub fn digest(&self) -> Digest32 {
        crate::CanonicalEncode::object_digest(self)
    }

    /// v2 identity excludes parameters. The journal binds parameters_digest separately
    /// and rejects changed parameters for the same caller nonce/type/target.
    pub fn operation_id(&self) -> Digest32 {
        let bytes = crate::canonical::encode_value(&serde_json::json!({
            "intent_type": self.intent_type, "target": self.target,
            "request_identity": self.request_identity
        }));
        Digest32::blake3(b"AKG:OPERATION:v2\0", &bytes)
    }

    pub fn analysis_record(&self) -> Result<Digest32, &'static str> {
        let mut entries = self
            .context
            .iter()
            .filter(|e| e.kind == ContextKind::AnalysisRecord);
        let hash = entries.next().ok_or("missing analysis evidence")?.hash;
        if entries.next().is_some() {
            return Err("ambiguous analysis evidence");
        }
        Ok(hash)
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[serde(transparent)]
pub struct RequestIdentity(pub Digest32);
impl RequestIdentity {
    /// Caller supplies one key per logical request and reuses it for retries.
    pub fn new(key: &[u8]) -> Self {
        Self(Digest32::blake3(b"AKG:REQUEST:v1\0", key))
    }
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub enum ContextKind {
    ReviewDecision,
    HumanReview,
    AuthToken,
    HumanityProof,
    ContentProvenance,
    ProgramScope,
    SeverityClassification,
    ClassificationPolicy,
    SourceReport,
    AnalysisRecord,
    Policy,
    Named(String),
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ContextEntry {
    pub kind: ContextKind,
    pub hash: Digest32,
}
