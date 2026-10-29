//! Minimal ontology types required by the resolver. Graph storage, typed edges,
//! schema evolution and condition implication are not implemented here.

pub type InvariantId = [u8; 32];

/// Modality uses **weak permission** semantics:
/// - `Optional(α)` = `P_w(α)` (weakly permitted)
/// - `Obligatory(α)` implies `P_w(α)` — no conflict with Optional
/// - `Impermissible(α)` = `¬P_w(α)` — contradicts both Optional and Obligatory
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Modality {
    Obligatory,
    Optional,
    Impermissible,
}
