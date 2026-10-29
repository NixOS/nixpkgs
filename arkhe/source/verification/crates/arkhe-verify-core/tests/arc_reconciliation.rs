#[path = "support/arc_fixture.rs"]
mod fixture;
use arkhe_core::Digest32;
use arkhe_verify_core::{mmr::build_root_and_proof, reconciliation::*};

#[test]
fn offline_roundtrip_reproduces_decision() {
    let (bundle, trust) = fixture::fixture();
    let bytes = serde_json::to_vec(&bundle).unwrap();
    let decoded: Bundle = serde_json::from_slice(&bytes).unwrap();
    assert_eq!(verify(&decoded, &trust).unwrap().status, Status::Matched);
    assert_eq!(decoded.record.leaf_bytes(), bundle.record.leaf_bytes());
    // Read-only verification is intentionally repeatable, not single-use.
    assert_eq!(verify(&decoded, &trust), verify(&decoded, &trust));
}

#[test]
fn explicit_partial_excess_and_unmatched_outcomes() {
    let (bundle, _) = fixture::fixture();
    let mut input = bundle.record.input;
    input.transfer.amount_microusd -= 1;
    assert_eq!(evaluate(&input).unwrap().status, Status::Partial);
    input.transfer.amount_microusd += 2;
    assert_eq!(evaluate(&input).unwrap().status, Status::Excess);
    input.transfer.reference = "unrecognized".into();
    assert_eq!(evaluate(&input).unwrap().status, Status::Unmatched);
}

#[test]
fn ambiguous_case_requires_review() {
    let (bundle, _) = fixture::fixture();
    let mut input = bundle.record.input;
    let mut other = input.invoices[0].clone();
    other.id = "invoice-2".into();
    input.invoices.push(other);
    let decision = evaluate(&input).unwrap();
    assert_eq!(decision.status, Status::Ambiguous);
    assert_eq!(decision.invoice_ids.len(), 2);
}

#[test]
fn swapped_invoice_rejected() {
    let (mut bundle, trust) = fixture::fixture();
    bundle.record.input.invoices[0].document = b"different document".to_vec();
    assert!(verify(&bundle, &trust).is_err());
}

#[test]
fn changed_amount_rejected() {
    let (mut bundle, trust) = fixture::fixture();
    bundle.record.input.transfer.amount_microusd += 1;
    assert!(verify(&bundle, &trust).is_err());
}

#[test]
fn evidence_from_another_operation_rejected() {
    let (mut bundle, trust) = fixture::fixture();
    bundle.record.input.operation_id = Digest32([7; 32]);
    assert!(verify(&bundle, &trust).is_err());
}

#[test]
fn untrusted_checkpoint_rejected() {
    let (bundle, mut trust) = fixture::fixture();
    trust.root[0] ^= 1;
    assert_eq!(
        verify(&bundle, &trust),
        Err("record absent from trusted checkpoint")
    );
}

#[test]
fn forged_decision_with_consistent_hash_and_membership_still_rejected() {
    let (mut bundle, mut trust) = fixture::fixture();
    bundle.record.decision.status = Status::Excess;
    bundle.record.worker.output_digest = bundle.record.decision.digest();
    let (root, steps) = build_root_and_proof(&[bundle.record.leaf_bytes()], 0).unwrap();
    trust.root = root;
    trust.leaf_count = 1;
    bundle.leaf_index = 0;
    bundle.steps = steps;
    assert_eq!(
        verify(&bundle, &trust),
        Err("reconciliation predicate does not reproduce recorded decision")
    );
}

#[test]
fn altered_rule_cannot_be_adopted_by_bundle() {
    let (mut bundle, trust) = fixture::fixture();
    bundle.record.input.rule.profile = "different-rule".into();
    assert!(verify(&bundle, &trust).is_err());
}

#[test]
fn malformed_proof_and_profile_rejected() {
    let (mut bundle, mut trust) = fixture::fixture();
    bundle.leaf_index = trust.leaf_count;
    assert!(verify(&bundle, &trust).is_err());
    bundle.leaf_index = 1;
    trust.mmr_profile_digest = "unknown".into();
    assert!(verify(&bundle, &trust).is_err());
}

#[test]
fn malformed_and_oversized_inputs_rejected() {
    let (bundle, _) = fixture::fixture();
    let mut input = bundle.record.input;
    input.invoices[0].document = vec![0; 65537];
    assert!(evaluate(&input).is_err());
    input.invoices[0].document = vec![0];
    input.transfer.from = "not-an-address".into();
    assert!(evaluate(&input).is_err());
}

#[test]
fn document_truth_is_not_claimed() {
    let (bundle, _) = fixture::fixture();
    let mut input = bundle.record.input;
    input.invoices[0].document = b"unverified document".to_vec();
    // Predicate checks typed fields, not the meaning/authenticity of document bytes.
    assert_eq!(evaluate(&input).unwrap().status, Status::Matched);
}

// Synthetic trusted checkpoints deliberately include the manipulated record:
// membership must not substitute for validation of internal case bindings.
fn reseal(bundle: &mut Bundle, trust: &mut Trust) {
    let (root, steps) = build_root_and_proof(&[bundle.record.leaf_bytes()], 0).unwrap();
    trust.root = root;
    trust.leaf_count = 1;
    bundle.leaf_index = 0;
    bundle.steps = steps;
}

fn refresh_worker_and_decision(bundle: &mut Bundle) {
    bundle.record.decision = evaluate(&bundle.record.input).unwrap();
    bundle.record.worker.input_digest = bundle.record.input.digest();
    bundle.record.worker.output_digest = bundle.record.decision.digest();
}

#[test]
fn swapped_invoice_with_refreshed_worker_requires_intent_commitment() {
    let (mut bundle, mut trust) = fixture::fixture();
    bundle.record.input.invoices[0].document = b"substituted document".to_vec();
    refresh_worker_and_decision(&mut bundle);
    // Keep the independently retained intent unchanged. Everything except its
    // commitment to the input agrees, including rule evaluation and membership.
    reseal(&mut bundle, &mut trust);
    assert_eq!(
        verify(&bundle, &trust),
        Err("untrusted profile or mismatched case bindings")
    );
}

#[test]
fn foreign_operation_with_consistent_commitments_rejected() {
    let (mut bundle, mut trust) = fixture::fixture();
    bundle.record.input.operation_id = Digest32([7; 32]);
    refresh_worker_and_decision(&mut bundle);
    bundle.record.intent.parameters_digest = bundle.record.input.digest();
    // The synthetic host accepts this exact intent for the experiment, while
    // its derived operation ID still disagrees with the supplied input's ID.
    trust.expected_intent = bundle.record.intent.digest();
    reseal(&mut bundle, &mut trust);
    assert_eq!(
        verify(&bundle, &trust),
        Err("untrusted profile or mismatched case bindings")
    );
}
