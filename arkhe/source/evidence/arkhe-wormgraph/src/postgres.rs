//! Persistent, tenant-scoped implementation. Callers own evidence admission;
//! this store does not convert untrusted input into verified evidence.
use crate::regenerate::{
    anchor_checkpoint, AnchoredCheckpoint, CheckpointAnchor, CheckpointBinding,
    OrderedRecordSource, SequencedRecord, SourceError, DEFAULT_STREAM_ID,
};
use arkhe_core::{
    evidence::{EvidenceCommitter, EvidenceEnvelope, EvidenceReader, WorkEvidenceCommitter},
    work::WorkIntent,
    worker::WorkerExecutionRecord,
    CanonicalEncode, Digest32,
};
use async_trait::async_trait;
use sqlx::{postgres::PgPoolOptions, postgres::PgRow, PgPool, Postgres, Row, Transaction};

pub mod memo;
pub mod replica;

pub struct PgWormGraph {
    pool: PgPool,
    tenant: String,
    stream_id: String,
    writer_epoch: Option<u64>,
}
impl PgWormGraph {
    /// Deployment-only entry point. Runtime requests never run migrations.
    pub async fn migrate(url: &str) -> Result<(), String> {
        let pool = PgPoolOptions::new()
            .max_connections(1)
            .connect(url)
            .await
            .map_err(|e| e.to_string())?;
        sqlx::migrate!("../../storage/sql/migrations")
            .run(&pool)
            .await
            .map_err(|e| e.to_string())?;
        pool.close().await;
        Ok(())
    }
    pub async fn connect(url: &str, tenant: &str) -> Result<Self, String> {
        Self::connect_with_stream(url, tenant, DEFAULT_STREAM_ID).await
    }

