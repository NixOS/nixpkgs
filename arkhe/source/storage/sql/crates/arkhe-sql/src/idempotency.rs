use crate::error::ArkheSqlError;
use sqlx::{Postgres, Transaction};
use uuid::Uuid;

/// Claims an operation-scoped idempotency key.
///
/// Same key + same request_digest => replay, returns existing operation_id.
/// Same key + different request_digest => hard conflict.
pub async fn claim(
    tx: &mut Transaction<'_, Postgres>,
    tenant_id: &str,
    operation_type: &str,
    idempotency_key: &str,
    request_digest: &[u8],
) -> Result<Uuid, ArkheSqlError> {
    let inserted: Option<Uuid> = sqlx::query_scalar(
        r#"
        INSERT INTO idempotency_keys
            (tenant_id, operation_type, idempotency_key, request_digest)
        VALUES ($1, $2, $3, $4)
        ON CONFLICT (tenant_id, operation_type, idempotency_key) DO NOTHING
        RETURNING operation_id
        "#,
    )
    .bind(tenant_id)
    .bind(operation_type)
    .bind(idempotency_key)
    .bind(request_digest)
    .fetch_optional(&mut **tx)
    .await?;

    if let Some(id) = inserted {
        return Ok(id);
    }

    let (operation_id, existing_digest): (Uuid, Vec<u8>) = sqlx::query_as(
        r#"
        SELECT operation_id, request_digest
        FROM idempotency_keys
        WHERE tenant_id = $1
          AND operation_type = $2
          AND idempotency_key = $3
        "#,
    )
    .bind(tenant_id)
    .bind(operation_type)
    .bind(idempotency_key)
    .fetch_one(&mut **tx)
    .await?;

    if existing_digest != request_digest {
        return Err(ArkheSqlError::IdempotencyConflict);
    }

    Ok(operation_id)
}
