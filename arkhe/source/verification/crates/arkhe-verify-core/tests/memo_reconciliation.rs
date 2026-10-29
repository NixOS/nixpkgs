#[path = "support/memo_package.rs"]
mod producer;
use arkhe_verify_core::{memo_reconciliation::*, reconciliation::Status};
use serde_json::Value;

fn evidence() -> MemoEvidence {
    MemoEvidence {
        profile: "arkhe/arc-direct-memo-evidence/v1".into(),
        chain_response: include_bytes!("fixtures/arc-memo/chain.json").to_vec(),
        receipt_response: include_bytes!("fixtures/arc-memo/receipt.json").to_vec(),
        block_response: include_bytes!("fixtures/arc-memo/block.json").to_vec(),
        finalized_response: include_bytes!("fixtures/arc-memo/finalized.json").to_vec(),
    }
}
fn edit_receipt(e: &mut MemoEvidence, edit: impl FnOnce(&mut Value)) {
    let mut v: Value = serde_json::from_slice(&e.receipt_response).unwrap();
    edit(&mut v["result"]);
    e.receipt_response = serde_json::to_vec(&v).unwrap();
}

#[test]
fn archived_real_memo_is_decoded_independently() {
    let observation = observe(&evidence()).unwrap();
    assert_eq!(
        observation.memo_id,
        "0x3837656331313461306600000000000000000000000000000000000000000000"
    );
    assert_eq!(
        observation.transfer.reference,
        format!("arc-memo-id:{}", observation.memo_id)
    );
    assert_eq!(observation.transfer.amount_microusd, 2_000_000);
    assert_eq!(observation.transfer.event_index, 11);
    assert!(!observation.transfer.synthetic);
    assert_eq!(observation.memo_hex, "0x4d657368506f72742023313432");
}

#[test]
fn real_memo_plus_synthetic_invoice_matches_offline() {
    let e = evidence();
    let invoice = producer::synthetic_invoice(&observe(&e).unwrap().transfer);
    let (bundle, trust) = producer::package(e, vec![invoice], "matched");
    let serialized = serde_json::to_vec(&bundle).unwrap();
    let decoded: MemoBundle = serde_json::from_slice(&serialized).unwrap();
    assert_eq!(verify(&decoded, &trust).unwrap().status, Status::Matched);
}

#[test]
fn coherent_invoice_changes_classify_without_weakening_rule() {
    let e = evidence();
    let invoice = producer::synthetic_invoice(&observe(&e).unwrap().transfer);
    let mut changed = invoice.clone();
    changed.amount_microusd += 1;
    let (bundle, trust) = producer::package(e.clone(), vec![changed], "partial");
    assert_eq!(verify(&bundle, &trust).unwrap().status, Status::Partial);
    let mut changed = invoice.clone();
    changed.reference = "wrong-reference".into();
    let (bundle, trust) = producer::package(e.clone(), vec![changed], "wrong-reference");
    assert_eq!(verify(&bundle, &trust).unwrap().status, Status::Unmatched);
    let mut changed = invoice;
    changed.payee = format!("0x{}", "55".repeat(20));
    let (bundle, trust) = producer::package(e, vec![changed], "wrong-payee");
    assert_eq!(verify(&bundle, &trust).unwrap().status, Status::Unmatched);
}

#[test]
fn changed_raw_memo_id_cannot_substitute_committed_evidence() {
    let e = evidence();
    let invoice = producer::synthetic_invoice(&observe(&e).unwrap().transfer);
    let (mut bundle, trust) = producer::package(e, vec![invoice], "matched");
    edit_receipt(&mut bundle.evidence, |r| {
        r["logs"][3]["topics"][3] = format!("0x{}", "11".repeat(32)).into()
    });
    assert_eq!(
        verify(&bundle, &trust),
        Err("memo evidence does not derive the exact reconciliation transfer")
    );
}

#[test]
fn altered_calldata_hash_is_rejected_by_decoder() {
    let mut e = evidence();
    edit_receipt(&mut e, |r| {
        let data = r["logs"][3]["data"].as_str().unwrap();
        r["logs"][3]["data"] = format!("0x{}{}", "00".repeat(32), &data[66..]).into();
    });
    assert_eq!(observe(&e).unwrap_err(), "memo calldata hash mismatch");
}

#[test]
fn sender_frame_and_mirror_corruptions_are_rejected() {
    let mut e = evidence();
    edit_receipt(&mut e, |r| {
        r["from"] = format!("0x{}", "55".repeat(20)).into()
    });
    assert!(observe(&e).is_err());
    let mut e = evidence();
    edit_receipt(&mut e, |r| r["logs"][0]["logIndex"] = "0xff".into());
    assert!(observe(&e).is_err());
    let mut e = evidence();
    edit_receipt(&mut e, |r| {
        r["logs"][2]["data"] = format!("0x{:064x}", 2_000_001).into()
    });
    assert!(observe(&e).is_err());
}

#[test]
fn malformed_abi_and_ambiguous_frames_rejected() {
    let mut e = evidence();
    edit_receipt(&mut e, |r| r["logs"][3]["data"] = "0x00".into());
    assert!(observe(&e).is_err());
    let mut e = evidence();
    edit_receipt(&mut e, |r| {
        let duplicate = r["logs"][0].clone();
        r["logs"].as_array_mut().unwrap().push(duplicate);
    });
    assert!(observe(&e).is_err());
}

#[test]
fn wrong_network_and_unfinalized_block_rejected() {
    let mut e = evidence();
    e.chain_response = br#"{"jsonrpc":"2.0","id":1,"result":"0x1"}"#.to_vec();
    assert_eq!(observe(&e).unwrap_err(), "wrong memo network");
    let mut e = evidence();
    let mut head: Value = serde_json::from_slice(&e.finalized_response).unwrap();
    head["result"]["number"] = "0x1".into();
    e.finalized_response = serde_json::to_vec(&head).unwrap();
    assert!(observe(&e).is_err());
}

#[test]
fn unsupported_profile_and_size_are_rejected() {
    let mut e = evidence();
    e.profile = "unknown".into();
    assert!(observe(&e).is_err());
    let mut e = evidence();
    e.receipt_response = vec![0; 1_000_001];
    assert!(observe(&e).is_err());
}

#[test]
fn duplicate_index_on_unrecognized_event_is_rejected() {
    let mut e = evidence();
    edit_receipt(&mut e, |r| {
        let mut extra = r["logs"][0].clone();
        // Same Memo emitter/index, but a different event signature. It does not
        // add a BeforeMemo frame, so frame cardinality cannot mask uniqueness.
        extra["topics"][0] = format!("0x{}", "99".repeat(32)).into();
        r["logs"].as_array_mut().unwrap().push(extra);
    });
    assert_eq!(observe(&e).unwrap_err(), "log provenance or index mismatch");
}

#[test]
fn oversized_valid_rpc_json_is_rejected_by_size_bound() {
    let mut e = evidence();
    // JSON whitespace is valid: removing the size guard must not be masked by
    // an unrelated parse failure, unlike the original all-zero byte fixture.
    e.receipt_response.resize(1_000_001, b' ');
    let parsed: Value = serde_json::from_slice(&e.receipt_response).unwrap();
    assert_eq!(parsed["jsonrpc"], "2.0");
    assert_eq!(
        observe(&e).unwrap_err(),
        "invalid or oversized memo evidence"
    );
}
