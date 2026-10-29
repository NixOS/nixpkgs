use std::sync::Arc;

use arkhe_governance::constitution_graph::{InvariantId, Modality};
use arkhe_governance::er_backend::{InMemoryBackend, Invariant};
use arkhe_governance::invariant_resolver::{
    InvariantResolver, MockResolutionLog, ResolutionLog, ResolutionRecord, ResolutionVerdict,
};

fn id(n: u8) -> InvariantId {
    let mut a = [0u8; 32];
    a[0] = n;
    a
}

fn inv(n: u8, action: &str, condition: &str, modality: Modality, spec: u32) -> Invariant {
    Invariant {
        id: id(n),
        modality,
        action: action.into(),
        condition: condition.into(),
        specificity: spec,
        enacted_at: n as u64,
    }
}

fn resolver_with(log: Arc<MockResolutionLog>) -> InvariantResolver {
    struct ArcLog(Arc<MockResolutionLog>);
    impl ResolutionLog for ArcLog {
        fn append(&self, r: &ResolutionRecord) -> Result<[u8; 32], String> {
            self.0.append(r)
        }
    }
    InvariantResolver::new(Box::new(InMemoryBackend), Box::new(ArcLog(log)))
}

// Correlated comparison attributes provide evidence for the match component.
// The tiny fixtures in the pasted specification do not cross its thresholds.
fn evidence_corpus(spec: u32) -> Vec<Invariant> {
    let mut corpus: Vec<_> = (2..6)
        .map(|n| inv(n, "pay", "amount>1000", Modality::Obligatory, spec))
        .collect();
    corpus.extend((6..14).map(|n| inv(n, "pay", &format!("condition-{n}"), Modality::Optional, 5)));
    corpus
}

// --- Original 5 tests ---

#[test]
fn duplicate_is_detected_and_anchored() {
    let log = Arc::new(MockResolutionLog::new());
    let r = resolver_with(log.clone());
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 5);
    let existing = evidence_corpus(5);
    let v = r.resolve(&candidate, &existing).unwrap();
    assert_eq!(v, ResolutionVerdict::Duplicate { canonical: id(2) });
    assert_eq!(log.count(), 1);
    assert_eq!(log.last().unwrap().verdict_kind, "duplicate");
}

#[test]
fn candidate_refines_existing_when_more_specific() {
    let log = Arc::new(MockResolutionLog::new());
    let r = resolver_with(log.clone());
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 10);
    let existing = evidence_corpus(5);
    let v = r.resolve(&candidate, &existing).unwrap();
    assert_eq!(v, ResolutionVerdict::CandidateRefines { parent: id(2) });
    assert_eq!(log.last().unwrap().verdict_kind, "candidate_refines");
}

#[test]
fn existing_refines_candidate_when_less_specific() {
    let log = Arc::new(MockResolutionLog::new());
    let r = resolver_with(log.clone());
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 3);
    let existing = evidence_corpus(8);
    let v = r.resolve(&candidate, &existing).unwrap();
    assert_eq!(v, ResolutionVerdict::ExistingRefines { child: id(2) });
    assert_eq!(log.last().unwrap().verdict_kind, "existing_refines");
}

#[test]
fn opposite_modality_is_conflict() {
    let log = Arc::new(MockResolutionLog::new());
    let r = resolver_with(log.clone());
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 5);
    let existing = vec![
        inv(2, "pay", "amount>1000", Modality::Impermissible, 5),
        inv(3, "pay", "amount<500", Modality::Obligatory, 5),
    ];
    let v = r.resolve(&candidate, &existing).unwrap();
    match v {
        ResolutionVerdict::Conflict { existing, .. } => assert_eq!(existing, id(2)),
        other => panic!("expected Conflict, got {other:?}"),
    }
    assert_eq!(log.last().unwrap().verdict_kind, "conflict");
}

#[test]
fn different_action_is_novel() {
    let log = Arc::new(MockResolutionLog::new());
    let r = resolver_with(log.clone());
    let candidate = inv(1, "refund", "amount>1000", Modality::Obligatory, 5);
    let existing = vec![
        inv(2, "pay", "amount>1000", Modality::Obligatory, 5),
        inv(3, "pay", "amount<500", Modality::Obligatory, 5),
        inv(4, "pay", "amount<500", Modality::Impermissible, 5),
    ];
    let v = r.resolve(&candidate, &existing).unwrap();
    assert_eq!(v, ResolutionVerdict::Novel);
    assert_eq!(log.last().unwrap().verdict_kind, "novel");
}

