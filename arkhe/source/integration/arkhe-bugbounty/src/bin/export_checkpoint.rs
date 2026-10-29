//! Export a persisted tenant snapshot and MMR proof for offline anchoring.
use arkhe_core::{canonical::encode_value, Digest32};
use arkhe_verify_core::mmr::{
    build_root_and_proof,
    profile::{mmr_size, PROFILE_DIGEST_HEX},
};
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let url = std::env::var("DATABASE_URL")?;
    let tenant = std::env::var("ARKHE_TENANT_ID")?;
    let output = std::env::args().nth(1).ok_or("output file required")?;
    let graph = arkhe_wormgraph::postgres::PgWormGraph::connect(&url, &tenant).await?;
    graph.health().await?;
    let pool = sqlx::PgPool::connect(&url).await?;
    let mut tx = pool.begin().await?;
    sqlx::query("SET LOCAL ROLE arkhe_append")
        .execute(&mut *tx)
        .await?;
    arkhe_sql::tenant::set_tenant(&mut tx, &tenant).await?;
    sqlx::query("SELECT pg_advisory_xact_lock(hashtextextended($1,0))")
        .bind(format!("arkhe:wormgraph:{tenant}"))
        .execute(&mut *tx)
        .await?;
    let leaves: Vec<Vec<u8>> = sqlx::query_scalar(
        "SELECT record_hash FROM wormgraph_records WHERE tenant_id=$1 ORDER BY append_sequence",
    )
    .bind(&tenant)
    .fetch_all(&mut *tx)
    .await?;
    if leaves.is_empty() {
        return Err("no persisted WormGraph evidence to anchor".into());
    }
    let n = leaves.len();
    let (root, proof) = build_root_and_proof(&leaves, n - 1)?;
    let mut peaks = Vec::new();
    let mut start = 0;
    for bit in (0..usize::BITS).rev() {
        let width = 1usize << bit;
        if n & width != 0 {
            peaks.push(
                build_root_and_proof(&leaves[start..start + width], 0)?
                    .0
                    .to_vec(),
            );
            start += width;
        }
    }
    let checkpoint = serde_json::json!({"version":1,"tenant_id":tenant,"stream_id":"wormgraph-records-v1","leaf_count":n,"mmr_size":mmr_size(n as u64),"mmr_root":hex::encode(root),"profile_digest":PROFILE_DIGEST_HEX,"covered_up_to_hash":hex::encode(&leaves[n-1])});
    let canonical = encode_value(&checkpoint);
    let digest = Digest32::blake3(b"AKG:CHECKPOINT:v1\0", &canonical);
    // The snapshot is retained in the existing append-only checkpoint table.
    sqlx::query("INSERT INTO mmr_checkpoints(tenant_id,stream_id,leaf_count,mmr_size,mmr_root,peaks,profile_digest,covered_up_to_hash) VALUES($1,'wormgraph-records-v1',$2,$3,$4,$5,$6,$7) ON CONFLICT DO NOTHING")
 .bind(&tenant).bind(n as i64).bind(mmr_size(n as u64) as i64).bind(root.to_vec()).bind(peaks).bind(hex::decode(PROFILE_DIGEST_HEX)?).bind(&leaves[n-1]).execute(&mut *tx).await?;
    let stored:Vec<u8>=sqlx::query_scalar("SELECT mmr_root FROM mmr_checkpoints WHERE tenant_id=$1 AND stream_id='wormgraph-records-v1' AND leaf_count=$2").bind(&tenant).bind(n as i64).fetch_one(&mut *tx).await?;
    if stored != root {
        return Err("checkpoint conflict".into());
    }
    tx.commit().await?;
    let bundle = serde_json::json!({"checkpoint":checkpoint,"checkpoint_cbor_hex":hex::encode(canonical),"checkpoint_digest":digest.to_hex(),"leaf_hex":hex::encode(&leaves[n-1]),"proof":proof});
    std::fs::write(output, serde_json::to_vec_pretty(&bundle)?)?;
    println!(
        "Exported persisted checkpoint: {n} leaves, digest {}",
        digest.to_hex()
    );
    Ok(())
}
