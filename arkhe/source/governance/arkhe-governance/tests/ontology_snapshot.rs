use std::sync::{Arc, Mutex};

use arkhe_core::{CanonicalEncode, Digest32};
use arkhe_governance::{
    constitution_graph::Modality,
    er_backend::{InMemoryBackend, Invariant},
    invariant_resolver::{InvariantResolver, ResolutionLog, ResolutionRecord},
    ontology_snapshot::{OntologySnapshot, OntologyVersion, SnapshotError},
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

#[test]
fn permutation_preserves_snapshot_identity_and_canonical_corpus() {
    let candidate = inv(1);
    let mut other_action = inv(4);
    other_action.action = "refund".into();
    let mut upper = inv(3);
    upper.action = "PAY".into();
    let content = vec![upper, candidate.clone(), other_action, inv(2)];
    let first = OntologySnapshot::new(content.clone()).unwrap();
    let second = OntologySnapshot::new(content.into_iter().rev().collect()).unwrap();
    assert_eq!(first.version(), second.version());
    assert_eq!(first.canonical_bytes(), second.canonical_bytes());
    assert_eq!(first.version().digest(), first.object_digest());
    let corpus = first.training_corpus(&candidate);
    assert_eq!(
        corpus.iter().map(|v| v.id).collect::<Vec<_>>(),
        vec![inv(2).id, inv(3).id]
    );
    assert_eq!(
        first.corpus_digest(&candidate),
        second.corpus_digest(&candidate)
    );
}

#[test]
fn every_stored_invariant_field_is_bound_to_both_digests() {
    let base = inv(2);
    let candidate = inv(1);
    let baseline = OntologySnapshot::new(vec![base.clone()]).unwrap();
    let baseline_candidate = base.object_digest();
    for field in 0..7 {
        let mut changed = base.clone();
        match field {
            0 => changed.id[1] = 99,
            1 => changed.modality = Modality::Optional,
            2 => changed.action = "PAY".into(),
            3 => changed.condition = "C".into(),
            4 => changed.specificity += 1,
            5 => changed.enacted_at += 1,
            6 => changed.modality = Modality::Impermissible,
            _ => unreachable!(),
        }
        assert_ne!(changed.object_digest(), baseline_candidate, "field {field}");
        let snapshot = OntologySnapshot::new(vec![changed]).unwrap();
        assert_ne!(snapshot.version(), baseline.version(), "field {field}");
        assert_ne!(
            snapshot.corpus_digest(&candidate),
            baseline.corpus_digest(&candidate),
            "field {field}"
        );
    }
}

#[test]
fn duplicate_identity_is_rejected_even_for_identical_records() {
    for condition in ["c", "changed"] {
        let first = inv(2);
        let mut second = first.clone();
        second.condition = condition.into();
        assert_eq!(
            OntologySnapshot::new(vec![first.clone(), second]).unwrap_err(),
            SnapshotError::DuplicateId(first.id)
        );
    }
}

#[test]
fn verified_loading_rejects_tampering_and_accepts_reordered_content() {
    let original = OntologySnapshot::new(vec![inv(2), inv(3)]).unwrap();
    let version = original.version();
    let loaded = OntologySnapshot::from_verified_invariants(vec![inv(3), inv(2)], version).unwrap();
    assert_eq!(loaded.version(), version);
    let mut changed = inv(2);
    changed.condition = "tampered".into();
    assert!(matches!(
        OntologySnapshot::from_verified_invariants(vec![changed, inv(3)], version),
        Err(SnapshotError::VersionMismatch { expected, actual }) if expected == version && actual != version
    ));
    assert!(OntologySnapshot::from_verified_invariants(
        vec![inv(2), inv(3)],
        OntologyVersion::from_bytes([0; 32])
    )
    .is_err());
}

#[test]
fn snapshot_owns_its_content_and_canonicalization_preserves_text() {
    let mut source = vec![inv(2)];
    let snapshot = OntologySnapshot::new(source.clone()).unwrap();
    let before = snapshot.canonical_bytes();
    source[0].condition = "mutated".into();
    source.clear();
    assert_eq!(snapshot.canonical_bytes(), before);
    assert_eq!(snapshot.invariants()[0].condition, "c");
    let mut composed = inv(2);
    composed.condition = "é".into();
    let mut decomposed = composed.clone();
    decomposed.condition = "e\u{301}".into();
    assert_ne!(composed.object_digest(), decomposed.object_digest());
}

#[test]
fn corpus_digest_binds_selected_content_not_candidate_scoring_fields() {
    let candidate = inv(1);
    let first = OntologySnapshot::new(vec![candidate.clone(), inv(2)]).unwrap();
    let mut unrelated = inv(3);
    unrelated.action = "refund".into();
    let second = OntologySnapshot::new(vec![candidate.clone(), inv(2), unrelated]).unwrap();
    assert_ne!(first.version(), second.version());
    assert_eq!(
        first.corpus_digest(&candidate),
        second.corpus_digest(&candidate)
    );
    let mut changed_candidate = candidate.clone();
    changed_candidate.specificity = 100;
    assert_ne!(candidate.object_digest(), changed_candidate.object_digest());
    assert_eq!(
        first.corpus_digest(&candidate),
        first.corpus_digest(&changed_candidate)
    );
    changed_candidate.action = "refund".into();
    assert_ne!(
        first.corpus_digest(&candidate),
        first.corpus_digest(&changed_candidate)
    );
    assert_ne!(first.version().digest(), first.corpus_digest(&candidate));
}

#[test]
fn independent_cbor_vectors_fix_profile_text_byte_ids_and_integer_widths() {
    let vectors: serde_json::Value =
        serde_json::from_str(include_str!("fixtures/ontology_snapshot_vectors.json")).unwrap();
    let mut boundary = inv(7);
    boundary.action = "Pagar".into();
    boundary.condition = "valor>á".into();
    boundary.specificity = u32::MAX;
    boundary.enacted_at = u64::MAX;
    for (i, content) in [vec![], vec![boundary]].into_iter().enumerate() {
        let snapshot = OntologySnapshot::new(content).unwrap();
        let expected = vectors[i]["canonical_cbor_hex"].as_str().unwrap();
        let actual: String = snapshot
            .canonical_bytes()
            .iter()
            .map(|b| format!("{b:02x}"))
            .collect();
        assert_eq!(actual, expected);
        // Independently verify domain + canonical bytes composition.
        let mut h = blake3::Hasher::new();
        h.update(b"AKG:ONTO:INVARIANT-SNAPSHOT:v1\0");
        h.update(&snapshot.canonical_bytes());
        assert_eq!(
            snapshot.version().digest(),
            Digest32(*h.finalize().as_bytes())
        );
    }
}

struct CapturingLog(Arc<Mutex<Vec<ResolutionRecord>>>);

impl ResolutionLog for CapturingLog {
    fn append(&self, record: &ResolutionRecord) -> Result<[u8; 32], String> {
        self.0.lock().unwrap().push(record.clone());
        Ok([0; 32])
    }
}

#[test]
fn snapshot_adapter_preserves_scoring_and_records_under_permutation() {
    let mut corpus: Vec<_> = (2..6).map(inv).collect();
    corpus.extend((6..14).map(|n| {
        let mut value = inv(n);
        value.condition = format!("c-{n}");
        value.modality = Modality::Optional;
        value
    }));
    let snapshot = OntologySnapshot::new(corpus.clone()).unwrap();
    let records = Arc::new(Mutex::new(Vec::new()));
    let resolver = InvariantResolver::new(
        Box::new(InMemoryBackend),
        Box::new(CapturingLog(records.clone())),
    );
    let candidate = inv(1);
    let verdict = resolver.resolve_snapshot(&candidate, &snapshot).unwrap();
    corpus.reverse();
    // A fresh resolver rules out a warm cache hiding a training-order issue.
    let fresh_resolver = InvariantResolver::new(
        Box::new(InMemoryBackend),
        Box::new(CapturingLog(records.clone())),
    );
    assert_eq!(
        fresh_resolver.resolve(&candidate, &corpus).unwrap(),
        verdict
    );
    let records = records.lock().unwrap();
    assert_eq!(records.len(), 2);
    assert_eq!(
        records[0].match_probability.to_bits(),
        records[1].match_probability.to_bits()
    );
    assert_eq!(records[0].existing_id, records[1].existing_id);
    assert_eq!(records[0].verdict_kind, records[1].verdict_kind);
}
