//! Seal a local bridge observation, or verify its portable receipt offline.
use arkhe_core::{work::WorkIntent, worker::WorkerExecutionRecord, CanonicalEncode};
use arkhe_runtime::portable_wer::{append, PortableWer, WerTrust};
use clap::{Parser, Subcommand};
use ed25519_dalek::SigningKey;
use serde_json::{json, Value};
use std::{
    fs,
    io::Write,
    path::{Path, PathBuf},
    time::{SystemTime, UNIX_EPOCH},
};

#[derive(Parser)]
struct Args {
    #[command(subcommand)]
    command: Command,
}
#[derive(Subcommand)]
enum Command {
    Seal {
        #[arg(long)]
        native: PathBuf,
        #[arg(long)]
        trust: PathBuf,
        #[arg(long)]
        worker_key_file: PathBuf,
        #[arg(long)]
        log_key_file: PathBuf,
        #[arg(long)]
        journal: PathBuf,
        #[arg(long)]
        output: PathBuf,
    },
    Verify {
        #[arg(long)]
        bundle: PathBuf,
        #[arg(long)]
        trust: PathBuf,
    },
}
fn load<T: serde::de::DeserializeOwned>(path: &Path) -> Result<T, Box<dyn std::error::Error>> {
    if fs::metadata(path)?.len() > 2_000_000 {
        return Err("input too large".into());
    }
    Ok(serde_json::from_slice(&fs::read(path)?)?)
}
fn key(path: &Path) -> Result<SigningKey, Box<dyn std::error::Error>> {
    let raw = fs::read(path)?;
    let bytes = if raw.len() == 32 {
        raw
    } else {
        hex::decode(std::str::from_utf8(&raw)?.trim())?
    };
    Ok(SigningKey::from_bytes(
        &bytes
            .try_into()
            .map_err(|_| "expected 32-byte signing seed")?,
    ))
}
fn main() -> Result<(), Box<dyn std::error::Error>> {
    match Args::parse().command {
        Command::Seal {
            native,
            trust,
            worker_key_file,
            log_key_file,
            journal,
            output,
        } => {
            if output.exists() {
                return Err("output exists".into());
            }
            let native: Value = load(&native)?;
            if native["gate"] != "ALLOW" || native["phase"] != "record" {
                return Err("bridge observation was not admitted".into());
            }
            let intent: WorkIntent = serde_json::from_value(native["intent"].clone())?;
            let worker: WorkerExecutionRecord =
                serde_json::from_value(native["worker_record"].clone())?;
            if native["worker_digest"] != worker.digest().to_hex()
                || native["worker_cbor_hex"] != hex::encode(worker.canonical_bytes())
                || native["intent_digest"] != intent.digest().to_hex()
            {
                return Err("native export commitment mismatch".into());
            }
            let trust: WerTrust = load(&trust)?;
            let now = SystemTime::now().duration_since(UNIX_EPOCH)?.as_secs();
            let bundle = append(
                &journal,
                intent,
                worker,
                &key(&worker_key_file)?,
                &key(&log_key_file)?,
                &trust,
                now,
            )?;
            let mut file = fs::OpenOptions::new()
                .write(true)
                .create_new(true)
                .open(output)?;
            file.write_all(&serde_json::to_vec_pretty(&bundle)?)?;
            file.sync_all()?;
            println!(
                "{}",
                json!({"worker_signature":"ED25519_CANONICAL_CBOR_V1",
                "artifact_authenticity":"VERIFIED_WER_AGAINST_SUPPLIED_TRUST",
                "wormgraph_anchor":"LOCAL_SIGNED_MMR_CHECKPOINT", "leaf_count":bundle.checkpoint.leaf_count,
                "record_hash":bundle.record_hash.to_hex(), "model_attestation":"NOT_VERIFIED",
                "trusted_timestamp":"NOT_VERIFIED", "capability_demonstrated":false})
            );
        }
        Command::Verify { bundle, trust } => {
            let bundle: PortableWer = load(&bundle)?;
            let trust: WerTrust = load(&trust)?;
            bundle.verify(&trust)?;
            println!(
                "{}",
                json!({"status":"VERIFIED_SIGNED_WER_AND_MMR_INCLUSION",
                "record_hash":bundle.record_hash.to_hex(), "leaf_count":bundle.checkpoint.leaf_count,
                "model_attestation":"NOT_VERIFIED", "trusted_timestamp":"NOT_VERIFIED",
                "capability_demonstrated":false})
            );
        }
    }
    Ok(())
}
