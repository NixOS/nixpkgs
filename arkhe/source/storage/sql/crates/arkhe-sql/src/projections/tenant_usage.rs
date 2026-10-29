use sqlx::PgPool;

pub async fn refresh(pool: &PgPool) -> Result<(), sqlx::Error> {
    sqlx::query("REFRESH MATERIALIZED VIEW CONCURRENTLY tenant_usage_daily")
        .execute(pool)
        .await?;
    Ok(())
}
