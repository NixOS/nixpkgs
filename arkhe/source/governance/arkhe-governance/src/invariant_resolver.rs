//! AKG-ONTO-0003 — Invariant resolver.
//!
//! Both entry points use a validated immutable snapshot. Validate parameters
//! and backend version, bind the six audit inputs, and select `same_action`
//! without the candidate ID in canonical order. Detect weak-permission conflict
//! before cold start. Empty comparison/training sets return Novel before EM.
//! Otherwise fit EM and score only same-action existing invariants.
//!
//! Logging: `partial_digest` is computed **before** `append`; the error
//! `LogFailure` carries an opaque `ComputedVerdict` (no access to the
//! inner verdict) to preserve fail-closed semantics.

use crate::ontology_snapshot::OntologySnapshot;
use crate::resolution_binding::{BindingMismatch, ResolutionContext, ResolverParams};
use arkhe_core::{canonical::encode_map_with_bytes, CanonicalEncode};
use std::collections::HashMap;
use std::sync::Mutex;

use crate::constitution_graph::{InvariantId, Modality};
use crate::er_backend::{ComparisonVector, ErBackend, Invariant};
use crate::fellegi_sunter::FellegiSunter;

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum ResolutionVerdict {
    Duplicate {
        canonical: InvariantId,
    },
    CandidateRefines {
        parent: InvariantId,
    },
    ExistingRefines {
        child: InvariantId,
    },
    /// One conflicting existing invariant, chosen by lowest ID for stability.
    /// This is an arbitrary witness, not semantic priority or an exhaustive list.
    Conflict {
        existing: InvariantId,
        reason: String,
    },
    Novel,
}

/// Opaque wrapper: `LogFailure` exposes only a diagnostic digest, never the
/// inner `ResolutionVerdict`. Debug also hides it. This prevents accidental
/// application of an unlogged decision; the diagnostic tag is not a secret.
///
/// ```compile_fail
/// use arkhe_governance::invariant_resolver::ComputedVerdict;
/// fn unwrap(v: ComputedVerdict) { let _ = v.0; }
/// ```
pub struct ComputedVerdict(ResolutionVerdict);

impl std::fmt::Debug for ComputedVerdict {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("ComputedVerdict")
            .field("diagnostic_digest", &self.diagnostic_digest())
            .finish_non_exhaustive()
    }
}

impl ComputedVerdict {
    pub fn diagnostic_digest(&self) -> [u8; 32] {
        let mut h = blake3::Hasher::new();
        h.update(b"AKG:VERDICT:DIAG:v1\0");
        let tag: u8 = match &self.0 {
            ResolutionVerdict::Duplicate { .. } => 0,
            ResolutionVerdict::CandidateRefines { .. } => 1,
            ResolutionVerdict::ExistingRefines { .. } => 2,
            ResolutionVerdict::Conflict { .. } => 3,
            ResolutionVerdict::Novel => 4,
        };
        h.update(&[tag]);
        *h.finalize().as_bytes()
    }
}

#[derive(Debug)]
pub enum ResolverError {
    InvalidInput(String),
    BindingMismatch(BindingMismatch),
    LogFailure {
        verdict: ComputedVerdict,
        reason: String,
        partial_digest: [u8; 32],
        context: Box<ResolutionContext>,
    },
}

#[derive(Debug, Clone)]
pub struct ResolutionRecord {
    pub context: ResolutionContext,
    pub candidate_id: InvariantId,
    pub existing_id: Option<InvariantId>,
    pub verdict_kind: &'static str,
    /// Model posterior for scored records. Zero is a sentinel for no evidence
    /// in `novel_cold_start` / no-comparable `novel`; conflict uses 1.0 as a
    /// deterministic marker, not a calibrated probability.
    pub match_probability: f64,
}

pub trait ResolutionLog: Send + Sync {
    fn append(&self, record: &ResolutionRecord) -> Result<[u8; 32], String>;
}

