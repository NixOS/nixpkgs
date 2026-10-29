use arkhe_rag::citation::{
    extract_entities, keyword_overlap, CitationError, CitationVerifier, Claim, EntityKind,
    Evidence, OverlapVerifier,
};

#[test]
fn sydney_not_melbourne() {
    let evidence = [Evidence {
        id: "e1",
        text: "Melbourne is the capital of Australia.",
    }];
    let claims = [Claim {
        text: "Sydney is the capital",
        evidence_id: "e1",
    }];
    let v = OverlapVerifier::default();
    match v.verify(&claims, &evidence) {
        Err(CitationError::EntityNotInEvidence { entity, .. }) => assert_eq!(entity, "Sydney"),
        other => panic!("expected EntityNotInEvidence, got {other:?}"),
    }
}

#[test]
fn generic_claim_without_entity_passes() {
    let evidence = [Evidence {
        id: "e1",
        text: "The capital city is large and populated.",
    }];
    let claims = [Claim {
        text: "the capital city is large",
        evidence_id: "e1",
    }];
    let v = OverlapVerifier {
        min_keyword_overlap: 0.5,
    };
    assert!(v.verify(&claims, &evidence).is_ok());
}

#[test]
fn numeral_mismatch_is_rejected() {
    let evidence = [Evidence {
        id: "e1",
        text: "The treaty was signed in 1957.",
    }];
    let claims = [Claim {
        text: "The treaty was signed in 1956",
        evidence_id: "e1",
    }];
    let v = OverlapVerifier::default();
    match v.verify(&claims, &evidence) {
        Err(CitationError::EntityNotInEvidence { entity, .. }) => assert_eq!(entity, "1956"),
        other => panic!("expected EntityNotInEvidence, got {other:?}"),
    }
}

#[test]
fn entity_present_in_evidence_passes() {
    let evidence = [Evidence {
        id: "e1",
        text: "Sydney is the capital of New South Wales.",
    }];
    let claims = [Claim {
        text: "Sydney is a city in New South Wales",
        evidence_id: "e1",
    }];
    let v = OverlapVerifier::default();
    assert!(v.verify(&claims, &evidence).is_ok());
}

#[test]
fn unknown_evidence_id_is_rejected() {
    let evidence = [Evidence {
        id: "e1",
        text: "anything",
    }];
    let claims = [Claim {
        text: "anything",
        evidence_id: "e2",
    }];
    let v = OverlapVerifier::default();
    assert!(matches!(
        v.verify(&claims, &evidence),
        Err(CitationError::UnknownEvidence(id)) if id == "e2"
    ));
}

#[test]
fn extract_entities_classifies_kinds() {
    let ents = extract_entities("Sydney signed the 1956 treaty with NASA");
    let kinds: Vec<_> = ents.iter().map(|e| (e.kind, e.text.as_str())).collect();
    assert!(kinds.contains(&(EntityKind::ProperNoun, "Sydney")));
    assert!(kinds.contains(&(EntityKind::Numeral, "1956")));
    assert!(kinds.contains(&(EntityKind::Acronym, "NASA")));
}

#[test]
fn keyword_overlap_is_jaccard() {
    // "alpha beta" vs "alpha beta" → 1.0
    assert!((keyword_overlap("alpha beta", "alpha beta") - 1.0).abs() < 1e-9);
    // "alpha beta" vs "alpha gamma" → 1/3
    assert!((keyword_overlap("alpha beta", "alpha gamma") - 1.0 / 3.0).abs() < 1e-9);
    // stopwords only → 0.0
    assert_eq!(keyword_overlap("the a an", "the a an"), 0.0);
}

// ---- Seeded corruption: every mutated entity is rejected ----

struct SplitMix64(u64);

impl SplitMix64 {
    fn new(seed: u64) -> Self {
        Self(seed)
    }
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9E3779B97F4A7C15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xBF58476D1CE4E5B9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94D049BB133111EB);
        z ^ (z >> 31)
    }
    fn byte(&mut self) -> u8 {
        (self.next() & 0xff) as u8
    }
}

#[test]
fn corrupted_entities_are_always_rejected() {
    let evidence = [Evidence {
        id: "e1",
        text: "Sydney is the capital of Australia.",
    }];
    let v = OverlapVerifier::default();
    let mut rng = SplitMix64::new(42);
    let original: Vec<char> = "Sydney".chars().collect();
    for _ in 0..256 {
        let pos = (rng.next() as usize) % original.len();
        let orig = original[pos];
        let mut repl = orig;
        while repl == orig {
            repl = (b'a' + (rng.byte() % 26)) as char;
        }
        let mut mutated = original.clone();
        mutated[pos] = repl;
        let claim_text: String = mutated.into_iter().collect();
        let claims = [Claim {
            text: &claim_text,
            evidence_id: "e1",
        }];
        assert!(
            v.verify(&claims, &evidence).is_err(),
            "mutation at {pos} to {repl:?} produced {claim_text:?}, which should be rejected",
        );
    }
}

/// Documented limitation of the exact-entity layer: extraction requires an
/// uppercase first letter, so a fully lower-cased claim escapes entity
/// verification and is judged by keyword overlap alone — which is
/// case-insensitive, so "sydney is the capital" is still supported by a
/// chunk that says "Sydney is the capital of Australia". The tokenizer
/// swap the exact layer exists for ("Sydney" → "sydney" → chunk "Sydney")
/// is a *match* here, not a miss: lowercasing an entity that IS in the
/// chunk must not be rejected. The uncovered case is a lowercased entity
/// that is NOT in the chunk while its keywords overlap — the overlap floor
/// is the only guard there.
#[test]
fn lowercased_entity_is_matched_by_overlap_not_by_the_exact_layer() {
    let evidence = [Evidence {
        id: "e1",
        text: "Sydney is the capital of Australia.",
    }];
    // "sydney" (lowercase) is not an extracted entity; overlap carries it.
    let supported = [Claim {
        text: "sydney is the capital",
        evidence_id: "e1",
    }];
    let v = OverlapVerifier::default();
    assert!(v.verify(&supported, &evidence).is_ok());
    // But a lowercased *wrong* city still fails the overlap floor.
    let wrong = [Claim {
        text: "melbourne is the capital",
        evidence_id: "e1",
    }];
    assert!(v.verify(&wrong, &evidence).is_err());
}
