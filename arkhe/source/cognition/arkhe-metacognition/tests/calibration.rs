use arkhe_cognition_sdk::{CanonicalEncode, Digest32, EvidenceEnvelope, EvidenceReader};
use arkhe_metacognition::self_model::{
    calibrate_history, outcome_payload_digest, prediction_payload_digest, HistoryStatus,
    ResolvedPrediction, OUTCOME_KIND, PREDICTION_KIND,
};

fn cohort() -> Digest32 {
    Digest32::blake3(b"test:cohort", b"model-v1/task-family/policy-v1")
}
fn fixture(probabilities: &[(u16, bool)]) -> (Vec<ResolvedPrediction>, Vec<EvidenceEnvelope>) {
    let mut samples = Vec::new();
    let mut records = Vec::new();
    for (i, &(predicted_bps, observed)) in probabilities.iter().enumerate() {
        let prediction_ref = Digest32::blake3(b"prediction", &(i as u64).to_be_bytes());
        let outcome_ref = Digest32::blake3(b"outcome", &(i as u64).to_be_bytes());
        samples.push(ResolvedPrediction {
            prediction_ref,
            outcome_ref,
            predicted_bps,
            observed,
            predicted_at: 10,
            resolved_at: 20,
        });
        records.push(EvidenceEnvelope {
            record_hash: prediction_ref,
            kind: PREDICTION_KIND.into(),
            subject: cohort(),
            payload_digest: prediction_payload_digest(cohort(), predicted_bps, 10).unwrap(),
            policy_digest: None,
            causal_parents: vec![],
        });
        records.push(EvidenceEnvelope {
            record_hash: outcome_ref,
            kind: OUTCOME_KIND.into(),
            subject: prediction_ref,
            payload_digest: outcome_payload_digest(prediction_ref, observed, 20).unwrap(),
            policy_digest: None,
            causal_parents: vec![prediction_ref],
        });
    }
    (samples, records)
}

#[test]
fn references_are_not_confidence_or_coverage() {
    for refs in [vec![], vec![cohort()]] {
        let (assessment, record) = arkhe_metacognition::assess(cohort(), cohort(), refs);
        assert_eq!(assessment.confidence_bps, None);
        assert_eq!(assessment.evidence_coverage_bps, None);
        assert_eq!(record.confidence_bps, None);
    }
}

#[test]
fn empty_history_has_no_invented_metrics() {
    let reader = EvidenceReader::from_snapshot(vec![]).unwrap();
    let (report, record) = calibrate_history(cohort(), 20, &[], &reader).unwrap();
    assert_eq!(report.status(), HistoryStatus::InsufficientHistory);
    assert_eq!(report.count(), 0);
    assert_eq!(report.brier_score_ppm(), None);
    assert_eq!(report.expected_calibration_error_bps(), None);
    assert_eq!(record.confidence_bps, None);
}

#[test]
fn perfect_and_completely_wrong_predictions_have_expected_scores() {
    for (rows, brier, ece) in [
        (vec![(0, false), (10_000, true)], 0, 0),
        (vec![(10_000, false), (0, true)], 1_000_000, 10_000),
    ] {
        let (samples, records) = fixture(&rows);
        let reader = EvidenceReader::from_snapshot(records).unwrap();
        let (report, record) = calibrate_history(cohort(), 2, &samples, &reader).unwrap();
        assert_eq!(report.brier_score_ppm(), Some(brier));
        assert_eq!(report.expected_calibration_error_bps(), Some(ece));
        assert_eq!(report.status(), HistoryStatus::DescriptiveMetricsAvailable);
        assert_eq!(record.output_digest, report.object_digest());
        assert_eq!(record.input_digest, report.history_digest());
        assert_eq!(record.confidence_bps, None);
        assert_eq!(report.bins()[0].count, 1);
        assert_eq!(report.bins()[9].count, 1);
    }
}

