use arkhe_core::{
    evidence::{EvidenceCommitter, EvidenceEnvelope, EvidenceReader},
    Digest32,
};
use async_trait::async_trait;
use std::collections::HashMap;
use tokio::sync::RwLock;

pub struct WormGraph {
    records: RwLock<HashMap<Digest32, EvidenceEnvelope>>,
}

impl Default for WormGraph {
    fn default() -> Self {
        Self::new()
    }
}

impl WormGraph {
    pub fn new() -> Self {
        Self {
            records: RwLock::new(HashMap::new()),
        }
    }
}

#[async_trait]
impl EvidenceReader for WormGraph {
    async fn get(&self, record_hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(self.records.read().await.get(&record_hash).cloned())
    }
}

#[async_trait]
impl EvidenceCommitter for WormGraph {
    async fn append_verified(&self, evidence: EvidenceEnvelope) -> Result<Digest32, String> {
        let id = evidence.record_hash;
        let mut guard = self.records.write().await;
        if let Some(existing) = guard.get(&id) {
            if existing != &evidence {
                return Err("same record_hash bound to different envelope".into());
            }
            return Ok(id);
        }
        guard.insert(id, evidence);
        Ok(id)
    }
}

pub mod anchor;
pub mod detection;
pub mod fencing;
pub mod identity;
pub mod postgres;
pub mod regenerate;
pub mod retention;
pub mod replica;
pub mod roster;
