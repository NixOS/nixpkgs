use super::{checkpoint_from_row, PgWormGraph};
use crate::{
    anchor::SignedCheckpoint,
    replica::{ReplicaBundle, ReplicaObject, ReplicaRecord},
};
use arkhe_core::evidence::EvidenceEnvelope;
use sqlx::Row;

impl PgWormGraph {
    /// One repeatable-read snapshot of checkpoint, journal, envelopes and contents.
    /// Caller signs the returned bundle; an empty signature is not ready.
    pub async fn export_replica_snapshot(
        &self,
        checkpoint: SignedCheckpoint,
    ) -> Result<ReplicaBundle, String> {
        let mut tx = self.pool.begin().await.map_err(|e| e.to_string())?;
        sqlx::query("SET TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY")
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        sqlx::query("SET LOCAL ROLE arkhe_read")
            .execute(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        arkhe_sql::tenant::set_tenant(&mut tx, &self.tenant)
            .await
            .map_err(|e| e.to_string())?;
        let epoch: i64 = sqlx::query_scalar("SELECT arkhe_writer_epoch($1)")
            .bind(&self.tenant)
            .fetch_one(&mut *tx)
            .await
            .map_err(|e| e.to_string())?;
        if checkpoint.tenant_id != self.tenant
            || checkpoint.stream_id != self.stream_id
            || checkpoint.leaf_count == 0
            || checkpoint.leaf_count > 1_000_000
        {
            return Err("export checkpoint scope or size mismatch".into());
        }
        let row = sqlx::query("SELECT leaf_count,mmr_size,mmr_root,peaks,profile_digest,covered_up_to_hash FROM mmr_checkpoints WHERE tenant_id=$1 AND stream_id=$2 AND leaf_count=$3")
            .bind(&self.tenant).bind(&self.stream_id).bind(checkpoint.leaf_count as i64)
            .fetch_one(&mut *tx).await.map_err(|e|e.to_string())?;
        if checkpoint_from_row(&row, &self.tenant, &self.stream_id)? != checkpoint.binding() {
            return Err("signed checkpoint differs from transactional checkpoint".into());
        }
        let rows = sqlx::query("SELECT append_sequence,record_hash,envelope,writer_epoch FROM wormgraph_records WHERE tenant_id=$1 ORDER BY append_sequence LIMIT $2")
            .bind(&self.tenant).bind(checkpoint.leaf_count as i64).fetch_all(&mut *tx).await.map_err(|e|e.to_string())?;
        let mut records = Vec::new();
        for row in rows {
            let envelope: EvidenceEnvelope =
                serde_json::from_value(row.try_get("envelope").map_err(|e| e.to_string())?)
                    .map_err(|e| e.to_string())?;
            let stored_hash: Vec<u8> = row.try_get("record_hash").map_err(|e| e.to_string())?;
            if stored_hash != envelope.record_hash.0 {
                return Err("journal/envelope hash mismatch".into());
            }
            let mut contents = Vec::new();
            if envelope.kind == "MemoObservationPackage/v1" {
                let bytes: Vec<u8> = sqlx::query_scalar("SELECT package_bytes FROM memo_observation_packages WHERE tenant_id=$1 AND record_hash=$2 AND stream_id=$3")
                    .bind(&self.tenant).bind(&stored_hash).bind(&self.stream_id).fetch_one(&mut *tx).await.map_err(|e|e.to_string())?;
                contents.push(ReplicaObject {
                    kind: envelope.kind.clone(),
                    digest: envelope.payload_digest,
                    bytes,
                });
            } else {
                let mut needed = vec![("WorkerExecutionRecord", envelope.payload_digest)];
                if envelope.kind == "work-authorization" {
                    needed.push(("WorkIntent", envelope.subject));
                }
                for (kind, digest) in needed {
                    let bytes: Vec<u8> = sqlx::query_scalar("SELECT canonical_bytes FROM work_objects WHERE tenant_id=$1 AND object_type=$2 AND object_digest=$3")
                        .bind(&self.tenant).bind(kind).bind(digest.0.to_vec()).fetch_one(&mut *tx).await.map_err(|e|e.to_string())?;
                    contents.push(ReplicaObject {
                        kind: kind.into(),
                        digest,
                        bytes,
                    });
                }
            }
            let sequence: i64 = row.try_get("append_sequence").map_err(|e| e.to_string())?;
            records.push(ReplicaRecord {
                append_sequence: sequence.try_into().map_err(|_| "invalid append sequence")?,
                envelope,
                contents,
                writer_epoch: row
                    .try_get::<Option<i64>, _>("writer_epoch")
                    .map_err(|e| e.to_string())?
                    .ok_or("legacy record without verified writer epoch")?
                    .try_into()
                    .map_err(|_| "invalid record epoch")?,
            });
        }
        let bundle = ReplicaBundle {
            schema: "arkhe-replica-bundle-v1".into(),
            writer_epoch: epoch.try_into().map_err(|_| "invalid epoch")?,
            checkpoint,
            records,
            signature_hex: String::new(),
        };
        bundle.verify_contents()?;
        tx.commit().await.map_err(|e| e.to_string())?;
        Ok(bundle)
    }
}
