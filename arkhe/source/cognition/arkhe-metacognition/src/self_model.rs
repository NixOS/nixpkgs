//! Descriptive calibration of host-authenticated, resolved binary predictions.
//! No signing, persistence, network, clock reads or authorization capability.
use arkhe_cognition_sdk::{
    worker::WorkerExecutionRecord, CanonicalEncode, Digest32, EvidenceReader,
};
use serde::Serialize;
use serde_json::{json, Value};
use std::collections::HashSet;

pub const PREDICTION_KIND: &str = "arkhe/calibration-prediction/v1";
pub const OUTCOME_KIND: &str = "arkhe/calibration-outcome/v1";
pub const MAX_RESOLUTIONS: usize = 100_000;

/// A cohort identifies module/version, task population and policy outside this
/// module. The host must authenticate that scope and admission of each envelope.
#[derive(Debug, Clone)]
pub struct ResolvedPrediction {
    pub prediction_ref: Digest32,
    pub outcome_ref: Digest32,
    pub predicted_bps: u16,
    pub observed: bool,
    pub predicted_at: i64,
    pub resolved_at: i64,
}

struct Projection(Value);
impl CanonicalEncode for Projection {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:METACOG:PAYLOAD:v1\0";
    fn unsigned_projection(&self) -> Value {
        self.0.clone()
    }
}

pub fn prediction_payload_digest(
    cohort: Digest32,
    predicted_bps: u16,
    predicted_at: i64,
) -> Result<Digest32, &'static str> {
    if cohort == Digest32::ZERO || predicted_bps > 10_000 || predicted_at < 0 {
        return Err("invalid prediction payload");
    }
    Ok(
        Projection(json!({"type":PREDICTION_KIND,"input_digest":cohort,
        "predicted_bps":predicted_bps,"predicted_at":predicted_at}))
        .object_digest(),
    )
}

pub fn outcome_payload_digest(
    prediction_ref: Digest32,
    observed: bool,
    resolved_at: i64,
) -> Result<Digest32, &'static str> {
    if prediction_ref == Digest32::ZERO || resolved_at < 0 {
        return Err("invalid outcome payload");
    }
    Ok(
        Projection(json!({"type":OUTCOME_KIND,"input_digest":prediction_ref,
        "observed":u8::from(observed),"resolved_at":resolved_at}))
        .object_digest(),
    )
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize)]
pub enum HistoryStatus {
    InsufficientHistory,
    DescriptiveMetricsAvailable,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct CalibrationBin {
    pub lower_bps: u16,
    pub upper_bps_inclusive: u16,
    pub count: u32,
    pub successes: u32,
    pub mean_prediction_bps: Option<u16>,
    pub observed_success_bps: Option<u16>,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize)]
pub struct CalibrationReport {
    status: HistoryStatus,
    cohort: Digest32,
    history_digest: Digest32,
    count: u32,
    minimum_samples: u32,
    brier_score_ppm: Option<u32>,
    expected_calibration_error_bps: Option<u16>,
    mean_prediction_bps: Option<u16>,
    observed_success_bps: Option<u16>,
    bins: Vec<CalibrationBin>,
}

impl CalibrationReport {
    pub fn status(&self) -> HistoryStatus {
        self.status
    }
    pub fn count(&self) -> u32 {
        self.count
    }
    pub fn cohort(&self) -> Digest32 {
        self.cohort
    }
    pub fn history_digest(&self) -> Digest32 {
        self.history_digest
    }
    pub fn brier_score_ppm(&self) -> Option<u32> {
        self.brier_score_ppm
    }
    pub fn expected_calibration_error_bps(&self) -> Option<u16> {
        self.expected_calibration_error_bps
    }
    pub fn mean_prediction_bps(&self) -> Option<u16> {
        self.mean_prediction_bps
    }
    pub fn observed_success_bps(&self) -> Option<u16> {
        self.observed_success_bps
    }
    pub fn bins(&self) -> &[CalibrationBin] {
        &self.bins
    }
}

impl CanonicalEncode for CalibrationReport {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:METACOG:CALIBRATION:v1\0";
    fn unsigned_projection(&self) -> Value {
        // Reuse typed digest field projections of AKG-CBOR-v1, rather than a
        // JSON serialization preimage. The names map cohort/history explicitly.
        json!({"schema":1,"input_digest":self.cohort,"output_digest":self.history_digest,
            "status":self.status,"count":self.count,"minimum_samples":self.minimum_samples,
            "brier_score_ppm":self.brier_score_ppm,
            "expected_calibration_error_bps":self.expected_calibration_error_bps,
            "mean_prediction_bps":self.mean_prediction_bps,
            "observed_success_bps":self.observed_success_bps,"bins":self.bins})
    }
}

