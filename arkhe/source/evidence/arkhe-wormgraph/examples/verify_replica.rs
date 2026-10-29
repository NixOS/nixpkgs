//! Native gate for recoverable content bundles; hash-only v1 is rejected.
use arkhe_wormgraph::replica::{ReplicaBundle, ReplicaTrust};
use std::{error::Error, io::Read, path::Path};
fn read(path: &Path, limit: u64) -> Result<Vec<u8>, Box<dyn Error>> {
    let mut data = Vec::new();
    std::fs::File::open(path)?
        .take(limit + 1)
        .read_to_end(&mut data)?;
    if data.len() as u64 > limit {
        return Err("replica input exceeds limit".into());
    }
    Ok(data)
}
fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<_> = std::env::args_os().skip(1).collect();
    if args.len() != 3 {
        return Err(
            "usage: verify_replica REPLICA_TRUST_JSON REPLICA_BUNDLE_JSON HASH_BLOCKS_BIN".into(),
        );
    }
    let trust: ReplicaTrust = serde_json::from_slice(&read(Path::new(&args[0]), 65_536)?)?;
    let bundle: ReplicaBundle =
        serde_json::from_slice(&read(Path::new(&args[1]), 64 * 1024 * 1024)?)?;
    bundle.verify(&trust)?;
    let hashes = read(Path::new(&args[2]), 32_000_000)?;
    let expected: Vec<u8> = bundle
        .records
        .iter()
        .flat_map(|r| r.envelope.record_hash.0)
        .collect();
    if hashes != expected {
        return Err("hash blocks do not match recovered journal content".into());
    }
    println!("epoch, signed snapshot, journal contents and MMR verified");
    Ok(())
}