// --- New tests (iterations 4–9) ---

#[test]
fn optional_impermissible_is_conflict() {
    let log = Arc::new(MockResolutionLog::new());
    let r = resolver_with(log.clone());
    let candidate = inv(1, "pay", "amount>1000", Modality::Optional, 5);
    let existing = vec![inv(2, "pay", "amount>1000", Modality::Impermissible, 5)];
    let v = r.resolve(&candidate, &existing).unwrap();
    match v {
        ResolutionVerdict::Conflict { existing, .. } => assert_eq!(existing, id(2)),
        other => panic!("expected Conflict, got {other:?}"),
    }
}

#[test]
fn different_action_same_condition_modality_not_duplicate_with_variance() {
    let log = Arc::new(MockResolutionLog::new());
    let r = resolver_with(log.clone());
    let candidate = inv(1, "refund", "amount>1000", Modality::Obligatory, 5);
    // "pay" group has variance: inv(4) differs in condition and modality.
    let existing = vec![
        inv(2, "pay", "amount>1000", Modality::Obligatory, 5),
        inv(3, "pay", "amount>1000", Modality::Obligatory, 7),
        inv(4, "pay", "amount<500", Modality::Optional, 5),
    ];
    let v = r.resolve(&candidate, &existing).unwrap();
    assert_eq!(
        v,
        ResolutionVerdict::Novel,
        "different action must be Novel regardless of condition/modality"
    );
}

#[test]
fn cold_start_single_existing_same_action_is_novel() {
    let log = Arc::new(MockResolutionLog::new());
    let r = resolver_with(log.clone());
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 5);
    let existing = vec![inv(2, "pay", "amount>1000", Modality::Obligatory, 5)];
    let v = r.resolve(&candidate, &existing).unwrap();
    assert_eq!(v, ResolutionVerdict::Novel);
    assert_eq!(log.last().unwrap().verdict_kind, "novel_cold_start");
    assert_eq!(log.count(), 1);
}

#[test]
fn conflict_detected_even_with_single_existing_same_action() {
    let log = Arc::new(MockResolutionLog::new());
    let r = resolver_with(log.clone());
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 5);
    let existing = vec![inv(2, "pay", "amount>1000", Modality::Impermissible, 5)];
    let v = r.resolve(&candidate, &existing).unwrap();
    match v {
        ResolutionVerdict::Conflict { existing, .. } => assert_eq!(existing, id(2)),
        other => panic!("expected Conflict, got {other:?}"),
    }
    assert_eq!(log.last().unwrap().verdict_kind, "conflict");
    assert_eq!(log.count(), 1); // no cold-start record
}

#[test]
fn specification_small_corpora_do_not_prove_a_match() {
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 5);
    let fixtures = [
        vec![
            inv(2, "pay", "amount>1000", Modality::Obligatory, 5),
            inv(3, "pay", "amount<500", Modality::Obligatory, 5),
            inv(4, "pay", "amount<500", Modality::Impermissible, 5),
            inv(5, "pay", "amount>1000", Modality::Optional, 5),
        ],
        vec![
            inv(2, "pay", "amount>1000", Modality::Obligatory, 5),
            inv(3, "pay", "amount<500", Modality::Obligatory, 5),
            inv(4, "pay", "amount<500", Modality::Impermissible, 5),
        ],
        vec![
            inv(2, "pay", "amount>1000", Modality::Obligatory, 8),
            inv(3, "pay", "amount<500", Modality::Obligatory, 5),
        ],
    ];
    for corpus in fixtures {
        let log = Arc::new(MockResolutionLog::new());
        assert_eq!(
            resolver_with(log.clone())
                .resolve(&candidate, &corpus)
                .unwrap(),
            ResolutionVerdict::Novel
        );
        assert!(log.last().unwrap().match_probability < 0.70);
    }
}

