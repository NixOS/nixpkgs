//! v2 fixtures: real Ed25519, synthetic log/registry. No hardware or payout.
use arkhe_bugbounty::bounty_evidence::{
    priority::*,
    signed_poc::{key_id, PocContext, PocSignatureTrust},
    v2, *,
};
use async_trait::async_trait;
use ed25519_dalek::{Signer, SigningKey};
struct Source {
    block: u64,
    commitment: [u8; 32],
}
#[async_trait]
impl AnchorSource for Source {
    async fn verified_anchor(&self, report: [u8; 32]) -> Result<AnchoredClaim, String> {
        Ok(AnchoredClaim {
            log_id: [1; 32],
            commitment: self.commitment,
            report_digest: report,
            recipient: [2; 32],
            anchored_at: 50,
            log_position: 1,
            chain_id: 1,
            submission_block: self.block,
        })
    }
    async fn verified_priority_snapshot(&self, _: [u8; 32]) -> Result<PrioritySnapshot, String> {
        Err("unused".into())
    }
}
fn m() -> v2::PocMeasurement {
    v2::PocMeasurement {
        chain_id: 1,
        fork_block: 100,
        target: [1; 32],
        asset_id: [2; 32],
        attacker_gain: 100,
        report_commitment: [3; 32],
    }
}
fn policy() -> PocPolicy {
    PocPolicy {
        chain_id: 1,
        fork_block: 100,
        max_block_drift: 10,
        in_scope_targets: vec![[1; 32]],
        asset_id: [2; 32],
        min_attacker_gain: 100,
    }
}
#[tokio::test]
async fn v2_has_no_submission_field_and_binds_anchor_commitment_preexistence_and_block() {
    let a = v2::VerifiedAnchor::resolve(
        &Source {
            block: 111,
            commitment: [3; 32],
        },
        [4; 32],
    )
    .await
    .unwrap();
    let measurement = m();
    assert_eq!(
        evaluate_poc(&policy(), &measurement.with_anchor(&a).unwrap()),
        PocVerdict::ForkOutsideWindow
    );
    assert!(v2::pre_existence_holds(&a, [3; 32], 51));
    assert!(!v2::pre_existence_holds(&a, [3; 32], 50));
    assert!(!v2::pre_existence_holds(&a, [9; 32], 51));
    let mut mismatch = m();
    mismatch.report_commitment = [8; 32];
    assert!(mismatch.with_anchor(&a).is_err());
    let mut value = serde_json::to_value(m()).unwrap();
    value["submission_block"] = 100.into();
    assert!(serde_json::from_value::<v2::PocMeasurement>(value).is_err());
    let mut changed = m();
    changed.report_commitment = [8; 32];
    assert_ne!(m().digest(), changed.digest());
}
#[test]
fn v2_uses_real_signatures_and_cannot_accept_v1_bytes_or_tampered_commitment() {
    let sk = SigningKey::from_bytes(&[7; 32]);
    let context = PocContext {
        report_digest: [1; 32],
        policy_digest: [2; 32],
        operation_id: [3; 32],
        parameters_digest: [4; 32],
    };
    let mut signed = v2::SignedPocMeasurement {
        version: 2,
        measurement: m(),
        context: context.clone(),
        verifier_id: [5; 32],
        public_key: sk.verifying_key().to_bytes(),
        signed_at: 40,
        signature_hex: String::new(),
    };
    signed.signature_hex = hex::encode(sk.sign(&signed.signing_bytes()).to_bytes());
    let mut registry = VerifierRegistry::default();
    registry
        .insert(VerifierEntry {
            verifier_id: [5; 32],
            operator_id: [6; 32],
            key_id: key_id(&signed.public_key),
            level: AttestationLevel::Workload,
            not_before: 10,
            not_after: 100,
            revoked: false,
        })
        .unwrap();
    let trust = PocSignatureTrust {
        registry: &registry,
        at: 50,
        max_age: 20,
        min_level: AttestationLevel::Workload,
    };
    assert!(signed.verify(&context, &trust).is_ok());
    let mut bad = signed.clone();
    bad.measurement.report_commitment = [7; 32];
    assert!(bad.verify(&context, &trust).is_err());
    let mut bad = signed.clone();
    bad.version = 1;
    assert!(bad.verify(&context, &trust).is_err());
    let v1 = arkhe_bugbounty::bounty_evidence::signed_poc::SignedPocMeasurement {
        version: 1,
        measurement: PocMeasurement {
            chain_id: 1,
            fork_block: 100,
            submission_block: 110,
            target: [1; 32],
            asset_id: [2; 32],
            attacker_gain: 100,
        },
        context: context.clone(),
        verifier_id: [5; 32],
        public_key: signed.public_key,
        signed_at: 40,
        signature_hex: String::new(),
    };
    let mut bad = signed;
    bad.signature_hex = hex::encode(sk.sign(&v1.signing_bytes()).to_bytes());
    assert!(bad.verify(&context, &trust).is_err());
}
