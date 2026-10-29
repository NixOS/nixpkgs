use crate::{error::ArkheSqlError, mmr::profile::PROFILE_DIGEST_HEX};
use sqlx::{Postgres, Transaction};

// Keep the established SQL adapter call contract; all fields are persisted together.
#[allow(clippy::too_many_arguments)]
pub async fn insert_checkpoint(
    tx: &mut Transaction<'_, Postgres>,
    tenant_id: &str,
    stream_id: &str,
    leaf_count: i64,
    mmr_size: i64,
    mmr_root: &[u8],
    peaks: &[Vec<u8>],
    covered_up_to_hash: &[u8],
) -> Result<(), ArkheSqlError> {
    if mmr_root.len() != 32 || covered_up_to_hash.len() != 32 {
        return Err(ArkheSqlError::InvalidMmrCheckpoint(
            "root and covered hash must be 32 bytes".into(),
        ));
    }

    let profile_digest = hex::decode(PROFILE_DIGEST_HEX)
        .map_err(|e| ArkheSqlError::InvalidMmrCheckpoint(e.to_string()))?;

    sqlx::query(
        r#"
        INSERT INTO mmr_checkpoints (
            tenant_id, stream_id, leaf_count, mmr_size, mmr_root, peaks,
            profile_digest, covered_up_to_hash
        ) VALUES ($1,$2,$3,$4,$5,$6,$7,$8)
        "#,
    )
    .bind(tenant_id)
    .bind(stream_id)
    .bind(leaf_count)
    .bind(mmr_size)
    .bind(mmr_root)
    .bind(peaks)
    .bind(profile_digest)
    .bind(covered_up_to_hash)
    .execute(&mut **tx)
    .await?;

    Ok(())
}
