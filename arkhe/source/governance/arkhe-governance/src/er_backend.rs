//! AKG-ONTO-0001 — Entity resolution backend abstraction.
//!
//! ACTION is **not** an FS attribute: it is the blocking key. Under blocking
//! by action, every training pair has `gamma[ACTION] = 1`, so the attribute
//! has no variance in training and degenerates (see ADR-0001).
//! The informative FS attributes are `(condition, modality)`.

use std::collections::HashMap;

use crate::constitution_graph::{InvariantId, Modality};

/// Number of FS comparison attributes (condition, modality).
pub const FS_ATTRIBUTES: usize = 2;

pub const ATTR_CONDITION: usize = 0;
pub const ATTR_MODALITY: usize = 1;

#[derive(Debug, Clone, PartialEq)]
pub struct Invariant {
    pub id: InvariantId,
    pub modality: Modality,
    pub action: String,
    pub condition: String,
    pub specificity: u32,
    pub enacted_at: u64,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct ComparisonVector {
    /// Per-attribute agreement over `(condition, modality)`.
    pub gamma: [u8; FS_ATTRIBUTES],
}

impl ComparisonVector {
    pub fn agreements(&self) -> usize {
        self.gamma.iter().filter(|g| **g == 1).count()
    }
}

pub trait ErBackend: Send + Sync {
    /// Unknown by default: audit resolution fails closed unless a backend
    /// explicitly declares its supported blocking/comparison semantics.
    fn comparison_version(&self) -> Option<crate::resolution_binding::ComparisonVersion> {
        None
    }
    /// Blocking: valid, unique index pairs. Output is quadratic within a block.
    fn candidate_pairs(&self, invariants: &[Invariant]) -> Vec<(usize, usize)>;

    /// Comparison: per-attribute agreement for a pair.
    fn comparison_vector(&self, a: &Invariant, b: &Invariant) -> ComparisonVector;
}

// --- In-memory backend (default) ---

pub struct InMemoryBackend;

impl ErBackend for InMemoryBackend {
    fn comparison_version(&self) -> Option<crate::resolution_binding::ComparisonVersion> {
        Some(crate::resolution_binding::ComparisonVersion::AsciiExactV1)
    }
    fn candidate_pairs(&self, invariants: &[Invariant]) -> Vec<(usize, usize)> {
        let mut groups: HashMap<String, Vec<usize>> = HashMap::new();
        for (i, inv) in invariants.iter().enumerate() {
            groups
                .entry(inv.action.to_ascii_lowercase())
                .or_default()
                .push(i);
        }
        let mut pairs = Vec::new();
        for indices in groups.values() {
            for i in 0..indices.len() {
                for j in (i + 1)..indices.len() {
                    pairs.push((indices[i], indices[j]));
                }
            }
        }
        pairs.sort_unstable();
        pairs
    }

    fn comparison_vector(&self, a: &Invariant, b: &Invariant) -> ComparisonVector {
        let mut gamma = [0u8; FS_ATTRIBUTES];
        gamma[ATTR_CONDITION] = (a.condition.eq_ignore_ascii_case(&b.condition)) as u8;
        gamma[ATTR_MODALITY] = (a.modality == b.modality) as u8;
        ComparisonVector { gamma }
    }
}

// --- DuckDB backend (feature-gated) ---

#[cfg(feature = "duckdb-backend")]
pub struct DuckDbBackend {
    conn: std::sync::Mutex<duckdb::Connection>,
}

#[cfg(feature = "duckdb-backend")]
impl DuckDbBackend {
    pub fn new() -> Self {
        let conn = duckdb::Connection::open_in_memory().expect("in-memory DuckDB");
        conn.execute_batch("CREATE TABLE invariants (idx INTEGER, action TEXT);")
            .expect("create table");
        Self {
            conn: std::sync::Mutex::new(conn),
        }
    }
}

#[cfg(feature = "duckdb-backend")]
impl ErBackend for DuckDbBackend {
    fn comparison_version(&self) -> Option<crate::resolution_binding::ComparisonVersion> {
        InMemoryBackend.comparison_version()
    }
    fn candidate_pairs(&self, invariants: &[Invariant]) -> Vec<(usize, usize)> {
        let conn = self.conn.lock().expect("DuckDB lock poisoned");
        conn.execute_batch("DELETE FROM invariants;")
            .expect("clear table");
        let mut stmt = conn
            .prepare("INSERT INTO invariants VALUES (?, ?)")
            .expect("prepare insert");
        for (i, inv) in invariants.iter().enumerate() {
            stmt.execute(duckdb::params![i as i64, inv.action.to_ascii_lowercase()])
                .expect("insert");
        }
        drop(stmt);
        let mut stmt = conn
            .prepare(
                "SELECT a.idx, b.idx FROM invariants a
                 JOIN invariants b ON a.action = b.action AND a.idx < b.idx
                 ORDER BY a.idx, b.idx",
            )
            .expect("prepare join");
        let rows = stmt
            .query_map([], |row| {
                Ok((
                    row.get::<_, i64>(0)? as usize,
                    row.get::<_, i64>(1)? as usize,
                ))
            })
            .expect("query");
        rows.map(|r| r.expect("row")).collect()
    }

    fn comparison_vector(&self, a: &Invariant, b: &Invariant) -> ComparisonVector {
        InMemoryBackend.comparison_vector(a, b)
    }
}

#[cfg(feature = "duckdb-backend")]
impl Default for DuckDbBackend {
    fn default() -> Self {
        Self::new()
    }
}