pub struct MockResolutionLog {
    records: Mutex<Vec<ResolutionRecord>>,
}

impl MockResolutionLog {
    pub fn new() -> Self {
        Self {
            records: Mutex::new(Vec::new()),
        }
    }
    pub fn count(&self) -> usize {
        self.records.lock().unwrap().len()
    }
    pub fn last(&self) -> Option<ResolutionRecord> {
        self.records.lock().unwrap().last().cloned()
    }
}

impl Default for MockResolutionLog {
    fn default() -> Self {
        Self::new()
    }
}

impl ResolutionLog for MockResolutionLog {
    fn append(&self, record: &ResolutionRecord) -> Result<[u8; 32], String> {
        let digest = compute_digest(record);
        self.records.lock().unwrap().push(record.clone());
        Ok(digest)
    }
}

pub struct InvariantResolver {
    pub backend: Box<dyn ErBackend>,
    pub duplicate_threshold: f64,
    pub refinement_threshold: f64,
    pub max_em_iterations: usize,
    pub em_tolerance: f64,
    pub log: Box<dyn ResolutionLog>,
    model_cache: Mutex<Option<([u8; 32], FellegiSunter)>>,
    blocking_cache: Mutex<HashMap<String, Vec<(InvariantId, InvariantId)>>>,
}

impl InvariantResolver {
    pub fn new(backend: Box<dyn ErBackend>, log: Box<dyn ResolutionLog>) -> Self {
        Self {
            backend,
            duplicate_threshold: 0.85,
            refinement_threshold: 0.70,
            max_em_iterations: 50,
            em_tolerance: 1e-4,
            log,
            model_cache: Mutex::new(None),
            blocking_cache: Mutex::new(HashMap::new()),
        }
    }

    pub fn params(&self) -> Result<ResolverParams, ResolverError> {
        ResolverParams::new(
            self.duplicate_threshold,
            self.refinement_threshold,
            self.max_em_iterations,
            self.em_tolerance,
        )
        .map_err(|reason| ResolverError::InvalidInput(reason.into()))
    }

    /// Preflight audit bindings against this resolver's actual configuration.
    /// No blocking, comparisons, scoring or append occurs here. This does not
    /// authenticate the record or execute a replay.
    pub fn verify_record_inputs(
        &self,
        record: &ResolutionRecord,
        candidate: &Invariant,
        snapshot: &OntologySnapshot,
    ) -> Result<(), ResolverError> {
        if record.candidate_id != candidate.id {
            return Err(ResolverError::BindingMismatch(BindingMismatch::Candidate));
        }
        let params = self.params()?;
        let comparison = self.backend.comparison_version().ok_or_else(|| {
            ResolverError::InvalidInput("backend has no supported comparison version".into())
        })?;
        record
            .context
            .verify(snapshot, candidate, params, comparison)
            .map_err(ResolverError::BindingMismatch)
    }

    /// Compatibility entry: build a validated snapshot, then use the same
    /// audited path as resolve_snapshot. Duplicate IDs fail before resolution.
    pub fn resolve(
        &self,
        candidate: &Invariant,
        existing: &[Invariant],
    ) -> Result<ResolutionVerdict, ResolverError> {
        let snapshot = OntologySnapshot::new(existing.to_vec())
            .map_err(|error| ResolverError::InvalidInput(error.to_string()))?;
        self.resolve_snapshot(candidate, &snapshot)
    }

