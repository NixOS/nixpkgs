use arkhe_ask::events::PgProofJournal;
pub async fn fixture() -> (PgProofJournal, sqlx::PgPool, String) {
    let url = std::env::var("DATABASE_URL").expect("DATABASE_URL");
    let admin = sqlx::PgPool::connect(&url).await.unwrap();
    sqlx::query("CREATE EXTENSION IF NOT EXISTS vector")
        .execute(&admin)
        .await
        .unwrap();
    let schema = format!("ask_event_test_{}", uuid::Uuid::new_v4().simple());
    sqlx::query(&format!("CREATE SCHEMA {schema}"))
        .execute(&admin)
        .await
        .unwrap();
    sqlx::query(&format!("CREATE TABLE {schema}.chunks(id TEXT PRIMARY KEY,text TEXT NOT NULL,embedding vector(1536) NOT NULL)"))
        .execute(&admin).await.unwrap();
    sqlx::query(&format!("CREATE TABLE {schema}._sqlx_migrations(version BIGINT PRIMARY KEY,description TEXT NOT NULL,installed_on TIMESTAMPTZ NOT NULL DEFAULT now(),success BOOLEAN NOT NULL,checksum BYTEA NOT NULL,execution_time BIGINT NOT NULL)"))
        .execute(&admin).await.unwrap();
    let path = format!("SET search_path TO {schema}, public");
    let pool = sqlx::postgres::PgPoolOptions::new()
        .max_connections(4)
        .after_connect(move |conn, _| {
            let path = path.clone();
            Box::pin(async move {
                sqlx::query(&path).execute(conn).await?;
                Ok(())
            })
        })
        .connect(&url)
        .await
        .unwrap();
    (PgProofJournal::connect(pool).await.unwrap(), admin, schema)
}
pub async fn cleanup(journal: &PgProofJournal, admin: sqlx::PgPool, schema: String) {
    journal.pool().close().await;
    sqlx::query(&format!("DROP SCHEMA {schema} CASCADE"))
        .execute(&admin)
        .await
        .unwrap();
    admin.close().await;
}
