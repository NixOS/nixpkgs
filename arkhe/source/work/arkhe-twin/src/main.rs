use anyhow::Context;
use arkhe_core::{
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use arkhe_twin::{CareerRecord, TestRun};
use clap::{Parser, Subcommand};
use ed25519_dalek::SigningKey;
use std::{
    fs::{self, OpenOptions},
    io::Write,
    path::PathBuf,
    process::Command,
};

#[derive(Parser)]
#[command(name = "arkhe-twin", about = "Local signed career evidence (F0–F1)")]
struct Cli {
    #[command(subcommand)]
    command: Commands,
}

#[derive(Subcommand)]
enum Commands {
    /// Verify the restricted pinned-key DSSE/SLSA profile against an actual artifact.
    VerifyProvenance {
        #[arg(long)]
        envelope: PathBuf,
        #[arg(long)]
        artifact: PathBuf,
        #[arg(long)]
        policy: PathBuf,
    },
    /// Import an existing CI-signed envelope without changing its signature.
    ImportCi {
        #[arg(long)]
        record: PathBuf,
        /// Pin the CI signing key through an independent trusted channel.
        #[arg(long)]
        trusted_public_key: String,
        /// Bind the imported record to the expected component.
        #[arg(long)]
        expected_module: String,
        /// Store of imported records; execution IDs are content-hashed for filenames.
        #[arg(long)]
        store: PathBuf,
    },
    /// Sign an artifact and the result of a test command executed now.
    Record {
        #[arg(long)]
        module: String,
        #[arg(long, default_value = "1")]
        module_version: String,
        #[arg(long)]
        output: PathBuf,
        #[arg(long)]
        input: Option<PathBuf>,
        /// File containing a hex-encoded 32-byte Ed25519 seed. Never printed.
        #[arg(long)]
        key: PathBuf,
        #[arg(long)]
        out: PathBuf,
        /// Executable and arguments after --; no implicit shell.
        #[arg(required = true, last = true)]
        tests: Vec<String>,
    },
    /// Authenticate a record against an independently trusted public key.
    VerifyRecord {
        #[arg(long)]
        record: PathBuf,
        #[arg(long)]
        trusted_public_key: String,
    },
}

fn write_new(path: &PathBuf, bytes: &[u8]) -> anyhow::Result<()> {
    let mut file = OpenOptions::new()
        .write(true)
        .create_new(true)
        .open(path)
        .with_context(|| format!("create {} (will not overwrite)", path.display()))?;
    file.write_all(bytes)?;
    file.sync_all()?;
    Ok(())
}

fn main() -> anyhow::Result<()> {
    match Cli::parse().command {
        Commands::VerifyProvenance {
            envelope,
            artifact,
            policy,
        } => {
            use std::io::Read;
            let policy: arkhe_twin::provenance::Policy =
                serde_json::from_slice(&fs::read(policy)?)?;
            let digest = arkhe_twin::provenance::artifact_digest(fs::File::open(artifact)?)?;
            let mut bytes = Vec::new();
            fs::File::open(envelope)?
                .take(4 * 1024 * 1024 + 1)
                .read_to_end(&mut bytes)?;
            let result = arkhe_twin::provenance::verify(&bytes, &digest, &policy)?;
            println!("{}", serde_json::to_string_pretty(&result)?);
        }
        Commands::ImportCi {
            record,
            trusted_public_key,
            expected_module,
            store,
        } => {
            let bytes = fs::read(record)?;
            let record: CareerRecord = serde_json::from_slice(&bytes)?;
            record.verify(&trusted_public_key)?;
            anyhow::ensure!(
                record.wer.module_id == expected_module,
                "unexpected CI module"
            );
            anyhow::ensure!(
                !record.wer.execution_id.trim().is_empty(),
                "missing execution ID"
            );
            chrono::DateTime::parse_from_rfc3339(&record.recorded_at)
                .context("invalid record timestamp")?;
            let id = Digest32::blake3(
                b"arkhe:twin:import-id:v1\0",
                record.wer.execution_id.as_bytes(),
            )
            .to_hex();
            fs::create_dir_all(&store)?;
            let path = store.join(format!("{id}.json"));
            write_new(&path, &bytes)?;
            println!(
                "{}; tests passed: {}",
                path.display(),
                record.test_run.passed
            );
        }
        Commands::Record {
            module,
            module_version,
            output,
            input,
            key,
            out,
            tests,
        } => {
            anyhow::ensure!(
                !module.trim().is_empty() && !module_version.trim().is_empty(),
                "module and version must be nonempty"
            );
            anyhow::ensure!(!out.exists(), "output record already exists");
            let seed: [u8; 32] = hex::decode(fs::read_to_string(key)?.trim())?
                .try_into()
                .map_err(|_| anyhow::anyhow!("key must contain a hex-encoded 32-byte seed"))?;
            let key = SigningKey::from_bytes(&seed);
            let input_digest = match input {
                Some(path) => Digest32::blake3(b"arkhe:twin:artifact:v1\0", &fs::read(path)?),
                None => Digest32::ZERO,
            };
            let before = fs::read(&output).context("read output artifact before testing")?;
            let run = Command::new(&tests[0])
                .args(&tests[1..])
                .output()
                .context("execute tests")?;
            let after = fs::read(&output).context("read output artifact after testing")?;
            anyhow::ensure!(
                before == after,
                "artifact changed during testing; no record emitted"
            );
            let test_run = TestRun {
                command: tests,
                exit_code: run.status.code(),
                passed: run.status.success(),
                stdout_digest: Digest32::blake3(b"arkhe:twin:test-stdout:v1\0", &run.stdout),
                stderr_digest: Digest32::blake3(b"arkhe:twin:test-stderr:v1\0", &run.stderr),
            };
            let test_digest = Digest32::blake3(
                b"arkhe:twin:test-run:v1\0",
                &arkhe_core::canonical::encode_value(&serde_json::to_value(&test_run)?),
            );
            let mut record = CareerRecord {
                schema: "arkhe:twin:career-record:v1".into(),
                recorded_at: chrono::Utc::now().to_rfc3339(),
                wer: WorkerExecutionRecord {
                    classification: None, operation: Some(CognitiveOperation::Execute),
                    module_id: module, module_version, input_digest,
                    output_digest: Digest32::blake3(b"arkhe:twin:artifact:v1\0", &after),
                    evidence_refs: vec![test_digest], confidence_bps: None,
                    uncertainty_note: Some("Local runtime observation; no independent CI or human authorship attestation".into()),
                    execution_id: uuid::Uuid::new_v4().to_string(),
                },
                test_run, signer_public_key: String::new(), signature: String::new(),
            };
            record.sign(&key)?;
            record.verify(&record.signer_public_key)?;
            write_new(&out, &serde_json::to_vec_pretty(&record)?)?;
            println!("{}", out.display());
            anyhow::ensure!(
                record.test_run.passed,
                "tests failed; signed failure record saved"
            );
        }
        Commands::VerifyRecord {
            record,
            trusted_public_key,
        } => {
            let record: CareerRecord = serde_json::from_slice(&fs::read(record)?)?;
            record.verify(&trusted_public_key)?;
            println!(
                "signature valid; local tests passed: {}",
                record.test_run.passed
            );
        }
    }
    Ok(())
}