#[test]
fn balanced_half_probability_history_is_calibrated_but_uncertain() {
    let (samples, records) = fixture(&[(5000, true), (5000, false)]);
    let (report, _) = calibrate_history(
        cohort(),
        20,
        &samples,
        &EvidenceReader::from_snapshot(records).unwrap(),
    )
    .unwrap();
    assert_eq!(report.brier_score_ppm(), Some(250_000));
    assert_eq!(report.expected_calibration_error_bps(), Some(0));
    assert_eq!(report.observed_success_bps(), Some(5000));
    assert_eq!(report.mean_prediction_bps(), Some(5000));
    assert_eq!(report.status(), HistoryStatus::InsufficientHistory);
}

#[test]
fn changing_order_preserves_history_and_report_digests() {
    let (mut samples, records) = fixture(&[(1250, true), (8750, false), (10_000, true)]);
    let reader = EvidenceReader::from_snapshot(records).unwrap();
    let (a, ar) = calibrate_history(cohort(), 3, &samples, &reader).unwrap();
    samples.reverse();
    let (b, br) = calibrate_history(cohort(), 3, &samples, &reader).unwrap();
    assert_eq!(a, b);
    assert_eq!(ar.digest(), br.digest());
    let (c, _) = calibrate_history(cohort(), 4, &samples, &reader).unwrap();
    assert_eq!(a.history_digest(), c.history_digest());
    assert_ne!(a.object_digest(), c.object_digest());
}

#[test]
fn missing_prediction_or_outcome_fails_closed() {
    for drop in [0, 1] {
        let (samples, mut records) = fixture(&[(5000, true)]);
        records.remove(drop);
        let reader = EvidenceReader::from_snapshot(records).unwrap();
        assert!(calibrate_history(cohort(), 1, &samples, &reader).is_err());
    }
}

#[test]
fn duplicate_prediction_or_reused_outcome_cannot_inflate_sample_count() {
    let (samples, records) = fixture(&[(5000, true), (5000, false)]);
    let reader = EvidenceReader::from_snapshot(records).unwrap();
    let repeated = vec![samples[0].clone(), samples[0].clone()];
    assert!(calibrate_history(cohort(), 2, &repeated, &reader).is_err());
    let mut reused = samples;
    reused[1].outcome_ref = reused[0].outcome_ref;
    assert!(calibrate_history(cohort(), 2, &reused, &reader).is_err());
}

#[test]
fn altered_predictions_outcomes_and_timestamps_cannot_reuse_payload_bindings() {
    let (samples, records) = fixture(&[(5000, true)]);
    let reader = EvidenceReader::from_snapshot(records).unwrap();
    for mutation in 0..4 {
        let mut changed = samples.clone();
        match mutation {
            0 => changed[0].predicted_bps = 9000,
            1 => changed[0].observed = false,
            2 => changed[0].predicted_at = 9,
            _ => changed[0].resolved_at = 21,
        }
        assert!(calibrate_history(cohort(), 1, &changed, &reader).is_err());
    }
}

#[test]
fn wrong_cohort_kind_subject_or_policy_is_rejected() {
    let (samples, records) = fixture(&[(5000, true)]);
    for mutation in 0..5 {
        let mut changed = records.clone();
        match mutation {
            0 => changed[0].subject = Digest32::ZERO,
            1 => changed[1].kind = "other".into(),
            2 => changed[1].subject = Digest32::ZERO,
            3 => changed[1].policy_digest = Some(cohort()),
            _ => changed[1].causal_parents.clear(),
        }
        let reader = EvidenceReader::from_snapshot(changed).unwrap();
        assert!(calibrate_history(cohort(), 1, &samples, &reader).is_err());
    }
}

#[test]
fn invalid_probability_time_or_threshold_is_rejected() {
    assert!(prediction_payload_digest(cohort(), 10_001, 10).is_err());
    let (mut samples, records) = fixture(&[(5000, true)]);
    let reader = EvidenceReader::from_snapshot(records).unwrap();
    assert!(calibrate_history(cohort(), 0, &samples, &reader).is_err());
    assert!(calibrate_history(Digest32::ZERO, 1, &samples, &reader).is_err());
    samples[0].resolved_at = samples[0].predicted_at;
    assert!(calibrate_history(cohort(), 1, &samples, &reader).is_err());
}
