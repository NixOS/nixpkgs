use std::sync::Arc;

use arkhe_core::{CanonicalEncode, Digest32};
use arkhe_governance::{
    constitution_graph::Modality,
    er_backend::{ComparisonVector, ErBackend, InMemoryBackend, Invariant},
    fellegi_sunter::FellegiSunter,
    invariant_resolver::{
        InvariantResolver, MockResolutionLog, ResolutionLog, ResolutionRecord, ResolverError,
    },
    ontology_snapshot::{OntologySnapshot, OntologyVersion},
    resolution_binding::{
        AlgorithmVersion, BindingMismatch, ComparisonVersion, ResolutionContext, ResolverParams,
    },
};

fn inv(n: u8) -> Invariant {
    let mut id = [0; 32];
    id[0] = n;
    Invariant {
        id,
        modality: Modality::Obligatory,
        action: "pay".into(),
        condition: "c".into(),
        specificity: 5,
        enacted_at: n.into(),
    }
}

struct SharedLog(Arc<MockResolutionLog>);
impl ResolutionLog for SharedLog {
    fn append(&self, record: &ResolutionRecord) -> Result<[u8; 32], String> {
        self.0.append(record)
    }
}

fn resolver() -> (InvariantResolver, Arc<MockResolutionLog>) {
    let log = Arc::new(MockResolutionLog::new());
    (
        InvariantResolver::new(Box::new(InMemoryBackend), Box::new(SharedLog(log.clone()))),
        log,
    )
}

fn corpus() -> Vec<Invariant> {
    let mut corpus: Vec<_> = (2..6).map(inv).collect();
    corpus.extend((6..14).map(|n| {
        let mut i = inv(n);
        i.condition = format!("c-{n}");
        i.modality = Modality::Optional;
        i
    }));
    corpus
}

fn recorded() -> (
    InvariantResolver,
    ResolutionRecord,
    Invariant,
    OntologySnapshot,
) {
    let (r, log) = resolver();
    let snapshot = OntologySnapshot::new(corpus()).unwrap();
    let candidate = inv(1);
    r.resolve_snapshot(&candidate, &snapshot).unwrap();
    (r, log.last().unwrap(), candidate, snapshot)
}

#[test]
fn all_decision_paths_preserve_the_six_bindings_and_parameter_payload() {
    let mut forbidden = inv(2);
    forbidden.modality = Modality::Impermissible;
    let mut small = inv(3);
    small.condition = "other".into();
    let cases = [
        (vec![], 5, "novel"),
        (vec![inv(2)], 5, "novel_cold_start"),
        (vec![forbidden], 5, "conflict"),
        (corpus(), 5, "duplicate"),
        (corpus(), 10, "candidate_refines"),
        (corpus(), 1, "existing_refines"),
        (vec![inv(2), small], 5, "novel"),
    ];
    for (content, spec, kind) in cases {
        let (r, log) = resolver();
        let mut candidate = inv(1);
        candidate.specificity = spec;
        let snapshot = OntologySnapshot::new(content).unwrap();
        r.resolve_snapshot(&candidate, &snapshot).unwrap();
        let record = log.last().unwrap();
        assert_eq!(record.verdict_kind, kind);
        assert_eq!(log.count(), 1);
        assert_eq!(
            record.context,
            ResolutionContext::new(
                &snapshot,
                &candidate,
                r.params().unwrap(),
                ComparisonVersion::AsciiExactV1
            )
        );
        r.verify_record_inputs(&record, &candidate, &snapshot)
            .unwrap();
        let b = record.context.bindings;
        assert_eq!(b.snapshot, snapshot.version());
        assert_eq!(b.candidate, candidate.object_digest());
        assert_eq!(b.corpus, snapshot.corpus_digest(&candidate));
        assert_eq!(b.params, record.context.params.digest());
        assert_eq!(b.algorithm, record.context.algorithm.digest());
        assert_eq!(b.comparison, record.context.comparison.digest());
    }
}

#[test]
fn slice_and_snapshot_entries_produce_identical_record_identity() {
    let (_, record, candidate, snapshot) = recorded();
    let (r, log) = resolver();
    let mut reversed = snapshot.invariants().to_vec();
    reversed.reverse();
    r.resolve(&candidate, &reversed).unwrap();
    let second = log.last().unwrap();
    assert_eq!(record.context, second.context);
    assert_eq!(record.canonical_bytes(), second.canonical_bytes());
    assert_eq!(record.object_digest(), second.object_digest());
}

