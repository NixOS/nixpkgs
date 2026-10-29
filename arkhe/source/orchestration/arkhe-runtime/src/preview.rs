//! Preview admission and gated dispatch. No signing keys or implicit production policy.
//! Signature verification belongs to this host boundary; the gate receives only
//! authenticated envelopes. Queued admission is not an execution capability.
use arkhe_core::{
    canonical::encode_value,
    evidence::{EvidenceEnvelope, EvidenceReader},
    review::{
        HumanReviewEvidence, HumanReviewRecord, HumanVerdict, ReviewDecision, ReviewReason,
        ReviewVerdict,
    },
    work::{ContextEntry, ContextKind, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_governance::{EvidenceKindRequirement, PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use async_trait::async_trait;
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
use sqlx::{Postgres, Transaction};

pub mod authority;
pub mod dispatch;
pub mod executor;
pub mod queue;

const REVIEW_MODULE: &str = "arkhe-preview-human-review";

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PreviewSpec {
    pub version: u16,
    pub tenant: String,
    pub baseline_digest: Digest32,
    pub proposal_digest: Digest32,
    pub artifact_digest: Digest32,
    /// Immutable OCI image identifier, never a tag.
    pub image: String,
    pub runtime_profile: Digest32,
    pub module: String,
    #[serde(default, skip_serializing_if = "Option::is_none")]
    pub cockpit_binding: Option<Digest32>,
}
impl PreviewSpec {
    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:PREVIEW:SPEC:v1\0",
            &encode_value(&serde_json::to_value(self).expect("typed spec")),
        )
    }
}

/// Operator-controlled trust configuration. Never accept it from the model/request.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PreviewTrust {
    pub tenant: String,
    pub requested_by: String,
    pub reviewer: String,
    pub reviewer_key: [u8; 32],
    pub supervisor_key: [u8; 32],
    pub supervisor_module: String,
    pub supervisor_version: String,
    pub policy_digest: Digest32,
    pub image: String,
    pub runtime_profile: Digest32,
    pub allowed_modules: Vec<String>,
    /// Seconds; used for both worker receipt freshness and review duration.
    pub max_age_seconds: i64,
    pub emergency_stop: bool,
}

