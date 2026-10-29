//! Real Ed25519 signatures, deterministic TEST key; no attestation or live PoC.
use arkhe_bugbounty::bounty_evidence::{identity::*, signed_poc::*, *};
use ed25519_dalek::{Signer, SigningKey};
fn context() -> PocContext {
    PocContext {
        report_digest: [1; 32],
        policy_digest: [2; 32],
        operation_id: [3; 32],
        parameters_digest: [4; 32],
    }
}
fn fixture() -> (SignedPocMeasurement, VerifierRegistry) {
    let key = SigningKey::from_bytes(&[7; 32]);
    let mut signed = SignedPocMeasurement {
        version: 1,
        measurement: PocMeasurement {
            chain_id: 1,
            fork_block: 100,
            submission_block: 110,
            target: [5; 32],
            asset_id: [6; 32],
            attacker_gain: u128::MAX,
        },
        context: context(),
        verifier_id: [8; 32],
        public_key: key.verifying_key().to_bytes(),
        signed_at: 40,
        signature_hex: String::new(),
    };
    signed.signature_hex = hex::encode(key.sign(&signed.signing_bytes()).to_bytes());
    let mut r = VerifierRegistry::default();
    r.insert(VerifierEntry {
        verifier_id: [8; 32],
        operator_id: [9; 32],
        key_id: key_id(&signed.public_key),
        level: AttestationLevel::Workload,
        not_before: 10,
        not_after: 100,
        revoked: false,
    })
    .unwrap();
    (signed, r)
}
#[test]
fn signature_binds_every_measurement_and_context_field() {
    let (s, r) = fixture();
    assert_eq!(
        s.verify(&r, &context(), 50, 20, AttestationLevel::Workload)
            .unwrap()
            .attacker_gain,
        u128::MAX
    );
    for mode in 0..14 {
        let mut changed = s.clone();
        match mode {
            0 => changed.measurement.chain_id += 1,
            1 => changed.measurement.fork_block += 1,
            2 => changed.measurement.submission_block += 1,
            3 => changed.measurement.target = [10; 32],
            4 => changed.measurement.asset_id = [10; 32],
            5 => changed.measurement.attacker_gain -= 1,
            6 => changed.context.report_digest = [10; 32],
            7 => changed.context.policy_digest = [10; 32],
            8 => changed.context.operation_id = [10; 32],
            9 => changed.context.parameters_digest = [10; 32],
            10 => changed.signed_at += 1,
            11 => changed.verifier_id = [10; 32],
            12 => changed.public_key = [10; 32],
            _ => changed.version = 2,
        };
        assert!(
            changed
                .verify(&r, &context(), 50, 20, AttestationLevel::Workload)
                .is_err(),
            "mode {mode}"
        );
    }
    let mut bad = s.clone();
    bad.signature_hex = "00".repeat(64);
    assert!(bad
        .verify(&r, &context(), 50, 20, AttestationLevel::Workload)
        .is_err());
    let mut expected = context();
    expected.policy_digest = [11; 32];
    assert!(s
        .verify(&r, &expected, 50, 20, AttestationLevel::Workload)
        .is_err());
}
#[test]
fn current_revocation_expiry_level_and_trusted_freshness_fail_closed() {
    let (s, mut r) = fixture();
    assert!(s
        .verify(&r, &context(), 60, 20, AttestationLevel::Workload)
        .is_ok());
    for (at, age, level) in [
        (39, 20, AttestationLevel::Workload),
        (61, 20, AttestationLevel::Workload),
        (100, 100, AttestationLevel::Workload),
        (50, 20, AttestationLevel::Hardware),
    ] {
        assert!(s.verify(&r, &context(), at, age, level).is_err());
    }
    r.revoke(&s.verifier_id).unwrap();
    assert!(s
        .verify(&r, &context(), 50, 20, AttestationLevel::Workload)
        .is_err());
}
fn identity() -> VulnerabilityIdentity {
    VulnerabilityIdentity {
        version: 1,
        chain_id: 1,
        deployment: [1; 32],
        code_revision: [2; 32],
        function_selector: [3; 4],
        bug_class: BugClass::Reentrancy,
        adjudicated_root_cause: [4; 32],
    }
}
#[test]
fn structural_identity_has_fixed_vocabulary_and_requires_adjudication() {
    let a = identity();
    let first = a.digest().unwrap();
    let mut alias = a.clone();
    alias.bug_class = BugClass::from_label(" reentrant call ").unwrap();
    assert_eq!(first, alias.digest().unwrap());
    assert!(BugClass::from_label("arbitrary trigger").is_err());
    let json = serde_json::to_value(&a).unwrap();
    let reordered = serde_json::to_string(&json).unwrap();
    let parsed: VulnerabilityIdentity = serde_json::from_str(&reordered).unwrap();
    assert_eq!(first, parsed.digest().unwrap());
    for mode in 0..6 {
        let mut changed = a.clone();
        match mode {
            0 => changed.chain_id = 2,
            1 => changed.deployment = [5; 32],
            2 => changed.code_revision = [5; 32],
            3 => changed.function_selector = [5; 4],
            4 => changed.bug_class = BugClass::AccessControl,
            _ => changed.adjudicated_root_cause = [5; 32],
        };
        assert_ne!(first, changed.digest().unwrap());
    }
    let mut invalid = a;
    invalid.adjudicated_root_cause = [0; 32];
    assert!(invalid.digest().is_err());
}
