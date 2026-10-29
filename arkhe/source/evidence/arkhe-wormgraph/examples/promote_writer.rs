//! Native promotion gate; invoke via promote.py after external anchor verification.
use arkhe_wormgraph::{
    fencing::promote_after_external_anchor,
    replica::{ReplicaBundle, ReplicaTrust},
};
use sqlx::postgres::PgPoolOptions;
use std::io::Read;
type Error = Box<dyn std::error::Error + Send + Sync>;
fn read(path: &std::ffi::OsStr, max: u64) -> Result<Vec<u8>, Error> {
    let mut data = Vec::new();
    std::fs::File::open(path)?
        .take(max + 1)
        .read_to_end(&mut data)?;
    if data.len() as u64 > max {
        return Err("input too large".into());
    }
    Ok(data)
}
#[tokio::main]
async fn main() -> Result<(), Error> {
    let a: Vec<_> = std::env::args_os().skip(1).collect();
    if a.len() != 3 {
        return Err(
            "usage: promote_writer REPLICA_TRUST_JSON BUNDLE_JSON NEW_DATABASE_LOGIN".into(),
        );
    }
    let trust: ReplicaTrust = serde_json::from_slice(&read(&a[0], 65536)?)?;
    let bundle: ReplicaBundle = serde_json::from_slice(&read(&a[1], 64 * 1024 * 1024)?)?;
    let login = a[2].to_str().ok_or("invalid login")?;
    let url = std::env::var("ARKHE_FENCE_ADMIN_DATABASE_URL")?;
    let pool = PgPoolOptions::new()
        .max_connections(1)
        .connect(&url)
        .await?;
    let next = promote_after_external_anchor(&pool, &bundle, &trust, login).await?;
    println!(
        "{}",
        serde_json::json!({"writer_epoch":next,"owner_login":login,"tenant":bundle.checkpoint.tenant_id})
    );
    Ok(())
}
