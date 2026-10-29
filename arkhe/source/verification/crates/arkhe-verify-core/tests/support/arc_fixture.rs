use arkhe_core::{
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::WorkerExecutionRecord,
    Digest32,
};
use arkhe_verify_core::{
    mmr::{build_root_and_proof, profile::PROFILE_DIGEST_HEX},
    reconciliation::*,
};

pub fn fixture() -> (Bundle, Trust) {
    let payer = format!("0x{}", "11".repeat(20));
    let payee = format!("0x{}", "22".repeat(20));
    let mut intent = WorkIntent {
        requested_by: "synthetic-demo".into(),
        intent_type: WorkIntentType::Simulate,
        target: Digest32::blake3(b"ARC:DEMO:CASE\0", b"case-1"),
        parameters_digest: Digest32::ZERO,
        context: vec![],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"arc-synthetic-case-1"),
        claimed_created_at: 100,
    };
    let input = Input {
        operation_id: intent.operation_id(),
        rule: Rule {
            profile: PROFILE.into(),
            chain_id: 5042002,
            payee: payee.clone(),
        },
        transfer: Transfer {
            chain_id: 5042002,
            block_number: 10,
            block_hash: format!("0x{}", "33".repeat(32)),
            transaction_hash: format!("0x{}", "44".repeat(32)),
            event_index: 0,
            from: payer.clone(),
            to: payee.clone(),
            amount_microusd: 100_000_000,
            observed_at: 100,
            reference: "INV-1".into(),
            source: "synthetic:no-rpc-query".into(),
            synthetic: true,
        },
        invoices: vec![Invoice {
            id: "invoice-1".into(),
            reference: "INV-1".into(),
            payer,
            payee,
            amount_microusd: 100_000_000,
            valid_from: 90,
            valid_until: 110,
            document: b"SYNTHETIC INVOICE: 100 USDC".to_vec(),
            synthetic: true,
        }],
    };
    intent.parameters_digest = input.digest();
    let decision = evaluate(&input).unwrap();
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: MODULE.into(),
        module_version: "1".into(),
        input_digest: input.digest(),
        output_digest: decision.digest(),
        evidence_refs: vec![input.rule.digest()],
        confidence_bps: None,
        uncertainty_note: Some("Synthetic source; no authentication".into()),
        execution_id: "synthetic-execution-1".into(),
    };
    let record = Record {
        intent,
        input,
        decision,
        worker,
    };
    // Three local leaves exercise peak bagging as well as membership. No external log.
    let leaves = vec![
        b"synthetic-prior-record".to_vec(),
        record.leaf_bytes(),
        b"synthetic-next-record".to_vec(),
    ];
    let (root, steps) = build_root_and_proof(&leaves, 1).unwrap();
    let trust = Trust {
        mmr_profile_digest: PROFILE_DIGEST_HEX.into(),
        root,
        leaf_count: 3,
        expected_intent: record.intent.digest(),
        accepted_rule: record.input.rule.digest(),
    };
    (
        Bundle {
            record,
            leaf_index: 1,
            steps,
        },
        trust,
    )
}