#[test]
fn all_weak_permission_combinations() {
    use Modality::*;
    for a in [Obligatory, Optional, Impermissible] {
        for b in [Obligatory, Optional, Impermissible] {
            let log = Arc::new(MockResolutionLog::new());
            let verdict = resolver_with(log.clone())
                .resolve(&inv(1, "PAY", "C", a, 5), &[inv(2, "pay", "c", b, 5)])
                .unwrap();
            let conflict = (a == Impermissible) != (b == Impermissible);
            assert_eq!(
                matches!(verdict, ResolutionVerdict::Conflict { .. }),
                conflict
            );
            assert_eq!(log.count(), 1);
            if !conflict {
                assert_eq!(log.last().unwrap().verdict_kind, "novel_cold_start");
            }
        }
    }
}

#[test]
fn cold_start_does_not_score_even_at_zero_thresholds() {
    let log = Arc::new(MockResolutionLog::new());
    let mut resolver = resolver_with(log.clone());
    resolver.duplicate_threshold = 0.0;
    resolver.refinement_threshold = 0.0;
    assert_eq!(
        resolver
            .resolve(
                &inv(1, "pay", "c", Modality::Optional, 5),
                &[inv(2, "pay", "c", Modality::Optional, 5)]
            )
            .unwrap(),
        ResolutionVerdict::Novel
    );
    let record = log.last().unwrap();
    assert_eq!(record.verdict_kind, "novel_cold_start");
    assert_eq!(record.existing_id, Some(id(2)));
}

#[test]
fn cold_start_and_conflict_never_invoke_comparisons() {
    use arkhe_governance::er_backend::{ComparisonVector, ErBackend};
    struct NoScoring;
    impl ErBackend for NoScoring {
        fn comparison_version(
            &self,
        ) -> Option<arkhe_governance::resolution_binding::ComparisonVersion> {
            InMemoryBackend.comparison_version()
        }
        fn candidate_pairs(&self, corpus: &[Invariant]) -> Vec<(usize, usize)> {
            assert_eq!(corpus.len(), 1);
            Vec::new()
        }
        fn comparison_vector(&self, _: &Invariant, _: &Invariant) -> ComparisonVector {
            panic!("comparison/scoring must not run without training evidence")
        }
    }
    for modality in [Modality::Obligatory, Modality::Impermissible] {
        let log = Arc::new(MockResolutionLog::new());
        struct Shared(Arc<MockResolutionLog>);
        impl ResolutionLog for Shared {
            fn append(&self, record: &ResolutionRecord) -> Result<[u8; 32], String> {
                self.0.append(record)
            }
        }
        let mut resolver =
            InvariantResolver::new(Box::new(NoScoring), Box::new(Shared(log.clone())));
        resolver.duplicate_threshold = 0.0;
        resolver.refinement_threshold = 0.0;
        let result = resolver
            .resolve(
                &inv(1, "pay", "c", Modality::Obligatory, 5),
                &[inv(2, "pay", "c", modality, 5)],
            )
            .unwrap();
        if modality == Modality::Impermissible {
            assert!(matches!(result, ResolutionVerdict::Conflict { .. }));
            assert_eq!(log.last().unwrap().verdict_kind, "conflict");
        } else {
            assert_eq!(result, ResolutionVerdict::Novel);
            assert_eq!(log.last().unwrap().verdict_kind, "novel_cold_start");
        }
        assert_eq!(log.count(), 1);
    }
}

#[test]
fn candidate_and_other_actions_never_enter_training() {
    use arkhe_governance::er_backend::{ComparisonVector, ErBackend};
    struct Guard;
    impl ErBackend for Guard {
        fn comparison_version(
            &self,
        ) -> Option<arkhe_governance::resolution_binding::ComparisonVersion> {
            InMemoryBackend.comparison_version()
        }
        fn candidate_pairs(&self, corpus: &[Invariant]) -> Vec<(usize, usize)> {
            assert_eq!(corpus.len(), 2);
            assert!(corpus.iter().all(|v| v.id != id(1) && v.action == "pay"));
            InMemoryBackend.candidate_pairs(corpus)
        }
        fn comparison_vector(&self, a: &Invariant, b: &Invariant) -> ComparisonVector {
            InMemoryBackend.comparison_vector(a, b)
        }
    }
    let resolver = InvariantResolver::new(Box::new(Guard), Box::new(MockResolutionLog::new()));
    let candidate = inv(1, "pay", "c", Modality::Optional, 5);
    resolver
        .resolve(
            &candidate,
            &[
                candidate.clone(),
                inv(2, "pay", "c", Modality::Optional, 5),
                inv(3, "pay", "d", Modality::Optional, 5),
                inv(4, "refund", "c", Modality::Optional, 5),
            ],
        )
        .unwrap();
}

