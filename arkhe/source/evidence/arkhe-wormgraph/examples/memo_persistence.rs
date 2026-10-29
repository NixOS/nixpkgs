//! Opt-in local storage tool. No payment execution or external anchoring.
use arkhe_core::Digest32;
use arkhe_verify_core::{memo_reconciliation::MemoBundle, reconciliation::Trust};
use arkhe_wormgraph::postgres::{
    memo::{verify_export, DurableMemoExport, MemoGraphTrust, MemoPackage},
    PgWormGraph,
};
use std::{
    error::Error,
    fs,
    io::{Read, Write},
    path::Path,
};

fn read<T: serde::de::DeserializeOwned>(path: &str, max: u64) -> Result<T, Box<dyn Error>> {
    let mut raw = Vec::new();
    fs::File::open(path)?.take(max + 1).read_to_end(&mut raw)?;
    if raw.len() as u64 > max {
        return Err("input too large".into());
    }
    Ok(serde_json::from_slice(&raw)?)
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<_> = std::env::args().skip(1).collect();
    if let [command, export, pin] = args.as_slice() {
        if command == "verify" {
            let export: DurableMemoExport = read(export, 100_000_000)?;
            let pin: MemoGraphTrust = read(pin, 16384)?;
            println!("{}", serde_json::to_string(&verify_export(&export, &pin)?)?);
            return Ok(());
        }
    }
    let url = std::env::var("ARKHE_MEMO_DATABASE_URL")?;
    let tenant = std::env::var("ARKHE_MEMO_TENANT")?;
    let graph = PgWormGraph::connect(&url, &tenant).await?;
    match args.as_slice() {
        [command, bundle, trust] if matches!(command.as_str(), "commit" | "commit-hold") => {
            let bundle: MemoBundle = read(bundle, 20_000_000)?;
            let local_trust: Trust = read(trust, 16384)?;
            let receipt = graph.commit_memo_observation(&MemoPackage { bundle, local_trust }).await?;
            println!("{}", serde_json::to_string(&receipt)?);
            std::io::stdout().flush()?;
            if command == "commit-hold" {
                // Test harness kills this process after it has observed commit.
                loop { std::thread::park(); }
            }
        }
        [command, hash, directory] if command == "export" => {
            let decoded = hex::decode(hash)?;
            let hash = Digest32(decoded.try_into().map_err(|_| "record hash must be 32 bytes")?);
            let export = graph.export_memo_observation(hash).await?;
            let result = verify_export(&export, &export.graph)?;
            let directory = Path::new(directory);
            fs::create_dir(directory)?;
            fs::write(directory.join("export.json"), serde_json::to_vec_pretty(&export)?)?;
            fs::write(directory.join("graph-trust.json"), serde_json::to_vec_pretty(&export.graph)?)?;
            fs::write(directory.join("package.json"), &export.package_bytes)?;
            println!("{}", serde_json::to_string(&result)?);
        }
        _ => return Err("usage: memo_persistence commit|commit-hold BUNDLE TRUST | export HASH NEW_DIRECTORY | verify EXPORT GRAPH_PIN".into()),
    }
    Ok(())
}
