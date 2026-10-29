use anyhow::Context;
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "arkhe-verify")]
struct Cli {
    #[command(subcommand)]
    command: Command,
}

#[derive(Subcommand)]
enum Command {
    /// Verify an experimental release; local approval never starts execution.
    VerifyRelease {
        artifact: String,
        attestation: String,
        trust: String,
        #[arg(long)]
        approval: Option<String>,
        #[arg(long)]
        now: u64,
        #[arg(long, default_value_t = 0)]
        high_water: u64,
    },
    ReleasePolicyDigest {
        trust: String,
    },
    /// Inspect the restricted binary GGUF profile; '-' reads a bounded stdin snapshot.
    /// This command computes digests and does not verify authenticity.
    InspectGguf {
        gguf_file: String,
    },
    Blake3 {
        hex: String,
    },
    VerifyGguf {
        json_file: String,
    },
    /// Verify the restricted Stage 10 binary GGUF laboratory profile offline.
    VerifyGgufArtifact {
        gguf_file: String,
        bundle_file: String,
        trust_file: String,
    },
    VerifyC2pa {
        json_file: String,
    },
}

fn main() -> anyhow::Result<()> {
    let cli = Cli::parse();
    match cli.command {
        Command::ReleasePolicyDigest { trust } => {
            let trust = serde_json::from_slice(&bounded_release_read(&trust, 32768)?)?;
            println!(
                "{}",
                arkhe_verify_core::release::policy_digest(&trust).map_err(anyhow::Error::msg)?
            );
        }
        Command::VerifyRelease {
            artifact,
            attestation,
            trust,
            approval,
            now,
            high_water,
        } => {
            use arkhe_verify_core::release::{verify, Envelope, Trust, MAX_ARTIFACT};
            let bytes = bounded_release_read(&artifact, MAX_ARTIFACT)?;
            let attestation: Envelope =
                serde_json::from_slice(&bounded_release_read(&attestation, 32768)?)?;
            let trust: Trust = serde_json::from_slice(&bounded_release_read(&trust, 32768)?)?;
            let approval: Option<Envelope> = approval
                .map(|p| -> anyhow::Result<_> {
                    Ok(serde_json::from_slice(&bounded_release_read(&p, 32768)?)?)
                })
                .transpose()?;
            let result = verify(
                &bytes,
                &attestation,
                &trust,
                approval.as_ref(),
                now,
                high_water,
            )
            .map_err(anyhow::Error::msg)?;
            println!("{}", serde_json::to_string_pretty(&result)?);
        }
        Command::InspectGguf { gguf_file } => {
            use arkhe_verify_core::gguf::supply_chain::{statement, MAX_ARTIFACT_BYTES};
            use std::io::Read;
            let reader: Box<dyn Read> = if gguf_file == "-" {
                Box::new(std::io::stdin())
            } else {
                Box::new(
                    std::fs::File::open(&gguf_file).with_context(|| format!("open {gguf_file}"))?,
                )
            };
            let mut bytes = Vec::new();
            reader
                .take(MAX_ARTIFACT_BYTES as u64 + 1)
                .read_to_end(&mut bytes)?;
            anyhow::ensure!(bytes.len() <= MAX_ARTIFACT_BYTES, "GGUF exceeds size limit");
            println!(
                "{}",
                serde_json::to_string_pretty(&statement(&bytes, String::new())?)?
            );
        }
        Command::Blake3 { hex } => {
            let bytes = hex::decode(hex)?;
            println!(
                "{}",
                hex::encode(arkhe_verify_core::hash::blake3_256(&bytes))
            );
        }
        Command::VerifyGguf { json_file } => {
            let raw =
                std::fs::read_to_string(&json_file).with_context(|| format!("read {json_file}"))?;
            let v: serde_json::Value = serde_json::from_str(&raw)?;
            let cbor = arkhe_verify_core::gguf::canonical::canonicalize_metadata(&v)?;
            println!("{}", hex::encode(cbor));
        }
        Command::VerifyGgufArtifact {
            gguf_file,
            bundle_file,
            trust_file,
        } => {
            use arkhe_verify_core::gguf::supply_chain::{
                verify, Bundle, Trust, MAX_ARTIFACT_BYTES,
            };
            use std::io::Read;
            fn bounded_read(path: &str, limit: usize) -> anyhow::Result<Vec<u8>> {
                let mut bytes = Vec::new();
                std::fs::File::open(path)
                    .with_context(|| format!("open {path}"))?
                    .take(limit as u64 + 1)
                    .read_to_end(&mut bytes)?;
                anyhow::ensure!(bytes.len() <= limit, "input exceeds size limit: {path}");
                Ok(bytes)
            }
            let bytes = bounded_read(&gguf_file, MAX_ARTIFACT_BYTES)?;
            let bundle: Bundle = serde_json::from_slice(&bounded_read(&bundle_file, 1024 * 1024)?)?;
            let trust: Trust = serde_json::from_slice(&bounded_read(&trust_file, 16384)?)?;
            println!(
                "{}",
                serde_json::to_string_pretty(&verify(&bytes, &bundle, &trust)?)?
            );
        }
        Command::VerifyC2pa { json_file } => {
            let raw =
                std::fs::read_to_string(&json_file).with_context(|| format!("read {json_file}"))?;
            let v: serde_json::Value = serde_json::from_str(&raw)?;
            let cbor = arkhe_verify_core::c2pa::claim::canonicalize_claim_v2(&v)?;
            println!("{}", hex::encode(cbor));
        }
    }
    Ok(())
}

fn bounded_release_read(path: &str, limit: usize) -> anyhow::Result<Vec<u8>> {
    use std::io::Read;
    let mut bytes = Vec::new();
    std::fs::File::open(path)
        .with_context(|| format!("open {path}"))?
        .take(limit as u64 + 1)
        .read_to_end(&mut bytes)?;
    anyhow::ensure!(bytes.len() <= limit, "release input exceeds limit");
    Ok(bytes)
}
