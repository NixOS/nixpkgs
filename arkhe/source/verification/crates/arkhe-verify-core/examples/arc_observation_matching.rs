//! Controlled experiment: captured public Testnet transfer + synthetic invoice
//! and synthetic off-chain reference. Does not establish a real commercial debt.
use arkhe_core::{
    canonical::encode_value,
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::WorkerExecutionRecord,
    Digest32,
};
use arkhe_verify_core::{
    mmr::{build_root_and_proof, profile::PROFILE_DIGEST_HEX},
    reconciliation::{
        evaluate, verify, Bundle, Input, Invoice, Record, Rule, Status, Transfer, Trust, MODULE,
        PROFILE,
    },
};
use serde_json::json;
use std::{error::Error, fs, io::Read, path::Path};

fn package(
    transfer: Transfer,
    invoices: Vec<Invoice>,
    case: &str,
) -> Result<(Bundle, Trust), Box<dyn Error>> {
    let target = Digest32::blake3(b"AKG:ARC:MIXED-EXPERIMENT:v1\0", case.as_bytes());
    let mut intent = WorkIntent {
        requested_by: "synthetic-invoice-experiment".into(),
        intent_type: WorkIntentType::Simulate,
        target,
        parameters_digest: Digest32::ZERO,
        context: vec![],
        context_refs: vec![],
        request_identity: RequestIdentity::new(case.as_bytes()),
        claimed_created_at: 0,
    };
    let input = Input {
        operation_id: intent.operation_id(),
        rule: Rule {
            profile: PROFILE.into(),
            chain_id: transfer.chain_id,
            payee: transfer.to.clone(),
        },
        transfer,
        invoices,
    };
    intent.parameters_digest = input.digest();
    let decision = evaluate(&input)?;
    let worker = WorkerExecutionRecord {
        classification: None, operation: None, module_id: MODULE.into(), module_version: "1".into(),
        input_digest: input.digest(), output_digest: decision.digest(), evidence_refs: vec![input.rule.digest()],
        confidence_bps: None,
        uncertainty_note: Some("Captured RPC transfer; SYNTHETIC invoice and off-chain reference; no authentic obligation or source consensus proof".into()),
        execution_id: target.to_hex(),
    };
    let record = Record {
        intent,
        input,
        decision,
        worker,
    };
    let (root, steps) = build_root_and_proof(&[record.leaf_bytes()], 0)?;
    let trust = Trust {
        mmr_profile_digest: PROFILE_DIGEST_HEX.into(),
        root,
        leaf_count: 1,
        expected_intent: record.intent.digest(),
        accepted_rule: record.input.rule.digest(),
    };
    Ok((
        Bundle {
            record,
            leaf_index: 0,
            steps,
        },
        trust,
    ))
}

fn write_json(path: &Path, value: &impl serde::Serialize) -> Result<(), Box<dyn Error>> {
    fs::write(path, serde_json::to_vec_pretty(value)?)?;
    Ok(())
}

