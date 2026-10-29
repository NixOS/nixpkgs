use sqlx::PgPool;

pub async fn run(pool: &PgPool) -> anyhow::Result<()> {
    let mutation_grants: i64 = sqlx::query_scalar(
        r#"
        SELECT count(*)
        FROM information_schema.role_table_grants
        WHERE grantee IN ('arkhe_append','arkhe_read')
          AND table_schema = 'public'
          AND privilege_type IN ('UPDATE','DELETE','TRUNCATE')
        "#,
    )
    .fetch_one(pool)
    .await?;

    anyhow::ensure!(
        mutation_grants == 0,
        "runtime/read role has mutation grants"
    );
    Ok(())
}
