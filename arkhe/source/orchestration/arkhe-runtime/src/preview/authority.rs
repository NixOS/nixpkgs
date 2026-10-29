//! External bridge verdict admission. Native HSM/TEE/Sigstore chains are verified
//! by the designated external bridge, never by trusting self-declared origin labels.
use super::{executor::read_json, PreviewSpec};
use arkhe_core::{
    canonical::encode_value,
    evidence::{EvidenceEnvelope, EvidenceReader},
    work::{ContextEntry, ContextKind, RequestIdentity, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_governance::{EvidenceKindRequirement, PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use async_trait::async_trait;
use serde::{Deserialize, Serialize};
use std::path::PathBuf;
#[derive(Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct ExternalIdentity {
    pub source: String,
    pub issuer: String,
    pub subject: String,
    pub measurement: Option<Digest32>,
}
#[derive(Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct AuthorityPolicy {
    pub root_key: [u8; 32],
    pub expected: ExternalIdentity,
    pub admission_file: PathBuf,
}
#[derive(Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct AuthorityAdmission {
    pub version: u16,
    pub identity: ExternalIdentity,
    pub qualification_key: [u8; 32],
    pub evidence_digest: Digest32,
    pub issued_at: i64,
    pub expires_at: i64,
    pub signature: String,
}
impl AuthorityAdmission {
    pub fn signing_bytes(&self) -> Vec<u8> {
        let mut v = serde_json::to_value(self).expect("authority projection");
        v.as_object_mut().unwrap().remove("signature");
        let mut b = b"AKG:RUNTIME:EXTERNAL-AUTHORITY:v1\0".to_vec();
        b.extend(encode_value(&v));
        b
    }
    pub fn verify(&self, p: &AuthorityPolicy, key: [u8; 32], now: i64) -> Result<(), String> {
        if self.version != 1
            || self.identity != p.expected
            || self.qualification_key != key
            || p.root_key == key
            || self.evidence_digest == Digest32::ZERO
            || self.issued_at < 0
            || self.issued_at > now
            || self.expires_at <= now
            || self.expires_at.saturating_sub(self.issued_at) > 86400
            || p.expected.issuer.trim().is_empty()
            || p.expected.subject.trim().is_empty()
            || !matches!(
                p.expected.source.as_str(),
                "HSM_KMS" | "TEE" | "COSIGN_SIGSTORE"
            )
            || (p.expected.source == "TEE"
                && p.expected.measurement.is_none_or(|v| v == Digest32::ZERO))
            || (p.expected.source == "COSIGN_SIGSTORE"
                && p.expected.issuer != "https://token.actions.githubusercontent.com")
        {
            return Err("external authority identity, time or provenance binding rejected".into());
        }
        super::verify_signature(&p.root_key, &self.signing_bytes(), &self.signature)
    }
}
struct Policy {
    target: Digest32,
    parameters: Digest32,
}
impl PolicyResolver for Policy {
    fn resolve(&self, i: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        if i.intent_type == WorkIntentType::ReleaseSoftware
            && i.target == self.target
            && i.parameters_digest == self.parameters
        {
            PolicyVerdict::Allow
        } else {
            PolicyVerdict::Deny("external authority admission only".into())
        }
    }
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec!["external-runtime-authority-bridge".into()],
            allowed_operations: vec![CognitiveOperation::Decide],
        })
    }
}
struct Reader(EvidenceEnvelope);
#[async_trait]
impl EvidenceReader for Reader {
    async fn get(&self, h: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok((h == self.0.record_hash).then(|| self.0.clone()))
    }
}
pub async fn admit(
    policy: &AuthorityPolicy,
    key: [u8; 32],
    spec: &PreviewSpec,
    now: i64,
) -> Result<Digest32, String> {
    let a: AuthorityAdmission = read_json(&policy.admission_file)?;
    a.verify(policy, key, now)?;
    // Only a successfully authenticated external verdict reaches this private gate policy.
    let target = Digest32::blake3(b"AKG:RUNTIME:QUALIFIER-KEY:v1\0", &key);
    let parameters = Digest32::blake3(
        b"AKG:RUNTIME:AUTHORITY-BINDING:v1\0",
        &encode_value(
            &serde_json::json!({"admission":hex::encode(a.signing_bytes()),"tenant":spec.tenant,"profile":spec.runtime_profile,"image":spec.image}),
        ),
    );
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Decide),
        module_id: "external-runtime-authority-bridge".into(),
        module_version: "1".into(),
        input_digest: a.evidence_digest,
        output_digest: parameters,
        evidence_refs: vec![a.evidence_digest],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: parameters.to_hex(),
    };
    let intent = WorkIntent {
        requested_by: a.identity.subject.clone(),
        intent_type: WorkIntentType::ReleaseSoftware,
        target,
        parameters_digest: parameters,
        context: vec![
            ContextEntry {
                kind: ContextKind::SourceReport,
                hash: a.evidence_digest,
            },
            ContextEntry {
                kind: ContextKind::AnalysisRecord,
                hash: worker.digest(),
            },
        ],
        context_refs: vec![],
        request_identity: RequestIdentity::new(&parameters.0),
        claimed_created_at: now,
    };
    let reader = Reader(EvidenceEnvelope {
        record_hash: worker.digest(),
        kind: "WorkerExecutionRecord".into(),
        subject: a.evidence_digest,
        payload_digest: worker.digest(),
        policy_digest: Some(parameters),
        causal_parents: vec![a.evidence_digest],
    });
    match ContainmentGate::new(Policy { target, parameters })
        .authorize_admitted(
            &intent,
            &worker,
            &PolicyBinding {
                policy_id: "external-runtime-authority/v1".into(),
                version: 1,
                policy_digest: parameters,
            },
            &reader,
        )
        .await
    {
        AuthorizationDecision::Allow { authorization_ref } => Ok(authorization_ref),
        AuthorizationDecision::Reject { reason } => Err(reason),
    }
}