    /// All successful decisions and log failures carry the same six bindings,
    /// including deterministic conflicts and paths which do not execute EM.
    pub fn resolve_snapshot(
        &self,
        candidate: &Invariant,
        snapshot: &OntologySnapshot,
    ) -> Result<ResolutionVerdict, ResolverError> {
        let params = self.params()?;
        let comparison = self.backend.comparison_version().ok_or_else(|| {
            ResolverError::InvalidInput("backend has no supported comparison version".into())
        })?;
        let context = ResolutionContext::new(snapshot, candidate, params, comparison);
        let same_action = snapshot.training_corpus(candidate);

        // Conflict precedes cold start; sorted snapshot order selects one witness.
        for ex in &same_action {
            if ex.condition.eq_ignore_ascii_case(&candidate.condition)
                && is_opposite_modality(ex.modality, candidate.modality)
            {
                let verdict = ResolutionVerdict::Conflict {
                    existing: ex.id,
                    reason: format!(
                        "opposite modality on action {:?} condition {:?}",
                        candidate.action, candidate.condition
                    ),
                };
                return self.log_verdict(
                    verdict,
                    ResolutionRecord {
                        context,
                        candidate_id: candidate.id,
                        existing_id: Some(ex.id),
                        verdict_kind: "conflict",
                        match_probability: 1.0,
                    },
                );
            }
        }

        if same_action.is_empty() {
            return self.log_verdict(
                ResolutionVerdict::Novel,
                ResolutionRecord {
                    context,
                    candidate_id: candidate.id,
                    existing_id: None,
                    verdict_kind: "novel",
                    match_probability: 0.0,
                },
            );
        }

        let training_corpus: Vec<Invariant> = same_action.iter().map(|e| (*e).clone()).collect();
        let training_pairs = self.cached_pairs(&training_corpus);
        let training_vectors: Vec<ComparisonVector> = training_pairs
            .iter()
            .map(|(i, j)| {
                self.backend
                    .comparison_vector(&training_corpus[*i], &training_corpus[*j])
            })
            .collect();

        if training_vectors.is_empty() {
            return self.log_verdict(
                ResolutionVerdict::Novel,
                ResolutionRecord {
                    context,
                    candidate_id: candidate.id,
                    existing_id: Some(same_action[0].id),
                    verdict_kind: "novel_cold_start",
                    match_probability: 0.0,
                },
            );
        }

        let corpus_hash = corpus_hash(&training_pairs, &training_vectors);
        let model = self.get_or_fit_model(&training_vectors, corpus_hash);
        let mut best: Option<(f64, &Invariant)> = None;
        for ex in &same_action {
            let v = self.backend.comparison_vector(candidate, ex);
            let p = model.match_probability(&v);
            if best.is_none_or(|(bp, _)| p > bp) {
                best = Some((p, *ex));
            }
        }
        // same_action is nonempty here, so scoring always selects one member.
        let (best_p, best_ex) = best.expect("nonempty comparison corpus");
        let verdict = if best_p >= params.duplicate_threshold() {
            if candidate.specificity > best_ex.specificity {
                ResolutionVerdict::CandidateRefines { parent: best_ex.id }
            } else if candidate.specificity < best_ex.specificity {
                ResolutionVerdict::ExistingRefines { child: best_ex.id }
            } else {
                ResolutionVerdict::Duplicate {
                    canonical: best_ex.id,
                }
            }
        } else if best_p >= params.refinement_threshold() {
            if candidate.specificity > best_ex.specificity {
                ResolutionVerdict::CandidateRefines { parent: best_ex.id }
            } else if candidate.specificity < best_ex.specificity {
                ResolutionVerdict::ExistingRefines { child: best_ex.id }
            } else {
                ResolutionVerdict::Novel
            }
        } else {
            ResolutionVerdict::Novel
        };

        let (existing_id, kind) = match &verdict {
            ResolutionVerdict::Duplicate { canonical } => (Some(*canonical), "duplicate"),
            ResolutionVerdict::CandidateRefines { parent } => (Some(*parent), "candidate_refines"),
            ResolutionVerdict::ExistingRefines { child } => (Some(*child), "existing_refines"),
            ResolutionVerdict::Conflict { .. } => unreachable!("conflicts return before EM"),
            ResolutionVerdict::Novel => (None, "novel"),
        };
        self.log_verdict(
            verdict,
            ResolutionRecord {
                context,
                candidate_id: candidate.id,
                existing_id,
                verdict_kind: kind,
                match_probability: best_p,
            },
        )
    }

