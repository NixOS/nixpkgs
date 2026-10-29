use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    work::*,
    worker::*,
    Digest32,
};
use arkhe_governance::{EvidenceKindRequirement, PolicyBinding, PolicyResolver, PolicyVerdict};
use arkhe_kernel::{broker::*, ContainmentGate};
use arkhe_verify_core::{
    action_proof::*,
    mmr::{build_root_and_proof, profile::PROFILE_DIGEST_HEX},
};
use async_trait::async_trait;
use ed25519_dalek::{Signer, SigningKey};
use std::{
    collections::HashMap,
    sync::{
        atomic::{AtomicUsize, Ordering},
        Arc,
    },
};

struct Allow;
impl PolicyResolver for Allow {
    fn resolve(&self, _: &WorkIntent, _: &PolicyBinding) -> PolicyVerdict {
        PolicyVerdict::Allow
    }
    fn required_worker_evidence(
        &self,
        _: &WorkIntent,
        _: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        Some(EvidenceKindRequirement {
            allowed_modules: vec!["test".into()],
            allowed_operations: vec![CognitiveOperation::Analyze],
        })
    }
}
struct Store(Option<EvidenceEnvelope>);
#[async_trait]
impl EvidenceReader for Store {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(self.0.as_ref().filter(|e| e.record_hash == hash).cloned())
    }
}
/// Reference journal for contract tests only, deliberately not exported.
type JournalEntries = HashMap<(String, Digest32), (Digest32, Option<Vec<u8>>)>;
#[derive(Default)]
struct Journal(JournalEntries);
impl DispatchJournal for Journal {
    fn reserve(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
    ) -> Result<Reservation, String> {
        let slot = (caller.into(), operation);
        if let Some((old, receipt)) = self.0.get(&slot) {
            if old != &binding {
                return Err("parameter conflict".into());
            }
            return Ok(match receipt {
                Some(r) => Reservation::Replay(r.clone()),
                None => Reservation::Uncertain,
            });
        }
        self.0.insert(slot, (binding, None));
        Ok(Reservation::Acquired)
    }
    fn complete(
        &mut self,
        caller: &str,
        operation: Digest32,
        binding: Digest32,
        receipt: &[u8],
    ) -> Result<(), String> {
        let (old, cached) = self
            .0
            .get_mut(&(caller.into(), operation))
            .ok_or("missing reservation")?;
        if *old != binding || cached.is_some() {
            return Err("invalid transition".into());
        }
        *cached = Some(receipt.to_vec());
        Ok(())
    }
}
struct Executor {
    calls: Arc<AtomicUsize>,
    fail: bool,
}
impl CapabilityExecutor for Executor {
    fn execute(&mut self, _: &WorkIntent) -> Result<Vec<u8>, String> {
        self.calls.fetch_add(1, Ordering::SeqCst);
        if self.fail {
            Err("uncertain upstream outcome".into())
        } else {
            Ok(b"receipt".to_vec())
        }
    }
}
fn fixture() -> (
    WorkIntent,
    WorkerExecutionRecord,
    PolicyBinding,
    Store,
    ActionProof,
    Trust,
) {
    let worker = WorkerExecutionRecord {
        classification: None,
        operation: Some(CognitiveOperation::Analyze),
        module_id: "test".into(),
        module_version: "1".into(),
        input_digest: Digest32([1; 32]),
        output_digest: Digest32([2; 32]),
        evidence_refs: vec![],
        confidence_bps: None,
        uncertainty_note: None,
        execution_id: "test".into(),
    };
    let intent = WorkIntent {
        requested_by: "operator".into(),
        intent_type: WorkIntentType::ApproveExpense,
        target: Digest32([3; 32]),
        parameters_digest: worker.output_digest,
        context: vec![
            ContextEntry {
                kind: ContextKind::SourceReport,
                hash: worker.input_digest,
            },
            ContextEntry {
                kind: ContextKind::AnalysisRecord,
                hash: worker.digest(),
            },
        ],
        context_refs: vec![],
        request_identity: RequestIdentity::new(b"action-1"),
        claimed_created_at: 0,
    };
    let policy = PolicyBinding {
        policy_id: "local".into(),
        version: 1,
        policy_digest: Digest32([4; 32]),
    };
    let mandate = Mandate {
        profile: PROFILE.into(),
        requested_by: intent.requested_by.clone(),
        intent_type: intent.intent_type.clone(),
        operation_id: intent.operation_id(),
        target: intent.target,
        policy_digest: policy.policy_digest,
        allowed_parameters: vec![intent.parameters_digest],
        issued_at: 10,
        expires_at: 100,
    };
    let key = SigningKey::from_bytes(&[11; 32]);
    let log = SigningKey::from_bytes(&[12; 32]);
    let payload = mandate_bytes(&mandate).unwrap();
    let (root, steps) = build_root_and_proof(std::slice::from_ref(&payload), 0).unwrap();
    let checkpoint = Checkpoint {
        profile_digest: PROFILE_DIGEST_HEX.into(),
        root,
        leaf_count: 1,
        issued_at: 20,
    };
    let proof = ActionProof {
        mandate,
        mandate_signature: key.sign(&payload).to_bytes().to_vec(),
        checkpoint_signature: log
            .sign(&checkpoint_bytes(&checkpoint).unwrap())
            .to_bytes()
            .to_vec(),
        checkpoint: checkpoint.clone(),
        leaf_index: 0,
        steps,
    };
    let trust = Trust {
        mandate_key: key.verifying_key(),
        log_key: log.verifying_key(),
        policy_digest: policy.policy_digest,
        checkpoint,
        now: 21,
        max_checkpoint_age: 30,
    };
    let store = Store(Some(EvidenceEnvelope {
        record_hash: worker.digest(),
        kind: "WorkerExecutionRecord".into(),
        subject: worker.input_digest,
        payload_digest: worker.digest(),
        policy_digest: None,
        causal_parents: vec![],
    }));
    (intent, worker, policy, store, proof, trust)
}

