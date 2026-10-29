//! Shared PostgreSQL authority, not independently replicated per-cloud locks.
use crate::replica::{ReplicaBundle, ReplicaTrust};
use sqlx::{PgPool, Row};
type Error = Box<dyn std::error::Error + Send + Sync>;

/// Caller must first verify the external transparency bundle for these exact
/// snapshot bytes. This native gate checks epoch, contents and latest storage
/// prefix again. An operator-only pool is required; runtime roles have no UPDATE.
pub async fn promote_after_external_anchor(
    pool: &PgPool,
    bundle: &ReplicaBundle,
    trust: &ReplicaTrust,
    login: &str,
) -> Result<u64, Error> {
    bundle.verify(trust)?;
    let epoch = i64::try_from(bundle.writer_epoch)?;
    let next = epoch.checked_add(1).ok_or("epoch exhausted")?;
    let mut tx = pool.begin().await?;
    sqlx::query("SET TRANSACTION ISOLATION LEVEL READ COMMITTED")
        .execute(&mut *tx)
        .await?;
    sqlx::query("SET LOCAL lock_timeout = '10s'")
        .execute(&mut *tx)
        .await?;
    let update=sqlx::query("UPDATE wormgraph_writer_fence SET epoch=$1,owner_login=$2::name WHERE tenant_id=$3 AND epoch=$4 AND owner_login<>$2::name AND EXISTS(SELECT 1 FROM pg_roles WHERE rolname=$2 AND rolcanlogin AND NOT rolsuper AND NOT rolbypassrls AND NOT rolcreaterole AND NOT rolcreatedb) AND pg_has_role($2,'arkhe_append','MEMBER') RETURNING epoch")
        .bind(next).bind(login).bind(&bundle.checkpoint.tenant_id).bind(epoch).fetch_optional(&mut *tx).await?;
    if update.is_none() {
        return Err("stale promotion or invalid new writer login".into());
    }
    let count: i64 =
        sqlx::query_scalar("SELECT count(*) FROM wormgraph_records WHERE tenant_id=$1")
            .bind(&bundle.checkpoint.tenant_id)
            .fetch_one(&mut *tx)
            .await?;
    if count as usize != bundle.records.len() {
        return Err("replica is not the complete committed authority prefix".into());
    }
    let latest=sqlx::query("SELECT leaf_count,mmr_root FROM mmr_checkpoints WHERE tenant_id=$1 AND stream_id=$2 ORDER BY leaf_count DESC LIMIT 1")
        .bind(&bundle.checkpoint.tenant_id).bind(&bundle.checkpoint.stream_id).fetch_one(&mut *tx).await?;
    if latest.try_get::<i64, _>("leaf_count")? as u64 != bundle.checkpoint.leaf_count
        || latest.try_get::<Vec<u8>, _>("mmr_root")? != bundle.checkpoint.root
    {
        return Err("replica does not match latest committed checkpoint".into());
    }
    tx.commit().await?;
    Ok(next as u64)
}