struct NoWork;
impl ErBackend for NoWork {
    fn comparison_version(&self) -> Option<ComparisonVersion> {
        Some(ComparisonVersion::AsciiExactV1)
    }
    fn candidate_pairs(&self, _: &[Invariant]) -> Vec<(usize, usize)> {
        panic!("preflight must not block")
    }
    fn comparison_vector(&self, _: &Invariant, _: &Invariant) -> ComparisonVector {
        panic!("preflight must not compare")
    }
}
struct NoLog;
impl ResolutionLog for NoLog {
    fn append(&self, _: &ResolutionRecord) -> Result<[u8; 32], String> {
        panic!("preflight must not append")
    }
}

fn tampered(record: &ResolutionRecord, dimension: BindingMismatch) -> ResolutionRecord {
    let mut altered = record.clone();
    let b = &mut altered.context.bindings;
    match dimension {
        BindingMismatch::Snapshot => b.snapshot = OntologyVersion::from_bytes([99; 32]),
        BindingMismatch::Candidate => b.candidate.0[0] ^= 1,
        BindingMismatch::Corpus => b.corpus.0[0] ^= 1,
        BindingMismatch::Params => {
            b.params = ResolverParams::new(0.9, 0.7, 50, 1e-4).unwrap().digest()
        }
        BindingMismatch::Algorithm => b.algorithm.0[0] ^= 1,
        BindingMismatch::Comparison => b.comparison.0[0] ^= 1,
    }
    altered
}

#[test]
fn each_binding_mismatch_is_rejected_without_blocking_scoring_or_logging() {
    let (_, record, candidate, snapshot) = recorded();
    let verifier = InvariantResolver::new(Box::new(NoWork), Box::new(NoLog));
    verifier
        .verify_record_inputs(&record, &candidate, &snapshot)
        .unwrap();
    for dimension in [
        BindingMismatch::Snapshot,
        BindingMismatch::Candidate,
        BindingMismatch::Corpus,
        BindingMismatch::Params,
        BindingMismatch::Algorithm,
        BindingMismatch::Comparison,
    ] {
        let altered = tampered(&record, dimension);
        assert!(
            matches!(verifier.verify_record_inputs(&altered,&candidate,&snapshot),Err(ResolverError::BindingMismatch(actual)) if actual==dimension)
        );
    }
}

#[test]
fn preflight_checks_actual_inputs_configuration_and_attached_payload() {
    let (mut r, record, candidate, snapshot) = recorded();
    let mut changed = candidate.clone();
    changed.specificity += 1;
    assert!(matches!(
        r.verify_record_inputs(&record, &changed, &snapshot),
        Err(ResolverError::BindingMismatch(BindingMismatch::Candidate))
    ));
    let different = OntologySnapshot::new(vec![]).unwrap();
    assert!(matches!(
        r.verify_record_inputs(&record, &candidate, &different),
        Err(ResolverError::BindingMismatch(BindingMismatch::Snapshot))
    ));
    r.max_em_iterations = 1;
    assert!(matches!(
        r.verify_record_inputs(&record, &candidate, &snapshot),
        Err(ResolverError::BindingMismatch(BindingMismatch::Params))
    ));
    r.max_em_iterations = 50;
    let mut changed = record.clone();
    changed.context.params = ResolverParams::new(0.9, 0.7, 50, 1e-4).unwrap();
    assert!(matches!(
        r.verify_record_inputs(&changed, &candidate, &snapshot),
        Err(ResolverError::BindingMismatch(BindingMismatch::Params))
    ));
    let mut changed = record.clone();
    changed.candidate_id[0] ^= 1;
    assert!(matches!(
        r.verify_record_inputs(&changed, &candidate, &snapshot),
        Err(ResolverError::BindingMismatch(BindingMismatch::Candidate))
    ));
}

