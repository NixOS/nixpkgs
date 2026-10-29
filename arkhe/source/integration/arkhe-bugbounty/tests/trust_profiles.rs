//! Real crypto with deterministic TEST roots and a local MMR; no public log.
use arkhe_bugbounty::bounty_evidence::{
    priority::*,
    signed_poc::{key_id, PocContext},
    trust::*,
    v2, *,
};
use arkhe_core::Digest32;
use arkhe_verify_core::mmr::{build_root_and_proof, ProofStep};
use ed25519_dalek::{Signer, SigningKey};
fn log_fixture(
    subject: Digest32,
) -> (
    AnchorLeaf,
    SignedCheckpoint,
    Vec<ProofStep>,
    CheckpointTrust,
) {
    let sk = SigningKey::from_bytes(&[7; 32]);
    let leaf = AnchorLeaf {
        claim: AnchoredClaim {
            log_id: [1; 32],
            commitment: [2; 32],
            report_digest: [3; 32],
            recipient: [4; 32],
            anchored_at: 50,
            log_position: 0,
            chain_id: 1,
            submission_block: 100,
        },
        subject_digest: subject,
    };
    let leaves = vec![leaf.canonical_bytes(), b"another leaf".to_vec()];
    let (root, proof) = build_root_and_proof(&leaves, 0).unwrap();
    let mut cp = SignedCheckpoint {
        log_id: [1; 32],
        root,
        leaf_count: 2,
        issued_at: 55,
        signature_hex: String::new(),
    };
    cp.signature_hex = hex::encode(sk.sign(&cp.signing_bytes()).to_bytes());
    let trust = CheckpointTrust {
        log_id: [1; 32],
        public_key: sk.verifying_key().to_bytes(),
        minimum_leaf_count: 2,
        earliest_checkpoint: 50,
        latest_checkpoint: 60,
    };
    (leaf, cp, proof, trust)
}
fn verified(subject: Digest32) -> ProofVerifiedAnchor {
    let (l, c, p, t) = log_fixture(subject);
    ProofVerifiedAnchor::verify(l, &c, &p, &t).unwrap()
}
#[tokio::test]
async fn inclusion_and_signed_checkpoint_bind_leaf_subject_report_and_time() {
    let (l, c, p, t) = log_fixture(Digest32([8; 32]));
    let a = ProofVerifiedAnchor::verify(l.clone(), &c, &p, &t).unwrap();
    assert_eq!(a.time().for_subject(Digest32([8; 32])).unwrap(), 50);
    assert!(a.time().for_subject(Digest32([9; 32])).is_err());
    assert!(a.precedes_patch([2; 32], 51));
    assert!(!a.precedes_patch([2; 32], 50));
    assert!(a.verified_anchor([9; 32]).await.is_err());
    assert!(a.verified_priority_snapshot([3; 32]).await.is_err());
    let mut leaf = l.clone();
    leaf.claim.anchored_at = 1;
    assert!(ProofVerifiedAnchor::verify(leaf, &c, &p, &t).is_err());
    let mut cp = c.clone();
    cp.issued_at = 54;
    assert!(ProofVerifiedAnchor::verify(l.clone(), &cp, &p, &t).is_err());
    let mut proof = p.clone();
    proof[0].hash = [9; 32];
    assert!(ProofVerifiedAnchor::verify(l.clone(), &c, &proof, &t).is_err());
    let wrong = CheckpointTrust {
        public_key: SigningKey::from_bytes(&[8; 32]).verifying_key().to_bytes(),
        ..t
    };
    assert!(ProofVerifiedAnchor::verify(l, &c, &p, &wrong).is_err());
}
fn roster() -> GovernedRegistryArtifact {
    GovernedRegistryArtifact {
        version: 1,
        registry_id: "TEST-ROSTER".into(),
        valid_from: 10,
        valid_until: 100,
        operator_dids: vec!["did:web:operator-a.example".into()],
        verifiers: vec![VerifierEntry {
            verifier_id: [1; 32],
            operator_id: operator_id("did:web:operator-a.example").unwrap(),
            key_id: [3; 32],
            level: AttestationLevel::Workload,
            not_before: 10,
            not_after: 100,
            revoked: false,
        }],
    }
}
fn approvals(a: &GovernedRegistryArtifact) -> (Vec<RegistryApproval>, RegistryGovernanceTrust) {
    let keys = [
        SigningKey::from_bytes(&[10; 32]),
        SigningKey::from_bytes(&[11; 32]),
    ];
    let approvals = keys
        .iter()
        .map(|k| RegistryApproval {
            public_key: k.verifying_key().to_bytes(),
            signature_hex: hex::encode(k.sign(&a.approval_bytes()).to_bytes()),
        })
        .collect();
    let trust = RegistryGovernanceTrust {
        public_keys: keys.iter().map(|k| k.verifying_key().to_bytes()).collect(),
        threshold: 2,
    };
    (approvals, trust)
}
#[test]
fn governance_quorum_authorizes_operator_mapping_and_registry_is_not_freely_mutable() {
    let a = roster();
    let (approvals, trust) = approvals(&a);
    let anchor = verified(a.digest());
    let r = GovernedVerifierRegistry::verify(&a, &approvals, &trust, anchor.time()).unwrap();
    assert!(r
        .authenticate(&[1; 32], &[3; 32], AttestationLevel::Workload)
        .is_ok());
    use arkhe_bugbounty::review::votes::*;
    let policy = Policy {
        policy_digest: [7; 32],
        auto_accept_enabled: true,
        auto_reject_enabled: false,
        min_confidence_permille: [500, 600, 700, 900, 950],
        required_independent_confirmations: 1,
    };
    let vote = RegisteredVote {
        vote: Vote {
            kind: VerifierKind::Replay,
            outcome: Outcome::Confirmed,
            verifier_id: [1; 32],
        },
        signing_key_id: [3; 32],
    };
    assert_eq!(
        route_with_governed_registry(
            Some(Assessment {
                severity: Severity::High,
                confidence_permille: 1000
            }),
            &[vote],
            &policy,
            true,
            &r,
            AttestationLevel::Workload
        )
        .decision,
        Decision::AutoAccept
    );
    assert_eq!(
        route_with_governed_registry(
            Some(Assessment {
                severity: Severity::High,
                confidence_permille: 1000
            }),
            &[vote],
            &policy,
            true,
            &r,
            AttestationLevel::Hardware
        )
        .reason,
        Reason::VerifierRegistryRejected
    );

    assert!(GovernedVerifierRegistry::verify(&a, &approvals[..1], &trust, anchor.time()).is_err());
    let mut altered = a.clone();
    altered.verifiers[0].operator_id = [9; 32];
    assert!(GovernedVerifierRegistry::verify(&altered, &approvals, &trust, anchor.time()).is_err());
    let (mut authorized, roots) = super_approvals(&altered);
    let altered_anchor = verified(altered.digest());
    assert!(
        GovernedVerifierRegistry::verify(&altered, &authorized, &roots, altered_anchor.time())
            .is_err()
    );
    authorized[1].public_key = authorized[0].public_key;
    assert!(
        GovernedVerifierRegistry::verify(&altered, &authorized, &roots, altered_anchor.time())
            .is_err()
    );
    assert!(operator_id("admin").is_err());
    assert!(operator_id("did:web:bad host").is_err());
}
fn super_approvals(
    a: &GovernedRegistryArtifact,
) -> (Vec<RegistryApproval>, RegistryGovernanceTrust) {
    approvals(a)
}
#[test]
fn receipt_time_cannot_be_borrowed_from_report_or_used_to_override_current_revocation() {
    let sk = SigningKey::from_bytes(&[12; 32]);
    let context = PocContext {
        report_digest: [1; 32],
        policy_digest: [2; 32],
        operation_id: [3; 32],
        parameters_digest: [4; 32],
    };
    let mut signed = v2::SignedPocMeasurement {
        version: 2,
        measurement: v2::PocMeasurement {
            chain_id: 1,
            fork_block: 1,
            target: [1; 32],
            asset_id: [2; 32],
            attacker_gain: 1,
            report_commitment: [3; 32],
        },
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
    let wrong = verified(Digest32([9; 32]));
    assert!(signed
        .verify_at_anchored_receipt(
            &context,
            &registry,
            wrong.time(),
            20,
            AttestationLevel::Workload
        )
        .is_err());
    let a = verified(signed.receipt_digest().unwrap());
    assert!(signed
        .verify_at_anchored_receipt(
            &context,
            &registry,
            a.time(),
            20,
            AttestationLevel::Workload
        )
        .is_ok());
    registry.revoke(&[5; 32]).unwrap();
    assert!(signed
        .verify_at_anchored_receipt(
            &context,
            &registry,
            a.time(),
            20,
            AttestationLevel::Workload
        )
        .is_err());
}
