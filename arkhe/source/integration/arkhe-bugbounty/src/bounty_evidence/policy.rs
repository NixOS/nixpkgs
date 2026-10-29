//! Scoped resolved-policy candidate. An independent governance pin is mandatory.
use super::{evaluate_poc, PocMeasurement, PocPolicy, PocVerdict};
use arkhe_core::{
    canonical::encode_value,
    evidence::EvidenceReader,
    work::{ContextKind, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_governance::{PolicyBinding, PolicyResolver, PolicyVerdict};
use serde::{Deserialize, Serialize};
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ResolvedPocPolicyArtifact {
    pub version: u16,
    pub parent_policy_id: String,
    pub parent_policy_version: u64,
    pub parent_policy_digest: Digest32,
    pub poc: PocPolicy,
    pub allowed_modules: Vec<String>,
}
impl ResolvedPocPolicyArtifact {
    pub fn digest(&self) -> Digest32 {
        // Decimal text preserves full u128 range without JSON/CBOR numeric truncation.
        let p = &self.poc;
        Digest32::blake3(
            b"AKG:POC:RESOLVED-POLICY:v1\0",
            &encode_value(&serde_json::json!({
             "version":self.version,"parent_policy_id":self.parent_policy_id,"parent_policy_version":self.parent_policy_version,"parent_policy_digest":self.parent_policy_digest.to_hex(),
             "allowed_modules":self.allowed_modules,"chain_id":p.chain_id,"fork_block":p.fork_block,"max_block_drift":p.max_block_drift,"in_scope_targets":p.in_scope_targets,"asset_id":p.asset_id,"min_attacker_gain_decimal":p.min_attacker_gain.to_string()
            })),
        )
    }
}
/// Only resolve against an independently approved digest, never the artifact's
/// own self-reported digest. This type does not resolve institutional governance.
pub struct ResolvedPocPolicy {
    artifact: ResolvedPocPolicyArtifact,
    digest: Digest32,
}
impl ResolvedPocPolicy {
    pub fn resolve(
        artifact: ResolvedPocPolicyArtifact,
        approved_digest: Digest32,
        binding: &PolicyBinding,
    ) -> Result<Self, String> {
        let p = &artifact.poc;
        if artifact.version != 1
            || approved_digest == Digest32::ZERO
            || artifact.digest() != approved_digest
            || artifact.parent_policy_id != binding.policy_id
            || artifact.parent_policy_version != binding.version
            || artifact.parent_policy_digest != binding.policy_digest
            || binding.policy_digest == Digest32::ZERO
            || binding.policy_id.trim().is_empty()
            || binding.version == 0
            || artifact.allowed_modules.is_empty()
            || artifact.allowed_modules.len() > 32
            || artifact
                .allowed_modules
                .iter()
                .any(|m| m.trim().is_empty() || m.len() > 128)
            || p.chain_id == 0
            || p.in_scope_targets.is_empty()
            || p.in_scope_targets.len() > 1024
            || p.in_scope_targets.contains(&[0; 32])
            || p.asset_id == [0; 32]
            || p.min_attacker_gain == 0
        {
            return Err("unapproved, unbound or invalid PoC policy artifact".into());
        }
        Ok(Self {
            artifact,
            digest: approved_digest,
        })
    }
    pub fn digest(&self) -> Digest32 {
        self.digest
    }
    pub fn measurement_digest(&self, intent: &WorkIntent, m: &PocMeasurement) -> Digest32 {
        Digest32::blake3(
            b"AKG:POC:BOUND-MEASUREMENT:v1\0",
            &encode_value(&serde_json::json!({
             "artifact_digest":self.digest.to_hex(),"requested_by":intent.requested_by,"operation_id":intent.operation_id().to_hex(),"source_report_digest":intent.target.to_hex(),"parameters_digest":intent.parameters_digest.to_hex(),
             "chain_id":m.chain_id,"fork_block":m.fork_block,"submission_block":m.submission_block,"target":m.target,"asset_id":m.asset_id,"attacker_gain_decimal":m.attacker_gain.to_string()
            })),
        )
    }
    /// Pure policy predicate after independent admission lookup. Pass is not Allow.
    // Preserve the public admission boundary's explicit trusted inputs.
    #[allow(clippy::too_many_arguments)]
    pub async fn evaluate_admitted<
        R: PolicyResolver,
        E: EvidenceReader,
        A: super::priority::AnchorSource,
    >(
        &self,
        intent: &WorkIntent,
        binding: &PolicyBinding,
        resolver: &R,
        evidence: &E,
        worker: &WorkerExecutionRecord,
        m: &PocMeasurement,
        anchors: &A,
    ) -> Result<PocVerdict, String> {
        let a = &self.artifact;
        if intent.intent_type != WorkIntentType::TriageReport
            || binding.policy_id != a.parent_policy_id
            || binding.version != a.parent_policy_version
            || binding.policy_digest != a.parent_policy_digest
            || resolver.resolve(intent, binding) != PolicyVerdict::Allow
        {
            return Err("PoC parent governance denied or changed".into());
        }
        let has_one = |kind: ContextKind, hash: Digest32| {
            let entries: Vec<_> = intent.context.iter().filter(|e| e.kind == kind).collect();
            entries.len() == 1 && entries[0].hash == hash
        };
        let hash = worker.digest();
        if !has_one(ContextKind::Named("PocPolicy".into()), self.digest)
            || !has_one(ContextKind::Named("PocExecution".into()), hash)
            || worker.input_digest != intent.target
            || worker.output_digest != self.measurement_digest(intent, m)
            || worker.execution_id != intent.operation_id().to_hex()
            || worker.operation != Some(CognitiveOperation::Execute)
            || !a.allowed_modules.contains(&worker.module_id)
        {
            return Err("PoC worker or context binding rejected".into());
        }
        match evidence.get(hash).await? {
            Some(e)
                if e.kind == "WorkerExecutionRecord"
                    && e.record_hash == hash
                    && e.payload_digest == hash
                    && e.subject == intent.target => {}
            _ => return Err("PoC execution is not independently admitted".into()),
        }
        let anchor = anchors.verified_anchor(intent.target.0).await?;
        if anchor.report_digest != intent.target.0
            || anchor.log_id == [0; 32]
            || anchor.commitment == [0; 32]
            || anchor.chain_id != a.poc.chain_id
            || m.submission_block != anchor.submission_block
        {
            return Err("untrusted or forged submission block/report anchor".into());
        }
        let mut measured = m.clone();
        measured.submission_block = anchor.submission_block;
        Ok(evaluate_poc(&a.poc, &measured))
    }
}

impl ResolvedPocPolicy {
    /// Additional detached-signature profile; retains independent WER admission and anchor checks.
    #[allow(clippy::too_many_arguments)]
    pub async fn evaluate_signed_admitted<
        R: PolicyResolver,
        E: EvidenceReader,
        A: super::priority::AnchorSource,
    >(
        &self,
        intent: &WorkIntent,
        binding: &PolicyBinding,
        resolver: &R,
        evidence: &E,
        worker: &WorkerExecutionRecord,
        signed: &super::signed_poc::SignedPocMeasurement,
        trust: &super::signed_poc::PocSignatureTrust<'_>,
        anchors: &A,
    ) -> Result<PocVerdict, String> {
        let expected = super::signed_poc::PocContext {
            report_digest: intent.target.0,
            policy_digest: self.digest.0,
            operation_id: intent.operation_id().0,
            parameters_digest: intent.parameters_digest.0,
        };
        let measurement = signed.verify(
            trust.registry,
            &expected,
            trust.at,
            trust.max_age,
            trust.min_level,
        )?;
        self.evaluate_admitted(
            intent,
            binding,
            resolver,
            evidence,
            worker,
            measurement,
            anchors,
        )
        .await
    }
}
