//! Operational candidate only. No payment provider, authorization issuer or auto-retry.
use super::{
    priority::ClosedPriority,
    trust::{CheckpointTrust, SignedCheckpoint},
};
use crate::postgres::PgOperations;
use arkhe_core::{canonical::encode_value, Digest32};
use serde::{Deserialize, Serialize};
use sqlx::Row;
use uuid::Uuid;
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PayoutRequest {
    pub idempotency_key: Digest32,
    pub vulnerability_id: Digest32,
    pub recipient: [u8; 32],
    pub amount_decimal: String,
    pub asset_id: Digest32,
    pub chain_id: u64,
}
impl PayoutRequest {
    fn digest(&self, priority: &ClosedPriority) -> Digest32 {
        Digest32::blake3(
            b"AKG:PAYOUT:REQUEST:v1\0",
            &encode_value(
                &serde_json::json!({"vulnerability_id":self.vulnerability_id.to_hex(),"recipient":self.recipient,"amount_decimal":self.amount_decimal,"asset_id":self.asset_id.to_hex(),"chain_id":self.chain_id,"priority_digest":hex::encode(priority.digest())}),
            ),
        )
    }
}
#[derive(Debug, PartialEq, Eq)]
pub enum Enqueued {
    Pending,
    Replay(String),
    Uncertain,
    ParameterMismatch,
    DuplicateVulnerability,
}
pub struct Dispatch {
    pub request: PayoutRequest,
    pub owner: Uuid,
}
pub struct PgPayoutJournal {
    operations: PgOperations,
    tenant: String,
}
fn err(e: impl std::fmt::Display) -> String {
    e.to_string()
}
impl PgPayoutJournal {
    pub async fn connect(url: &str, tenant: &str) -> Result<Self, String> {
        let operations = PgOperations::connect(url, tenant).await.map_err(err)?;
        let mut tx = operations.begin().await.map_err(err)?;
        sqlx::query("SELECT idempotency_key FROM payout_jobs LIMIT 0")
            .execute(&mut *tx)
            .await
            .map_err(err)?;
        tx.commit().await.map_err(err)?;
        Ok(Self {
            operations,
            tenant: tenant.into(),
        })
    }
    /// Reservation and job insertion are one transaction/row under UNIQUE(vulnerability_id).
    /// An eligible priority is not kernel authorization; caller must enforce that separately.
    pub async fn enqueue_candidate(
        &self,
        request: &PayoutRequest,
        priority: &ClosedPriority,
    ) -> Result<Enqueued, String> {
        let amount = request
            .amount_decimal
            .parse::<u128>()
            .map_err(|_| "invalid u128 amount")?;
        if amount == 0
            || amount.to_string() != request.amount_decimal
            || request.idempotency_key == Digest32::ZERO
            || request.vulnerability_id == Digest32::ZERO
            || request.asset_id == Digest32::ZERO
            || request.chain_id == 0
            || request.recipient == [0; 32]
            || priority.vulnerability_id() != request.vulnerability_id.0
            || priority.winner().recipient != request.recipient
            || priority.winner().chain_id != request.chain_id
        {
            return Err("invalid candidate payout or priority".into());
        }
        let digest = request.digest(priority);
        let mut tx = self.operations.begin().await.map_err(err)?;
        sqlx::query("INSERT INTO payout_jobs(tenant_id,idempotency_key,vulnerability_id,parameters_digest,payload) VALUES($1,$2,$3,$4,$5) ON CONFLICT DO NOTHING").bind(&self.tenant).bind(request.idempotency_key.0.to_vec()).bind(request.vulnerability_id.0.to_vec()).bind(digest.0.to_vec()).bind(serde_json::to_value(request).map_err(err)?).execute(&mut *tx).await.map_err(err)?;
        let row=sqlx::query("SELECT parameters_digest,status,receipt FROM payout_jobs WHERE tenant_id=$1 AND idempotency_key=$2 FOR UPDATE").bind(&self.tenant).bind(request.idempotency_key.0.to_vec()).fetch_optional(&mut *tx).await.map_err(err)?;
        let result = match row {
            None => Enqueued::DuplicateVulnerability,
            Some(row) => {
                let stored: Vec<u8> = row.get("parameters_digest");
                let status: String = row.get("status");
                if stored != digest.0 {
                    Enqueued::ParameterMismatch
                } else if status == "COMPLETED" {
                    Enqueued::Replay(
                        row.get::<Option<String>, _>("receipt")
                            .ok_or("missing completion receipt")?,
                    )
                } else if status == "DISPATCHED" {
                    Enqueued::Uncertain
                } else {
                    Enqueued::Pending
                }
            }
        };
        tx.commit().await.map_err(err)?;
        Ok(result)
    }
    /// Commits DISPATCHED before returning. Abandonment is uncertain, never auto-requeued.
    pub async fn claim(&self) -> Result<Option<Dispatch>, String> {
        let mut tx = self.operations.begin().await.map_err(err)?;
        let owner = Uuid::new_v4();
        let row=sqlx::query("WITH candidate AS (SELECT tenant_id,idempotency_key FROM payout_jobs WHERE tenant_id=$1 AND status='PENDING' ORDER BY created_at,idempotency_key FOR UPDATE SKIP LOCKED LIMIT 1) UPDATE payout_jobs j SET status='DISPATCHED',owner_token=$2 FROM candidate c WHERE j.tenant_id=c.tenant_id AND j.idempotency_key=c.idempotency_key RETURNING j.payload").bind(&self.tenant).bind(owner).fetch_optional(&mut *tx).await.map_err(err)?;
        let result = row
            .map(|r| {
                serde_json::from_value::<PayoutRequest>(r.get("payload"))
                    .map(|request| Dispatch { request, owner })
            })
            .transpose()
            .map_err(err)?;
        tx.commit().await.map_err(err)?;
        Ok(result)
    }
    pub async fn complete(&self, key: Digest32, owner: Uuid, receipt: &str) -> Result<(), String> {
        if receipt.trim().is_empty() || receipt.len() > 4096 {
            return Err("invalid receipt".into());
        }
        let mut tx = self.operations.begin().await.map_err(err)?;
        let n=sqlx::query("UPDATE payout_jobs SET status='COMPLETED',receipt=$4 WHERE tenant_id=$1 AND idempotency_key=$2 AND owner_token=$3 AND status='DISPATCHED'").bind(&self.tenant).bind(key.0.to_vec()).bind(owner).bind(receipt).execute(&mut *tx).await.map_err(err)?.rows_affected();
        if n != 1 {
            return Err("unknown owner or non-dispatched payout".into());
        }
        tx.commit().await.map_err(err)
    }
    pub async fn uncertain(&self) -> Result<usize, String> {
        let mut tx = self.operations.begin().await.map_err(err)?;
        let n: i64 = sqlx::query_scalar(
            "SELECT count(*) FROM payout_jobs WHERE tenant_id=$1 AND status='DISPATCHED'",
        )
        .bind(&self.tenant)
        .fetch_one(&mut *tx)
        .await
        .map_err(err)?;
        tx.commit().await.map_err(err)?;
        Ok(n as usize)
    }
}
/// Full leaf-prefix witness, deliberately not a compact RFC6962/COSE proof.
pub struct FullPrefixConsistency {
    pub leaves: Vec<Vec<u8>>,
}
impl FullPrefixConsistency {
    pub fn verify(&self, old: &SignedCheckpoint, new: &SignedCheckpoint) -> Result<(), String> {
        if old.leaf_count == 0
            || new.leaf_count > 65536
            || old.log_id != new.log_id
            || old.leaf_count > new.leaf_count
            || self.leaves.len() != new.leaf_count as usize
            || self.leaves.len() > 65536
            || self.leaves.iter().map(Vec::len).sum::<usize>() > 16 * 1024 * 1024
        {
            return Err("invalid/oversized full-prefix consistency witness".into());
        }
        let root = |leaves: &[Vec<u8>]| {
            arkhe_verify_core::mmr::build_root_and_proof(leaves, 0)
                .map(|p| p.0)
                .map_err(err)
        };
        if root(&self.leaves[..old.leaf_count as usize])? != old.root
            || root(&self.leaves)? != new.root
        {
            return Err("checkpoint does not extend accepted prefix".into());
        }
        Ok(())
    }
}
pub struct PgCheckpointWitness {
    operations: PgOperations,
    tenant: String,
}
impl PgCheckpointWitness {
    pub async fn connect(url: &str, tenant: &str) -> Result<Self, String> {
        Ok(Self {
            operations: PgOperations::connect(url, tenant).await.map_err(err)?,
            tenant: tenant.into(),
        })
    }
    pub async fn observe(
        &self,
        checkpoint: &SignedCheckpoint,
        trust: &CheckpointTrust,
        consistency: Option<&FullPrefixConsistency>,
    ) -> Result<(), String> {
        checkpoint.verify(trust)?;
        let mut tx = self.operations.begin().await.map_err(err)?;
        sqlx::query("INSERT INTO checkpoint_witness(tenant_id,log_id,checkpoint) VALUES($1,$2,$3) ON CONFLICT DO NOTHING").bind(&self.tenant).bind(checkpoint.log_id.to_vec()).bind(serde_json::to_value(checkpoint).map_err(err)?).execute(&mut *tx).await.map_err(err)?;
        let value: serde_json::Value = sqlx::query_scalar(
            "SELECT checkpoint FROM checkpoint_witness WHERE tenant_id=$1 AND log_id=$2 FOR UPDATE",
        )
        .bind(&self.tenant)
        .bind(checkpoint.log_id.to_vec())
        .fetch_one(&mut *tx)
        .await
        .map_err(err)?;
        let old: SignedCheckpoint = serde_json::from_value(value).map_err(err)?;
        // Recheck stored signature under the current pinned key; historical freshness may differ.
        let historical = CheckpointTrust {
            log_id: trust.log_id,
            public_key: trust.public_key,
            minimum_leaf_count: 1,
            earliest_checkpoint: 0,
            latest_checkpoint: u64::MAX,
        };
        old.verify(&historical)?;
        if checkpoint.leaf_count < old.leaf_count || checkpoint.issued_at < old.issued_at {
            return Err("checkpoint rollback".into());
        }
        if checkpoint.leaf_count == old.leaf_count {
            if checkpoint.root != old.root {
                return Err("same-size checkpoint equivocation".into());
            }
        } else {
            consistency
                .ok_or("growth requires consistency witness")?
                .verify(&old, checkpoint)?;
        }
        sqlx::query("UPDATE checkpoint_witness SET checkpoint=$3 WHERE tenant_id=$1 AND log_id=$2")
            .bind(&self.tenant)
            .bind(checkpoint.log_id.to_vec())
            .bind(serde_json::to_value(checkpoint).map_err(err)?)
            .execute(&mut *tx)
            .await
            .map_err(err)?;
        tx.commit().await.map_err(err)
    }
}
