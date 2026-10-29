use crate::{error::ArkheSqlError, models::usage_event::UsageEvent};
use sqlx::{Postgres, Transaction};

pub async fn insert(
    tx: &mut Transaction<'_, Postgres>,
    event: &UsageEvent,
) -> Result<(), ArkheSqlError> {
    sqlx::query(
        r#"
        INSERT INTO usage_events (
            request_id, operation_id, tenant_id, tool_name, started_at,
            duration_ms, result, policy_digest, evidence_hash,
            estimated_cost_usd, billable_units
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10::numeric,$11)
        "#,
    )
    .bind(event.request_id)
    .bind(event.operation_id)
    .bind(&event.tenant_id)
    .bind(&event.tool_name)
    .bind(event.started_at)
    .bind(event.duration_ms)
    .bind(&event.result)
    .bind(&event.policy_digest)
    .bind(&event.evidence_hash)
    .bind(&event.estimated_cost_usd)
    .bind(event.billable_units)
    .execute(&mut **tx)
    .await?;

    Ok(())
}
