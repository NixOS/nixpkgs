//! Tenant-scoped production storage ports. No implicit provenance verifier.
use crate::{
    journal::{Claim, Journal},
    Error, Kernel, OperationalLog,
};
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    work::WorkIntent,
    worker::WorkerExecutionRecord,
    Digest32,
};
use arkhe_wormgraph::postgres::PgWormGraph;
use async_trait::async_trait;
use sqlx::{PgPool, Postgres, Transaction};
use uuid::Uuid;

pub struct PgOperations {
    pool: PgPool,
    tenant: String,
}
impl PgOperations {
    pub async fn connect(url: &str, tenant: &str) -> Result<Self, Error> {
        if tenant.trim().is_empty() {
            return Err(Error::Journal("tenant required".into()));
        }
        let pool = sqlx::postgres::PgPoolOptions::new()
            .max_connections(5)
            .acquire_timeout(std::time::Duration::from_secs(5))
            .connect(url)
            .await
            .map_err(db)?;
        let privileged:bool=sqlx::query_scalar("SELECT rolsuper OR rolbypassrls OR rolcreaterole OR rolcreatedb FROM pg_roles WHERE rolname=current_user").fetch_one(&pool).await.map_err(db)?;
        if privileged {
            return Err(Error::Journal("runtime role must not bypass RLS".into()));
        }
        let this = Self {
            pool,
            tenant: tenant.into(),
        };
        let mut tx = this.begin().await?;
        sqlx::query("SELECT operation_id FROM operation_journal LIMIT 0")
            .execute(&mut *tx)
            .await
            .map_err(db)?;
        tx.commit().await.map_err(db)?;
        Ok(this)
    }
    pub(crate) async fn begin(&self) -> Result<Transaction<'_, Postgres>, Error> {
        let mut tx = self.pool.begin().await.map_err(db)?;
        sqlx::query("SET LOCAL ROLE arkhe_operations")
            .execute(&mut *tx)
            .await
            .map_err(db)?;
        arkhe_sql::tenant::set_tenant(&mut tx, &self.tenant)
            .await
            .map_err(|e| Error::Journal(e.to_string()))?;
        Ok(tx)
    }
}
fn db(e: sqlx::Error) -> Error {
    Error::Journal(e.to_string())
}
#[async_trait]
impl Journal for PgOperations {
    async fn require_manual_reconciliation(
        &self,
        caller: &str,
        operation: Digest32,
        reason: &str,
    ) -> Result<(), Error> {
        let mut tx = self.begin().await?;
        sqlx::query("INSERT INTO manual_reconciliation_requests(tenant_id,requested_by,operation_id,reason) VALUES($1,$2,$3,$4) ON CONFLICT DO NOTHING")
            .bind(&self.tenant).bind(caller).bind(operation.0.to_vec()).bind(reason).execute(&mut *tx).await.map_err(db)?;
        tx.commit().await.map_err(db)?;
        Ok(())
    }

