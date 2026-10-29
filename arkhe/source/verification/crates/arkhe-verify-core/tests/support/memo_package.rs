//! Synthetic local package producer for tests and the opt-in example only.
use arkhe_core::{
    work::{RequestIdentity, WorkIntent, WorkIntentType},
    worker::WorkerExecutionRecord,
    Digest32,
};
use arkhe_verify_core::{
    memo_reconciliation::{observe, MemoBundle, MemoEvidence},
    mmr::{build_root_and_proof, profile::PROFILE_DIGEST_HEX},
    reconciliation::{
        evaluate, Bundle, Input, Invoice, Record, Rule, Transfer, Trust, MODULE, PROFILE,
    },
};

pub fn synthetic_invoice(t: &Transfer) -> Invoice {
    Invoice {
        id: "synthetic-memo-invoice".into(),
        reference: t.reference.clone(),
        payer: t.from.clone(),
        payee: t.to.clone(),
        amount_microusd: t.amount_microusd,
        valid_from: t.observed_at.saturating_sub(60),
        valid_until: t.observed_at.saturating_add(60),
        document:
            b"SYNTHETIC INVOICE: memo matching experiment only, no authentic commercial obligation"
                .to_vec(),
        synthetic: true,
    }
}

pub fn package(evidence: MemoEvidence, invoices: Vec<Invoice>, case: &str) -> (MemoBundle, Trust) {
    let transfer = observe(&evidence)
        .expect("qualified evidence for local producer")
        .transfer;
    let target = Digest32::blake3(b"AKG:ARC:MEMO-EXPERIMENT:v1\0", case.as_bytes());
    let mut intent = WorkIntent {
        requested_by: "synthetic-memo-invoice-experiment".into(),
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
    let decision = evaluate(&input).expect("bounded synthetic invoice");
    let worker = WorkerExecutionRecord {
        classification: None, operation: None, module_id: MODULE.into(), module_version: "1".into(),
        input_digest: input.digest(), output_digest: decision.digest(), evidence_refs: vec![input.rule.digest()],
        confidence_bps: None,
        uncertainty_note: Some("Real archived RPC memo; synthetic invoice and local checkpoint; source/consensus not independently authenticated".into()),
        execution_id: target.to_hex(),
    };
    let record = Record {
        intent,
        input,
        decision,
        worker,
    };
    let (root, steps) = build_root_and_proof(&[record.leaf_bytes()], 0).unwrap();
    let trust = Trust {
        mmr_profile_digest: PROFILE_DIGEST_HEX.into(),
        root,
        leaf_count: 1,
        expected_intent: record.intent.digest(),
        accepted_rule: record.input.rule.digest(),
    };
    (
        MemoBundle {
            reconciliation: Bundle {
                record,
                leaf_index: 0,
                steps,
            },
            evidence,
        },
        trust,
    )
}