impl PreviewTrust {
    /// Binds every configured identity, key and constraint to human approval.
    /// Emergency stop is a live deny override, never an approval parameter.
    pub fn digest(&self) -> Digest32 {
        let mut value = serde_json::to_value(self).expect("typed preview trust");
        let fields = value.as_object_mut().expect("trust object");
        fields.remove("policy_digest");
        fields.remove("emergency_stop");
        Digest32::blake3(b"AKG:PREVIEW:POLICY:v1\0", &encode_value(&value))
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PreviewRequest {
    pub spec: PreviewSpec,
    pub intent: WorkIntent,
    pub worker: WorkerExecutionRecord,
    pub completed_at: i64,
    pub supervisor_signature: String,
    pub review: HumanReviewRecord,
    pub reviewer_signature: String,
}
impl PreviewRequest {
    /// A supervisor attests a successful build/test of this exact preview spec.
    /// The caller must verify the actual build independently before signing.
    pub fn supervisor_signing_bytes(&self) -> Vec<u8> {
        signing_bytes(
            b"AKG:PREVIEW:SUPERVISOR:v1\0",
            &serde_json::json!({
                "tenant": self.spec.tenant, "spec": self.spec.digest().to_hex(),
                "worker": self.worker.digest().to_hex(), "completed_at": self.completed_at,
                "outcome": "Succeeded"
            }),
        )
    }
    pub fn reviewer_signing_bytes(&self) -> Vec<u8> {
        signing_bytes(
            b"AKG:PREVIEW:HUMAN:v1\0",
            &serde_json::json!({
                "tenant": self.spec.tenant, "review": self.review.digest().to_hex()
            }),
        )
    }
    pub fn route(policy: Digest32) -> ReviewDecision {
        ReviewDecision {
            verdict: ReviewVerdict::ReviewRequired,
            reasons: vec![ReviewReason::HighImpact],
            review_policy_digest: policy,
        }
    }
    pub fn human_attestation(&self) -> WorkerExecutionRecord {
        WorkerExecutionRecord {
            classification: None,
            operation: Some(CognitiveOperation::Decide),
            module_id: REVIEW_MODULE.into(),
            module_version: "1".into(),
            input_digest: self.worker.digest(),
            output_digest: self.review.digest(),
            evidence_refs: vec![self.worker.digest()],
            confidence_bps: None,
            uncertainty_note: None,
            execution_id: self.review.operation_id.to_hex(),
        }
    }
    /// Context is deterministic and contains no caller-selected admission aliases.
    pub fn expected_context(&self) -> Vec<ContextEntry> {
        vec![
            ContextEntry {
                kind: ContextKind::SourceReport,
                hash: self.spec.baseline_digest,
            },
            ContextEntry {
                kind: ContextKind::AnalysisRecord,
                hash: self.worker.digest(),
            },
            ContextEntry {
                kind: ContextKind::ReviewDecision,
                hash: Self::route(self.review.policy_digest).digest(),
            },
            ContextEntry {
                kind: ContextKind::HumanReview,
                hash: self.human_attestation().digest(),
            },
        ]
    }
}
fn signing_bytes(domain: &[u8], value: &serde_json::Value) -> Vec<u8> {
    let mut bytes = domain.to_vec();
    bytes.extend(encode_value(value));
    bytes
}
fn verify_signature(key: &[u8; 32], payload: &[u8], signature: &str) -> Result<(), String> {
    let key = VerifyingKey::from_bytes(key).map_err(|_| "invalid trust key")?;
    if key.is_weak() || signature.len() != 128 {
        return Err("invalid signing key or signature length".into());
    }
    let raw = hex::decode(signature).map_err(|_| "invalid signature encoding")?;
    let signature = Signature::from_slice(&raw).map_err(|_| "invalid signature")?;
    key.verify_strict(payload, &signature)
        .map_err(|_| "preview signature rejected".into())
}
fn image_is_digest(image: &str) -> bool {
    image.strip_prefix("sha256:").is_some_and(|s| {
        s.len() == 64
            && s.bytes()
                .all(|b| b.is_ascii_hexdigit() && !b.is_ascii_uppercase())
    })
}

/// Constructible only through successful host admission and ContainmentGate.
/// It is intentionally not deserializable and grants no right to execute.
pub struct AdmittedPreview {
    request: PreviewRequest,
    authorization_ref: Digest32,
    admitted_at: i64,
}
impl AdmittedPreview {
    pub fn authorization_ref(&self) -> Digest32 {
        self.authorization_ref
    }
    pub fn operation_id(&self) -> Digest32 {
        self.request.intent.operation_id()
    }
    pub fn spec(&self) -> &PreviewSpec {
        &self.request.spec
    }
    pub fn request(&self) -> &PreviewRequest {
        &self.request
    }
}

struct PreviewPolicy {
    policy: Digest32,
    worker: String,
}
impl PolicyResolver for PreviewPolicy {
    fn resolve(&self, i: &WorkIntent, p: &PolicyBinding) -> PolicyVerdict {
        if i.intent_type == WorkIntentType::ReleaseSoftware
            && p.policy_id == "arkhe-preview/v1"
            && p.version == 1
            && p.policy_digest == self.policy
        {
            PolicyVerdict::Allow
        } else {
            PolicyVerdict::Deny("preview-only policy".into())
        }
    }
    fn review_routing_required(&self, _: &WorkIntent, _: &PolicyBinding) -> bool {
        true
    }
    fn human_review_modules(&self, _: &WorkIntent, _: &PolicyBinding) -> Vec<String> {
        vec![REVIEW_MODULE.into()]
    }
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec![self.worker.clone()],
            allowed_operations: vec![CognitiveOperation::Execute],
        })
    }
}