    async fn claim(&self, i: &WorkIntent) -> Result<Claim, Error> {
        let mut tx = self.begin().await?;
        let owner = Uuid::new_v4();
        let inserted:Option<Uuid>=sqlx::query_scalar("INSERT INTO operation_journal(tenant_id,requested_by,operation_id,request_identity,intent_type,target_digest,parameters_digest,owner_token,status) VALUES($1,$2,$3,$4,$5,$6,$7,$8,'PREPARED') ON CONFLICT DO NOTHING RETURNING owner_token")
   .bind(&self.tenant).bind(&i.requested_by).bind(i.operation_id().0.to_vec()).bind(i.request_identity.0.0.to_vec()).bind(format!("{:?}",i.intent_type)).bind(i.target.0.to_vec()).bind(i.parameters_digest.0.to_vec()).bind(owner).fetch_optional(&mut *tx).await.map_err(db)?;
        if inserted.is_some() {
            tx.commit().await.map_err(db)?;
            return Ok(Claim::Acquired(owner));
        }
        // ON CONFLICT waits for a competing INSERT to commit; READ COMMITTED sees it here.
        let (params,status,response):(Vec<u8>,String,Option<serde_json::Value>)=sqlx::query_as("SELECT parameters_digest,status,response FROM operation_journal WHERE tenant_id=$1 AND requested_by=$2 AND operation_id=$3 FOR UPDATE")
   .bind(&self.tenant).bind(&i.requested_by).bind(i.operation_id().0.to_vec()).fetch_one(&mut *tx).await.map_err(db)?;
        if params != i.parameters_digest.0 {
            return Err(Error::ParameterMismatch);
        }
        let result = if status == "COMPLETED" {
            let r: WorkerExecutionRecord =
                serde_json::from_value(response.ok_or(Error::Uncertain)?)
                    .map_err(|e| Error::Journal(e.to_string()))?;
            if r.execution_id != i.operation_id().to_hex() {
                return Err(Error::Uncertain);
            }
            Claim::Replay(r)
        } else {
            Claim::Pending
        };
        tx.commit().await.map_err(db)?;
        Ok(result)
    }
    async fn mark_dispatched(&self, i: &WorkIntent, owner: Uuid) -> Result<(), Error> {
        let mut tx = self.begin().await?;
        let n=sqlx::query("UPDATE operation_journal SET status='DISPATCHED' WHERE tenant_id=$1 AND requested_by=$2 AND operation_id=$3 AND parameters_digest=$4 AND owner_token=$5 AND status='PREPARED'")
   .bind(&self.tenant).bind(&i.requested_by).bind(i.operation_id().0.to_vec()).bind(i.parameters_digest.0.to_vec()).bind(owner).execute(&mut *tx).await.map_err(db)?.rows_affected();
        if n != 1 {
            return Err(Error::Uncertain);
        }
        tx.commit().await.map_err(db)?;
        Ok(())
    }
    async fn complete(
        &self,
        i: &WorkIntent,
        owner: Uuid,
        r: &WorkerExecutionRecord,
    ) -> Result<(), Error> {
        if r.execution_id != i.operation_id().to_hex() {
            return Err(Error::Uncertain);
        }
        let mut tx = self.begin().await?;
        let n=sqlx::query("UPDATE operation_journal SET status='COMPLETED',response=$6,completed_at=now() WHERE tenant_id=$1 AND requested_by=$2 AND operation_id=$3 AND parameters_digest=$4 AND owner_token=$5 AND status='DISPATCHED'")
   .bind(&self.tenant).bind(&i.requested_by).bind(i.operation_id().0.to_vec()).bind(i.parameters_digest.0.to_vec()).bind(owner).bind(serde_json::to_value(r).map_err(|e|Error::Journal(e.to_string()))?).execute(&mut *tx).await.map_err(db)?.rows_affected();
        if n != 1 {
            return Err(Error::Uncertain);
        }
        tx.commit().await.map_err(db)?;
        Ok(())
    }
}
#[async_trait]
impl OperationalLog for PgOperations {
    async fn record(
        &self,
        id: &str,
        op: Option<Digest32>,
        stage: &str,
        error: &str,
    ) -> Result<(), String> {
        let mut tx = self.begin().await.map_err(|e| e.to_string())?;
        sqlx::query("INSERT INTO bugbounty_operational_log(tenant_id,event_id,report_id,operation_id,stage,error) VALUES($1,$2,$3,$4,$5,$6)")
   .bind(&self.tenant).bind(Uuid::new_v4()).bind(id).bind(op.map(|h|h.0.to_vec())).bind(stage).bind(error).execute(&mut *tx).await.map_err(|e|e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())
    }
}
/// Must verify a trusted execution receipt/signature and successful result.
/// Merely checking module_id, confidence or a self-declared hash is insufficient.
#[async_trait]
pub trait WorkerVerifier: Send + Sync {
    async fn verify(&self, record: &WorkerExecutionRecord) -> Result<(), String>;
}
pub struct PgKernel<V: WorkerVerifier> {
    graph: PgWormGraph,
    verifier: V,
}
impl<V: WorkerVerifier> PgKernel<V> {
    pub async fn connect(url: &str, tenant: &str, verifier: V) -> Result<Self, String> {
        Ok(Self {
            graph: PgWormGraph::connect(url, tenant).await?,
            verifier,
        })
    }
    pub async fn canonical_worker(&self, h: Digest32) -> Result<Option<Vec<u8>>, String> {
        self.graph
            .canonical_object("WorkerExecutionRecord", h)
            .await
    }
}
#[async_trait]
impl<V: WorkerVerifier> EvidenceReader for PgKernel<V> {
    async fn get(&self, h: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        self.graph.get(h).await
    }
}
#[async_trait]
impl<V: WorkerVerifier> Kernel for PgKernel<V> {
    async fn admit(&self, r: &WorkerExecutionRecord) -> Result<Digest32, String> {
        self.verifier.verify(r).await?;
        self.graph.commit_verified_worker(r).await
    }
}

