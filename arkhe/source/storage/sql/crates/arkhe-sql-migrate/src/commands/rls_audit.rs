use sqlx::PgPool;

pub async fn run(pool: &PgPool) -> anyhow::Result<()> {
    let bad_roles: i64 = sqlx::query_scalar(
        r#"
        SELECT count(*)
        FROM pg_roles
        WHERE rolname IN ('arkhe_append','arkhe_read','arkhe_operations')
          AND (rolsuper OR rolbypassrls)
        "#,
    )
    .fetch_one(pool)
    .await?;

    anyhow::ensure!(bad_roles == 0, "runtime/read role bypasses RLS");

    let bad_tables: i64 = sqlx::query_scalar(
        r#"
        SELECT count(*)
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE n.nspname = 'public'
          AND c.relname IN (
            'usage_events','verification_records','idempotency_keys',
            'intents','branch_states','finding_dispositions','mmr_checkpoints',
            'work_objects','wormgraph_records','operation_journal','bugbounty_operational_log','worker_receipts','manual_reconciliation_requests',
            'memo_observation_packages'
          )
          AND (NOT c.relrowsecurity OR NOT c.relforcerowsecurity)
        "#,
    )
    .fetch_one(pool)
    .await?;

    anyhow::ensure!(bad_tables == 0, "tenant table missing ENABLE/FORCE RLS");
    Ok(())
}
