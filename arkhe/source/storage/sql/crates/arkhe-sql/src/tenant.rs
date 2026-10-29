use crate::error::ArkheSqlError;
use sqlx::{PgConnection, Postgres, Transaction};

/// Tenant context must be transaction-local.
/// Using `set_config(..., true)` avoids leaking tenant identity through pooled connections.
pub async fn set_tenant(
    tx: &mut Transaction<'_, Postgres>,
    tenant_id: &str,
) -> Result<(), ArkheSqlError> {
    if tenant_id.is_empty() {
        return Err(ArkheSqlError::EmptyTenant);
    }

    sqlx::query("SELECT set_config('app.tenant_id', $1, true)")
        .bind(tenant_id)
        .execute(&mut **tx)
        .await?;

    // Force an explicit failure here rather than relying on silent zero-row RLS behavior.
    sqlx::query("SELECT arkhe_assert_tenant()")
        .execute(&mut **tx)
        .await?;

    Ok(())
}

#[allow(dead_code)]
pub async fn assert_tenant_connection(conn: &mut PgConnection) -> Result<(), ArkheSqlError> {
    sqlx::query("SELECT arkhe_assert_tenant()")
        .execute(conn)
        .await?;
    Ok(())
}