#[async_trait]
impl crate::provenance::ReceiptReader for PgOperations {
    async fn receipts(
        &self,
        hash: Digest32,
    ) -> Result<Vec<crate::provenance::SignedWorkerReceipt>, String> {
        let mut tx = self.begin().await.map_err(|e| e.to_string())?;
        let rows:Vec<serde_json::Value>=sqlx::query_scalar("SELECT receipt FROM worker_receipts WHERE tenant_id=$1 AND record_hash=$2 ORDER BY key_id LIMIT 17")
   .bind(&self.tenant).bind(hash.0.to_vec()).fetch_all(&mut *tx).await.map_err(|e|e.to_string())?;
        tx.commit().await.map_err(|e| e.to_string())?;
        rows.into_iter()
            .map(|r| serde_json::from_value(r).map_err(|e| e.to_string()))
            .collect()
    }
}
impl PgOperations {
    /// Persist as untrusted receipt material; only SignedWorkerVerifier can authorize admission.
    pub async fn stage_receipt(
        &self,
        r: &crate::provenance::SignedWorkerReceipt,
    ) -> Result<(), Error> {
        if r.tenant != self.tenant {
            return Err(Error::Admission("receipt tenant mismatch".into()));
        }
        let value = serde_json::to_value(r).map_err(|e| Error::Admission(e.to_string()))?;
        let mut tx = self.begin().await?;
        sqlx::query("INSERT INTO worker_receipts(tenant_id,record_hash,key_id,receipt) VALUES($1,$2,$3,$4) ON CONFLICT DO NOTHING")
   .bind(&self.tenant).bind(r.record_hash.0.to_vec()).bind(&r.key_id).bind(&value).execute(&mut *tx).await.map_err(db)?;
        let stored:serde_json::Value=sqlx::query_scalar("SELECT receipt FROM worker_receipts WHERE tenant_id=$1 AND record_hash=$2 AND key_id=$3")
   .bind(&self.tenant).bind(r.record_hash.0.to_vec()).bind(&r.key_id).fetch_one(&mut *tx).await.map_err(db)?;
        if stored != value {
            return Err(Error::Admission("receipt identity conflict".into()));
        }
        tx.commit().await.map_err(db)?;
        Ok(())
    }
}

#[derive(Debug, serde::Serialize)]
pub struct ManualReconciliation {
    pub operation_id: Digest32,
    pub requested_by: String,
    pub status: String,
    pub reason: String,
    pub manual_reconciliation_required: bool,
}
impl PgOperations {
    /// Explicit failures appear immediately. Abandoned reservations appear after a grace period.
    /// This is an escalation queue, not a retry/recovery authority.
    pub async fn reconciliation_queue(
        &self,
        grace_seconds: u32,
    ) -> Result<Vec<ManualReconciliation>, Error> {
        let mut tx = self.begin().await?;
        let rows:Vec<(Vec<u8>,String,String,String)>=sqlx::query_as("SELECT j.operation_id,j.requested_by,j.status,COALESCE(r.reason,'unresolved operation exceeded grace period') FROM operation_journal j LEFT JOIN manual_reconciliation_requests r USING(tenant_id,requested_by,operation_id) WHERE j.tenant_id=$1 AND j.status!='COMPLETED' AND (r.operation_id IS NOT NULL OR j.created_at < now()-($2::bigint * interval '1 second')) ORDER BY j.created_at LIMIT 1001")
   .bind(&self.tenant).bind(i64::from(grace_seconds)).fetch_all(&mut *tx).await.map_err(db)?;
        if rows.len() > 1000 {
            return Err(Error::Journal(
                "reconciliation queue requires pagination".into(),
            ));
        }
        tx.commit().await.map_err(db)?;
        rows.into_iter()
            .map(|(op, caller, status, reason)| {
                Ok(ManualReconciliation {
                    operation_id: Digest32(
                        op.try_into().map_err(|_| {
                            Error::Journal("invalid stored operation digest".into())
                        })?,
                    ),
                    requested_by: caller,
                    status,
                    reason,
                    manual_reconciliation_required: true,
                })
            })
            .collect()
    }
    pub async fn reconciliation_metrics(&self, grace_seconds: u32) -> Result<String, Error> {
        let mut tx = self.begin().await?;
        let count:i64=sqlx::query_scalar("SELECT count(*) FROM operation_journal j LEFT JOIN manual_reconciliation_requests r USING(tenant_id,requested_by,operation_id) WHERE j.tenant_id=$1 AND j.status!='COMPLETED' AND (r.operation_id IS NOT NULL OR j.created_at < now()-($2::bigint * interval '1 second'))")
   .bind(&self.tenant).bind(i64::from(grace_seconds)).fetch_one(&mut *tx).await.map_err(db)?;
        tx.commit().await.map_err(db)?;
        let label = self
            .tenant
            .replace('\\', r"\\")
            .replace('"', r#"\""#)
            .replace('\n', r"\n");
        Ok(format!("# TYPE arkhe_bugbounty_manual_reconciliation_required gauge\narkhe_bugbounty_manual_reconciliation_required{{tenant=\"{label}\"}} {count}\n"))
    }
}