    pub async fn connect_with_stream(
        url: &str,
        tenant: &str,
        stream_id: &str,
    ) -> Result<Self, String> {
        if tenant.trim().is_empty() {
            return Err("tenant is required".into());
        }
        if stream_id.trim().is_empty() {
            return Err("stream is required".into());
        }
        let pool = PgPoolOptions::new()
            .max_connections(5)
            .acquire_timeout(std::time::Duration::from_secs(5))
            .connect(url)
            .await
            .map_err(|e| e.to_string())?;
        let privileged: bool = sqlx::query_scalar(
            "SELECT rolsuper OR rolbypassrls OR rolcreaterole OR rolcreatedb FROM pg_roles WHERE rolname = current_user"
        ).fetch_one(&pool).await.map_err(|e| e.to_string())?;
        if privileged {
            return Err(
                "runtime database role must not have administrative or RLS-bypass privileges"
                    .into(),
            );
        }
        let graph = Self {
            pool,
            tenant: tenant.into(),
            stream_id: stream_id.into(),
            writer_epoch: match std::env::var("ARKHE_WRITER_EPOCH") {
                Ok(value) => {
                    let epoch: u64 = value.parse().map_err(|_| "invalid ARKHE_WRITER_EPOCH")?;
                    if epoch == 0 || epoch > i64::MAX as u64 {
                        return Err("invalid ARKHE_WRITER_EPOCH".into());
                    }
                    Some(epoch)
                }
                Err(std::env::VarError::NotPresent) => None,
                Err(_) => return Err("invalid ARKHE_WRITER_EPOCH encoding".into()),
            },
        };
        // Check role memberships, schema availability, and tenant context before serving.
        for role in ["arkhe_append", "arkhe_read"] {
            let mut tx = graph.begin(role).await?;
            sqlx::query("SELECT record_hash FROM wormgraph_records LIMIT 0")
                .execute(&mut *tx)
                .await
                .map_err(|e| e.to_string())?;
            tx.commit().await.map_err(|e| e.to_string())?;
        }
        Ok(graph)
    }
    /// Opt-in writer identity. SQL additionally binds the database session login
    /// to the fence owner, so claiming another epoch alone cannot impersonate it.
    pub async fn connect_fenced(
        url: &str,
        tenant: &str,
        stream: &str,
        epoch: u64,
    ) -> Result<Self, String> {
        if epoch == 0 || epoch > i64::MAX as u64 {
            return Err("invalid writer epoch".into());
        }
        let mut graph = Self::connect_with_stream(url, tenant, stream).await?;
        graph.writer_epoch = Some(epoch);
        Ok(graph)
    }
    async fn begin(&self, role: &str) -> Result<Transaction<'_, Postgres>, String> {
        let mut tx = self.pool.begin().await.map_err(|e| e.to_string())?;
        let stmt = match role {
            "arkhe_append" => "SET LOCAL ROLE arkhe_append",
            "arkhe_read" => "SET LOCAL ROLE arkhe_read",
            _ => return Err("invalid storage role".into()),
        };
        sqlx::query(stmt)
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        arkhe_sql::tenant::set_tenant(&mut tx, &self.tenant)
            .await
            .map_err(|e| e.to_string())?;
        if role == "arkhe_append" {
            sqlx::query("SELECT set_config('arkhe.writer_epoch', $1, true)")
                .bind(self.writer_epoch.map(|v| v.to_string()).unwrap_or_default())
                .execute(&mut *tx)
                .await
                .map_err(|e| e.to_string())?;
        }
        Ok(tx)
    }
    pub async fn health(&self) -> Result<(), String> {
        let mut tx = self.begin("arkhe_read").await?;
        sqlx::query("SELECT record_hash FROM wormgraph_records LIMIT 0")
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())
    }

    pub async fn load_checkpoint(
        &self,
        stream_id: &str,
        leaf_count: u64,
    ) -> Result<Option<CheckpointBinding>, String> {
        if stream_id != self.stream_id {
            return Err("checkpoint stream does not match configured stream".into());
        }
        let leaf_count = i64::try_from(leaf_count)
            .map_err(|_| "checkpoint leaf_count exceeds bigint".to_string())?;
        let mut tx = self.begin("arkhe_read").await?;
        let row = sqlx::query(
            "SELECT leaf_count, mmr_size, mmr_root, peaks, profile_digest, covered_up_to_hash
             FROM mmr_checkpoints
             WHERE tenant_id=$1 AND stream_id=$2 AND leaf_count=$3",
        )
        .bind(&self.tenant)
        .bind(stream_id)
        .bind(leaf_count)
        .fetch_optional(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())?;

        row.map(|row| checkpoint_from_row(&row, &self.tenant, stream_id))
            .transpose()
    }

    pub async fn load_latest_checkpoint(
        &self,
        stream_id: &str,
    ) -> Result<Option<CheckpointBinding>, String> {
        if stream_id != self.stream_id {
            return Err("checkpoint stream does not match configured stream".into());
        }
        let mut tx = self.begin("arkhe_read").await?;
        let row = sqlx::query(
            "SELECT leaf_count, mmr_size, mmr_root, peaks, profile_digest, covered_up_to_hash
             FROM mmr_checkpoints
             WHERE tenant_id=$1 AND stream_id=$2
             ORDER BY leaf_count DESC
             LIMIT 1",
        )
        .bind(&self.tenant)
        .bind(stream_id)
        .fetch_optional(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())?;

        row.map(|row| checkpoint_from_row(&row, &self.tenant, stream_id))
            .transpose()
    }

    pub async fn load_anchored_checkpoint<A: CheckpointAnchor + ?Sized>(
        &self,
        stream_id: &str,
        leaf_count: u64,
        anchor: &A,
    ) -> Result<AnchoredCheckpoint, String> {
        let checkpoint = self
            .load_checkpoint(stream_id, leaf_count)
            .await?
            .ok_or_else(|| "checkpoint not found".to_string())?;
        anchor_checkpoint(checkpoint, anchor)
            .await
            .map_err(|error| error.0)
    }

    pub async fn load_latest_anchored_checkpoint<A: CheckpointAnchor + ?Sized>(
        &self,
        stream_id: &str,
        anchor: &A,
    ) -> Result<AnchoredCheckpoint, String> {
        let checkpoint = self
            .load_latest_checkpoint(stream_id)
            .await?
            .ok_or_else(|| "checkpoint not found".to_string())?;
        anchor_checkpoint(checkpoint, anchor)
            .await
            .map_err(|error| error.0)
    }

    pub async fn canonical_object(
        &self,
        kind: &str,
        digest: Digest32,
    ) -> Result<Option<Vec<u8>>, String> {
        let mut tx = self.begin("arkhe_read").await?;
        let result = sqlx::query_scalar("SELECT canonical_bytes FROM work_objects WHERE tenant_id=$1 AND object_type=$2 AND object_digest=$3")
            .bind(&self.tenant).bind(kind).bind(digest.0.to_vec())
            .fetch_optional(&mut *tx).await.map_err(|e| e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(result)
    }
    async fn require_parents(
        &self,
        tx: &mut Transaction<'_, Postgres>,
        refs: &[Digest32],
    ) -> Result<(), String> {
        for parent in refs {
            let exists: bool = sqlx::query_scalar("SELECT EXISTS(SELECT 1 FROM wormgraph_records WHERE tenant_id=$1 AND record_hash=$2)")
                .bind(&self.tenant).bind(parent.0.to_vec()).fetch_one(&mut **tx)
                .await.map_err(|e| e.to_string())?;
            if !exists {
                return Err("evidence parent is not readable in this tenant".into());
            }
        }
        Ok(())
    }
    async fn insert_envelope(
        &self,
        tx: &mut Transaction<'_, Postgres>,
        evidence: &EvidenceEnvelope,
    ) -> Result<(), String> {
        sqlx::query("SELECT pg_advisory_xact_lock(hashtextextended($1,0))")
            .bind(format!("arkhe:wormgraph:{}", self.tenant))
            .execute(&mut **tx)
            .await
            .map_err(|e| e.to_string())?;
        self.require_parents(tx, &evidence.causal_parents).await?;
        let json = serde_json::to_value(evidence).map_err(|e| e.to_string())?;
        sqlx::query("INSERT INTO wormgraph_records(tenant_id,record_hash,envelope) VALUES($1,$2,$3) ON CONFLICT (tenant_id,record_hash) DO NOTHING")
            .bind(&self.tenant).bind(evidence.record_hash.0.to_vec()).bind(&json)
            .execute(&mut **tx).await.map_err(|e| e.to_string())?;
        let stored: serde_json::Value = sqlx::query_scalar(
            "SELECT envelope FROM wormgraph_records WHERE tenant_id=$1 AND record_hash=$2",
        )
        .bind(&self.tenant)
        .bind(evidence.record_hash.0.to_vec())
        .fetch_one(&mut **tx)
        .await
        .map_err(|e| e.to_string())?;
        if stored != json {
            return Err("same record_hash bound to different envelope".into());
        }
        Ok(())
    }
    /// Only a trusted admission verifier may call this after provenance checks.
    /// Canonical WER and envelope commit atomically and idempotently.
    pub async fn commit_verified_worker(
        &self,
        worker: &WorkerExecutionRecord,
    ) -> Result<Digest32, String> {
        let hash = worker.digest();
        let evidence = EvidenceEnvelope {
            record_hash: hash,
            kind: "WorkerExecutionRecord".into(),
            subject: worker.input_digest,
            payload_digest: hash,
            policy_digest: None,
            causal_parents: worker.evidence_refs.clone(),
        };
        let mut tx = self.begin("arkhe_append").await?;
        self.insert_object(&mut tx, "WorkerExecutionRecord", worker)
            .await?;
        self.insert_envelope(&mut tx, &evidence).await?;
        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(hash)
    }
    async fn insert_object<T: CanonicalEncode>(
        &self,
        tx: &mut Transaction<'_, Postgres>,
        kind: &str,
        object: &T,
    ) -> Result<(), String> {
        let bytes = object.canonical_bytes();
        let digest = object.object_digest();
        sqlx::query("INSERT INTO work_objects(tenant_id,object_type,object_digest,canonical_bytes) VALUES($1,$2,$3,$4) ON CONFLICT (tenant_id,object_type,object_digest) DO NOTHING")
            .bind(&self.tenant).bind(kind).bind(digest.0.to_vec()).bind(&bytes)
            .execute(&mut **tx).await.map_err(|e| e.to_string())?;
        let stored: Vec<u8> = sqlx::query_scalar("SELECT canonical_bytes FROM work_objects WHERE tenant_id=$1 AND object_type=$2 AND object_digest=$3")
            .bind(&self.tenant).bind(kind).bind(digest.0.to_vec())
            .fetch_one(&mut **tx).await.map_err(|e| e.to_string())?;
        if stored != bytes {
            return Err("object digest already bound to different canonical bytes".into());
        }
        Ok(())
    }
}

