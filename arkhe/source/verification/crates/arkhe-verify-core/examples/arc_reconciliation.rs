//! Offline synthetic demo or packaging of a separately captured observation.
//! This executable never queries RPC, authorizes payments, or writes a production log.
#[path = "../tests/support/arc_fixture.rs"]
mod fixture;
use arkhe_core::{
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::WorkerExecutionRecord,
    Digest32,
};
use arkhe_verify_core::{
    mmr::{build_root_and_proof, profile::PROFILE_DIGEST_HEX},
    reconciliation::{
        evaluate, verify, Bundle, Input, Record, Rule, Transfer, Trust, MODULE, PROFILE,
    },
};
use std::{error::Error, fs, path::Path};

fn read_bounded(path: &Path, max: u64) -> Result<Vec<u8>, Box<dyn Error>> {
    use std::io::Read;
    let mut bytes = Vec::new();
    fs::File::open(path)?
        .take(max + 1)
        .read_to_end(&mut bytes)?;
    if bytes.len() as u64 > max {
        return Err("input file too large".into());
    }
    Ok(bytes)
}

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<_> = std::env::args().skip(1).collect();
    match args.as_slice() {
        [command, transfer_path, directory] if command == "observe" => {
            let transfer: Transfer = serde_json::from_slice(&read_bounded(Path::new(transfer_path), 16384)?)?;
            if transfer.synthetic || transfer.chain_id != 5042002 || !transfer.reference.is_empty()
                || !transfer.source.starts_with("arc-rpc-capture:sha256:") {
                return Err("observe requires a captured testnet transfer without an invented reference".into());
            }
            let target = Digest32::blake3(b"AKG:ARC:OBSERVED-EVENT:v1\0", format!("{}:{}:{}:{}",
                transfer.chain_id, transfer.block_hash, transfer.transaction_hash, transfer.event_index).as_bytes());
            let mut intent = WorkIntent {
                requested_by: "local-arc-observer".into(), intent_type: WorkIntentType::Simulate,
                target, parameters_digest: Digest32::ZERO, context: vec![], context_refs: vec![],
                request_identity: RequestIdentity::new(&target.0), claimed_created_at: 0,
            };
            let input = Input {
                operation_id: intent.operation_id(),
                rule: Rule { profile: PROFILE.into(), chain_id: transfer.chain_id, payee: transfer.to.clone() },
                transfer, invoices: vec![],
            };
            intent.parameters_digest = input.digest();
            let decision = evaluate(&input)?;
            let worker = WorkerExecutionRecord {
                classification: None, operation: None, module_id: MODULE.into(), module_version: "1".into(),
                input_digest: input.digest(), output_digest: decision.digest(), evidence_refs: vec![input.rule.digest()],
                confidence_bps: None,
                uncertainty_note: Some("RPC observation; source and consensus not independently authenticated; no invoice supplied".into()),
                execution_id: target.to_hex(),
            };
            let record = Record { intent, input, decision, worker };
            let (root, steps) = build_root_and_proof(&[record.leaf_bytes()], 0)?;
            let trust = Trust { mmr_profile_digest: PROFILE_DIGEST_HEX.into(), root, leaf_count: 1,
                expected_intent: record.intent.digest(), accepted_rule: record.input.rule.digest() };
            let bundle = Bundle { record, leaf_index: 0, steps };
            let result = verify(&bundle, &trust)?;
            let directory = Path::new(directory);
            fs::create_dir(directory)?;
            fs::write(directory.join("bundle.json"), serde_json::to_vec_pretty(&bundle)?)?;
            fs::write(directory.join("local-trust.json"), serde_json::to_vec_pretty(&trust)?)?;
            println!("Observed transfer packaged: {:?}. Local MMR only; no authorization or source authentication.", result.status);
        }
        [command, directory] if command == "demo" => {
            let directory = Path::new(directory);
            fs::create_dir(directory)?; // Refuse existing output; preserve prior artifacts.
            let (bundle, trust) = fixture::fixture();
            verify(&bundle, &trust)?;
            fs::write(
                directory.join("bundle.json"),
                serde_json::to_vec_pretty(&bundle)?,
            )?;
            fs::write(
                directory.join("demo-trust.json"),
                serde_json::to_vec_pretty(&trust)?,
            )?;
            println!(
                "Synthetic local demo exported. The demo checkpoint is not externally anchored."
            );
        }
        [command, bundle, trust] if command == "verify" => {
            let bundle: Bundle =
                serde_json::from_slice(&read_bounded(Path::new(bundle), 20_000_000)?)?;
            let trust: Trust = serde_json::from_slice(&read_bounded(Path::new(trust), 16_384)?)?;
            let decision = verify(&bundle, &trust)?;
            println!("{}", serde_json::to_string_pretty(&decision)?);
            println!("Verified bindings, predicate and inclusion only. Source authenticity is not established.");
        }
        _ => {
            return Err("usage: arc_reconciliation demo NEW_DIRECTORY | observe TRANSFER NEW_DIRECTORY | verify BUNDLE TRUST".into())
        }
    }
    Ok(())
}