#[test]
fn v2_record_digest_binds_each_input_and_output_field() {
    let (_, record, _, _) = recorded();
    let baseline = record.object_digest();
    assert_eq!(ResolutionRecord::DOMAIN_OBJECT, b"AKG:ONTO:RESOLUTION:v2\0");
    for dimension in [
        BindingMismatch::Snapshot,
        BindingMismatch::Candidate,
        BindingMismatch::Corpus,
        BindingMismatch::Params,
        BindingMismatch::Algorithm,
        BindingMismatch::Comparison,
    ] {
        assert_ne!(tampered(&record, dimension).object_digest(), baseline);
    }
    for field in 0..6 {
        let mut altered = record.clone();
        match field {
            0 => altered.candidate_id[1] ^= 1,
            1 => altered.existing_id = None,
            2 => altered.existing_id = Some([99; 32]),
            3 => altered.verdict_kind = "novel",
            4 => {
                altered.match_probability = f64::from_bits(altered.match_probability.to_bits() + 1)
            }
            5 => altered.context.params = ResolverParams::new(0.9, 0.7, 50, 1e-4).unwrap(),
            _ => unreachable!(),
        }
        assert_ne!(altered.object_digest(), baseline, "field {field}");
    }
    // The six digests are CBOR byte strings, not arrays of integers.
    let encoded = record.canonical_bytes();
    for name in [
        "snapshot_digest",
        "candidate_digest",
        "corpus_digest",
        "params_digest",
        "algorithm_digest",
        "comparison_digest",
    ] {
        let mut prefix = arkhe_core::canonical::encode_value(&serde_json::json!(name));
        prefix.extend([0x58, 0x20]);
        assert!(encoded.windows(prefix.len()).any(|window| window == prefix));
    }
}

#[test]
fn params_are_validated_and_each_exact_setting_changes_the_digest() {
    let baseline = ResolverParams::new(0.85, 0.7, 50, 1e-4).unwrap();
    for alternate in [
        ResolverParams::new(f64::from_bits(0.85f64.to_bits() + 1), 0.7, 50, 1e-4),
        ResolverParams::new(0.85, 0.6, 50, 1e-4),
        ResolverParams::new(0.85, 0.7, 1, 1e-4),
        ResolverParams::new(0.85, 0.7, 50, 1e-5),
    ] {
        assert_ne!(alternate.unwrap().digest(), baseline.digest());
    }
    for (d, r, n, t) in [
        (f64::NAN, 0.7, 50, 1e-4),
        (0.85, f64::INFINITY, 50, 1e-4),
        (0.6, 0.7, 50, 1e-4),
        (1.1, 0.7, 50, 1e-4),
        (0.85, -0.1, 50, 1e-4),
        (0.85, 0.7, 0, 1e-4),
        (0.85, 0.7, 50, 0.0),
        (0.85, 0.7, 50, f64::NAN),
    ] {
        assert!(ResolverParams::new(d, r, n, t).is_err());
    }
    assert_eq!(baseline.max_em_iterations(), 50);
    assert_eq!(baseline.em_tolerance().to_bits(), 1e-4f64.to_bits());
}

#[test]
fn parameter_cbor_matches_independent_python_ieee754_vector() {
    let vector: serde_json::Value =
        serde_json::from_str(include_str!("fixtures/resolver_params_vector.json")).unwrap();
    let params = ResolverParams::new(0.85, 0.7, 50, 1e-4).unwrap();
    assert_eq!(params.unsigned_projection(), vector["projection"]);
    let hex: String = params
        .canonical_bytes()
        .iter()
        .map(|b| format!("{b:02x}"))
        .collect();
    assert_eq!(hex, vector["canonical_cbor_hex"].as_str().unwrap());
    let expected = Digest32::blake3(b"AKG:ONTO:RESOLVER-PARAMS:v2\0", &params.canonical_bytes());
    assert_eq!(params.digest().digest(), expected);
    let zero_params = ResolverParams::new(-0.0, -0.0, 50, 1e-4).unwrap();
    assert_eq!(zero_params.unsigned_projection(), vector["zero_projection"]);
    let hex: String = zero_params
        .canonical_bytes()
        .iter()
        .map(|b| format!("{b:02x}"))
        .collect();
    assert_eq!(hex, vector["zero_canonical_cbor_hex"].as_str().unwrap());
    // v1 preserved signed zero. It is not silently reinterpreted as v2.
    let mut legacy = params.unsigned_projection();
    legacy["profile"] = serde_json::json!("resolver-params-ieee754-bits-v1");
    assert_ne!(
        params.digest().digest(),
        Digest32::blake3(
            b"AKG:ONTO:RESOLVER-PARAMS:v1\0",
            &arkhe_core::canonical::encode_value(&legacy)
        )
    );
}