#[async_trait]
impl OrderedRecordSource for PgWormGraph {
    async fn prefix(
        &self,
        tenant_id: &str,
        stream_id: &str,
        limit: u64,
    ) -> Result<Vec<SequencedRecord>, SourceError> {
        if tenant_id != self.tenant {
            return Err(SourceError("tenant does not match store".into()));
        }
        if stream_id != self.stream_id {
            return Err(SourceError(
                "wormgraph_records has no stream dimension; configured stream does not match"
                    .into(),
            ));
        }
        let limit =
            i64::try_from(limit).map_err(|_| SourceError("record limit exceeds bigint".into()))?;
        let mut tx = self.begin("arkhe_read").await.map_err(SourceError)?;
        let rows = sqlx::query(
            "SELECT append_sequence, record_hash
             FROM wormgraph_records
             WHERE tenant_id=$1
             ORDER BY append_sequence ASC
             LIMIT $2",
        )
        .bind(&self.tenant)
        .bind(limit)
        .fetch_all(&mut *tx)
        .await
        .map_err(|error| SourceError(error.to_string()))?;
        tx.commit()
            .await
            .map_err(|error| SourceError(error.to_string()))?;

        rows.iter()
            .map(|row| {
                let sequence: i64 = row
                    .try_get("append_sequence")
                    .map_err(|error| SourceError(error.to_string()))?;
                let sequence = u64::try_from(sequence)
                    .map_err(|_| SourceError("negative append_sequence".into()))?;
                let hash: Vec<u8> = row
                    .try_get("record_hash")
                    .map_err(|error| SourceError(error.to_string()))?;
                let record_hash = digest_from_bytes(&hash, "record_hash").map_err(SourceError)?;
                Ok(SequencedRecord {
                    append_sequence: sequence,
                    record_hash,
                })
            })
            .collect()
    }
}

