//! Hybrid search over an explicit immutable invariant-text snapshot.
//! Dense hits must match that snapshot exactly. Roots are local commitments,
//! not authenticated ontology versions or externally anchored checkpoints.
use crate::pipeline::{ChunkStore, RetrievalBatch, StoredChunk};
use arkhe_core::{canonical::encode_value, Digest32};
use arkhe_rag::retrieval::{Bm25Index, Document, HybridRetriever, OverlapReranker, Reranker};
use arkhe_verify_core::mmr::{build_root_and_proof, verify_proof_at, ProofStep};
use async_trait::async_trait;
use serde::{Deserialize, Serialize};
use std::collections::BTreeMap;

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct InclusionProof {
    pub root: [u8; 32],
    pub leaf_index: usize,
    pub leaf_count: usize,
    pub steps: Vec<ProofStep>,
}

#[derive(Debug, Clone, PartialEq, Serialize, Deserialize)]
pub struct ChunkEvidence {
    pub tenant_id: String,
    pub id: String,
    pub text: String,
    pub content_digest: Digest32,
    pub inclusion_proof: InclusionProof,
}

fn leaf(tenant: &str, id: &str, text: &str) -> Vec<u8> {
    let mut bytes = b"AKG:INVARIANT:RETRIEVAL-CHUNK:v1\0".to_vec();
    bytes.extend(encode_value(
        &serde_json::json!({"tenant_id": tenant, "id": id, "text": text}),
    ));
    bytes
}

impl ChunkEvidence {
    /// Caller must obtain the expected root through an independently trusted channel.
    pub fn verify(&self, tenant: &str, expected_root: &[u8; 32]) -> bool {
        let bytes = leaf(&self.tenant_id, &self.id, &self.text);
        self.tenant_id == tenant
            && &self.inclusion_proof.root == expected_root
            && self.content_digest == Digest32::blake3(b"AKG:INVARIANT:CHUNK-DIGEST:v1\0", &bytes)
            && verify_proof_at(
                &bytes,
                self.inclusion_proof.leaf_count,
                self.inclusion_proof.leaf_index,
                &self.inclusion_proof.steps,
                expected_root,
            )
            .unwrap_or(false)
    }
}

struct TenantSnapshot {
    retriever: HybridRetriever,
    leaves: Vec<Vec<u8>>,
    positions: BTreeMap<String, usize>,
    root: [u8; 32],
}

pub struct InvariantRetriever<S> {
    dense: S,
    snapshots: BTreeMap<String, TenantSnapshot>,
}

impl<S: ChunkStore> InvariantRetriever<S> {
    pub fn new(
        dense: S,
        corpus: Vec<StoredChunk>,
        k1: f64,
        b: f64,
        rrf_constant: u32,
        candidates: usize,
    ) -> Result<Self, String> {
        // Validate configuration even when the snapshot is empty.
        HybridRetriever::new(Bm25Index::new(vec![], k1, b)?, rrf_constant, candidates)?;
        if corpus.len() > 10_000 {
            return Err("invariant snapshot exceeds 10000 chunks".into());
        }
        let mut tenants = BTreeMap::<String, Vec<Document>>::new();
        for chunk in corpus {
            if chunk.tenant_id.trim().is_empty() || chunk.text.len() > 1_048_576 {
                return Err("invalid tenant or chunk exceeds 1 MiB".into());
            }
            tenants.entry(chunk.tenant_id).or_default().push(Document {
                id: chunk.id,
                text: chunk.text,
            });
        }
        let mut snapshots = BTreeMap::new();
        for (tenant, documents) in tenants {
            let index = Bm25Index::new(documents, k1, b)?;
            let positions = index
                .documents()
                .enumerate()
                .map(|(i, d)| (d.id.clone(), i))
                .collect();
            let leaves: Vec<_> = index
                .documents()
                .map(|d| leaf(&tenant, &d.id, &d.text))
                .collect();
            let (root, _) =
                build_root_and_proof(&leaves, 0).map_err(|e| format!("snapshot MMR: {e:?}"))?;
            snapshots.insert(
                tenant,
                TenantSnapshot {
                    retriever: HybridRetriever::new(index, rrf_constant, candidates)?,
                    leaves,
                    positions,
                    root,
                },
            );
        }
        Ok(Self { dense, snapshots })
    }

    pub fn snapshot_root(&self, tenant: &str) -> Option<[u8; 32]> {
        self.snapshots.get(tenant).map(|s| s.root)
    }

    async fn search(&self, tenant: &str, query: &str, k: usize) -> Result<RetrievalBatch, String> {
        if tenant.trim().is_empty() {
            return Err("tenant_id is required".into());
        }
        let mut batch = RetrievalBatch {
            chunks: vec![],
            evidence: vec![],
        };
        if k == 0 || query.trim().is_empty() {
            return Ok(batch);
        }
        let Some(snapshot) = self.snapshots.get(tenant) else {
            return Ok(batch);
        };
        let dense = match tokio::time::timeout(
            std::time::Duration::from_secs(5),
            self.dense
                .retrieve(tenant, query, snapshot.retriever.candidate_limit()),
        )
        .await
        {
            Ok(result) => result,
            Err(_) => Err("dense retrieval timed out".into()),
        };
        if let Ok(chunks) = &dense {
            if chunks.len() > snapshot.retriever.candidate_limit() {
                return Err("dense ranker exceeded candidate limit".into());
            }
            for chunk in chunks {
                if chunk.tenant_id != tenant
                    || snapshot
                        .retriever
                        .lexical
                        .document(&chunk.id)
                        .is_none_or(|d| d.text != chunk.text)
                {
                    return Err("dense evidence differs from tenant invariant snapshot".into());
                }
            }
        } else {
            tracing::warn!("invariant retrieval degraded to lexical: dense ranker unavailable");
        }
        let dense_ids = dense.map(|chunks| chunks.into_iter().map(|c| c.id).collect());
        let fused = snapshot.retriever.retrieve(query, dense_ids)?;
        let mut ranked = OverlapReranker.rerank(query, fused, &snapshot.retriever.lexical)?;
        ranked.truncate(k);
        for hit in ranked {
            let document = snapshot
                .retriever
                .lexical
                .document(&hit.id)
                .ok_or("unknown fused document")?;
            let position = snapshot.positions[&hit.id];
            let (root, steps) = build_root_and_proof(&snapshot.leaves, position)
                .map_err(|e| format!("inclusion: {e:?}"))?;
            batch.chunks.push(StoredChunk {
                tenant_id: tenant.into(),
                id: hit.id.clone(),
                text: document.text.clone(),
            });
            batch.evidence.push(ChunkEvidence {
                tenant_id: tenant.into(),
                id: hit.id,
                text: document.text.clone(),
                content_digest: Digest32::blake3(
                    b"AKG:INVARIANT:CHUNK-DIGEST:v1\0",
                    &snapshot.leaves[position],
                ),
                inclusion_proof: InclusionProof {
                    root,
                    leaf_index: position,
                    leaf_count: snapshot.leaves.len(),
                    steps,
                },
            });
        }
        Ok(batch)
    }
}

#[async_trait]
impl<S: ChunkStore> ChunkStore for InvariantRetriever<S> {
    async fn retrieve(
        &self,
        tenant: &str,
        query: &str,
        k: usize,
    ) -> Result<Vec<StoredChunk>, String> {
        Ok(self.search(tenant, query, k).await?.chunks)
    }
    async fn retrieve_evidenced(
        &self,
        tenant: &str,
        query: &str,
        k: usize,
    ) -> Result<RetrievalBatch, String> {
        self.search(tenant, query, k).await
    }
}
