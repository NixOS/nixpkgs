use super::AdmittedPreview;
use arkhe_core::{canonical::encode_value, CanonicalEncode, Digest32};
use sqlx::{Postgres, Transaction};

pub(super) async fn enqueue(
    tx: &mut Transaction<'_, Postgres>,
    preview: &AdmittedPreview,
) -> Result<Digest32, String> {
    let request = &preview.request;
    let intent = &request.intent;
    let value = serde_json::to_value(request).map_err(|e| e.to_string())?;
    let bundle_digest = Digest32::blake3(b"AKG:PREVIEW:ADMISSION:v1\0", &encode_value(&value));
    let context: String = sqlx::query_scalar("SELECT arkhe_assert_tenant()")
        .fetch_one(&mut **tx)
        .await
        .map_err(|e| e.to_string())?;
    if context != request.spec.tenant {
        return Err("preview transaction tenant mismatch".into());
    }
    let fresh: bool = sqlx::query_scalar("SELECT $1::bigint > extract(epoch FROM clock_timestamp()) AND $2::bigint <= extract(epoch FROM clock_timestamp())")
        .bind(request.review.expires_at).bind(preview.admitted_at)
        .fetch_one(&mut **tx).await.map_err(|e| e.to_string())?;
    if !fresh {
        return Err("preview admission expired or clock mismatch".into());
    }
    // A conflict never overwrites the signed bundle for a logical operation.
    sqlx::query("INSERT INTO preview_admissions(tenant_id,requested_by,operation_id,bundle_digest,authorization_ref,expires_at,intent_cbor,worker_cbor,bundle) VALUES($1,$2,$3,$4,$5,$6,$7,$8,$9) ON CONFLICT DO NOTHING")
        .bind(&request.spec.tenant).bind(&intent.requested_by).bind(intent.operation_id().0.to_vec())
        .bind(bundle_digest.0.to_vec()).bind(preview.authorization_ref.0.to_vec()).bind(request.review.expires_at)
        .bind(intent.canonical_bytes()).bind(request.worker.canonical_bytes()).bind(&value)
        .execute(&mut **tx).await.map_err(|e| e.to_string())?;
    let stored: Vec<u8> = sqlx::query_scalar("SELECT bundle_digest FROM preview_admissions WHERE tenant_id=$1 AND requested_by=$2 AND operation_id=$3")
        .bind(&request.spec.tenant).bind(&intent.requested_by).bind(intent.operation_id().0.to_vec())
        .fetch_one(&mut **tx).await.map_err(|e| e.to_string())?;
    if stored != bundle_digest.0 {
        return Err("preview operation already binds another signed bundle".into());
    }
    sqlx::query("INSERT INTO preview_jobs(tenant_id,requested_by,operation_id,bundle_digest) VALUES($1,$2,$3,$4) ON CONFLICT DO NOTHING")
        .bind(&request.spec.tenant).bind(&intent.requested_by).bind(intent.operation_id().0.to_vec())
        .bind(bundle_digest.0.to_vec()).execute(&mut **tx).await.map_err(|e| e.to_string())?;
    Ok(bundle_digest)
}