#[test]
fn mandate_rejects_tampering_in_every_signed_field_and_signature() {
    let (i, _, _, _, proof, trust) = fixture();
    assert!(verify(&proof, &i, &trust).is_ok());
    let mut variants = vec![];
    let mut p = proof.clone();
    p.mandate.requested_by = "other".into();
    variants.push(p);
    let mut p = proof.clone();
    p.mandate.intent_type = WorkIntentType::Publish;
    variants.push(p);
    let mut p = proof.clone();
    p.mandate.operation_id = Digest32::ZERO;
    variants.push(p);
    let mut p = proof.clone();
    p.mandate.target = Digest32::ZERO;
    variants.push(p);
    let mut p = proof.clone();
    p.mandate.policy_digest = Digest32::ZERO;
    variants.push(p);
    let mut p = proof.clone();
    p.mandate.allowed_parameters = vec![Digest32::ZERO];
    variants.push(p);
    let mut p = proof.clone();
    p.mandate.issued_at = 0;
    variants.push(p);
    let mut p = proof.clone();
    p.mandate.expires_at = 99;
    variants.push(p);
    let mut p = proof.clone();
    p.mandate.profile = "unknown".into();
    variants.push(p);
    let mut p = proof.clone();
    p.mandate_signature[0] ^= 1;
    variants.push(p);
    let mut p = proof.clone();
    p.checkpoint_signature[0] ^= 1;
    variants.push(p);
    let mut p = proof.clone();
    p.leaf_index = 1;
    variants.push(p);
    let mut p = proof.clone();
    p.checkpoint.leaf_count = 7;
    variants.push(p);
    for p in variants {
        assert!(verify(&p, &i, &trust).is_err());
    }
    let mut other = i.clone();
    other.request_identity = RequestIdentity::new(b"replay");
    assert!(verify(&proof, &other, &trust).is_err());
}

#[test]
fn checkpoint_is_independently_trusted_and_strictly_before_dispatch() {
    let (i, _, _, _, p, mut t) = fixture();
    for now in [-1, 20, 100, i64::MAX] {
        t.now = now;
        assert!(verify(&p, &i, &t).is_err());
    }
    t.now = 21;
    t.checkpoint.root[0] ^= 1;
    assert!(verify(&p, &i, &t).is_err());
    let (_, _, _, _, _, mut t) = fixture();
    t.mandate_key = SigningKey::from_bytes(&[99; 32]).verifying_key();
    assert!(verify(&p, &i, &t).is_err());
}

#[tokio::test]
async fn broker_requires_admission_and_never_redispatches_success_or_uncertainty() {
    for fail in [false, true] {
        let (i, w, policy, mut store, proof, trust) = fixture();
        let calls = Arc::new(AtomicUsize::new(0));
        let mut broker = CapabilityBroker::new(
            ContainmentGate::new(Allow),
            Journal::default(),
            Executor {
                calls: calls.clone(),
                fail,
            },
        );
        let admitted = store.0.take();
        assert!(broker
            .execute(&i, &w, &policy, &store, &proof, &trust)
            .await
            .is_err());
        assert_eq!(calls.load(Ordering::SeqCst), 0);
        store.0 = admitted;
        assert_eq!(
            broker
                .execute(&i, &w, &policy, &store, &proof, &trust)
                .await
                .is_err(),
            fail
        );
        assert_eq!(
            broker
                .execute(&i, &w, &policy, &store, &proof, &trust)
                .await
                .is_err(),
            fail
        );
        assert_eq!(calls.load(Ordering::SeqCst), 1);
        broker.set_emergency_stop(true);
        assert!(broker
            .execute(&i, &w, &policy, &store, &proof, &trust)
            .await
            .is_err());
    }
}
