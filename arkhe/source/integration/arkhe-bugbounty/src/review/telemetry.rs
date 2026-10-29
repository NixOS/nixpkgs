//! Descriptive routing load and read-only shadow comparisons. Not formal SA-ROC ΓArea,
//! calibrated uncertainty, expected-information optimization or production permission.
use super::*;
use std::collections::BTreeMap;

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum ObservationSource {
    Executor,
    HistoricalSeed,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReviewObservation {
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
    pub source: ObservationSource,
}
impl ReviewObservation {
    pub fn from_item(item: &ReviewItem, source: ObservationSource) -> Self {
        Self {
            case_id: item.case_id.clone(),
            requested_by: item.requested_by.clone(),
            operation_id: item.operation_id,
            report_digest: item.report_digest,
            parameters_digest: item.parameters_digest,
            governance_policy_digest: item.governance_policy_digest,
            severity: item.severity,
            model_version: item.model_version.clone(),
            signals: item.signals.clone(),
            decision: item.decision.clone(),
            source,
        }
    }
    /// Confidence/verdict changes update the latest observation for this same snapshot.
    /// Different report, parameters, policy, model or source form a distinct stratum.
    pub fn snapshot_key(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:REVIEW:OBSERVATION:v1\0",
            &encode_value(
                &serde_json::json!({"case_id":self.case_id,"requested_by":self.requested_by,"operation_id":self.operation_id,"report_digest":self.report_digest,"parameters_digest":self.parameters_digest,"governance_policy_digest":self.governance_policy_digest,"review_policy_digest":self.decision.review_policy_digest,"model_version":self.model_version,"severity":self.severity,"source":self.source}),
            ),
        )
    }
}
pub(super) fn upsert(
    rows: &mut Vec<ReviewObservation>,
    row: ReviewObservation,
) -> Result<bool, String> {
    let key = row.snapshot_key();
    if let Some(old) = rows.iter_mut().find(|r| r.snapshot_key() == key) {
        if serde_json::to_value(&*old).map_err(|e| e.to_string())?
            == serde_json::to_value(&row).map_err(|e| e.to_string())?
        {
            return Ok(false);
        }
        *old = row;
        return Ok(true);
    }
    if rows.len() >= 10000 {
        return Err("review telemetry capacity reached".into());
    }
    rows.push(row);
    Ok(true)
}
#[derive(Debug, Clone, Serialize, Default)]
pub struct LoadCounts {
    pub total: u64,
    pub review_required: u64,
    pub auto_accept: u64,
    pub auto_reject: u64,
    pub review_fraction: Option<f64>,
    /// Overlapping reasons, deduplicated within each snapshot; do not sum as cases.
    pub reason_counts: BTreeMap<String, u64>,
}
impl LoadCounts {
    fn add(&mut self, d: &ReviewDecision) {
        self.total += 1;
        match d.verdict {
            ReviewVerdict::ReviewRequired => self.review_required += 1,
            ReviewVerdict::AutoAccept => self.auto_accept += 1,
            ReviewVerdict::AutoReject => self.auto_reject += 1,
        };
        let reasons: std::collections::BTreeSet<_> =
            d.reasons.iter().map(|r| format!("{r:?}")).collect();
        for reason in reasons {
            *self.reason_counts.entry(reason).or_insert(0) += 1;
        }
        self.review_fraction = Some(self.review_required as f64 / self.total as f64);
    }
}
#[derive(Debug, Serialize)]
pub struct SeverityLoad {
    pub severity: Severity,
    pub counts: LoadCounts,
}
#[derive(Debug, Serialize)]
pub struct LoadStratum {
    pub severity: Severity,
    pub model_version: String,
    pub review_policy_digest: Digest32,
    pub source: ObservationSource,
    pub counts: LoadCounts,
}
#[derive(Debug, Serialize)]
pub struct ReviewLoadReport {
    pub metric: String,
    pub denominator: String,
    pub limitations: Vec<String>,
    pub gamma_area: Option<f64>,
    pub gamma_area_status: String,
    pub overall: LoadCounts,
    pub by_severity: Vec<SeverityLoad>,
    pub strata: Vec<LoadStratum>,
    pub pending_queue_cases: Option<usize>,
    pub completed_queue_cases: Option<usize>,
    pub queue_cases_without_observation: Option<usize>,
    pub review_time_seconds: Option<f64>,
    pub monetary_cost: Option<f64>,
    pub human_agreement: Option<f64>,
}
pub fn load_report(
    observations: &[ReviewObservation],
    pending: Option<usize>,
    completed: Option<usize>,
) -> ReviewLoadReport {
    let mut overall = LoadCounts::default();
    let mut by_severity: Vec<_> = [
        Severity::Critical,
        Severity::High,
        Severity::Medium,
        Severity::Low,
        Severity::Info,
    ]
    .into_iter()
    .map(|severity| SeverityLoad {
        severity,
        counts: LoadCounts::default(),
    })
    .collect();
    let mut strata: BTreeMap<String, LoadStratum> = BTreeMap::new();
    for o in observations {
        overall.add(&o.decision);
        by_severity
            .iter_mut()
            .find(|r| r.severity == o.severity)
            .unwrap()
            .counts
            .add(&o.decision);
        let key = format!(
            "{:?}|{}|{}|{:?}",
            o.severity,
            o.model_version,
            o.decision.review_policy_digest.to_hex(),
            o.source
        );
        strata
            .entry(key)
            .or_insert_with(|| LoadStratum {
                severity: o.severity,
                model_version: o.model_version.clone(),
                review_policy_digest: o.decision.review_policy_digest,
                source: o.source,
                counts: LoadCounts::default(),
            })
            .counts
            .add(&o.decision);
    }
    ReviewLoadReport {metric:"observed_review_routing_fraction".into(),denominator:"distinct routing snapshots; latest decision per snapshot; NOT attempts, population or elapsed time".into(),limitations:vec!["Only instrumented snapshots are counted; legacy/unobserved routes are absent".into(),"Historical seeds and executor observations are stratified; neither proves representative sampling".into(),"AutoAccept is a routing outcome, not an executed or authorized write".into(),"Routing load is not formal SA-ROC GammaArea or calibrated uncertainty".into()],gamma_area:None,gamma_area_status:"NOT_COMPUTED_FORMAL_SA_ROC_DEFINITION_AND_REQUIRED_DATA_NOT_IMPLEMENTED".into(),overall,by_severity,strata:strata.into_values().collect(),pending_queue_cases:pending,completed_queue_cases:completed,queue_cases_without_observation:None,review_time_seconds:None,monetary_cost:None,human_agreement:None}
}
#[derive(Debug, Serialize)]
pub struct ShadowCase {
    pub snapshot: Digest32,
    pub case_id: String,
    pub severity: Severity,
    pub active: ReviewVerdict,
    pub shadow: ReviewVerdict,
    pub changed: bool,
}
#[derive(Debug, Serialize)]
pub struct ShadowReport {
    pub status: String,
    pub candidate_policy_digest: Digest32,
    pub sampled_snapshots: usize,
    pub changed: u64,
    pub active_load: ReviewLoadReport,
    pub shadow_load: ReviewLoadReport,
    pub transitions: BTreeMap<String, u64>,
    pub cases: Vec<ShadowCase>,
    pub human_agreement: Option<f64>,
    pub efficacy_status: String,
    pub production_authorized: bool,
}
pub fn compare_shadow(
    observations: &[ReviewObservation],
    candidate: &ReviewRouter,
) -> ShadowReport {
    let mut cases = vec![];
    let mut simulated = vec![];
    let mut transitions = BTreeMap::new();
    let mut changed = 0;
    for o in observations {
        let d = candidate.decide(o.severity, &o.model_version, &o.signals);
        let differs = d.verdict != o.decision.verdict;
        if differs {
            changed += 1;
        }
        *transitions
            .entry(format!("{:?}->{:?}", o.decision.verdict, d.verdict))
            .or_insert(0) += 1;
        cases.push(ShadowCase {
            snapshot: o.snapshot_key(),
            case_id: o.case_id.clone(),
            severity: o.severity,
            active: o.decision.verdict,
            shadow: d.verdict,
            changed: differs,
        });
        let mut row = o.clone();
        row.decision = d;
        simulated.push(row);
    }
    ShadowReport {
        status: "SHADOW_ONLY_NO_POLICY_MUTATION_NO_DISPATCH".into(),
        candidate_policy_digest: candidate.policy().digest(),
        sampled_snapshots: observations.len(),
        changed,
        active_load: load_report(observations, None, None),
        shadow_load: load_report(&simulated, None, None),
        transitions,
        cases,
        human_agreement: None,
        efficacy_status: "CONJECTURE_NOT_EVALUATED_AGAINST_VALIDATED_HUMAN_LABELS".into(),
        production_authorized: false,
    }
}
