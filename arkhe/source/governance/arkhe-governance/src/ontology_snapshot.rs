//! Content-addressed, immutable invariant snapshots using AKG-CBOR-v1.
//!
//! This profile contains invariants only; it is not the identity of a full
//! ConstitutionGraph with edges or coverage. A future graph profile must use
//! a different schema/domain. No JSON/CBOR deserializer bypasses validation.

use arkhe_core::{canonical::encode_value, CanonicalEncode, Digest32};
use serde_json::{json, Value};

use crate::{
    constitution_graph::{InvariantId, Modality},
    er_backend::Invariant,
};

pub const SNAPSHOT_PROFILE: &str = "arkhe-invariant-snapshot-v1";
pub const CORPUS_SELECTION: &str = "same-action-ascii-exclude-candidate-id-v1";

/// Identity of the complete stored content in the invariant snapshot profile.
/// Digest equality relies on BLAKE3 collision resistance, not mathematical
/// injectivity. Importing an asserted version does not verify any content.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub struct OntologyVersion(Digest32);

impl OntologyVersion {
    pub const fn from_bytes(bytes: [u8; 32]) -> Self {
        Self(Digest32(bytes))
    }

    pub const fn digest(self) -> Digest32 {
        self.0
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum SnapshotError {
    DuplicateId(InvariantId),
    VersionMismatch {
        expected: OntologyVersion,
        actual: OntologyVersion,
    },
}

impl std::fmt::Display for SnapshotError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "ontology snapshot validation failed: {self:?}")
    }
}

impl std::error::Error for SnapshotError {}

/// Owns its invariants; readers cannot mutate content or assign its version.
///
/// ```compile_fail
/// use arkhe_governance::ontology_snapshot::OntologySnapshot;
/// let snapshot = OntologySnapshot::new(vec![]).unwrap();
/// snapshot.invariants().clear();
/// ```
#[derive(Debug, Clone)]
pub struct OntologySnapshot {
    invariants: Vec<Invariant>,
    version: OntologyVersion,
}

impl OntologySnapshot {
    pub fn new(mut invariants: Vec<Invariant>) -> Result<Self, SnapshotError> {
        invariants.sort_by_key(|inv| inv.id);
        if let Some(pair) = invariants.windows(2).find(|pair| pair[0].id == pair[1].id) {
            return Err(SnapshotError::DuplicateId(pair[0].id));
        }
        let version = OntologyVersion(Digest32::blake3(
            Self::DOMAIN_OBJECT,
            &encode_value(&snapshot_projection(&invariants)),
        ));
        Ok(Self {
            invariants,
            version,
        })
    }

    /// Validate externally loaded, typed content against an asserted version.
    /// Nothing is resolved or logged when this validation fails.
    pub fn from_verified_invariants(
        invariants: Vec<Invariant>,
        expected: OntologyVersion,
    ) -> Result<Self, SnapshotError> {
        let snapshot = Self::new(invariants)?;
        if snapshot.version != expected {
            return Err(SnapshotError::VersionMismatch {
                expected,
                actual: snapshot.version,
            });
        }
        Ok(snapshot)
    }

    pub fn version(&self) -> OntologyVersion {
        self.version
    }

    pub fn invariants(&self) -> &[Invariant] {
        &self.invariants
    }

    /// Ordered by raw ID bytes, after the same action/identity filters used
    /// by the resolver. The candidate is never a training member.
    pub fn training_corpus(&self, candidate: &Invariant) -> Vec<&Invariant> {
        self.invariants
            .iter()
            .filter(|inv| {
                inv.id != candidate.id && inv.action.eq_ignore_ascii_case(&candidate.action)
            })
            .collect()
    }

    /// Content digest for the selected corpus, including the selection profile.
    /// This is not the resolver's internal comparison-vector cache key.
    pub fn corpus_digest(&self, candidate: &Invariant) -> Digest32 {
        let invariants: Vec<_> = self
            .training_corpus(candidate)
            .into_iter()
            .map(CanonicalEncode::unsigned_projection)
            .collect();
        Digest32::blake3(
            b"AKG:ONTO:TRAINING-CORPUS:v1\0",
            &encode_value(&json!({
                "selection": CORPUS_SELECTION,
                "invariants": invariants,
            })),
        )
    }
}

fn snapshot_projection(invariants: &[Invariant]) -> Value {
    json!({
        "profile": SNAPSHOT_PROFILE,
        "invariants": invariants.iter().map(CanonicalEncode::unsigned_projection).collect::<Vec<_>>(),
    })
}

impl CanonicalEncode for OntologySnapshot {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:ONTO:INVARIANT-SNAPSHOT:v1\0";

    fn unsigned_projection(&self) -> Value {
        snapshot_projection(&self.invariants)
    }
}

impl CanonicalEncode for Invariant {
    const DOMAIN_OBJECT: &'static [u8] = b"AKG:ONTO:INVARIANT:v1\0";

    fn unsigned_projection(&self) -> Value {
        // `hash` is the stored InvariantId, encoded as a CBOR byte string by
        // the shared AKG encoder. It is not assumed to hash this record.
        let modality = match self.modality {
            Modality::Obligatory => "obligatory",
            Modality::Optional => "optional",
            Modality::Impermissible => "impermissible",
        };
        json!({
            "hash": self.id,
            "modality": modality,
            "action": self.action,
            "condition": self.condition,
            "specificity": self.specificity,
            "enacted_at": self.enacted_at,
        })
    }
}