#[test]
fn blocking_cache_survives_reorder_and_invalidates_on_membership_change() {
    use arkhe_governance::er_backend::{ComparisonVector, ErBackend};
    use std::sync::atomic::{AtomicUsize, Ordering};
    struct Counting(Arc<AtomicUsize>);
    impl ErBackend for Counting {
        fn comparison_version(
            &self,
        ) -> Option<arkhe_governance::resolution_binding::ComparisonVersion> {
            InMemoryBackend.comparison_version()
        }
        fn candidate_pairs(&self, corpus: &[Invariant]) -> Vec<(usize, usize)> {
            self.0.fetch_add(1, Ordering::SeqCst);
            InMemoryBackend.candidate_pairs(corpus)
        }
        fn comparison_vector(&self, a: &Invariant, b: &Invariant) -> ComparisonVector {
            InMemoryBackend.comparison_vector(a, b)
        }
    }
    let count = Arc::new(AtomicUsize::new(0));
    let resolver = InvariantResolver::new(
        Box::new(Counting(count.clone())),
        Box::new(MockResolutionLog::new()),
    );
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 5);
    let mut corpus = evidence_corpus(5);
    let first = resolver.resolve(&candidate, &corpus).unwrap();
    corpus.reverse();
    assert_eq!(resolver.resolve(&candidate, &corpus).unwrap(), first);
    assert_eq!(count.load(Ordering::SeqCst), 1);
    corpus.pop();
    resolver.resolve(&candidate, &corpus).unwrap();
    assert_eq!(count.load(Ordering::SeqCst), 2);
    corpus[0].action = "refund".into();
    resolver.resolve(&candidate, &corpus).unwrap();
    assert_eq!(count.load(Ordering::SeqCst), 3);
}

#[test]
fn log_failures_hide_every_computed_verdict_and_keep_record_digest() {
    use arkhe_governance::invariant_resolver::ResolverError;
    struct Failing;
    impl ResolutionLog for Failing {
        fn append(&self, _: &ResolutionRecord) -> Result<[u8; 32], String> {
            Err("disk unavailable".into())
        }
    }
    let mut corpus = evidence_corpus(5);
    for spec in [3, 5, 10] {
        let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, spec);
        check(&candidate, &corpus);
    }
    corpus = vec![inv(2, "pay", "amount>1000", Modality::Impermissible, 5)];
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 5);
    check(&candidate, &corpus);
    check(&candidate, &[]);
    check(&candidate, &[candidate_with_id(2)]);
    fn candidate_with_id(n: u8) -> Invariant {
        inv(n, "pay", "amount>1000", Modality::Obligatory, 5)
    }
    fn check(candidate: &Invariant, corpus: &[Invariant]) {
        let log = Arc::new(MockResolutionLog::new());
        resolver_with(log.clone())
            .resolve(candidate, corpus)
            .unwrap();
        let expected = log.append(&log.last().unwrap()).unwrap();
        let resolver = InvariantResolver::new(Box::new(InMemoryBackend), Box::new(Failing));
        match resolver.resolve(candidate, corpus).unwrap_err() {
            ResolverError::LogFailure {
                verdict,
                reason,
                partial_digest,
                context,
            } => {
                assert_eq!(reason, "disk unavailable");
                assert_eq!(partial_digest, expected);
                assert_eq!(*context, log.last().unwrap().context);
                let debug = format!("{verdict:?}");
                assert!(!debug.contains("canonical"));
                assert!(!debug.contains("Conflict"));
            }
            other => panic!("unexpected {other:?}"),
        }
    }
}

#[test]
fn invalid_parameters_and_repeated_ids_fail_before_logging() {
    let log = Arc::new(MockResolutionLog::new());
    let mut resolver = resolver_with(log.clone());
    let candidate = inv(1, "pay", "c", Modality::Optional, 5);
    resolver.max_em_iterations = 0;
    assert!(resolver.resolve(&candidate, &[]).is_err());
    resolver.max_em_iterations = 50;
    resolver.duplicate_threshold = f64::NAN;
    assert!(resolver.resolve(&candidate, &[]).is_err());
    resolver.duplicate_threshold = 0.85;
    assert!(resolver
        .resolve(&candidate, &[candidate.clone(), candidate.clone()])
        .is_err());
    assert_eq!(log.count(), 0);
}

