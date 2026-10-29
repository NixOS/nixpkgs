//! Local-key export tool. Production KMS signing can use the same signing_bytes API.
use arkhe_wormgraph::{anchor::SignedCheckpoint, postgres::PgWormGraph, replica::ReplicaTrust};
use ed25519_dalek::{Signer, SigningKey};
use std::{
    error::Error,
    fs::OpenOptions,
    io::{Read, Write},
    path::Path,
};
fn read(path: &Path, max: u64) -> Result<Vec<u8>, Box<dyn Error>> {
    let mut out = Vec::new();
    std::fs::File::open(path)?
        .take(max + 1)
        .read_to_end(&mut out)?;
    if out.len() as u64 > max {
        return Err("export input too large".into());
    }
    Ok(out)
}
#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    let a: Vec<_> = std::env::args_os().skip(1).collect();
    if a.len() != 4 {
        return Err("usage: export_replica REPLICA_TRUST_JSON CHECKPOINT_JSON ED25519_SEED_FILE OUTPUT_JSON".into());
    }
    let trust: ReplicaTrust = serde_json::from_slice(&read(Path::new(&a[0]), 65536)?)?;
    let checkpoint: SignedCheckpoint =
        serde_json::from_slice(&read(Path::new(&a[1]), 4 * 1024 * 1024)?)?;
    checkpoint
        .verify(&checkpoint.binding(), &trust.checkpoint)
        .map_err(|e| e.0)?;
    let seed: [u8; 32] = read(Path::new(&a[2]), 32)?
        .try_into()
        .map_err(|_| "signing seed must be 32 raw bytes")?;
    let key = SigningKey::from_bytes(&seed);
    if key.verifying_key().to_bytes() != trust.checkpoint.public_key {
        return Err("export signing key differs from trusted checkpoint key".into());
    }
    let graph = PgWormGraph::connect_with_stream(
        &std::env::var("ARKHE_EXPORT_DATABASE_URL")?,
        &checkpoint.tenant_id,
        &checkpoint.stream_id,
    )
    .await?;
    let mut bundle = graph.export_replica_snapshot(checkpoint).await?;
    bundle.signature_hex = hex::encode(key.sign(&bundle.signing_bytes()).to_bytes());
    bundle.verify(&trust)?;
    let raw = serde_json::to_vec(&bundle)?;
    if raw.len() > 64 * 1024 * 1024 {
        return Err("snapshot exceeds replica transport limit".into());
    }
    let output = Path::new(&a[3]);
    let temporary = output.with_extension(format!(
        "tmp-{}-{}",
        std::process::id(),
        std::time::SystemTime::now()
            .duration_since(std::time::UNIX_EPOCH)?
            .as_nanos()
    ));
    let mut file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(&temporary)?;
    file.write_all(&raw)?;
    file.sync_all()?;
    drop(file);
    // Atomic publication without overwriting an existing snapshot.
    let result = std::fs::hard_link(&temporary, output);
    std::fs::remove_file(&temporary)?;
    result?;
    println!("signed recoverable snapshot published");
    Ok(())
}