    fn log_verdict(
        &self,
        verdict: ResolutionVerdict,
        record: ResolutionRecord,
    ) -> Result<ResolutionVerdict, ResolverError> {
        let partial_digest = compute_digest(&record);
        self.log
            .append(&record)
            .map_err(|reason| ResolverError::LogFailure {
                verdict: ComputedVerdict(verdict.clone()),
                reason,
                partial_digest,
                context: Box::new(record.context),
            })?;
        Ok(verdict)
    }

    fn cached_pairs(&self, corpus: &[Invariant]) -> Vec<(usize, usize)> {
        // Membership and action enter the key: changing an action under a stable
        // identity must invalidate blocking just as adding/removing an ID does.
        let mut h = blake3::Hasher::new();
        h.update(b"AKG:BLOCK:v1\0");
        for inv in corpus {
            h.update(&inv.id);
            let action = inv.action.to_ascii_lowercase();
            h.update(&(action.len() as u64).to_be_bytes());
            h.update(action.as_bytes());
        }
        let key = h.finalize().to_hex().to_string();
        let indices: HashMap<_, _> = corpus
            .iter()
            .enumerate()
            .map(|(i, inv)| (inv.id, i))
            .collect();
        let mut cache = self.blocking_cache.lock().unwrap();
        if let Some(pairs) = cache.get(&key) {
            return pairs
                .iter()
                .map(|(a, b)| (indices[a], indices[b]))
                .collect();
        }
        let mut pairs = self.backend.candidate_pairs(corpus);
        pairs.sort_unstable();
        pairs.dedup();
        // A bounded cache avoids retaining every historical corpus forever.
        cache.clear();
        cache.insert(
            key,
            pairs
                .iter()
                .map(|&(i, j)| (corpus[i].id, corpus[j].id))
                .collect(),
        );
        pairs
    }

    fn get_or_fit_model(
        &self,
        training: &[ComparisonVector],
        corpus_hash: [u8; 32],
    ) -> FellegiSunter {
        let key = {
            let mut h = blake3::Hasher::new();
            h.update(&corpus_hash);
            h.update(&(self.max_em_iterations as u64).to_be_bytes());
            h.update(&self.em_tolerance.to_be_bytes());
            *h.finalize().as_bytes()
        };
        let mut cache = self.model_cache.lock().unwrap();
        if let Some((k, ref m)) = *cache {
            if k == key {
                return m.clone();
            }
        }
        let mut model = FellegiSunter::default_model();
        model.fit_em(training, self.max_em_iterations, self.em_tolerance);
        *cache = Some((key, model.clone()));
        model
    }
}

fn is_opposite_modality(a: Modality, b: Modality) -> bool {
    matches!(
        (a, b),
        (Modality::Obligatory, Modality::Impermissible)
            | (Modality::Impermissible, Modality::Obligatory)
            | (Modality::Optional, Modality::Impermissible)
            | (Modality::Impermissible, Modality::Optional)
    )
}

fn compute_digest(record: &ResolutionRecord) -> [u8; 32] {
    record.object_digest().0
}

impl CanonicalEncode for ResolutionRecord {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:ONTO:RESOLUTION:v2\0";

    fn unsigned_projection(&self) -> serde_json::Value {
        let b = self.context.bindings;
        serde_json::json!({
            "schema": "resolution-record-v2",
            "snapshot_digest": b.snapshot.digest(),
            "candidate_digest": b.candidate,
            "corpus_digest": b.corpus,
            "params_digest": b.params.digest(),
            "algorithm_digest": b.algorithm,
            "comparison_digest": b.comparison,
            "params": self.context.params.unsigned_projection(),
            "algorithm_version": self.context.algorithm.tag(),
            "comparison_version": self.context.comparison.tag(),
            "candidate_id": self.candidate_id,
            "existing_id": self.existing_id,
            "verdict_kind": self.verdict_kind,
            "match_probability_bits": self.match_probability.to_bits(),
        })
    }