#[test]
fn no_cross_action_matches_even_for_homogeneous_corpus() {
    let log = Arc::new(MockResolutionLog::new());
    let mut resolver = resolver_with(log);
    resolver.duplicate_threshold = 0.0;
    resolver.refinement_threshold = 0.0;
    assert_eq!(
        resolver
            .resolve(
                &inv(1, "refund", "c", Modality::Optional, 5),
                &[
                    inv(2, "pay", "c", Modality::Optional, 5),
                    inv(3, "pay", "c", Modality::Optional, 5)
                ]
            )
            .unwrap(),
        ResolutionVerdict::Novel
    );
}

#[cfg(feature = "duckdb-backend")]
#[test]
fn duckdb_backend_parity_and_concurrent_use() {
    use arkhe_governance::er_backend::{DuckDbBackend, ErBackend};
    let backend = Arc::new(DuckDbBackend::new());
    let mut corpus = evidence_corpus(5);
    corpus.push(inv(20, "PAY", "amount>1000", Modality::Obligatory, 5));
    corpus.push(inv(21, "refund", "c", Modality::Optional, 5));
    let expected = InMemoryBackend.candidate_pairs(&corpus);
    std::thread::scope(|scope| {
        for _ in 0..3 {
            scope.spawn(|| {
                assert_eq!(backend.candidate_pairs(&corpus), expected);
            });
        }
    });
    for &(i, j) in &expected {
        assert_eq!(
            backend.comparison_vector(&corpus[i], &corpus[j]),
            InMemoryBackend.comparison_vector(&corpus[i], &corpus[j])
        );
    }
    assert!(backend.candidate_pairs(&[]).is_empty());
    let log = Arc::new(MockResolutionLog::new());
    let candidate = inv(1, "pay", "amount>1000", Modality::Obligatory, 5);
    let expected = resolver_with(log).resolve(&candidate, &corpus).unwrap();
    let resolver = InvariantResolver::new(
        Box::new(DuckDbBackend::new()),
        Box::new(MockResolutionLog::new()),
    );
    assert_eq!(resolver.resolve(&candidate, &corpus).unwrap(), expected);
}

#[test]
fn refinement_band_does_not_duplicate_equal_specificity() {
    let log = Arc::new(MockResolutionLog::new());
    let mut resolver = resolver_with(log.clone());
    resolver.duplicate_threshold = 1.0;
    let corpus = evidence_corpus(5);
    for (spec, expected) in [
        (3, ResolutionVerdict::ExistingRefines { child: id(2) }),
        (5, ResolutionVerdict::Novel),
        (10, ResolutionVerdict::CandidateRefines { parent: id(2) }),
    ] {
        assert_eq!(
            resolver
                .resolve(
                    &inv(1, "pay", "amount>1000", Modality::Obligatory, spec),
                    &corpus
                )
                .unwrap(),
            expected
        );
        let p = log.last().unwrap().match_probability;
        assert!((0.70..1.0).contains(&p));
    }
}

#[test]
fn multiple_conflicts_report_one_stable_witness_without_semantic_priority() {
    let candidate = inv(1, "pay", "c", Modality::Obligatory, 5);
    // Larger ID has greater specificity and a later enactment, neither of which
    // governs selection of the conflict witness in the current contract.
    let mut corpus = vec![
        inv(9, "PAY", "C", Modality::Impermissible, 100),
        inv(2, "pay", "c", Modality::Impermissible, 1),
    ];
    let log = Arc::new(MockResolutionLog::new());
    let resolver = resolver_with(log.clone());
    let first = resolver.resolve(&candidate, &corpus).unwrap();
    assert!(matches!(first, ResolutionVerdict::Conflict { existing, .. } if existing == id(2)));
    let record = log.last().unwrap();
    assert_eq!(record.existing_id, Some(id(2)));
    assert_eq!(record.verdict_kind, "conflict");
    assert_eq!(log.count(), 1);
    corpus.reverse();
    assert_eq!(resolver.resolve(&candidate, &corpus).unwrap(), first);
    assert_eq!(log.last().unwrap().existing_id, Some(id(2)));
    assert_eq!(log.count(), 2);
}