fn checkpoint_from_row(
    row: &PgRow,
    tenant_id: &str,
    stream_id: &str,
) -> Result<CheckpointBinding, String> {
    let leaf_count: i64 = row.try_get("leaf_count").map_err(|e| e.to_string())?;
    let mmr_size: i64 = row.try_get("mmr_size").map_err(|e| e.to_string())?;
    let root: Vec<u8> = row.try_get("mmr_root").map_err(|e| e.to_string())?;
    let raw_peaks: Vec<Vec<u8>> = row.try_get("peaks").map_err(|e| e.to_string())?;
    let profile_digest: Vec<u8> = row.try_get("profile_digest").map_err(|e| e.to_string())?;
    let covered_up_to: Vec<u8> = row
        .try_get("covered_up_to_hash")
        .map_err(|e| e.to_string())?;

    let checkpoint = CheckpointBinding {
        tenant_id: tenant_id.into(),
        stream_id: stream_id.into(),
        leaf_count: non_negative_u64(leaf_count, "leaf_count")?,
        mmr_size: non_negative_u64(mmr_size, "mmr_size")?,
        root: digest_from_bytes(&root, "mmr_root")?,
        peaks: raw_peaks
            .iter()
            .map(|peak| digest_from_bytes(peak, "peaks"))
            .collect::<Result<Vec<_>, _>>()?,
        profile_digest: digest_from_bytes(&profile_digest, "profile_digest")?,
        covered_up_to: digest_from_bytes(&covered_up_to, "covered_up_to_hash")?,
    };
    checkpoint
        .validate()
        .map_err(|reason| format!("invalid checkpoint: {reason:?}"))?;
    Ok(checkpoint)
}

fn non_negative_u64(value: i64, field: &str) -> Result<u64, String> {
    u64::try_from(value).map_err(|_| format!("negative {field}"))
}

fn digest_from_bytes(bytes: &[u8], field: &str) -> Result<Digest32, String> {
    let bytes: [u8; 32] = bytes
        .try_into()
        .map_err(|_| format!("{field} must be 32 bytes"))?;
    Ok(Digest32(bytes))
}

#[async_trait]
impl EvidenceReader for PgWormGraph {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        let mut tx = self.begin("arkhe_read").await?;
        let value: Option<serde_json::Value> = sqlx::query_scalar(
            "SELECT envelope FROM wormgraph_records WHERE tenant_id=$1 AND record_hash=$2",
        )
        .bind(&self.tenant)
        .bind(hash.0.to_vec())
        .fetch_optional(&mut *tx)
        .await
        .map_err(|e| e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())?;
        let envelope: Option<EvidenceEnvelope> = value
            .map(serde_json::from_value)
            .transpose()
            .map_err(|e| e.to_string())?;
        if envelope.as_ref().is_some_and(|e| e.record_hash != hash) {
            return Err("stored envelope has inconsistent record hash".into());
        }
        Ok(envelope)
    }
}
#[async_trait]
impl EvidenceCommitter for PgWormGraph {
    async fn append_verified(&self, evidence: EvidenceEnvelope) -> Result<Digest32, String> {
        let mut tx = self.begin("arkhe_append").await?;
        self.insert_envelope(&mut tx, &evidence).await?;
        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(evidence.record_hash)
    }
}
#[async_trait]
impl WorkEvidenceCommitter for PgWormGraph {
    async fn commit_work(
        &self,
        intent: &WorkIntent,
        worker: &WorkerExecutionRecord,
        evidence: EvidenceEnvelope,
    ) -> Result<Digest32, String> {
        if worker.input_digest != intent.digest()
            || evidence.kind != "work-authorization"
            || evidence.subject != intent.digest()
            || evidence.payload_digest != worker.digest()
            || evidence.policy_digest.is_none()
            || evidence.causal_parents != worker.evidence_refs
        {
            return Err("inconsistent work admission".into());
        }
        let mut tx = self.begin("arkhe_append").await?;
        self.require_parents(&mut tx, &intent.context_refs).await?;
        self.insert_object(&mut tx, "WorkIntent", intent).await?;
        self.insert_object(&mut tx, "WorkerExecutionRecord", worker)
            .await?;
        self.insert_envelope(&mut tx, &evidence).await?;
        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(evidence.record_hash)
    }
}
