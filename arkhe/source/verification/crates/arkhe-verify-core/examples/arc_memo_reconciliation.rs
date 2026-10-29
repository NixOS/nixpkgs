//! Offline raw-RPC memo verification and a synthetic invoice experiment.
#[path = "../tests/support/memo_package.rs"]
mod producer;
use arkhe_verify_core::{
    hash::sha256,
    memo_reconciliation::*,
    reconciliation::{Status, Trust},
};
use serde_json::{json, Value};
use std::{error::Error, fs, io::Read, path::Path};

fn read(path: &Path, limit: u64) -> Result<Vec<u8>, Box<dyn Error>> {
    let mut raw = Vec::new();
    fs::File::open(path)?
        .take(limit + 1)
        .read_to_end(&mut raw)?;
    if raw.len() as u64 > limit {
        return Err("input too large".into());
    }
    Ok(raw)
}
fn write(path: &Path, value: &impl serde::Serialize) -> Result<(), Box<dyn Error>> {
    fs::write(path, serde_json::to_vec_pretty(value)?)?;
    Ok(())
}
fn archive_response(
    root: &Path,
    manifest: &Value,
    method: &str,
    finalized: bool,
) -> Result<Vec<u8>, Box<dyn Error>> {
    let entries = manifest["requests"]
        .as_array()
        .ok_or("missing archive requests")?;
    let matches: Vec<_> = entries
        .iter()
        .filter(|entry| {
            entry["request"]["method"] == method
                && (method != "eth_getBlockByNumber"
                    || (entry["request"]["params"][0] == "finalized") == finalized)
        })
        .collect();
    let [entry] = matches.as_slice() else {
        return Err("missing or ambiguous archive response".into());
    };
    let name = entry["response_file"]
        .as_str()
        .ok_or("missing archive filename")?;
    if name.len() != 12
        || !name.starts_with("rpc-")
        || !name.ends_with(".json")
        || !name.as_bytes()[4..7].iter().all(u8::is_ascii_digit)
    {
        return Err("unsafe archive filename".into());
    }
    let path = root.join(name).canonicalize()?;
    if !path.starts_with(root.canonicalize()?) {
        return Err("archive path escapes capture folder".into());
    }
    let raw = read(&path, 1_000_000)?;
    if entry["response_sha256"] != hex::encode(sha256(&raw)) {
        return Err("archive response digest mismatch".into());
    }
    Ok(raw)
}
fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<_> = std::env::args().skip(1).collect();
    match args.as_slice() {
        [command, archive, directory] if command == "demo" => {
            let archive = Path::new(archive);
            let manifest: Value = serde_json::from_slice(&read(&archive.join("memos.json"), 1_000_000)?)?;
            let evidence = MemoEvidence {
                profile: "arkhe/arc-direct-memo-evidence/v1".into(),
                chain_response: archive_response(archive, &manifest, "eth_chainId", false)?,
                receipt_response: archive_response(archive, &manifest, "eth_getTransactionReceipt", false)?,
                block_response: archive_response(archive, &manifest, "eth_getBlockByNumber", false)?,
                finalized_response: archive_response(archive, &manifest, "eth_getBlockByNumber", true)?,
            };
            // Only the raw archive responses are consumed, never Python association status.
            let observation = observe(&evidence)?;
            let invoice = producer::synthetic_invoice(&observation.transfer);
            let mut different_amount = invoice.clone();
            different_amount.amount_microusd += 1;
            let mut different_reference = invoice.clone();
            different_reference.reference = "not-the-onchain-memo-id".into();
            let mut different_payee = invoice.clone();
            different_payee.payee = format!("0x{}", "55".repeat(20));
            let directory = Path::new(directory);
            fs::create_dir(directory)?;
            write(&directory.join("observation.json"), &observation)?;
            let mut results = Vec::new();
            for (name, invoices, expected) in [
                ("matched", vec![invoice], Status::Matched),
                ("amount-plus-one", vec![different_amount], Status::Partial),
                ("wrong-reference", vec![different_reference], Status::Unmatched),
                ("wrong-payee", vec![different_payee], Status::Unmatched),
                ("no-invoice", vec![], Status::Unmatched),
            ] {
                let (bundle, trust) = producer::package(evidence.clone(), invoices, name);
                let result = verify(&bundle, &trust)?;
                if result.status != expected { return Err("unexpected experiment outcome".into()); }
                let case = directory.join(name);
                fs::create_dir(&case)?;
                write(&case.join("bundle.json"), &bundle)?;
                write(&case.join("local-trust.json"), &trust)?;
                results.push(json!({"case": name, "status": result.status}));
                println!("{name}: {:?}", result.status);
                if name == "matched" {
                    let mut tampered = bundle.clone();
                    let mut receipt: Value = serde_json::from_slice(&tampered.evidence.receipt_response)?;
                    receipt["result"]["logs"][3]["topics"][3] = format!("0x{}", "11".repeat(32)).into();
                    tampered.evidence.receipt_response = serde_json::to_vec(&receipt)?;
                    if verify(&tampered, &trust).is_ok() { return Err("tampered memo accepted".into()); }
                    write(&directory.join("tampered-memo.json"), &tampered)?;
                    write(&directory.join("tampered-local-trust.json"), &trust)?;
                }
            }
            write(&directory.join("results.json"), &json!({
                "cases": results, "raw_rpc_memo_consumed_by_rust": true,
                "synthetic_invoice": true, "independently_authenticated_source": false,
                "independently_trusted_checkpoint": false, "confidence_classification": "not-implemented",
                "reference_rule": "arc-memo-id: followed by full 0x-prefixed bytes32; no UTF-8 trimming or prefix matching"
            }))?;
        }
        [command, bundle, trust] if command == "verify" => {
            let bundle: MemoBundle = serde_json::from_slice(&read(Path::new(bundle), 20_000_000)?)?;
            let trust: Trust = serde_json::from_slice(&read(Path::new(trust), 16384)?)?;
            println!("{}", serde_json::to_string_pretty(&verify(&bundle, &trust)?)?);
            println!("Verified raw memo decoding, frame/calldata/transfer binding, reconciliation and local MMR. Source/consensus and invoice authenticity are not established.");
        }
        _ => return Err("usage: arc_memo_reconciliation demo CAPTURE_DIRECTORY NEW_DIRECTORY | verify BUNDLE TRUST".into()),
    }
    Ok(())
}