/// The snapshot is passive, not proof of authentication. The host must verify
/// signatures, scope and historical ordering before construction. All fields
/// used by these statistics are checked against the admitted payload digests.
pub fn calibrate_history(
    cohort: Digest32,
    minimum_samples: u32,
    samples: &[ResolvedPrediction],
    evidence: &EvidenceReader,
) -> Result<(CalibrationReport, WorkerExecutionRecord), &'static str> {
    if cohort == Digest32::ZERO
        || minimum_samples == 0
        || minimum_samples as usize > MAX_RESOLUTIONS
    {
        return Err("invalid cohort or minimum sample count");
    }
    if samples.len() > MAX_RESOLUTIONS {
        return Err("calibration input exceeds budget");
    }
    let mut ordered: Vec<_> = samples.iter().collect();
    ordered.sort_by_key(|sample| sample.prediction_ref.0);
    let mut predictions = HashSet::new();
    let mut outcomes = HashSet::new();
    let mut history = Vec::with_capacity(samples.len());
    let mut refs = Vec::with_capacity(samples.len() * 2);
    let mut counts = [0u32; 10];
    let mut successes = [0u32; 10];
    let mut sums = [0u64; 10];
    let mut squared_error = 0u64;
    for sample in ordered {
        if sample.prediction_ref == Digest32::ZERO
            || sample.outcome_ref == Digest32::ZERO
            || !predictions.insert(sample.prediction_ref)
            || !outcomes.insert(sample.outcome_ref)
        {
            return Err("duplicate or empty prediction/outcome identity");
        }
        if sample.predicted_at < 0 || sample.resolved_at <= sample.predicted_at {
            return Err("outcome must be recorded after its prediction");
        }
        let prediction = evidence
            .get(sample.prediction_ref)
            .ok_or("prediction evidence missing")?;
        let outcome = evidence
            .get(sample.outcome_ref)
            .ok_or("outcome evidence missing")?;
        if prediction.kind != PREDICTION_KIND
            || prediction.subject != cohort
            || prediction.payload_digest
                != prediction_payload_digest(cohort, sample.predicted_bps, sample.predicted_at)?
            || outcome.kind != OUTCOME_KIND
            || outcome.subject != sample.prediction_ref
            || !outcome.causal_parents.contains(&sample.prediction_ref)
            || outcome.payload_digest
                != outcome_payload_digest(
                    sample.prediction_ref,
                    sample.observed,
                    sample.resolved_at,
                )?
            || prediction.policy_digest != outcome.policy_digest
        {
            return Err("calibration evidence binding mismatch");
        }
        let bin = usize::from(sample.predicted_bps / 1000).min(9);
        counts[bin] += 1;
        successes[bin] += u32::from(sample.observed);
        sums[bin] += u64::from(sample.predicted_bps);
        let error = i64::from(sample.predicted_bps) - if sample.observed { 10_000 } else { 0 };
        squared_error += (error * error) as u64;
        refs.extend([sample.prediction_ref, sample.outcome_ref]);
        history.push(
            json!({"input_digest":sample.prediction_ref,"output_digest":sample.outcome_ref,
            "predicted_bps":sample.predicted_bps,"observed":u8::from(sample.observed),
            "predicted_at":sample.predicted_at,"resolved_at":sample.resolved_at}),
        );
    }
    let history_digest = Projection(json!({"type":"calibration-history/v1",
        "input_digest":cohort,"samples":history}))
    .object_digest();
    let count = samples.len() as u32;
    let n = u64::from(count);
    let bins: Vec<_> = (0..10)
        .map(|i| CalibrationBin {
            lower_bps: i as u16 * 1000,
            upper_bps_inclusive: if i == 9 {
                10_000
            } else {
                i as u16 * 1000 + 999
            },
            count: counts[i],
            successes: successes[i],
            mean_prediction_bps: (counts[i] > 0).then(|| (sums[i] / u64::from(counts[i])) as u16),
            observed_success_bps: (counts[i] > 0)
                .then(|| (u64::from(successes[i]) * 10_000 / u64::from(counts[i])) as u16),
        })
        .collect();
    let gap: u64 = (0..10)
        .map(|i| sums[i].abs_diff(u64::from(successes[i]) * 10_000))
        .sum();
    let report = CalibrationReport {
        status: if count < minimum_samples {
            HistoryStatus::InsufficientHistory
        } else {
            HistoryStatus::DescriptiveMetricsAvailable
        },
        cohort,
        history_digest,
        count,
        minimum_samples,
        brier_score_ppm: (n > 0).then(|| (squared_error / (n * 100)) as u32),
        expected_calibration_error_bps: (n > 0).then(|| (gap / n) as u16),
        mean_prediction_bps: (n > 0).then(|| (sums.iter().sum::<u64>() / n) as u16),
        observed_success_bps: (n > 0)
            .then(|| (u64::from(successes.iter().sum::<u32>()) * 10_000 / n) as u16),
        bins,
    };
    let output_digest = report.object_digest();
    let record = WorkerExecutionRecord {
        classification: None, operation: None,
        module_id: "arkhe-metacognition".into(), module_version: env!("CARGO_PKG_VERSION").into(),
        input_digest: history_digest, output_digest, evidence_refs: refs, confidence_bps: None,
        uncertainty_note: Some("descriptive cohort history only; no confidence for a new prediction, signature verification or execution authority".into()),
        execution_id: format!("calibration:{}", output_digest.to_hex()),
    };
    Ok((report, record))
}