    fn canonical_bytes(&self) -> Vec<u8> {
        let projection = self.unsigned_projection();
        let mut fields = projection.as_object().expect("record map").clone();
        let b = self.context.bindings;
        let snapshot = b.snapshot.digest();
        let params = b.params.digest();
        let mut bytes: Vec<(&str, &[u8])> = vec![
            ("snapshot_digest", &snapshot.0),
            ("candidate_digest", &b.candidate.0),
            ("corpus_digest", &b.corpus.0),
            ("params_digest", &params.0),
            ("algorithm_digest", &b.algorithm.0),
            ("comparison_digest", &b.comparison.0),
            ("candidate_id", &self.candidate_id),
        ];
        if let Some(id) = &self.existing_id {
            bytes.push(("existing_id", id));
        }
        for (key, _) in &bytes {
            fields.remove(*key);
        }
        encode_map_with_bytes(&fields, &bytes).expect("distinct typed record keys")
    }
}

fn corpus_hash(pairs: &[(usize, usize)], vectors: &[ComparisonVector]) -> [u8; 32] {
    let mut sorted: Vec<(usize, usize, &ComparisonVector)> = pairs
        .iter()
        .cloned()
        .zip(vectors.iter())
        .map(|((i, j), v)| (i, j, v))
        .collect();
    sorted.sort_unstable_by_key(|(i, j, _)| (*i, *j));
    let mut h = blake3::Hasher::new();
    h.update(b"AKG:FS:CORPUS:v1\0");
    for (i, j, v) in &sorted {
        h.update(&(*i as u64).to_be_bytes());
        h.update(&(*j as u64).to_be_bytes());
        h.update(&v.gamma);
    }
    *h.finalize().as_bytes()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn model_cache_includes_em_configuration_and_comparisons() {
        let mut resolver = InvariantResolver::new(
            Box::new(crate::er_backend::InMemoryBackend),
            Box::new(MockResolutionLog::new()),
        );
        let vectors = [
            ComparisonVector { gamma: [1, 1] },
            ComparisonVector { gamma: [0, 0] },
        ];
        let hash = corpus_hash(&[(0, 1), (0, 2)], &vectors);
        let first = resolver.get_or_fit_model(&vectors, hash);
        let key = resolver.model_cache.lock().unwrap().as_ref().unwrap().0;
        let cached = resolver.get_or_fit_model(&vectors, hash);
        assert_eq!(first.m, cached.m);
        resolver.max_em_iterations = 1;
        let changed = resolver.get_or_fit_model(&vectors, hash);
        assert_ne!(
            key,
            resolver.model_cache.lock().unwrap().as_ref().unwrap().0
        );
        let mut expected = FellegiSunter::default_model();
        expected.fit_em(&vectors, 1, resolver.em_tolerance);
        assert_eq!(changed.m, expected.m);
        let key = resolver.model_cache.lock().unwrap().as_ref().unwrap().0;
        resolver.em_tolerance = 0.1;
        resolver.get_or_fit_model(&vectors, hash);
        assert_ne!(
            key,
            resolver.model_cache.lock().unwrap().as_ref().unwrap().0
        );
        let key = resolver.model_cache.lock().unwrap().as_ref().unwrap().0;
        let updated = [
            ComparisonVector { gamma: [0, 1] },
            ComparisonVector { gamma: [0, 0] },
        ];
        resolver.get_or_fit_model(&updated, corpus_hash(&[(0, 1), (0, 2)], &updated));
        assert_ne!(
            key,
            resolver.model_cache.lock().unwrap().as_ref().unwrap().0
        );
    }
}
