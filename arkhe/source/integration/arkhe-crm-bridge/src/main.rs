use anyhow::Result;
use arkhe_crm_bridge_cli::{
    salesforce::WriteIntent,
    storage::Store,
    v2::{self, Bundle, Event, Policy, Request},
};
use clap::{Parser, Subcommand};
use serde::de::DeserializeOwned;
use std::{
    fs::{self, OpenOptions},
    io::Write,
    path::PathBuf,
};

#[derive(Parser)]
#[command(about = "Signed CRM provenance bridge, protocol v2")]
struct Cli {
    #[command(subcommand)]
    command: Command,
}
#[derive(Subcommand)]
enum Command {
    /// Producer signs the exact Salesforce SystemModstamp, without changing protocol v2.
    SignWrite {
        #[arg(long)]
        proof: PathBuf,
        #[arg(long)]
        policy: PathBuf,
        #[arg(long)]
        expected_version: String,
        #[arg(long)]
        secret: PathBuf,
    },
    /// Verify a signed write intent; optionally emit a fresh sandbox approval payload.
    PrepareWrite {
        #[arg(long)]
        input: PathBuf,
        #[arg(long)]
        policy: PathBuf,
        #[arg(long)]
        org_id: String,
        #[arg(long)]
        historical: bool,
    },
    /// Create a private key file exclusively; prints only its public key.
    Keygen {
        #[arg(long)]
        secret: PathBuf,
    },
    /// Producer-side signing of a versioned event.
    Sign {
        #[arg(long)]
        input: PathBuf,
        #[arg(long)]
        secret: PathBuf,
    },
    /// Authenticate, authorize and atomically persist an event and checkpoint.
    Anchor {
        #[arg(long)]
        input: PathBuf,
        #[arg(long)]
        database: PathBuf,
        #[arg(long)]
        policy: PathBuf,
        #[arg(long)]
        secret: PathBuf,
    },
    /// Offline verification using an independently distributed trust policy.
    Verify {
        #[arg(long)]
        proof: PathBuf,
        #[arg(long)]
        policy: PathBuf,
    },
    /// Recover a committed response after interrupted delivery.
    Export {
        #[arg(long)]
        event_id: String,
        #[arg(long)]
        database: PathBuf,
        #[arg(long)]
        policy: PathBuf,
    },
}
fn read<T: DeserializeOwned>(path: PathBuf) -> Result<T> {
    Ok(serde_json::from_slice(&fs::read(path)?)?)
}
fn key(path: PathBuf) -> Result<ed25519_dalek::SigningKey> {
    v2::signing_key(&fs::read_to_string(path)?)
}
fn print<T: serde::Serialize>(value: &T) -> Result<()> {
    println!("{}", serde_json::to_string_pretty(value)?);
    Ok(())
}
fn main() -> Result<()> {
    match Cli::parse().command {
        Command::SignWrite {
            proof,
            policy,
            expected_version,
            secret,
        } => {
            print(&WriteIntent::sign(
                read(proof)?,
                expected_version,
                &key(secret)?,
                &read(policy)?,
            )?)?;
        }
        Command::PrepareWrite {
            input,
            policy,
            org_id,
            historical,
        } => {
            let intent: WriteIntent = read(input)?;
            let policy: Policy = read(policy)?;
            intent.verify(&policy)?;
            anyhow::ensure!(
                intent.bundle.request.event.record.org_id == org_id,
                "wrong org"
            );
            if historical {
                // No approval is emitted on this path: expired evidence cannot authorize a write.
                println!("verified-historical");
            } else {
                let now = std::time::SystemTime::now()
                    .duration_since(std::time::UNIX_EPOCH)?
                    .as_secs();
                print(&intent.approval(&policy, &org_id, now)?)?;
            }
        }
        Command::Keygen { secret } => {
            let mut bytes = [0u8; 32];
            getrandom::getrandom(&mut bytes)
                .map_err(|e| anyhow::anyhow!("OS randomness unavailable: {e}"))?;
            let key = ed25519_dalek::SigningKey::from_bytes(&bytes);
            let mut options = OpenOptions::new();
            options.write(true).create_new(true);
            #[cfg(unix)]
            {
                use std::os::unix::fs::OpenOptionsExt;
                options.mode(0o600);
            }
            let mut file = options.open(secret)?;
            file.write_all(hex::encode(bytes).as_bytes())?;
            file.sync_all()?;
            println!("{}", v2::public_key(&key));
        }
        Command::Sign { input, secret } => {
            print(&Request::sign(read::<Event>(input)?, &key(secret)?)?)?
        }
        Command::Anchor {
            input,
            database,
            policy,
            secret,
        } => {
            let policy: Policy = read(policy)?;
            let now = std::time::SystemTime::now()
                .duration_since(std::time::UNIX_EPOCH)?
                .as_secs();
            print(&Store::open(&database)?.anchor(read(input)?, &policy, &key(secret)?, now)?)?;
        }
        Command::Verify { proof, policy } => {
            v2::verify(&read::<Bundle>(proof)?, &read::<Policy>(policy)?)?;
            println!("valid");
        }
        Command::Export {
            event_id,
            database,
            policy,
        } => print(&Store::open(&database)?.export(&event_id, &read::<Policy>(policy)?)?)?,
    }
    Ok(())
}
