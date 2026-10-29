//! Durable, tenant-scoped storage of memo observation packages. Consistency is
//! verified locally; these records do not establish payment authority or truth.
use super::PgWormGraph;
use crate::regenerate::{rebuild, OrderedRecordSource};
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    Digest32,
};
use arkhe_verify_core::{
    memo_reconciliation::{self, MemoBundle},
    mmr::{build_root_and_proof, profile::PROFILE_DIGEST_HEX, verify_proof_at, ProofStep},
    reconciliation::{Decision, Trust},
};
use serde::{Deserialize, Serialize};
use sqlx::Row;

const MAX_BYTES: usize = 20_000_000;
const KIND: &str = "MemoObservationPackage/v1";

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct MemoPackage {
    pub bundle: MemoBundle,
    /// Retained original local trust, not an independently authenticated anchor.
    pub local_trust: Trust,
}
fn package_hash(raw: &[u8]) -> Digest32 {
    Digest32::blake3(b"AKG:MEMO:STORED-PACKAGE:v1\0", raw)
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MemoStorageReceipt {
    pub record_hash: Digest32,
    pub operation_id: Digest32,
    pub graph_leaf_count: u64,
}

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
#[serde(deny_unknown_fields)]
pub struct MemoGraphTrust {
    pub tenant_id: String,
    pub stream_id: String,
    pub root: [u8; 32],
    pub leaf_count: u64,
    pub profile_digest: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct DurableMemoExport {
    pub package_bytes: Vec<u8>,
    pub record_hash: Digest32,
    pub graph: MemoGraphTrust,
    pub leaf_index: u64,
    pub steps: Vec<ProofStep>,
}

/// Pure offline check against a separately supplied graph pin. No database or
/// network access. Pin issuance, source authenticity and external anchoring are
/// outside this function.
pub fn verify_export(
    export: &DurableMemoExport,
    trust: &MemoGraphTrust,
) -> Result<Decision, String> {
    if export.package_bytes.is_empty()
        || export.package_bytes.len() > MAX_BYTES
        || &export.graph != trust
        || trust.tenant_id.is_empty()
        || trust.stream_id.is_empty()
        || trust.leaf_count == 0
        || trust.leaf_count > 1_000_000
        || export.leaf_index >= trust.leaf_count
        || trust.profile_digest != PROFILE_DIGEST_HEX
        || export.steps.len() > 64
        || package_hash(&export.package_bytes) != export.record_hash
    {
        return Err("invalid package or untrusted graph checkpoint".into());
    }
    if !verify_proof_at(
        &export.record_hash.0,
        trust.leaf_count as usize,
        export.leaf_index as usize,
        &export.steps,
        &trust.root,
    )
    .map_err(|e| e.to_string())?
    {
        return Err("stored package absent from graph checkpoint".into());
    }
    let package: MemoPackage =
        serde_json::from_slice(&export.package_bytes).map_err(|e| e.to_string())?;
    memo_reconciliation::verify(&package.bundle, &package.local_trust).map_err(str::to_string)
}

impl PgWormGraph {
    /// Atomic package + observation envelope + tenant-stream checkpoint.
    /// Caller authenticates who may submit observations; this is not admission
    /// of an externally authenticated invoice or a work authorization.
    pub async fn commit_memo_observation(
        &self,
        package: &MemoPackage,
    ) -> Result<MemoStorageReceipt, String> {
        memo_reconciliation::verify(&package.bundle, &package.local_trust)
            .map_err(str::to_string)?;
        let raw = serde_json::to_vec(package).map_err(|e| e.to_string())?;
        if raw.is_empty() || raw.len() > MAX_BYTES {
            return Err("package too large".into());
        }
        let hash = package_hash(&raw);
        let operation = package.bundle.reconciliation.record.intent.operation_id();
        let mut tx = self.begin("arkhe_append").await?;
        // Same lock as insert_envelope. Serializes tenant append/checkpoint order.
        sqlx::query("SELECT pg_advisory_xact_lock(hashtextextended($1,0))")
            .bind(format!("arkhe:wormgraph:{}", self.tenant))
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        sqlx::query("SET LOCAL synchronous_commit = on")
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        let existing = sqlx::query("SELECT record_hash,package_bytes,graph_leaf_count,stream_id FROM memo_observation_packages WHERE tenant_id=$1 AND operation_id=$2")
            .bind(&self.tenant).bind(operation.0.to_vec()).fetch_optional(&mut *tx).await.map_err(|e| e.to_string())?;
        if let Some(row) = existing {
            let old_hash: Vec<u8> = row.try_get("record_hash").map_err(|e| e.to_string())?;
            let old_bytes: Vec<u8> = row.try_get("package_bytes").map_err(|e| e.to_string())?;
            let stream: String = row.try_get("stream_id").map_err(|e| e.to_string())?;
            let count: i64 = row.try_get("graph_leaf_count").map_err(|e| e.to_string())?;
            if old_hash != hash.0 || old_bytes != raw || stream != self.stream_id {
                return Err("operation already bound to a different memo package".into());
            }
            tx.commit().await.map_err(|e| e.to_string())?;
            return Ok(MemoStorageReceipt {
                record_hash: hash,
                operation_id: operation,
                graph_leaf_count: count as u64,
            });
        }
        let envelope = EvidenceEnvelope {
            record_hash: hash,
            kind: KIND.into(),
            subject: operation,
            payload_digest: hash,
            policy_digest: None,
            causal_parents: vec![],
        };
        self.insert_envelope(&mut tx, &envelope).await?;
        let raw_hashes: Vec<Vec<u8>> = sqlx::query_scalar("SELECT record_hash FROM wormgraph_records WHERE tenant_id=$1 ORDER BY append_sequence LIMIT 1000001")
            .bind(&self.tenant).fetch_all(&mut *tx).await.map_err(|e| e.to_string())?;
        if raw_hashes.len() > 1_000_000 {
            return Err("graph checkpoint limit exceeded".into());
        }
        let hashes: Vec<Digest32> = raw_hashes
            .into_iter()
            .map(|v| {
                v.try_into()
                    .map(Digest32)
                    .map_err(|_| "invalid stored hash".to_string())
            })
            .collect::<Result<_, _>>()?;
        let snapshot = rebuild(&hashes).map_err(|e| format!("checkpoint rebuild failed: {e:?}"))?;
        let profile = hex::decode(PROFILE_DIGEST_HEX).map_err(|e| e.to_string())?;
        let peaks: Vec<Vec<u8>> = snapshot.peaks.iter().map(|p| p.0.to_vec()).collect();
        let covered = hashes
            .last()
            .ok_or("missing checkpoint coverage")?
            .0
            .to_vec();
        sqlx::query("INSERT INTO mmr_checkpoints(tenant_id,stream_id,leaf_count,mmr_size,mmr_root,peaks,profile_digest,covered_up_to_hash) VALUES($1,$2,$3,$4,$5,$6,$7,$8) ON CONFLICT(tenant_id,stream_id,leaf_count) DO NOTHING")
            .bind(&self.tenant).bind(&self.stream_id).bind(snapshot.leaf_count as i64).bind(snapshot.mmr_size as i64)
            .bind(snapshot.root.0.to_vec()).bind(&peaks).bind(&profile).bind(&covered)
            .execute(&mut *tx).await.map_err(|e| e.to_string())?;
        let row = sqlx::query("SELECT mmr_root,peaks,profile_digest,covered_up_to_hash,mmr_size FROM mmr_checkpoints WHERE tenant_id=$1 AND stream_id=$2 AND leaf_count=$3")
            .bind(&self.tenant).bind(&self.stream_id).bind(snapshot.leaf_count as i64).fetch_one(&mut *tx).await.map_err(|e| e.to_string())?;
        if row
            .try_get::<Vec<u8>, _>("mmr_root")
            .map_err(|e| e.to_string())?
            != snapshot.root.0
            || row
                .try_get::<Vec<Vec<u8>>, _>("peaks")
                .map_err(|e| e.to_string())?
                != peaks
            || row
                .try_get::<Vec<u8>, _>("profile_digest")
                .map_err(|e| e.to_string())?
                != profile
            || row
                .try_get::<Vec<u8>, _>("covered_up_to_hash")
                .map_err(|e| e.to_string())?
                != covered
            || row
                .try_get::<i64, _>("mmr_size")
                .map_err(|e| e.to_string())?
                != snapshot.mmr_size as i64
        {
            return Err("conflicting graph checkpoint".into());
        }
        sqlx::query("INSERT INTO memo_observation_packages(tenant_id,record_hash,operation_id,package_bytes,stream_id,graph_leaf_count) VALUES($1,$2,$3,$4,$5,$6)")
            .bind(&self.tenant).bind(hash.0.to_vec()).bind(operation.0.to_vec()).bind(raw)
            .bind(&self.stream_id).bind(snapshot.leaf_count as i64).execute(&mut *tx).await.map_err(|e| e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(MemoStorageReceipt {
            record_hash: hash,
            operation_id: operation,
            graph_leaf_count: snapshot.leaf_count,
        })
    }

    pub async fn export_memo_observation(
        &self,
        hash: Digest32,
    ) -> Result<DurableMemoExport, String> {
        let mut tx = self.begin("arkhe_read").await?;
        let row = sqlx::query("SELECT package_bytes,graph_leaf_count,operation_id,stream_id FROM memo_observation_packages WHERE tenant_id=$1 AND record_hash=$2")
            .bind(&self.tenant).bind(hash.0.to_vec()).fetch_optional(&mut *tx).await.map_err(|e| e.to_string())?.ok_or("memo package not found in tenant")?;
        let raw: Vec<u8> = row.try_get("package_bytes").map_err(|e| e.to_string())?;
        let count: i64 = row.try_get("graph_leaf_count").map_err(|e| e.to_string())?;
        let operation: Vec<u8> = row.try_get("operation_id").map_err(|e| e.to_string())?;
        let stream: String = row.try_get("stream_id").map_err(|e| e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())?;
        if raw.len() > MAX_BYTES
            || count <= 0
            || count > 1_000_000
            || stream != self.stream_id
            || package_hash(&raw) != hash
        {
            return Err("corrupt memo package metadata".into());
        }
        let envelope = self.get(hash).await?.ok_or("memo envelope missing")?;
        let package: MemoPackage = serde_json::from_slice(&raw).map_err(|e| e.to_string())?;
        if package
            .bundle
            .reconciliation
            .record
            .intent
            .operation_id()
            .0
            .as_slice()
            != operation
            || envelope.kind != KIND
            || envelope.subject.0.as_slice() != operation
            || envelope.payload_digest != hash
            || envelope.policy_digest.is_some()
            || !envelope.causal_parents.is_empty()
        {
            return Err("memo envelope/package mismatch".into());
        }
        let checkpoint = self
            .load_checkpoint(&self.stream_id, count as u64)
            .await?
            .ok_or("memo checkpoint missing")?;
        let records = self
            .prefix(&self.tenant, &self.stream_id, count as u64)
            .await
            .map_err(|e| e.0)?;
        if records.len() != count as usize {
            return Err("incomplete graph prefix".into());
        }
        let hashes: Vec<_> = records.iter().map(|r| r.record_hash).collect();
        let snapshot = rebuild(&hashes).map_err(|e| format!("graph rebuild failed: {e:?}"))?;
        if snapshot.root != checkpoint.root
            || snapshot.peaks != checkpoint.peaks
            || hashes.last() != Some(&checkpoint.covered_up_to)
        {
            return Err("graph prefix differs from retained checkpoint".into());
        }
        let index = hashes
            .iter()
            .position(|h| *h == hash)
            .ok_or("memo record not covered")?;
        let leaves: Vec<Vec<u8>> = hashes.iter().map(|h| h.0.to_vec()).collect();
        let (root, steps) = build_root_and_proof(&leaves, index).map_err(|e| e.to_string())?;
        let export = DurableMemoExport {
            package_bytes: raw,
            record_hash: hash,
            graph: MemoGraphTrust {
                tenant_id: self.tenant.clone(),
                stream_id: self.stream_id.clone(),
                root,
                leaf_count: count as u64,
                profile_digest: PROFILE_DIGEST_HEX.into(),
            },
            leaf_index: index as u64,
            steps,
        };
        if root != checkpoint.root.0 {
            return Err("graph proof root mismatch".into());
        }
        verify_export(&export, &export.graph)?;
        Ok(export)
    }
}
