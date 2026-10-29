use arkhe_sql::{pool::connect, tenant::set_tenant};

#[tokio::test]
async fn missing_tenant_context_fails_loudly() {
    let url = std::env::var("ARKHE_TEST_DATABASE_URL")
        .or_else(|_| std::env::var("DATABASE_URL"))
        .expect("postgres-integration requires a migrated real PostgreSQL database");
    let pool = connect(&url, 2).await.unwrap();
    let mut tx = pool.begin().await.unwrap();

    let err = sqlx::query("SELECT arkhe_assert_tenant()")
        .execute(&mut *tx)
        .await
        .unwrap_err();

    assert!(err.to_string().contains("app.tenant_id is not set"));
}

#[tokio::test]
async fn tenant_context_can_be_transaction_local() {
    let url = std::env::var("ARKHE_TEST_DATABASE_URL")
        .or_else(|_| std::env::var("DATABASE_URL"))
        .expect("postgres-integration requires a migrated real PostgreSQL database");
    let pool = connect(&url, 2).await.unwrap();
    let mut tx = pool.begin().await.unwrap();

    set_tenant(&mut tx, "tenant-a").await.unwrap();

    let tid: String = sqlx::query_scalar("SELECT arkhe_assert_tenant()")
        .fetch_one(&mut *tx)
        .await
        .unwrap();

    assert_eq!(tid, "tenant-a");
}
