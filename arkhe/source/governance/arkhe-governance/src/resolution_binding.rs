//! Versioned audit inputs. These bindings are preflight checks, not a replay
//! executor, executable archive, signature or proof of numerical portability.

use arkhe_core::{CanonicalEncode, Digest32};
use serde_json::{json, Value};

use crate::{
    er_backend::Invariant,
    ontology_snapshot::{OntologySnapshot, OntologyVersion},
};

#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct ParamsDigest(Digest32);

impl ParamsDigest {
    pub const fn digest(self) -> Digest32 {
        self.0
    }
}

/// Validated parameters. Float bits are encoded as CBOR uint64 values, avoiding
/// JSON floats. Valid zero thresholds are normalized to positive zero; all
/// other accepted IEEE-754 inputs are preserved exactly.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ResolverParams {
    duplicate_threshold_bits: u64,
    refinement_threshold_bits: u64,
    max_em_iterations: u64,
    em_tolerance_bits: u64,
}

impl ResolverParams {
    pub fn new(
        duplicate: f64,
        refinement: f64,
        iterations: usize,
        tolerance: f64,
    ) -> Result<Self, &'static str> {
        if !duplicate.is_finite()
            || !refinement.is_finite()
            || !(0.0..=1.0).contains(&refinement)
            || !(refinement..=1.0).contains(&duplicate)
            || iterations == 0
            || !tolerance.is_finite()
            || tolerance <= 0.0
        {
            return Err("invalid thresholds or EM parameters");
        }
        let canonicalize_zero = |value: f64| if value == 0.0 { 0.0 } else { value };
        Ok(Self {
            duplicate_threshold_bits: canonicalize_zero(duplicate).to_bits(),
            refinement_threshold_bits: canonicalize_zero(refinement).to_bits(),
            max_em_iterations: u64::try_from(iterations)
                .map_err(|_| "iteration count exceeds uint64")?,
            em_tolerance_bits: tolerance.to_bits(),
        })
    }

    pub fn duplicate_threshold(self) -> f64 {
        f64::from_bits(self.duplicate_threshold_bits)
    }
    pub fn refinement_threshold(self) -> f64 {
        f64::from_bits(self.refinement_threshold_bits)
    }
    pub fn max_em_iterations(self) -> u64 {
        self.max_em_iterations
    }
    pub fn em_tolerance(self) -> f64 {
        f64::from_bits(self.em_tolerance_bits)
    }
    pub fn digest(self) -> ParamsDigest {
        ParamsDigest(self.object_digest())
    }
}

impl CanonicalEncode for ResolverParams {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:ONTO:RESOLVER-PARAMS:v2\0";
    fn unsigned_projection(&self) -> Value {
        json!({
            "profile": "resolver-params-ieee754-canonical-zero-v2",
            "duplicate_threshold_bits": self.duplicate_threshold_bits,
            "refinement_threshold_bits": self.refinement_threshold_bits,
            "max_em_iterations": self.max_em_iterations,
            "em_tolerance_bits": self.em_tolerance_bits,
        })
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum AlgorithmVersion {
    FellegiSunterEmV1,
}

impl AlgorithmVersion {
    pub const fn tag(self) -> &'static str {
        match self {
            Self::FellegiSunterEmV1 => "fellegi-sunter-em-v1@0.1.0",
        }
    }
    pub fn digest(self) -> Digest32 {
        self.object_digest()
    }
}

impl CanonicalEncode for AlgorithmVersion {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:ONTO:RESOLVER-ALGORITHM:v1\0";
    fn unsigned_projection(&self) -> Value {
        json!({
            "version": self.tag(),
            "initial_m_bits": [0.9f64.to_bits(), 0.9f64.to_bits()],
            "initial_u_bits": [0.1f64.to_bits(), 0.5f64.to_bits()],
            "initial_prior_bits": 0.1f64.to_bits(),
            "fs_attributes": 2,
            "semantics": "weak-permission-cold-start-return-min-id-tie-v1",
            "em": "laplace-add-one-prior-clamp-max-absolute-delta-v1",
        })
    }
}

/// Version of *both* pair selection and binary comparison. InMemory and DuckDB
/// claim the same semantics; a custom backend must explicitly opt in truthfully.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ComparisonVersion {
    AsciiExactV1,
}

impl ComparisonVersion {
    pub const fn tag(self) -> &'static str {
        match self {
            Self::AsciiExactV1 => "ascii-condition-modality-action-blocking-v1@0.1.0",
        }
    }
    pub fn digest(self) -> Digest32 {
        self.object_digest()
    }
}

impl CanonicalEncode for ComparisonVersion {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:ONTO:RESOLVER-COMPARISON:v1\0";
    fn unsigned_projection(&self) -> Value {
        json!({
            "version": self.tag(),
            "blocking": "all-unordered-pairs-with-equal-ascii-lowercase-action",
            "attributes": ["condition-eq-ignore-ascii-case", "modality-equality"],
            "corpus_selection": crate::ontology_snapshot::CORPUS_SELECTION,
        })
    }
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ResolutionBindings {
    pub snapshot: OntologyVersion,
    pub candidate: Digest32,
    pub corpus: Digest32,
    pub params: ParamsDigest,
    pub algorithm: Digest32,
    pub comparison: Digest32,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum BindingMismatch {
    Snapshot,
    Candidate,
    Corpus,
    Params,
    Algorithm,
    Comparison,
}

/// Digests plus the actual parameter payload and supported version selectors.
/// Public fields allow loading assertions; verify must precede their use.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct ResolutionContext {
    pub bindings: ResolutionBindings,
    pub params: ResolverParams,
    pub algorithm: AlgorithmVersion,
    pub comparison: ComparisonVersion,
}

impl ResolutionContext {
    pub fn new(
        snapshot: &OntologySnapshot,
        candidate: &Invariant,
        params: ResolverParams,
        comparison: ComparisonVersion,
    ) -> Self {
        let algorithm = AlgorithmVersion::FellegiSunterEmV1;
        Self {
            bindings: ResolutionBindings {
                snapshot: snapshot.version(),
                candidate: candidate.object_digest(),
                corpus: snapshot.corpus_digest(candidate),
                params: params.digest(),
                algorithm: algorithm.digest(),
                comparison: comparison.digest(),
            },
            params,
            algorithm,
            comparison,
        }
    }

    /// Recompute all six bindings using the actual inputs/configuration. This
    /// does not call blocking, comparisons, EM, scoring or the resolution log.
    pub fn verify(
        &self,
        snapshot: &OntologySnapshot,
        candidate: &Invariant,
        params: ResolverParams,
        comparison: ComparisonVersion,
    ) -> Result<(), BindingMismatch> {
        let actual = Self::new(snapshot, candidate, params, comparison);
        let a = self.bindings;
        let b = actual.bindings;
        if a.snapshot != b.snapshot {
            return Err(BindingMismatch::Snapshot);
        }
        if a.candidate != b.candidate {
            return Err(BindingMismatch::Candidate);
        }
        if a.corpus != b.corpus {
            return Err(BindingMismatch::Corpus);
        }
        if a.params != b.params || self.params != actual.params {
            return Err(BindingMismatch::Params);
        }
        if a.algorithm != b.algorithm || self.algorithm != actual.algorithm {
            return Err(BindingMismatch::Algorithm);
        }
        if a.comparison != b.comparison || self.comparison != actual.comparison {
            return Err(BindingMismatch::Comparison);
        }
        Ok(())
    }
}
