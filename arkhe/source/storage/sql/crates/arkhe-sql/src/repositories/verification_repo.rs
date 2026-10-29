use crate::{error::ArkheSqlError, models::verification_record::VerificationRecord};
use sqlx::{Postgres, Transaction};

pub async fn insert(
    tx: &mut Transaction<'_, Postgres>,
    v: &VerificationRecord,
) -> Result<(), ArkheSqlError> {
    sqlx::query(
        r#"
        INSERT INTO verification_records (
            record_hash, tenant_id, intent_digest, policy_digest,
            result, canonical_bytes, created_at
        ) VALUES ($1,$2,$3,$4,$5,$6,$7)
        "#,
    )
    .bind(&v.record_hash)
    .bind(&v.tenant_id)
    .bind(&v.intent_digest)
    .bind(&v.policy_digest)
    .bind(&v.result)
    .bind(&v.canonical_bytes)
    .bind(v.created_at)
    .execute(&mut **tx)
    .await?;
    Ok(())
}