struct AdmittedEvidence<'a, E> {
    source: &'a E,
    worker: EvidenceEnvelope,
    human: EvidenceEnvelope,
}
#[async_trait]
impl<E: EvidenceReader> EvidenceReader for AdmittedEvidence<'_, E> {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        if hash == self.worker.record_hash {
            return Ok(Some(self.worker.clone()));
        }
        if hash == self.human.record_hash {
            return Ok(Some(self.human.clone()));
        }
        self.source.get(hash).await
    }
}
fn envelope(w: &WorkerExecutionRecord, policy: Digest32) -> EvidenceEnvelope {
    EvidenceEnvelope {
        record_hash: w.digest(),
        kind: "WorkerExecutionRecord".into(),
        subject: w.input_digest,
        payload_digest: w.digest(),
        policy_digest: Some(policy),
        causal_parents: w.evidence_refs.clone(),
    }
}

/// `source` must be an independently admitted tenant-scoped reader; a model map
/// is not a trust root. Time comes from the supervisor, never the request.
pub async fn admit_preview<E: EvidenceReader>(
    request: PreviewRequest,
    trust: &PreviewTrust,
    source: &E,
    now: i64,
) -> Result<AdmittedPreview, String> {
    verify_preview(request, trust, source, now, true).await
}

#[derive(Serialize)]
pub struct PreviewChallenge {
    pub signing_payload_hex: String,
    pub reviewer_key: [u8; 32],
    pub operation_id: String,
    pub spec: PreviewSpec,
    pub expires_at: i64,
}
pub async fn review_preview<E: EvidenceReader>(
    request: PreviewRequest,
    trust: &PreviewTrust,
    source: &E,
    now: i64,
) -> Result<PreviewChallenge, String> {
    let checked = verify_preview(request, trust, source, now, false).await?;
    Ok(PreviewChallenge {
        signing_payload_hex: hex::encode(checked.request.reviewer_signing_bytes()),
        reviewer_key: trust.reviewer_key,
        operation_id: checked.operation_id().to_hex(),
        expires_at: checked.request.review.expires_at,
        spec: checked.request.spec,
    })
}
// Only admit_preview can return the admitted object; the challenge path discards it.
async fn verify_preview<E: EvidenceReader>(
    request: PreviewRequest,
    trust: &PreviewTrust,
    source: &E,
    now: i64,
    verify_human: bool,
) -> Result<AdmittedPreview, String> {
    let s = &request.spec;
    let i = &request.intent;
    let w = &request.worker;
    let r = &request.review;
    if trust.emergency_stop {
        return Err("emergency stop".into());
    }
    for key in [&trust.supervisor_key, &trust.reviewer_key] {
        let vk = VerifyingKey::from_bytes(key).map_err(|_| "invalid trust key")?;
        if vk.is_weak() {
            return Err("weak trust key".into());
        }
    }
    if trust.tenant.trim().is_empty()
        || trust.requested_by.trim().is_empty()
        || trust.reviewer.trim().is_empty()
        || trust.supervisor_module.trim().is_empty()
        || trust.supervisor_version.trim().is_empty()
        || trust.supervisor_key == trust.reviewer_key
        || trust.max_age_seconds <= 0
        || trust.max_age_seconds > 86400
        || trust.policy_digest != trust.digest()
        || trust.runtime_profile == Digest32::ZERO
        || !image_is_digest(&trust.image)
    {
        return Err("invalid preview trust configuration".into());
    }
    if s.version != 1
        || s.tenant != trust.tenant
        || i.requested_by != trust.requested_by
        || s.image != trust.image
        || s.runtime_profile != trust.runtime_profile
        || !trust.allowed_modules.contains(&s.module)
        || s.module.is_empty()
        || [s.baseline_digest, s.proposal_digest, s.artifact_digest].contains(&Digest32::ZERO)
        || i.intent_type != WorkIntentType::ReleaseSoftware
        || i.target != s.baseline_digest
        || i.parameters_digest != s.digest()
        || !i.context_refs.is_empty()
        || i.request_identity.0 == Digest32::ZERO
    {
        return Err("preview spec, actor, target or scope mismatch".into());
    }
    if now < 0
        || request.completed_at < 0
        || request.completed_at > now
        || now.saturating_sub(request.completed_at) > trust.max_age_seconds
        || i.claimed_created_at < 0
        || i.claimed_created_at > request.completed_at
        || now.saturating_sub(i.claimed_created_at) > trust.max_age_seconds
        || r.reviewed_at < request.completed_at
        || r.reviewed_at > now
        || r.expires_at <= now
        || r.expires_at.saturating_sub(r.reviewed_at) > trust.max_age_seconds
    {
        return Err("stale, future or expired preview evidence".into());
    }
    if w.module_id != trust.supervisor_module
        || w.module_version != trust.supervisor_version
        || w.operation != Some(CognitiveOperation::Execute)
        || w.input_digest != s.baseline_digest
        || w.output_digest != s.digest()
        || w.execution_id != i.operation_id().to_hex()
        || w.evidence_refs != vec![s.baseline_digest]
        || w.classification.is_some()
        || r.reviewer != trust.reviewer
        || r.verdict != HumanVerdict::Approve
        || r.requested_by != i.requested_by
        || r.operation_id != i.operation_id()
        || r.parameters_digest != s.digest()
        || r.analysis_digest != w.digest()
        || r.policy_digest != trust.policy_digest
        || r.routing_digest != PreviewRequest::route(trust.policy_digest).digest()
    {
        return Err("supervisor or human review binding mismatch".into());
    }
    let expected = request.expected_context();
    if i.context.len() != expected.len()
        || i.context
            .iter()
            .zip(&expected)
            .any(|(a, b)| a.kind != b.kind || a.hash != b.hash)
    {
        return Err("noncanonical preview context".into());
    }
    verify_signature(
        &trust.supervisor_key,
        &request.supervisor_signing_bytes(),
        &request.supervisor_signature,
    )?;
    if verify_human {
        verify_signature(
            &trust.reviewer_key,
            &request.reviewer_signing_bytes(),
            &request.reviewer_signature,
        )?;
    }
    let baseline = source
        .get(s.baseline_digest)
        .await?
        .ok_or("baseline not admitted")?;
    if baseline.record_hash != s.baseline_digest || baseline.payload_digest != s.baseline_digest {
        return Err("baseline evidence binding mismatch".into());
    }
    let human = HumanReviewEvidence {
        review: r.clone(),
        attestation: request.human_attestation(),
    };
    let admitted = AdmittedEvidence {
        source,
        worker: envelope(w, trust.policy_digest),
        human: envelope(&human.attestation, trust.policy_digest),
    };
    let gate = ContainmentGate::new(PreviewPolicy {
        policy: trust.policy_digest,
        worker: trust.supervisor_module.clone(),
    });
    let binding = PolicyBinding {
        policy_id: "arkhe-preview/v1".into(),
        version: 1,
        policy_digest: trust.policy_digest,
    };
    match gate
        .authorize_routed_admitted(
            i,
            w,
            &binding,
            &admitted,
            &PreviewRequest::route(trust.policy_digest),
            Some(&human),
            now,
        )
        .await
    {
        AuthorizationDecision::Reject { reason } => Err(reason),
        AuthorizationDecision::Allow { authorization_ref } => Ok(AdmittedPreview {
            request,
            authorization_ref,
            admitted_at: now,
        }),
    }
}

/// Both evidence and pending job are written using the caller's transaction.
/// The caller owns commit/rollback. Restricted roles and SET LOCAL tenant required.
pub async fn enqueue_preview(
    tx: &mut Transaction<'_, Postgres>,
    preview: &AdmittedPreview,
) -> Result<Digest32, String> {
    use sqlx::Acquire;
    // A failed enqueue must not leave only the admission behind, even if the
    // caller handles the error and commits its unrelated business transaction.
    let mut savepoint = tx.begin().await.map_err(|e| e.to_string())?;
    match queue::enqueue(&mut savepoint, preview).await {
        Ok(digest) => {
            savepoint.commit().await.map_err(|e| e.to_string())?;
            Ok(digest)
        }
        Err(error) => {
            savepoint.rollback().await.map_err(|e| e.to_string())?;
            Err(error)
        }
    }
}
