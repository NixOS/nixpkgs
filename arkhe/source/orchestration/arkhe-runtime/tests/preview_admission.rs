#[path = "support/preview_fixture.rs"]
mod fixture;
use arkhe_core::{evidence::EvidenceReader, Digest32};
use arkhe_governance::{PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{AuthorizationDecision, ContainmentGate};
use arkhe_runtime::preview::admit_preview;
use async_trait::async_trait;
use fixture::{fixture, hash, sign, Baseline};

const NOW: i64 = 1_800_000_000;

#[tokio::test]
async fn review_challenge_checks_supervisor_but_never_grants_unsigned_admission() {
    let (mut request, trust, baseline) = fixture(NOW);
    request.reviewer_signature.clear();
    let challenge = arkhe_runtime::preview::review_preview(request.clone(), &trust, &baseline, NOW)
        .await
        .unwrap();
    assert_eq!(
        challenge.signing_payload_hex,
        hex::encode(request.reviewer_signing_bytes())
    );
    assert!(admit_preview(request.clone(), &trust, &baseline, NOW)
        .await
        .is_err());
    request.supervisor_signature.clear();
    assert!(
        arkhe_runtime::preview::review_preview(request, &trust, &baseline, NOW)
            .await
            .is_err()
    );
}

#[tokio::test]
async fn signed_preview_is_admitted_with_deterministic_identity() {
    let (request, trust, baseline) = fixture(NOW);
    let a = admit_preview(request.clone(), &trust, &baseline, NOW)
        .await
        .unwrap();
    let b = admit_preview(request, &trust, &baseline, NOW)
        .await
        .unwrap();
    assert_eq!(a.authorization_ref(), b.authorization_ref());
    assert_eq!(a.operation_id(), b.operation_id());
    assert_ne!(a.authorization_ref(), Digest32::ZERO);
}

#[tokio::test]
async fn scope_changes_are_rejected_even_with_new_valid_signatures() {
    for change in 0..10 {
        let (mut request, trust, baseline) = fixture(NOW);
        match change {
            0 => request.spec.tenant = "other".into(),
            1 => request.intent.requested_by = "impostor".into(),
            2 => request.spec.image = "sha256:tag".into(),
            3 => request.spec.runtime_profile = hash(99),
            4 => request.spec.artifact_digest = hash(99),
            5 => request.spec.proposal_digest = hash(99),
            6 => request.review.policy_digest = hash(99),
            7 => request.spec.module = "unapproved-crate".into(),
            8 => request.worker.module_version = "2".into(),
            _ => request.review.reviewer = "impostor".into(),
        }
        sign(&mut request);
        assert!(
            admit_preview(request, &trust, &baseline, NOW)
                .await
                .is_err(),
            "change {change}"
        );
    }
}

#[tokio::test]
async fn both_signatures_are_required_and_cannot_be_swapped_or_tampered() {
    for change in 0..5 {
        let (mut request, trust, baseline) = fixture(NOW);
        match change {
            0 => request.supervisor_signature.clear(),
            1 => request.reviewer_signature = "00".repeat(64),
            2 => std::mem::swap(
                &mut request.supervisor_signature,
                &mut request.reviewer_signature,
            ),
            3 => request.worker.uncertainty_note = Some("changed after signing".into()),
            _ => {
                request.completed_at -= 1;
            }
        }
        assert!(
            admit_preview(request, &trust, &baseline, NOW)
                .await
                .is_err(),
            "change {change}"
        );
    }
}

#[tokio::test]
async fn freshness_review_and_kill_switch_fail_closed() {
    for change in 0..8 {
        let (mut request, mut trust, baseline) = fixture(NOW);
        match change {
            0 => request.completed_at = NOW + 1,
            1 => request.completed_at = NOW - 301,
            2 => request.review.expires_at = NOW,
            3 => request.review.reviewed_at = NOW + 1,
            4 => request.review.expires_at = NOW + 1000,
            5 => request.review.verdict = arkhe_core::review::HumanVerdict::Reject,
            6 => trust.emergency_stop = true,
            _ => trust.supervisor_key = trust.reviewer_key,
        }
        sign(&mut request);
        assert!(
            admit_preview(request, &trust, &baseline, NOW)
                .await
                .is_err(),
            "change {change}"
        );
    }
}

#[tokio::test]
async fn missing_or_unavailable_baseline_never_admits() {
    let (request, trust, _) = fixture(NOW);
    assert!(
        admit_preview(request.clone(), &trust, &Baseline(hash(99)), NOW)
            .await
            .is_err()
    );
    struct Offline;
    #[async_trait]
    impl EvidenceReader for Offline {
        async fn get(
            &self,
            _: Digest32,
        ) -> Result<Option<arkhe_core::evidence::EvidenceEnvelope>, String> {
            Err("offline".into())
        }
    }
    assert!(admit_preview(request, &trust, &Offline, NOW).await.is_err());
}

#[tokio::test]
async fn duplicate_context_and_reused_review_for_new_operation_are_rejected() {
    let (mut request, trust, baseline) = fixture(NOW);
    request
        .intent
        .context
        .push(request.intent.context[0].clone());
    assert!(admit_preview(request, &trust, &baseline, NOW)
        .await
        .is_err());
    let (mut request, trust, baseline) = fixture(NOW);
    request.intent.request_identity =
        arkhe_core::work::RequestIdentity::new(b"different-operation");
    sign(&mut request);
    assert!(admit_preview(request, &trust, &baseline, NOW)
        .await
        .is_err());
}

#[test]
fn basic_gate_cannot_bypass_release_admission_even_with_allow_policy() {
    struct Allow;
    impl PolicyResolver for Allow {
        fn resolve(&self, _: &arkhe_core::work::WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
            PolicyVerdict::Allow
        }
    }
    let (request, trust, _) = fixture(NOW);
    let gate = ContainmentGate::new(Allow);
    let binding = PolicyBinding {
        policy_id: "any".into(),
        version: 1,
        policy_digest: trust.policy_digest,
    };
    assert!(matches!(
        gate.authorize(&request.intent, Some(&request.worker), &binding),
        AuthorizationDecision::Reject { .. }
    ));
}
