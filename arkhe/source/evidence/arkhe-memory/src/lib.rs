use arkhe_core::{evidence::EvidenceReader, Digest32};
use std::{collections::HashMap, sync::Arc};
use tokio::sync::RwLock;

#[derive(Debug, Clone)]
pub struct Episode {
    pub episode_hash: Digest32,
    pub content_digest: Digest32,
    pub trajectory_root: Digest32,
    pub evidence_ref: Digest32,
}

pub struct EpisodicMemory<R: EvidenceReader> {
    reader: Arc<R>,
    episodes: RwLock<HashMap<Digest32, Episode>>,
}

impl<R: EvidenceReader> EpisodicMemory<R> {
    pub fn new(reader: Arc<R>) -> Self {
        Self {
            reader,
            episodes: RwLock::new(HashMap::new()),
        }
    }

    pub async fn append_verified(
        &self,
        content_digest: Digest32,
        trajectory_root: Digest32,
        evidence_ref: Digest32,
    ) -> Result<Episode, String> {
        if self.reader.get(evidence_ref).await?.is_none() {
            return Err("evidence_ref is not readable/verified".into());
        }
        let mut payload = content_digest.0.to_vec();
        payload.extend_from_slice(&trajectory_root.0);
        payload.extend_from_slice(&evidence_ref.0);
        let episode = Episode {
            episode_hash: Digest32::blake3(b"AKG:EPISODE:v0-REF\0", &payload),
            content_digest,
            trajectory_root,
            evidence_ref,
        };
        self.episodes
            .write()
            .await
            .insert(episode.episode_hash, episode.clone());
        Ok(episode)
    }

    pub async fn retrieve(&self, id: Digest32) -> Option<Episode> {
        self.episodes.read().await.get(&id).cloned()
    }
}
