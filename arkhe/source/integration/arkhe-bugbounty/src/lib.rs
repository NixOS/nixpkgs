//! Integration boundary. Reports and analyzer output are untrusted until admission.
use arkhe_core::{
    canonical::encode_value,
    evidence::EvidenceReader,
    work::{ContextEntry, ContextKind, RequestIdentity, WorkIntent, WorkIntentType},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_governance::{PolicyBinding, PolicyResolver};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use async_trait::async_trait;
use serde::{Deserialize, Serialize};
use std::sync::Arc;
/// Local evidence/payout candidate; not connected to execution authority.
pub mod bounty_evidence;
pub mod classification;
pub mod governance;
pub mod journal;
pub mod mcp;
pub mod ollama;
pub mod postgres;
pub mod provenance;
pub mod review;
pub mod scope;
pub mod taxonomy;
pub mod workload;
pub use journal::{Claim, Journal, OperationJournal};

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("external call failed: {0}")]
    External(String),
    #[error("containment rejected: {0}")]
    Rejected(String),
    #[error("admission failed: {0}")]
    Admission(String),
    #[error("operational log failed: {0}")]
    Log(String),
    #[error("409 conflict: idempotency parameters differ")]
    ParameterMismatch,
    #[error("journal unavailable: {0}")]
    Journal(String),
    #[error("operation outcome uncertain; reconcile before retry")]
    Uncertain,
    #[error("invalid schema or mismatched report identifier")]
    InvalidReport,
    #[error("human review required: {0}")]
    ReviewRequired(String),
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum Severity {
    Critical,
    High,
    Medium,
    Low,
    Info,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum State {
    Triaged,
    Rejected,
    Duplicate,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct ReportDetails {
    pub version: u16,
    pub report_id: String,
    pub severity: Severity,
    pub title: String,
    pub report_body: String,
    pub submitted_at: i64,
    pub affected_assets: Vec<Digest32>,
}
impl ReportDetails {
    pub fn target(&self) -> Digest32 {
        report_target(&self.report_id)
    }
    /// Computed locally, never trusted from the remote service; no self-reference.
    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:HACKENPROOF:REPORT:v1\0",
            &encode_value(&serde_json::json!({
                "version": self.version, "report_id": self.report_id, "severity": self.severity,
                "title": self.title, "report_body": self.report_body, "submitted_at": self.submitted_at,
                "affected_assets": self.affected_assets.iter().map(|d| d.to_hex()).collect::<Vec<_>>()
            })),
        )
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct TriageResponse {
    pub version: u16,
    pub report_id: String,
    pub accepted_at: i64,
    pub transaction_digest: Digest32,
}
#[derive(Debug, Clone, Copy, Serialize, Deserialize)]
pub struct TriageParams {
    pub severity: Severity,
    pub state: State,
}
impl TriageParams {
    pub fn digest_for(
        &self,
        classification: Option<arkhe_core::worker::ClassificationBinding>,
    ) -> Digest32 {
        match classification {
            None => self.digest(),
            Some(binding) => Digest32::blake3(
                b"AKG:TRIAGE:CLASSIFIED-PARAMS:v1\0",
                &encode_value(&serde_json::json!({
                    "parameters_digest": self.digest(), "classification_digest": binding.classification_digest,
                    "policy_digest": binding.policy_digest
                })),
            ),
        }
    }
    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:TRIAGE:PARAMS:v1\0",
            &encode_value(&serde_json::json!(self)),
        )
    }
}
#[derive(Debug, thiserror::Error)]
pub enum HackenProofError {
    #[error("unauthorized: {0}")]
    Unauthorized(String),
    #[error("conflicting operation")]
    Conflict,
    #[error("not found: {0}")]
    NotFound(String),
    #[error("timeout after {0:?}")]
    Timeout(std::time::Duration),
    #[error("transient: {0}")]
    Transient(String),
    #[error("permanent: {0}")]
    Permanent(String),
}
#[async_trait]
pub trait HackenProofMcpClient: Send + Sync {
    /// Must resolve the report's program through the authenticated upstream contract.
    /// Missing support fails closed instead of assuming a report is in scope.
    async fn get_program_info(
        &self,
        _report_id: &str,
    ) -> Result<scope::ProgramScope, HackenProofError> {
        Err(HackenProofError::Permanent(
            "program scope contract not configured".into(),
        ))
    }
    async fn get_report_details(&self, report_id: &str) -> Result<ReportDetails, HackenProofError>;
    /// No automatic retries. A stable ID alone does not prove server deduplication.
    async fn triage_report(
        &self,
        report_id: &str,
        params: TriageParams,
        operation_id: Digest32,
    ) -> Result<TriageResponse, HackenProofError>;
}
#[async_trait]
pub trait LlmAnalyzer: Send + Sync {
    /// Review workflow may retain an explicit negative opinion for human examination.
    /// Legacy adapters only return their supported candidate; unknown signals still escalate.
    async fn analyze_for_review(
        &self,
        report: &ReportDetails,
        params: TriageParams,
    ) -> Result<(WorkerExecutionRecord, bool), String> {
        self.analyze(report, params)
            .await
            .map(|record| (record, true))
    }
    fn classification_evidence(&self) -> Option<arkhe_core::worker::ClassificationBinding> {
        None
    }
    /// Record must bind report.digest() as input and params.digest() as output.
    /// Admission must validate provenance and successful execution independently.
    async fn analyze(
        &self,
        report: &ReportDetails,
        params: TriageParams,
    ) -> Result<WorkerExecutionRecord, String>;
}
#[async_trait]
pub trait Kernel: EvidenceReader {
    /// Implementations verify provenance, hash and successful execution before commit.
    async fn admit(&self, record: &WorkerExecutionRecord) -> Result<Digest32, String>;
}
#[async_trait]
pub trait OperationalLog: Send + Sync {
    async fn record(
        &self,
        report_id: &str,
        operation_id: Option<Digest32>,
        stage: &str,
        error: &str,
    ) -> Result<(), String>;
}
pub fn report_target(id: &str) -> Digest32 {
    Digest32::blake3(b"AKG:HACKENPROOF:TARGET:v1\0", id.as_bytes())
}
pub struct TriageExecutor<C, L, K, O, R: PolicyResolver> {
    pub client: C,
    pub analyzer: L,
    pub kernel: K,
    pub operational_log: O,
    pub gate: ContainmentGate<R>,
    pub policy: PolicyBinding,
    pub requested_by: String,
    pub journal: Arc<dyn Journal>,
}
impl<C: HackenProofMcpClient, L: LlmAnalyzer, K: Kernel, O: OperationalLog, R: PolicyResolver>
    TriageExecutor<C, L, K, O, R>
{
    async fn fail(&self, id: &str, op: Option<Digest32>, stage: &str, error: Error) -> Error {
        let error = if let Some(operation) = op.filter(|_| stage != "claim") {
            match self
                .journal
                .require_manual_reconciliation(
                    &self.requested_by,
                    operation,
                    &format!("{stage}: {error}"),
                )
                .await
            {
                Ok(()) => error,
                Err(e) => Error::Journal(format!(
                    "manual reconciliation marker failed: {e}; original: {error}"
                )),
            }
        } else {
            error
        };

        match self
            .operational_log
            .record(id, op, stage, &error.to_string())
            .await
        {
            Ok(()) => error,
            Err(e) => Error::Log(format!("{e}; original: {error}")),
        }
    }
    pub async fn execute_triage(
        &self,
        id: &str,
        params: TriageParams,
        request_identity: RequestIdentity,
    ) -> Result<WorkerExecutionRecord, Error> {
        self.execute_triage_using(id, params, request_identity, &self.analyzer, None)
            .await
    }

    /// Review-aware entry point. Pending review creates no dispatch reservation and
    /// cached analysis is reused only for an unchanged source/parameters/policy snapshot.
    /// Install ReviewProtectedPolicy to prohibit the legacy entry point for production.
    #[allow(clippy::too_many_arguments)]
    pub async fn execute_triage_reviewed(
        &self,
        id: &str,
        params: TriageParams,
        request_identity: RequestIdentity,
        router: &review::ReviewRouter,
        queue: &review::FileReviewQueue,
        mut signals: review::ReviewSignals,
        human: Option<&review::HumanReviewEvidence>,
        now: i64,
    ) -> Result<WorkerExecutionRecord, Error> {
        use review::ReviewVerdict;
        let report = self
            .client
            .get_report_details(id)
            .await
            .map_err(|e| Error::External(e.to_string()))?;
        if report.version != 1 || report.report_id != id {
            return Err(Error::InvalidReport);
        }
        let scope = self
            .client
            .get_program_info(id)
            .await
            .map_err(|e| Error::External(e.to_string()))?;
        scope
            .check(&report)
            .map_err(|e| Error::Rejected(e.into()))?;
        let parameters = params.digest_for(self.analyzer.classification_evidence());
        let base = WorkIntent {
            requested_by: self.requested_by.clone(),
            intent_type: WorkIntentType::TriageReport,
            target: report.target(),
            parameters_digest: parameters,
            context: vec![],
            context_refs: vec![],
            request_identity,
            claimed_created_at: 0,
        };
        let operation = base.operation_id();
        if !matches!(
            self.gate.policy_verdict(&base, &self.policy),
            arkhe_governance::PolicyVerdict::Allow
        ) {
            signals.policy_exception = true;
        }
        let analysis = if let Some(item) = queue
            .get(&self.requested_by, operation)
            .map_err(Error::Journal)?
        {
            if item.parameters_digest != parameters {
                return Err(Error::ParameterMismatch);
            }
            if item.report_digest != report.digest()
                || item.governance_policy_digest != self.policy.policy_digest
                || item.decision.review_policy_digest != router.policy().digest()
            {
                return Err(Error::Rejected(
                    "review snapshot or policy changed; re-review required".into(),
                ));
            }
            // A pending case cannot lose risk flags simply by being retried.
            signals.policy_exception |= item.signals.policy_exception;
            signals.irreversible |= item.signals.irreversible;
            signals.supports_proposal &= item.signals.supports_proposal;
            let merge = |a: Option<bool>, b: Option<bool>| {
                if a == Some(true) || b == Some(true) {
                    Some(true)
                } else if a == Some(false) && b == Some(false) {
                    Some(false)
                } else {
                    None
                }
            };
            signals.ambiguous = merge(signals.ambiguous, item.signals.ambiguous);
            signals.text_decision_disagreement = merge(
                signals.text_decision_disagreement,
                item.signals.text_decision_disagreement,
            );
            item.analysis.ok_or_else(|| {
                Error::ReviewRequired("case has no independently admissible analysis".into())
            })?
        } else {
            match self.analyzer.analyze_for_review(&report, params).await {
                Ok((record, supports)) => {
                    signals.supports_proposal = supports;
                    record
                }
                Err(error) => {
                    // No candidate is fabricated for malformed/invalid analysis. Escalation
                    // retains an operational case, which cannot execute without valid evidence.
                    signals.supports_proposal = false;
                    signals.confidence_bps = None;
                    signals.ambiguous = None;
                    let decision = router.decide(params.severity, "UNAVAILABLE", &signals);
                    queue.enqueue(review::ReviewItem { completed_execution:None,review_evidence:None,case_id:id.into(),requested_by:self.requested_by.clone(),operation_id:operation,report_digest:report.digest(),parameters_digest:parameters,governance_policy_digest:self.policy.policy_digest,severity:params.severity,model_version:"UNAVAILABLE".into(),signals,decision,analysis:None,source:"Analysis unavailable or invalid; no admitted evidence; operator investigation required".into() }).map_err(Error::Journal)?;
                    self.operational_log
                        .record(id, Some(operation), "review_required_no_analysis", &error)
                        .await
                        .map_err(Error::Log)?;
                    return Err(Error::ReviewRequired(operation.to_hex()));
                }
            }
        };
        if analysis.input_digest != report.digest() || analysis.output_digest != parameters {
            return Err(Error::Rejected(
                "review analysis does not bind proposal".into(),
            ));
        }
        // Confidence comes from the signed analysis candidate, never a caller-supplied score.
        signals.confidence_bps = analysis.confidence_bps;
        let decision = router.decide(params.severity, &analysis.module_version, &signals);
        // Observe every route, including non-queued AutoAccept/AutoReject outcomes.
        // Otherwise measuring only the review queue would create a selected denominator.
        queue
            .observe(review::ReviewObservation {
                case_id: id.into(),
                requested_by: self.requested_by.clone(),
                operation_id: operation,
                report_digest: report.digest(),
                parameters_digest: parameters,
                governance_policy_digest: self.policy.policy_digest,
                severity: params.severity,
                model_version: analysis.module_version.clone(),
                signals: signals.clone(),
                decision: decision.clone(),
                source: review::ObservationSource::Executor,
            })
            .map_err(Error::Journal)?;
        if decision.verdict == ReviewVerdict::AutoReject {
            self.operational_log
                .record(
                    id,
                    Some(operation),
                    "auto_reject",
                    "review router rejected proposal",
                )
                .await
                .map_err(Error::Log)?;
            return Err(Error::Rejected("review router rejected proposal".into()));
        }
        if decision.verdict == ReviewVerdict::ReviewRequired {
            queue
                .enqueue(review::ReviewItem {
                    completed_execution: None,
                    review_evidence: None,
                    case_id: id.into(),
                    requested_by: self.requested_by.clone(),
                    operation_id: operation,
                    report_digest: report.digest(),
                    parameters_digest: parameters,
                    governance_policy_digest: self.policy.policy_digest,
                    severity: params.severity,
                    model_version: analysis.module_version.clone(),
                    signals,
                    decision: decision.clone(),
                    analysis: Some(analysis.clone()),
                    source:
                        "TriageExecutor review preflight; candidate requires verified admission"
                            .into(),
                })
                .map_err(Error::Journal)?;
            if human.is_none() {
                self.operational_log
                    .record(
                        id,
                        Some(operation),
                        "review_required",
                        "queued; no dispatch reserved",
                    )
                    .await
                    .map_err(Error::Log)?;
                return Err(Error::ReviewRequired(operation.to_hex()));
            }
        }
        let captured = review::CapturedReviewAnalysis(analysis);
        let result = self
            .execute_triage_using(
                id,
                params,
                request_identity,
                &captured,
                Some((&decision, human, now)),
            )
            .await;
        if let Ok(record) = &result {
            if decision.verdict == ReviewVerdict::ReviewRequired {
                queue
                    .complete(
                        &self.requested_by,
                        operation,
                        record.digest(),
                        human.cloned(),
                    )
                    .map_err(Error::Journal)?;
            }
        }
        result
    }

    async fn execute_triage_using(
        &self,
        id: &str,
        params: TriageParams,
        request_identity: RequestIdentity,
        analyzer: &dyn LlmAnalyzer,
        routed: Option<(
            &review::ReviewDecision,
            Option<&review::HumanReviewEvidence>,
            i64,
        )>,
    ) -> Result<WorkerExecutionRecord, Error> {
        let classification = analyzer.classification_evidence();
        let mut intent = WorkIntent {
            requested_by: self.requested_by.clone(),
            intent_type: WorkIntentType::TriageReport,
            target: report_target(id),
            parameters_digest: params.digest_for(classification),
            context_refs: vec![],
            context: vec![],
            request_identity,
            claimed_created_at: 0,
        };
        if let Some(binding) = classification {
            intent.context.extend([
                ContextEntry {
                    kind: ContextKind::SeverityClassification,
                    hash: binding.classification_digest,
                },
                ContextEntry {
                    kind: ContextKind::ClassificationPolicy,
                    hash: binding.policy_digest,
                },
            ]);
        }
        let op = intent.operation_id();
        let owner = match self.journal.claim(&intent).await {
            Ok(Claim::Acquired(owner)) => owner,
            Ok(Claim::Replay(record)) => return Ok(record),
            Ok(Claim::Pending) => {
                return Err(self.fail(id, Some(op), "reconcile", Error::Uncertain).await)
            }
            Err(e) => return Err(self.fail(id, Some(op), "claim", e).await),
        };
        let raw = self
            .client
            .get_report_details(id)
            .await
            .map_err(|e| Error::External(e.to_string()));
        let report = match raw {
            Ok(r) => r,
            Err(e) => return Err(self.fail(id, Some(op), "read", e).await),
        };
        if report.version != 1 || report.report_id != id {
            return Err(self.fail(id, Some(op), "read", Error::InvalidReport).await);
        }
        let scope = match self.client.get_program_info(id).await {
            Ok(scope) => scope,
            Err(e) => {
                return Err(self
                    .fail(id, Some(op), "scope_check", Error::External(e.to_string()))
                    .await)
            }
        };
        if let Err(reason) = scope.check(&report) {
            return Err(self
                .fail(id, Some(op), "out_of_scope", Error::Rejected(reason.into()))
                .await);
        }
        intent.context.push(ContextEntry {
            kind: ContextKind::ProgramScope,
            hash: scope.digest(),
        });
        intent.context.push(ContextEntry {
            kind: ContextKind::SourceReport,
            hash: report.digest(),
        });
        let analysis = match analyzer.analyze(&report, params).await {
            Ok(a) => a,
            Err(e) => {
                return Err(self
                    .fail(id, Some(op), "analyze", Error::Admission(e))
                    .await)
            }
        };
        let admitted = match self.kernel.admit(&analysis).await {
            Ok(h) if h == analysis.digest() => h,
            Ok(_) => {
                return Err(self
                    .fail(
                        id,
                        Some(op),
                        "admit",
                        Error::Admission("hash mismatch".into()),
                    )
                    .await)
            }
            Err(e) => return Err(self.fail(id, Some(op), "admit", Error::Admission(e)).await),
        };
        intent.context.push(ContextEntry {
            kind: ContextKind::AnalysisRecord,
            hash: admitted,
        });
        let authorization = if let Some((decision, human, now)) = routed {
            intent.context.push(ContextEntry {
                kind: ContextKind::ReviewDecision,
                hash: decision.digest(),
            });
            if let Some(human) = human {
                match self.kernel.admit(&human.attestation).await {
                    Ok(hash) if hash == human.attestation.digest() => {
                        intent.context.push(ContextEntry {
                            kind: ContextKind::HumanReview,
                            hash,
                        })
                    }
                    _ => {
                        return Err(self
                            .fail(
                                id,
                                Some(op),
                                "human_review",
                                Error::Rejected("human review attestation admission failed".into()),
                            )
                            .await)
                    }
                }
            }
            self.gate
                .authorize_routed_admitted(
                    &intent,
                    &analysis,
                    &self.policy,
                    &self.kernel,
                    decision,
                    human,
                    now,
                )
                .await
        } else {
            self.gate
                .authorize_admitted(&intent, &analysis, &self.policy, &self.kernel)
                .await
        };
        if let AuthorizationDecision::Reject { reason } = authorization {
            return Err(self
                .fail(id, Some(op), "authorize", Error::Rejected(reason))
                .await);
        }
        if let Err(e) = self.journal.mark_dispatched(&intent, owner).await {
            return Err(self.fail(id, Some(op), "dispatch", e).await);
        }
        let response = match self.client.triage_report(id, params, op).await {
            Ok(r) if r.version == 1 && r.report_id == id => r,
            Ok(_) => {
                return Err(self
                    .fail(id, Some(op), "execute", Error::InvalidReport)
                    .await)
            }
            Err(e) => {
                return Err(self
                    .fail(id, Some(op), "execute", Error::External(e.to_string()))
                    .await)
            }
        };
        let output = Digest32::blake3(
            b"AKG:TRIAGE:RECEIPT:v1\0",
            &encode_value(&serde_json::json!({
                "version": response.version, "report_id": response.report_id, "accepted_at": response.accepted_at,
                "transaction_digest": response.transaction_digest.to_hex(), "operation_id": op.to_hex(),
            })),
        );
        let record = WorkerExecutionRecord {
            classification: None,
            operation: Some(CognitiveOperation::Execute),
            module_id: "hackenproof-adapter-v1".into(),
            module_version: env!("CARGO_PKG_VERSION").into(),
            input_digest: admitted,
            output_digest: output,
            evidence_refs: vec![admitted],
            confidence_bps: None,
            uncertainty_note: None,
            execution_id: op.to_hex(),
        };
        match self.kernel.admit(&record).await {
            Ok(h) if h == record.digest() => (),
            result => {
                return Err(self
                    .fail(
                        id,
                        Some(op),
                        "record",
                        Error::Admission(format!("{result:?}")),
                    )
                    .await)
            }
        }
        if let Err(e) = self.journal.complete(&intent, owner, &record).await {
            return Err(self.fail(id, Some(op), "complete", e).await);
        }
        Ok(record)
    }
}
