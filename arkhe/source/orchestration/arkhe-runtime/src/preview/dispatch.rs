//! Fenced operational leases. Only pre-dispatch failures can retry automatically.
use super::PreviewRequest;
use arkhe_core::Digest32;
use serde::Serialize;
use sqlx::{PgPool, Postgres, Row, Transaction};
use uuid::Uuid;

pub struct PreviewQueue {
    pool: PgPool,
    tenant: String,
}
pub struct Lease {
    pub request: PreviewRequest,
    pub bundle_digest: Digest32,
    pub fence: i64,
    pub attempts: i32,
    owner: Uuid,
}
#[derive(Debug, Serialize)]
pub struct DispatchStatus {
    pub operation_id: String,
    pub state: String,
    pub attempts: i32,
    pub fence: i64,
    pub result: Option<serde_json::Value>,
}
pub enum Completion {
    Succeeded(serde_json::Value),
    Failed(String),
    Unknown(String),
    Retry(String),
}
impl PreviewQueue {
    pub async fn connect(url: &str, tenant: &str) -> Result<Self, String> {
        if tenant.trim().is_empty() {
            return Err("tenant required".into());
        }
        let pool = sqlx::postgres::PgPoolOptions::new()
            .max_connections(6)
            .acquire_timeout(std::time::Duration::from_secs(5))
            .connect(url)
            .await
            .map_err(|_| "preview database unavailable")?;
        let privileged: bool = sqlx::query_scalar("SELECT rolsuper OR rolbypassrls OR rolcreatedb OR rolcreaterole FROM pg_roles WHERE rolname=current_user")
            .fetch_one(&pool).await.map_err(|_|"preview role unavailable")?;
        if privileged {
            return Err("preview worker refuses administrative database roles".into());
        }
        Ok(Self {
            pool,
            tenant: tenant.into(),
        })
    }
    async fn begin(&self) -> Result<Transaction<'_, Postgres>, String> {
        let mut tx = self.pool.begin().await.map_err(db)?;
        sqlx::query("SET LOCAL ROLE arkhe_preview_execute")
            .execute(&mut *tx)
            .await
            .map_err(db)?;
        arkhe_sql::tenant::set_tenant(&mut tx, &self.tenant)
            .await
            .map_err(|e| e.to_string())?;
        Ok(tx)
    }
    pub async fn claim(&self, seconds: i32) -> Result<Option<Lease>, String> {
        self.claim_scoped(None, seconds).await
    }
    pub async fn claim_for(&self, actor: &str, seconds: i32) -> Result<Option<Lease>, String> {
        if actor.trim().is_empty() {
            return Err("worker actor required".into());
        }
        self.claim_scoped(Some(actor), seconds).await
    }
    async fn claim_scoped(
        &self,
        actor: Option<&str>,
        seconds: i32,
    ) -> Result<Option<Lease>, String> {
        if !(10..=300).contains(&seconds) {
            return Err("lease must be 10..300 seconds".into());
        }
        let mut tx = self.begin().await?;
        sqlx::query("INSERT INTO preview_dispatches(tenant_id,requested_by,operation_id) SELECT tenant_id,requested_by,operation_id FROM preview_jobs ON CONFLICT DO NOTHING").execute(&mut *tx).await.map_err(db)?;
        // An expired RUNNING job may have had an effect: never reclaim it.
        let expired=sqlx::query("UPDATE preview_dispatches SET state=CASE WHEN state='RUNNING' THEN 'UNKNOWN' ELSE 'DEAD' END,owner_token=NULL,lease_until=NULL,result='\"lease expired\"'::jsonb,updated_at=clock_timestamp() WHERE lease_until<=clock_timestamp() AND (state='RUNNING' OR (state='LEASED' AND attempts>=3)) RETURNING requested_by,operation_id,fence,state")
            .fetch_all(&mut *tx).await.map_err(db)?;
        for row in expired {
            event(
                &mut tx,
                &self.tenant,
                row.get("requested_by"),
                row.get("operation_id"),
                row.get("fence"),
                row.get("state"),
                serde_json::json!({"reason":"lease expired; no automatic redispatch"}),
            )
            .await?;
        }
        let row=sqlx::query("SELECT requested_by,operation_id FROM preview_dispatches WHERE ($1::text IS NULL OR requested_by=$1) AND attempts<3 AND available_at<=clock_timestamp() AND (state IN ('READY','RETRY') OR (state='LEASED' AND lease_until<=clock_timestamp())) ORDER BY available_at,operation_id FOR UPDATE SKIP LOCKED LIMIT 1")
            .bind(actor).fetch_optional(&mut *tx).await.map_err(db)?;
        let Some(row) = row else {
            tx.commit().await.map_err(db)?;
            return Ok(None);
        };
        let actor: String = row.get("requested_by");
        let op: Vec<u8> = row.get("operation_id");
        let owner = Uuid::new_v4();
        let row=sqlx::query("UPDATE preview_dispatches SET state='LEASED',attempts=attempts+1,fence=fence+1,owner_token=$3,lease_until=clock_timestamp()+make_interval(secs=>$4),updated_at=clock_timestamp(),result=NULL WHERE requested_by=$1 AND operation_id=$2 RETURNING fence,attempts")
            .bind(&actor).bind(&op).bind(owner).bind(f64::from(seconds)).fetch_one(&mut *tx).await.map_err(db)?;
        let fence: i64 = row.get("fence");
        let attempts: i32 = row.get("attempts");
        let row=sqlx::query("SELECT bundle,bundle_digest FROM preview_admissions WHERE requested_by=$1 AND operation_id=$2").bind(&actor).bind(&op).fetch_one(&mut *tx).await.map_err(db)?;
        let value: serde_json::Value = row.get("bundle");
        let request: PreviewRequest =
            serde_json::from_value(value.clone()).map_err(|_| "corrupt preview request")?;
        let raw: Vec<u8> = row.get("bundle_digest");
        let digest = Digest32(raw.try_into().map_err(|_| "invalid bundle digest")?);
        let actual = Digest32::blake3(
            b"AKG:PREVIEW:ADMISSION:v1\0",
            &arkhe_core::canonical::encode_value(&value),
        );
        if actual != digest
            || request.spec.tenant != self.tenant
            || request.intent.requested_by != actor
            || request.intent.operation_id().0.as_slice() != op
        {
            return Err("stored preview binding mismatch".into());
        }
        event(
            &mut tx,
            &self.tenant,
            &actor,
            &op,
            fence,
            "LEASED",
            serde_json::json!({"attempt":attempts}),
        )
        .await?;
        tx.commit().await.map_err(db)?;
        Ok(Some(Lease {
            request,
            bundle_digest: digest,
            fence,
            attempts,
            owner,
        }))
    }
    pub async fn heartbeat(&self, l: &Lease, seconds: i32) -> Result<bool, String> {
        if !(10..=300).contains(&seconds) {
            return Err("invalid lease duration".into());
        }
        self.update_lease(l,"UPDATE preview_dispatches SET lease_until=clock_timestamp()+make_interval(secs=>$5),updated_at=clock_timestamp() WHERE requested_by=$1 AND operation_id=$2 AND owner_token=$3 AND fence=$4 AND state IN ('LEASED','RUNNING') AND lease_until>clock_timestamp()",Some(seconds)).await
    }
    async fn update_lease(
        &self,
        l: &Lease,
        sql: &str,
        seconds: Option<i32>,
    ) -> Result<bool, String> {
        let mut tx = self.begin().await?;
        let query = sqlx::query(sql)
            .bind(&l.request.intent.requested_by)
            .bind(l.request.intent.operation_id().0.to_vec())
            .bind(l.owner)
            .bind(l.fence);
        let query = if let Some(s) = seconds {
            query.bind(f64::from(s))
        } else {
            query
        };
        let n = query.execute(&mut *tx).await.map_err(db)?.rows_affected();
        tx.commit().await.map_err(db)?;
        Ok(n == 1)
    }
    pub async fn start(&self, l: &Lease) -> Result<bool, String> {
        let mut tx = self.begin().await?;
        let n=sqlx::query("UPDATE preview_dispatches SET state='RUNNING',updated_at=clock_timestamp() WHERE requested_by=$1 AND operation_id=$2 AND owner_token=$3 AND fence=$4 AND state='LEASED' AND lease_until>clock_timestamp()")
            .bind(&l.request.intent.requested_by).bind(l.request.intent.operation_id().0.to_vec()).bind(l.owner).bind(l.fence).execute(&mut *tx).await.map_err(db)?.rows_affected();
        if n == 1 {
            event(
                &mut tx,
                &self.tenant,
                &l.request.intent.requested_by,
                &l.request.intent.operation_id().0,
                l.fence,
                "RUNNING",
                serde_json::json!({"bundle_digest":l.bundle_digest.to_hex()}),
            )
            .await?;
        }
        tx.commit().await.map_err(db)?;
        Ok(n == 1)
    }
    pub async fn finish(&self, l: &Lease, outcome: Completion) -> Result<bool, String> {
        let (state, details, retry) = match outcome {
            Completion::Succeeded(v) => ("SUCCEEDED", v, false),
            Completion::Failed(e) => ("FAILED", serde_json::json!({"reason":e}), false),
            Completion::Unknown(e) => ("UNKNOWN", serde_json::json!({"reason":e}), false),
            Completion::Retry(e) => (
                if l.attempts >= 3 { "DEAD" } else { "RETRY" },
                serde_json::json!({"reason":e}),
                true,
            ),
        };
        let mut tx = self.begin().await?;
        let n=sqlx::query("UPDATE preview_dispatches SET state=$5,owner_token=NULL,lease_until=NULL,result=$6,available_at=clock_timestamp()+make_interval(secs=>$7),updated_at=clock_timestamp() WHERE requested_by=$1 AND operation_id=$2 AND owner_token=$3 AND fence=$4 AND lease_until>clock_timestamp() AND (state='LEASED' OR (state='RUNNING' AND NOT $8))")
            .bind(&l.request.intent.requested_by).bind(l.request.intent.operation_id().0.to_vec()).bind(l.owner).bind(l.fence).bind(state).bind(&details).bind(f64::from(2i32.pow(l.attempts as u32))).bind(retry)
            .execute(&mut *tx).await.map_err(db)?.rows_affected();
        if n == 1 {
            event(
                &mut tx,
                &self.tenant,
                &l.request.intent.requested_by,
                &l.request.intent.operation_id().0,
                l.fence,
                state,
                details,
            )
            .await?;
        }
        tx.commit().await.map_err(db)?;
        Ok(n == 1)
    }
    pub async fn status(
        &self,
        actor: &str,
        operation: Digest32,
    ) -> Result<Option<DispatchStatus>, String> {
        let mut tx = self.begin().await?;
        let row=sqlx::query("SELECT d.state,d.attempts,d.fence,d.result FROM preview_jobs j LEFT JOIN preview_dispatches d USING(tenant_id,requested_by,operation_id) WHERE j.requested_by=$1 AND j.operation_id=$2").bind(actor).bind(operation.0.to_vec()).fetch_optional(&mut *tx).await.map_err(db)?;
        let result = row.map(|r| DispatchStatus {
            operation_id: operation.to_hex(),
            state: r
                .get::<Option<String>, _>("state")
                .unwrap_or("PENDING".into()),
            attempts: r.get::<Option<i32>, _>("attempts").unwrap_or(0),
            fence: r.get::<Option<i64>, _>("fence").unwrap_or(0),
            result: r.get("result"),
        });
        tx.commit().await.map_err(db)?;
        Ok(result)
    }
}
async fn event(
    tx: &mut Transaction<'_, Postgres>,
    tenant: &str,
    actor: &str,
    op: &[u8],
    fence: i64,
    state: &str,
    details: serde_json::Value,
) -> Result<(), String> {
    sqlx::query("INSERT INTO preview_execution_events(tenant_id,requested_by,operation_id,event_id,fence,state,details) VALUES($1,$2,$3,$4,$5,$6,$7)").bind(tenant).bind(actor).bind(op).bind(Uuid::new_v4()).bind(fence).bind(state).bind(details).execute(&mut **tx).await.map_err(db)?;
    Ok(())
}
fn db(_: sqlx::Error) -> String {
    "preview dispatch database operation failed".into()
}