fn main() -> Result<(), Box<dyn Error>> {
    let args: Vec<_> = std::env::args().skip(1).collect();
    let [input_path, output_path] = args.as_slice() else {
        return Err("usage: arc_observation_matching CAPTURED_TRANSFER NEW_DIRECTORY".into());
    };
    let mut raw = Vec::new();
    fs::File::open(input_path)?
        .take(16_385)
        .read_to_end(&mut raw)?;
    if raw.len() > 16_384 {
        return Err("transfer input too large".into());
    }
    let original: Transfer = serde_json::from_slice(&raw)?;
    if original.synthetic
        || original.chain_id != 5042002
        || !original.reference.is_empty()
        || !original.source.starts_with("arc-rpc-capture:sha256:")
    {
        return Err("expected unreferenced captured Testnet observation".into());
    }
    let output = Path::new(output_path);
    fs::create_dir(output)?;
    fs::write(output.join("original-transfer.json"), &raw)?;
    let reference = "SYNTHETIC-ASSOCIATION-INV-1";
    let association = json!({
        "profile": "arkhe/synthetic-reference-experiment/v1", "synthetic": true,
        "original_transfer_sha256": hex::encode(arkhe_verify_core::hash::sha256(&raw)),
        "transaction_hash": original.transaction_hash, "event_index": original.event_index,
        "reference": reference,
        "scope": "Fabricated off-chain association for an experiment; not emitted onchain or authenticated by a customer"
    });
    let association_bytes = encode_value(&association);
    let association_digest =
        Digest32::blake3(b"AKG:ARC:SYNTHETIC-REFERENCE:v1\0", &association_bytes);
    write_json(&output.join("synthetic-association.json"), &association)?;
    let mut associated = original.clone();
    associated.reference = reference.into();
    associated.source = format!(
        "{};synthetic-reference:blake3:{}",
        original.source,
        association_digest.to_hex()
    );
    let invoice = Invoice {
        id: "synthetic-invoice-1".into(),
        reference: reference.into(),
        payer: original.from.clone(),
        payee: original.to.clone(),
        amount_microusd: original.amount_microusd,
        valid_from: original.observed_at.saturating_sub(60),
        valid_until: original
            .observed_at
            .checked_add(60)
            .ok_or("timestamp overflow")?,
        document: format!(
            "SYNTHETIC INVOICE FOR MATCHING EXPERIMENT ONLY: {} micro-USDC",
            original.amount_microusd
        )
        .into_bytes(),
        synthetic: true,
    };
    let mut amount_changed = invoice.clone();
    amount_changed.amount_microusd = invoice
        .amount_microusd
        .checked_add(1)
        .ok_or("amount overflow")?;
    let mut payee_changed = invoice.clone();
    payee_changed.payee = if invoice.payee != format!("0x{}", "55".repeat(20)) {
        format!("0x{}", "55".repeat(20))
    } else {
        format!("0x{}", "66".repeat(20))
    };
    let cases = [
        ("no-invoice", original.clone(), vec![], Status::Unmatched),
        (
            "matched-synthetic-invoice",
            associated.clone(),
            vec![invoice.clone()],
            Status::Matched,
        ),
        (
            "invoice-amount-plus-one",
            associated.clone(),
            vec![amount_changed],
            Status::Partial,
        ),
        (
            "invoice-payee-changed",
            associated.clone(),
            vec![payee_changed],
            Status::Unmatched,
        ),
    ];
    let mut results = Vec::new();
    for (name, transfer, invoices, expected) in cases {
        let (bundle, trust) = package(transfer, invoices, name)?;
        let result = verify(&bundle, &trust)?;
        if result.status != expected {
            return Err(format!("unexpected outcome in {name}").into());
        }
        let directory = output.join(name);
        fs::create_dir(&directory)?;
        write_json(&directory.join("bundle.json"), &bundle)?;
        write_json(&directory.join("local-trust.json"), &trust)?;
        results.push(json!({"case": name, "status": result.status, "expected": expected}));
        println!("{name}: {:?}", result.status);
        if name == "matched-synthetic-invoice" {
            // Corrupt an already committed bundle, without updating trusted intent/root.
            let mut corrupted = bundle.clone();
            corrupted.record.input.invoices[0].amount_microusd += 1;
            if verify(&corrupted, &trust).is_ok() {
                return Err("tampered committed bundle accepted".into());
            }
            write_json(&output.join("tampered-bundle.json"), &corrupted)?;
            fs::copy(
                directory.join("local-trust.json"),
                output.join("tampered-local-trust.json"),
            )?;
        }
    }
    // The original rule rejects missing invoice references; do not weaken it.
    let mut empty_reference = invoice;
    empty_reference.reference.clear();
    if package(original.clone(), vec![empty_reference], "empty-reference").is_ok() {
        return Err("empty invoice reference unexpectedly accepted".into());
    }
    if fs::read(input_path)? != raw {
        return Err("original capture changed during experiment".into());
    }
    write_json(
        &output.join("results.json"),
        &json!({
            "scope": "Captured public Testnet transfer plus fabricated invoice/reference; no real commercial matching established",
            "original_transfer_sha256": hex::encode(arkhe_verify_core::hash::sha256(&raw)),
            "original_transfer_unchanged": true,
            "synthetic_invoice": true, "synthetic_offchain_association": true,
            "empty_invoice_reference_rejected": true, "committed_bundle_tampering_rejected": true,
            "cases": results
        }),
    )?;
    println!("Original capture preserved. All invoices and reference associations in this experiment are synthetic.");
    Ok(())
}
