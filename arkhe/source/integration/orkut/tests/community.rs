use arkhe_auth_md::{claims::PendingClaim, service::Service};
use arkhe_core::{
    work::{ContextKind, RequestIdentity},
    Digest32,
};
use arkhe_orkut::*;
use ed25519_dalek::SigningKey;

struct Human {
    subject: String,
    score: u16,
    audience: String,
}
impl HumanityVerifier for Human {
    fn verify(&self, _: &[u8], _: i64) -> Result<HumanityEvidence, Error> {
        Ok(HumanityEvidence {
            subject: self.subject.clone(),
            audience: self.audience.clone(),
            score: self.score,
            expires_at: 1000,
            digest: Digest32([42; 32]),
        })
    }
}
fn fixture() -> (Service, String) {
    let mut service = Service::new(
        "https://auth.example".into(),
        "https://orkut.example".into(),
        "key".into(),
        SigningKey::from_bytes(&[9; 32]),
    );
    let (mut pending, code) = PendingClaim::new(100).unwrap();
    pending.confirm(&code, "user", 101).unwrap();
    let reg = service
        .register_claimed(
            &mut pending,
            "user@example.com",
            102,
            &["community:join".into(), "community:post".into()],
        )
        .unwrap();
    let token = service
        .exchange(&reg.identity_assertion, "https://orkut.example", 103)
        .unwrap()
        .access_token;
    (service, token)
}

#[test]
fn token_and_verified_humanity_bind_proposal_with_stable_retry_identity() {
    let (mut service, token) = fixture();
    let trust = service.access_trust();
    let policy = CommunityPolicy {
        resource: "https://orkut.example".into(),
        minimum_humanity_score: 20,
    };
    let human = Human {
        subject: "user".into(),
        score: 20,
        audience: policy.resource.clone(),
    };
    let request = RequestIdentity::new(b"join-1");
    let p = propose(
        &policy,
        "rust",
        Action::Join,
        &token,
        &trust,
        service.token_state(),
        &human,
        b"synthetic",
        request,
        104,
    )
    .unwrap();
    let retry = propose(
        &policy,
        "rust",
        Action::Join,
        &token,
        &trust,
        service.token_state(),
        &human,
        b"synthetic",
        request,
        105,
    )
    .unwrap();
    assert_eq!(p.intent().operation_id(), retry.intent().operation_id());
    assert!(p
        .intent()
        .context
        .iter()
        .any(|e| e.kind == ContextKind::AuthToken));
    let other = Human {
        subject: "attacker".into(),
        ..human
    };
    assert!(matches!(
        propose(
            &policy,
            "rust",
            Action::Join,
            &token,
            &trust,
            service.token_state(),
            &other,
            b"proof",
            request,
            104
        ),
        Err(Error::Humanity)
    ));
    service.revoke_token(&token);
    assert!(propose(
        &policy,
        "rust",
        Action::Join,
        &token,
        &trust,
        service.token_state(),
        &other,
        b"proof",
        request,
        104
    )
    .is_err());
}

#[test]
fn humanity_score_audience_and_expired_access_are_rejected() {
    let (mut service, token) = fixture();
    let trust = service.access_trust();
    let policy = CommunityPolicy {
        resource: "https://orkut.example".into(),
        minimum_humanity_score: 20,
    };
    for (score, audience, now) in [
        (19, "https://orkut.example", 104),
        (20, "https://attacker.example", 104),
        (20, "https://orkut.example", 500),
    ] {
        let human = Human {
            subject: "user".into(),
            score,
            audience: audience.into(),
        };
        assert!(propose(
            &policy,
            "rust",
            Action::Post {
                content: "hello".into(),
                provenance: None
            },
            &token,
            &trust,
            service.token_state(),
            &human,
            b"synthetic",
            RequestIdentity::new(b"post"),
            now
        )
        .is_err());
    }
}

use arkhe_bugbounty::{Kernel, OperationJournal};
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    work::WorkIntent,
    worker::WorkerExecutionRecord,
};
use arkhe_governance::{EvidenceKindRequirement, PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::ContainmentGate;
use async_trait::async_trait;
use std::sync::{
    atomic::{AtomicUsize, Ordering},
    Arc, Mutex,
};

// Synthetic admission fixture, not a production signature/provenance verifier.
#[derive(Default)]
struct Store(Mutex<std::collections::HashMap<Digest32, EvidenceEnvelope>>);
#[async_trait]
impl EvidenceReader for Store {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(self.0.lock().unwrap().get(&hash).cloned())
    }
}
#[async_trait]
impl Kernel for Store {
    async fn admit(&self, w: &WorkerExecutionRecord) -> Result<Digest32, String> {
        let h = w.digest();
        self.0.lock().unwrap().insert(
            h,
            EvidenceEnvelope {
                record_hash: h,
                kind: "WorkerExecutionRecord".into(),
                subject: w.input_digest,
                payload_digest: h,
                policy_digest: None,
                causal_parents: w.evidence_refs.clone(),
            },
        );
        Ok(h)
    }
}
struct Policy;
impl PolicyResolver for Policy {
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        PolicyVerdict::Allow
    }
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec!["orkut-community-v1".into()],
            allowed_operations: vec![arkhe_core::worker::CognitiveOperation::Analyze],
        })
    }
}
struct Backend(AtomicUsize);
#[async_trait]
impl executor::CommunityBackend for Backend {
    async fn execute(&self, _: &Proposal, _: Digest32) -> Result<Digest32, String> {
        self.0.fetch_add(1, Ordering::SeqCst);
        Ok(Digest32([5; 32]))
    }
}
struct Recheck(bool);
#[async_trait]
impl executor::Revalidator for Recheck {
    async fn revalidate(&self, _: &Proposal) -> Result<(), String> {
        if self.0 {
            Ok(())
        } else {
            Err("revoked before dispatch".into())
        }
    }
}
#[tokio::test]
async fn admitted_execution_replays_once_and_revocation_recheck_blocks_dispatch() {
    let (mut service, token) = fixture();
    let trust = service.access_trust();
    let policy = CommunityPolicy {
        resource: "https://orkut.example".into(),
        minimum_humanity_score: 20,
    };
    let human = Human {
        subject: "user".into(),
        score: 20,
        audience: policy.resource.clone(),
    };
    let p = propose(
        &policy,
        "rust",
        Action::Join,
        &token,
        &trust,
        service.token_state(),
        &human,
        b"synthetic",
        RequestIdentity::new(b"once"),
        104,
    )
    .unwrap();
    let mut e = executor::Executor {
        kernel: Store::default(),
        backend: Backend(AtomicUsize::new(0)),
        revalidator: Recheck(true),
        journal: Arc::new(OperationJournal::default()),
        gate: ContainmentGate::new(Policy),
        policy: PolicyBinding {
            policy_id: "synthetic".into(),
            version: 1,
            policy_digest: Digest32::ZERO,
        },
    };
    let first = e.execute(&p).await.unwrap();
    assert_eq!(first.digest(), e.execute(&p).await.unwrap().digest());
    assert_eq!(e.backend.0.load(Ordering::SeqCst), 1);
    assert_eq!(e.kernel.0.lock().unwrap().len(), 2);
    e.journal = Arc::new(OperationJournal::default());
    e.revalidator = Recheck(false);
    assert!(e.execute(&p).await.is_err());
    assert_eq!(e.backend.0.load(Ordering::SeqCst), 1);
}