#[test]
fn negative_zero_thresholds_share_parameters_records_and_preflight() {
    let expected = ResolverParams::new(0.0, 0.0, 50, 1e-4).unwrap();
    let snapshot = OntologySnapshot::new(corpus()).unwrap();
    let candidate = inv(1);
    let mut first: Option<ResolutionRecord> = None;
    for (duplicate, refinement) in [
        (0.0, 0.0),
        (-0.0, 0.0),
        (0.0, -0.0),
        (-0.0, -0.0),
        (0.85, -0.0),
    ] {
        let params = ResolverParams::new(duplicate, refinement, 50, 1e-4).unwrap();
        assert_eq!(params.refinement_threshold().to_bits(), 0.0f64.to_bits());
        if duplicate == 0.0 {
            assert_eq!(params.duplicate_threshold().to_bits(), 0.0f64.to_bits());
            assert_eq!(params, expected);
            assert_eq!(params.digest(), expected.digest());
            assert_eq!(params.canonical_bytes(), expected.canonical_bytes());
        } else {
            assert_eq!(params, ResolverParams::new(0.85, 0.0, 50, 1e-4).unwrap());
            continue;
        }
        let (mut r, log) = resolver();
        r.duplicate_threshold = duplicate;
        r.refinement_threshold = refinement;
        r.resolve_snapshot(&candidate, &snapshot).unwrap();
        let record = log.last().unwrap();
        if let Some(baseline) = &first {
            assert_eq!(record.context, baseline.context);
            assert_eq!(record.canonical_bytes(), baseline.canonical_bytes());
            assert_eq!(record.object_digest(), baseline.object_digest());
            r.verify_record_inputs(baseline, &candidate, &snapshot)
                .unwrap();
        } else {
            first = Some(record);
        }
    }
}

#[test]
fn zero_tolerance_is_invalid_regardless_of_sign() {
    for tolerance in [0.0, -0.0] {
        assert!(ResolverParams::new(0.85, 0.7, 1, tolerance).is_err());
        let (mut r, log) = resolver();
        r.em_tolerance = tolerance;
        assert!(matches!(
            r.resolve(&inv(1), &[]),
            Err(ResolverError::InvalidInput(_))
        ));
        assert_eq!(log.count(), 0);
    }
}

#[test]
fn algorithm_descriptor_matches_current_model_initialization() {
    let descriptor = AlgorithmVersion::FellegiSunterEmV1.unsigned_projection();
    let model = FellegiSunter::default_model();
    assert_eq!(
        descriptor["initial_m_bits"],
        serde_json::json!(model.m.map(f64::to_bits))
    );
    assert_eq!(
        descriptor["initial_u_bits"],
        serde_json::json!(model.u.map(f64::to_bits))
    );
    assert_eq!(
        descriptor["initial_prior_bits"],
        serde_json::json!(model.prior_match_rate.to_bits())
    );
    assert_eq!(
        descriptor["fs_attributes"],
        arkhe_governance::er_backend::FS_ATTRIBUTES
    );
    assert_ne!(
        AlgorithmVersion::FellegiSunterEmV1.digest(),
        ComparisonVersion::AsciiExactV1.digest()
    );
    assert_ne!(AlgorithmVersion::FellegiSunterEmV1.digest(), Digest32::ZERO);
}

#[test]
fn unknown_backend_versions_fail_closed_without_fabricating_metadata() {
    struct Unknown;
    impl ErBackend for Unknown {
        fn candidate_pairs(&self, _: &[Invariant]) -> Vec<(usize, usize)> {
            panic!("unversioned backend must not run")
        }
        fn comparison_vector(&self, _: &Invariant, _: &Invariant) -> ComparisonVector {
            panic!("unversioned backend must not run")
        }
    }
    let r = InvariantResolver::new(Box::new(Unknown), Box::new(NoLog));
    assert!(matches!(
        r.resolve(&inv(1), &[]),
        Err(ResolverError::InvalidInput(_))
    ));
    let (_, record, candidate, snapshot) = recorded();
    assert!(matches!(
        r.verify_record_inputs(&record, &candidate, &snapshot),
        Err(ResolverError::InvalidInput(_))
    ));
}

#[cfg(feature = "duckdb-backend")]
#[test]
fn duckdb_and_memory_produce_identical_six_bindings_and_record_bytes() {
    let (_, memory, candidate, snapshot) = recorded();
    let log = Arc::new(MockResolutionLog::new());
    let duck = InvariantResolver::new(
        Box::new(arkhe_governance::er_backend::DuckDbBackend::new()),
        Box::new(SharedLog(log.clone())),
    );
    duck.resolve_snapshot(&candidate, &snapshot).unwrap();
    let record = log.last().unwrap();
    assert_eq!(record.context, memory.context);
    assert_eq!(record.canonical_bytes(), memory.canonical_bytes());
    assert_eq!(record.object_digest(), memory.object_digest());
}
