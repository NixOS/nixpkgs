//! Deterministic risk routing. No threshold here is a calibrated probability or authority.
use crate::{LlmAnalyzer, ReportDetails, Severity, TriageParams};
pub use arkhe_core::review::{
    HumanReviewEvidence, HumanReviewRecord, HumanVerdict, ReviewDecision, ReviewReason,
    ReviewVerdict,
};
use arkhe_core::{canonical::encode_value, worker::WorkerExecutionRecord, Digest32};
use serde::{Deserialize, Serialize};
use std::{
    fs,
    io::Write,
    path::{Path, PathBuf},
};
pub mod telemetry;
/// Pure experimental voting router; not an execution policy.
pub mod votes;
pub use telemetry::{ObservationSource, ReviewObservation};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReviewPolicy {
    pub version: u16,
    pub policy_id: String,
    /// Host-approved configuration only. Never populated by model self-confidence.
    pub automation_approved: bool,
    pub model_version: Option<String>,
    pub medium_threshold_bps: u16,
    pub low_threshold_bps: u16,
    pub info_threshold_bps: u16,
}
impl Default for ReviewPolicy {
    fn default() -> Self {
        Self {
            version: 1,
            policy_id: "CANDIDATE-NOT-CALIBRATED".into(),
            automation_approved: false,
            model_version: None,
            medium_threshold_bps: 7500,
            low_threshold_bps: 6000,
            info_threshold_bps: 6000,
        }
    }
}
impl ReviewPolicy {
    pub fn validate(&self) -> Result<(), String> {
        if self.version != 1
            || self.policy_id.trim().is_empty()
            || [
                self.medium_threshold_bps,
                self.low_threshold_bps,
                self.info_threshold_bps,
            ]
            .iter()
            .any(|n| *n > 10000)
        {
            return Err("invalid review policy".into());
        }
        Ok(())
    }
    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:REVIEW:POLICY:v1\0",
            &encode_value(
                &serde_json::json!({"version":self.version,"policy_id":self.policy_id,"automation_approved":if self.automation_approved{"true"}else{"false"},"model_version":self.model_version,"medium_threshold_bps":self.medium_threshold_bps,"low_threshold_bps":self.low_threshold_bps,"info_threshold_bps":self.info_threshold_bps}),
            ),
        )
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReviewSignals {
    pub supports_proposal: bool,
    pub confidence_bps: Option<u16>,
    /// Unknown is not false. The router never guesses ambiguity from prose.
    pub ambiguous: Option<bool>,
    pub text_decision_disagreement: Option<bool>,
    pub policy_exception: bool,
    pub irreversible: bool,
}
impl ReviewSignals {
    pub fn from_worker(w: &WorkerExecutionRecord) -> Self {
        Self {
            supports_proposal: true,
            confidence_bps: w.confidence_bps,
            ambiguous: None,
            text_decision_disagreement: None,
            policy_exception: false,
            irreversible: false,
        }
    }
}
pub struct ReviewRouter {
    policy: ReviewPolicy,
}
impl ReviewRouter {
    pub fn new(policy: ReviewPolicy) -> Result<Self, String> {
        policy.validate()?;
        Ok(Self { policy })
    }
    pub fn policy(&self) -> &ReviewPolicy {
        &self.policy
    }
    pub fn decide(
        &self,
        severity: Severity,
        model_version: &str,
        signals: &ReviewSignals,
    ) -> ReviewDecision {
        let mut reasons = vec![];
        if signals.policy_exception {
            reasons.push(ReviewReason::PolicyException);
        }
        if signals.irreversible {
            reasons.push(ReviewReason::Irreversible);
        }
        if matches!(severity, Severity::Critical | Severity::High) {
            reasons.push(ReviewReason::HighImpact);
        }
        let threshold = match severity {
            Severity::Critical | Severity::High => 10000,
            Severity::Medium => self.policy.medium_threshold_bps,
            Severity::Low => self.policy.low_threshold_bps,
            Severity::Info => self.policy.info_threshold_bps,
        };
        match signals.confidence_bps {
            Some(n) if n <= 10000 && n >= threshold => (),
            Some(n) if n <= 10000 => reasons.push(ReviewReason::LowConfidence),
            _ => reasons.push(ReviewReason::UnknownConfidence),
        }
        match signals.ambiguous {
            Some(false) => (),
            Some(true) => reasons.push(ReviewReason::Ambiguity),
            None => reasons.push(ReviewReason::UnknownAmbiguity),
        }
        if signals.text_decision_disagreement != Some(false) {
            reasons.push(ReviewReason::Disagreement);
        }
        // A rejection is only an operational outcome; high impact/policy/ambiguity still escalates.
        let verdict = if !reasons.is_empty() {
            ReviewVerdict::ReviewRequired
        } else if !signals.supports_proposal {
            reasons.push(ReviewReason::ModelRejects);
            ReviewVerdict::AutoReject
        } else if !self.policy.automation_approved
            || self.policy.model_version.as_deref() != Some(model_version)
        {
            reasons.push(ReviewReason::UncalibratedPolicy);
            ReviewVerdict::ReviewRequired
        } else {
            ReviewVerdict::AutoAccept
        };
        ReviewDecision {
            verdict,
            reasons,
            review_policy_digest: self.policy.digest(),
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReviewItem {
    #[serde(default)]
    pub completed_execution: Option<Digest32>,
    #[serde(default)]
    pub review_evidence: Option<HumanReviewEvidence>,
    pub case_id: String,
    pub requested_by: String,
    pub operation_id: Digest32,
    pub report_digest: Digest32,
    pub parameters_digest: Digest32,
    pub governance_policy_digest: Digest32,
    pub severity: Severity,
    pub model_version: String,
    pub signals: ReviewSignals,
    pub decision: ReviewDecision,
    pub analysis: Option<WorkerExecutionRecord>,
    pub source: String,
}
#[derive(Default, Serialize, Deserialize)]
struct QueueData {
    items: Vec<ReviewItem>,
    #[serde(default)]
    observations: Vec<ReviewObservation>,
}
/// Local operational queue with exclusive create_new lock and atomic file replacement.
/// A crashed owner leaves a lock requiring operator investigation; never auto-takeover.
pub struct FileReviewQueue {
    path: PathBuf,
}
struct Lock(PathBuf);
impl Drop for Lock {
    fn drop(&mut self) {
        let _ = fs::remove_file(&self.0);
    }
}
impl FileReviewQueue {
    pub fn new(path: impl AsRef<Path>) -> Self {
        Self {
            path: path.as_ref().to_owned(),
        }
    }
    fn locked<T>(
        &self,
        op: impl FnOnce(&mut QueueData) -> Result<(T, bool), String>,
    ) -> Result<T, String> {
        if let Some(parent) = self.path.parent().filter(|p| !p.as_os_str().is_empty()) {
            fs::create_dir_all(parent).map_err(|e| e.to_string())?;
        }
        let lock_path = self.path.with_extension("lock");
        let lock_file = fs::OpenOptions::new()
            .write(true)
            .create_new(true)
            .open(&lock_path)
            .map_err(|_| "review queue locked; investigate owner before recovery")?;
        let _lock = Lock(lock_path);
        drop(lock_file);
        let mut data = if self.path.exists() {
            if fs::metadata(&self.path).map_err(|e| e.to_string())?.len() > 16 * 1024 * 1024 {
                return Err("review queue too large".into());
            }
            serde_json::from_slice(&fs::read(&self.path).map_err(|e| e.to_string())?)
                .map_err(|e| format!("invalid review queue: {e}"))?
        } else {
            QueueData::default()
        };
        let (value, changed) = op(&mut data)?;
        if changed {
            let temp = self
                .path
                .with_extension(format!("{}.tmp", uuid::Uuid::new_v4()));
            let mut file = fs::OpenOptions::new()
                .write(true)
                .create_new(true)
                .open(&temp)
                .map_err(|e| e.to_string())?;
            file.write_all(&serde_json::to_vec_pretty(&data).map_err(|e| e.to_string())?)
                .map_err(|e| e.to_string())?;
            file.sync_all().map_err(|e| e.to_string())?;
            drop(file);
            fs::rename(&temp, &self.path).map_err(|e| e.to_string())?;
        }
        Ok(value)
    }
    pub fn enqueue(&self, item: ReviewItem) -> Result<(), String> {
        self.locked(|data| {
            let observation = ReviewObservation::from_item(
                &item,
                if item.analysis.is_none() && item.source.starts_with("Historical") {
                    ObservationSource::HistoricalSeed
                } else {
                    ObservationSource::Executor
                },
            );
            let observed = telemetry::upsert(&mut data.observations, observation)?;
            if let Some(old) = data.items.iter_mut().find(|i| {
                i.operation_id == item.operation_id && i.requested_by == item.requested_by
            }) {
                if old.parameters_digest != item.parameters_digest
                    || old.report_digest != item.report_digest
                    || old.governance_policy_digest != item.governance_policy_digest
                    || old.decision.review_policy_digest != item.decision.review_policy_digest
                {
                    return Err("409 review queue snapshot/parameters/policy mismatch".into());
                }
                if old.decision != item.decision {
                    let completed = old.completed_execution;
                    let reviewed = old.review_evidence.clone();
                    *old = item;
                    old.completed_execution = completed;
                    old.review_evidence = reviewed;
                    return Ok(((), true));
                }
                return Ok(((), observed));
            }
            if data.items.len() >= 1000 {
                return Err("review queue capacity reached".into());
            }
            data.items.push(item);
            Ok(((), true))
        })
    }
    pub fn observe(&self, observation: ReviewObservation) -> Result<(), String> {
        self.locked(|data| {
            let changed = telemetry::upsert(&mut data.observations, observation)?;
            Ok(((), changed))
        })
    }
    pub fn observations(&self) -> Result<Vec<ReviewObservation>, String> {
        self.locked(|data| Ok((data.observations.clone(), false)))
    }
    pub fn metrics(&self) -> Result<telemetry::ReviewLoadReport, String> {
        self.locked(|data| {
            let mut report = telemetry::load_report(
                &data.observations,
                Some(
                    data.items
                        .iter()
                        .filter(|i| i.completed_execution.is_none())
                        .count(),
                ),
                Some(
                    data.items
                        .iter()
                        .filter(|i| i.completed_execution.is_some())
                        .count(),
                ),
            );
            report.queue_cases_without_observation = Some(
                data.items
                    .iter()
                    .filter(|i| {
                        !data.observations.iter().any(|o| {
                            o.operation_id == i.operation_id
                                && o.requested_by == i.requested_by
                                && o.report_digest == i.report_digest
                                && o.parameters_digest == i.parameters_digest
                                && o.decision.review_policy_digest
                                    == i.decision.review_policy_digest
                        })
                    })
                    .count(),
            );
            Ok((report, false))
        })
    }
    pub fn list(&self) -> Result<Vec<ReviewItem>, String> {
        self.locked(|data| {
            let mut items: Vec<_> = data
                .items
                .iter()
                .filter(|i| i.completed_execution.is_none())
                .cloned()
                .collect();
            let rank = |s| match s {
                Severity::Critical => 0,
                Severity::High => 1,
                Severity::Medium => 2,
                Severity::Low => 3,
                Severity::Info => 4,
            };
            items.sort_by_key(|i| {
                (
                    rank(i.severity),
                    i.signals
                        .confidence_bps
                        .filter(|n| *n <= 10000)
                        .unwrap_or(0),
                    if i.signals.text_decision_disagreement == Some(true) {
                        0
                    } else {
                        1
                    },
                    i.case_id.clone(),
                )
            });
            Ok((items, false))
        })
    }
    pub fn get(&self, caller: &str, operation: Digest32) -> Result<Option<ReviewItem>, String> {
        self.locked(|data| {
            Ok((
                data.items
                    .iter()
                    .find(|i| i.requested_by == caller && i.operation_id == operation)
                    .cloned(),
                false,
            ))
        })
    }
    pub(crate) fn complete(
        &self,
        caller: &str,
        operation: Digest32,
        execution: Digest32,
        review: Option<HumanReviewEvidence>,
    ) -> Result<(), String> {
        self.locked(|data| {
            let item = data
                .items
                .iter_mut()
                .find(|i| i.requested_by == caller && i.operation_id == operation)
                .ok_or("review case missing")?;
            if item
                .completed_execution
                .is_some_and(|hash| hash != execution)
            {
                return Err("review completion conflict".into());
            }
            item.completed_execution = Some(execution);
            item.review_evidence = review;
            Ok(((), true))
        })
    }
}

pub(crate) struct CapturedReviewAnalysis(pub WorkerExecutionRecord);
#[async_trait::async_trait]
impl LlmAnalyzer for CapturedReviewAnalysis {
    fn classification_evidence(&self) -> Option<arkhe_core::worker::ClassificationBinding> {
        self.0.classification
    }
    async fn analyze(
        &self,
        report: &ReportDetails,
        params: TriageParams,
    ) -> Result<WorkerExecutionRecord, String> {
        if self.0.input_digest != report.digest()
            || self.0.output_digest != params.digest_for(self.0.classification)
        {
            return Err("reviewed analysis snapshot changed".into());
        }
        Ok(self.0.clone())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ReviewerFeedback {
    pub human_review_digest: Digest32,
    pub severity: Severity,
    pub confidence_bps: u16,
    pub corrected_model: bool,
}
#[derive(Debug, Serialize, Deserialize)]
pub struct ThresholdProposal {
    pub status: String,
    pub parent_policy_digest: Digest32,
    pub feedback: Vec<ReviewerFeedback>,
    pub candidate: ReviewPolicy,
}
/// A conservative governance candidate, not calibration or automatic policy activation.
/// The caller must validate feedback provenance; the proposal cannot enable automation.
pub fn propose_threshold_update(
    policy: &ReviewPolicy,
    feedback: Vec<ReviewerFeedback>,
) -> Result<ThresholdProposal, String> {
    policy.validate()?;
    if feedback.is_empty()
        || feedback
            .iter()
            .any(|f| f.confidence_bps > 10000 || f.human_review_digest == Digest32::ZERO)
    {
        return Err("invalid or absent reviewer feedback".into());
    }
    let mut candidate = policy.clone();
    candidate.automation_approved = false;
    candidate.policy_id = format!("{}:feedback-candidate", policy.policy_id);
    for f in &feedback {
        if f.corrected_model {
            let threshold = match f.severity {
                Severity::Medium => &mut candidate.medium_threshold_bps,
                Severity::Low => &mut candidate.low_threshold_bps,
                Severity::Info => &mut candidate.info_threshold_bps,
                _ => continue,
            };
            *threshold = (*threshold).max(f.confidence_bps.saturating_add(1).min(10000));
        }
    }
    Ok(ThresholdProposal {
        status: "PENDING_GOVERNANCE_APPROVAL_NOT_CALIBRATED".into(),
        parent_policy_digest: policy.digest(),
        feedback,
        candidate,
    })
}

/// Install this only around independently approved governance; it cannot turn a deny into allow.
pub struct ReviewProtectedPolicy<R> {
    pub inner: R,
    pub approved_human_modules: Vec<String>,
}
impl<R: arkhe_governance::PolicyResolver> arkhe_governance::PolicyResolver
    for ReviewProtectedPolicy<R>
{
    fn review_routing_required(
        &self,
        i: &arkhe_core::work::WorkIntent,
        _: &arkhe_governance::PolicyBinding,
    ) -> bool {
        i.intent_type == arkhe_core::work::WorkIntentType::TriageReport
    }
    fn human_review_modules(
        &self,
        _: &arkhe_core::work::WorkIntent,
        _: &arkhe_governance::PolicyBinding,
    ) -> Vec<String> {
        self.approved_human_modules.clone()
    }
    fn resolve(
        &self,
        i: &arkhe_core::work::WorkIntent,
        p: &arkhe_governance::PolicyBinding,
    ) -> arkhe_governance::PolicyVerdict {
        self.inner.resolve(i, p)
    }
    fn required_worker_evidence(
        &self,
        i: &arkhe_core::work::WorkIntent,
        p: &arkhe_governance::PolicyBinding,
    ) -> Option<arkhe_governance::EvidenceKindRequirement> {
        self.inner.required_worker_evidence(i, p)
    }
    fn required_classification_policy(
        &self,
        i: &arkhe_core::work::WorkIntent,
        p: &arkhe_governance::PolicyBinding,
    ) -> Option<Digest32> {
        self.inner.required_classification_policy(i, p)
    }
}
