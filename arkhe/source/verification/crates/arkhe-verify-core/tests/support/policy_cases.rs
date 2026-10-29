use arkhe_verify_core::policy::*;
use ed25519_dalek::{Signer, SigningKey};
use serde::Serialize;
use std::collections::{BTreeMap, BTreeSet};

pub fn principal() -> SigningKey {
    SigningKey::from_bytes(&[7; 32])
}
pub fn worker() -> SigningKey {
    SigningKey::from_bytes(&[8; 32])
}
pub fn policy() -> Policy {
    Policy {
        policy_id: "expense-v1".into(),
        max_amount_cents: 100_000,
        allowed: BTreeSet::from([
            ("mod-a".into(), "1.0.0".into()),
            ("mod-b".into(), "2.0.0".into()),
        ]),
    }
}
pub fn context() -> Context {
    Context {
        policy: policy(),
        audience: "arkhe:expenses".into(),
        now: 1_000,
        principal_keys: BTreeMap::from([(
            "principal-a".into(),
            principal().verifying_key().to_bytes(),
        )]),
        worker_keys: BTreeMap::from([
            ("worker-a".into(), worker().verifying_key().to_bytes()),
            (
                "worker-b".into(),
                SigningKey::from_bytes(&[9; 32]).verifying_key().to_bytes(),
            ),
        ]),
    }
}
pub fn resign_record(r: &mut Request) {
    r.worker_record.signature = worker()
        .sign(&r.worker_record.signed_message())
        .to_bytes()
        .to_vec();
    r.record_hash = r.worker_record.digest();
}
pub fn resign_all(r: &mut Request) {
    r.signed_intent.signature = principal()
        .sign(&r.signed_intent.intent.signed_message())
        .to_bytes()
        .to_vec();
    r.parameters_digest = r.signed_intent.intent.digest();
    r.worker_record.intent_digest = r.parameters_digest;
    resign_record(r);
}
pub fn base() -> Request {
    let action = Action {
        operation_id: "op-1".into(),
        amount_cents: 50_000,
        module_id: "mod-a".into(),
        module_version: "1.0.0".into(),
        payload: b"pay invoice 123 to vendor-a".to_vec(),
    };
    let intent = Intent {
        principal_id: "principal-a".into(),
        audience: context().audience,
        policy_digest: policy().digest(),
        not_before: 900,
        expires_at: 1_100,
        action: action.clone(),
    };
    let mut r = Request {
        action: action.clone(),
        parameters_digest: intent.digest(),
        record_hash: [0; 32],
        worker_record: WorkerRecord {
            worker_id: "worker-a".into(),
            action,
            intent_digest: intent.digest(),
            signature: vec![],
        },
        signed_intent: SignedIntent {
            intent,
            signature: vec![],
        },
    };
    resign_all(&mut r);
    r
}

#[derive(Serialize)]
pub struct Vector {
    pub name: String,
    pub request: Request,
    pub context: Context,
    pub expected_allow: bool,
}
pub fn vectors() -> Vec<Vector> {
    let mut out = vec![Vector {
        name: "valid".into(),
        request: base(),
        context: context(),
        expected_allow: true,
    }];
    let mut add = |name: &str, r: Request| {
        out.push(Vector {
            name: name.into(),
            request: r,
            context: context(),
            expected_allow: false,
        })
    };
    let mut r = base();
    r.parameters_digest[0] ^= 1;
    add("scenario_10_digest_replay", r);
    let mut r = base();
    r.action.amount_cents = 90_000;
    r.worker_record.action = r.action.clone();
    resign_record(&mut r);
    add("amount_changed_record_resigned", r);
    let mut r = base();
    r.action.operation_id = "op-2".into();
    r.worker_record.action = r.action.clone();
    resign_record(&mut r);
    add("operation_changed", r);
    let mut r = base();
    r.action.payload.push(1);
    r.worker_record.action = r.action.clone();
    resign_record(&mut r);
    add("payload_changed", r);
    let mut r = base();
    r.signed_intent.signature[0] ^= 1;
    add("principal_signature_forged", r);
    let mut r = base();
    r.worker_record.signature[0] ^= 1;
    add("worker_signature_forged", r);
    let mut r = base();
    r.worker_record.worker_id = "worker-b".into();
    resign_record(&mut r);
    add("worker_a_impersonates_b", r);
    let mut r = base();
    r.worker_record.action.operation_id = "other-operation".into();
    resign_record(&mut r);
    add("record_other_operation", r);
    let mut r = base();
    r.record_hash[0] ^= 1;
    add("record_hash_changed", r);
    let mut r = base();
    r.worker_record.intent_digest[0] ^= 1;
    resign_record(&mut r);
    add("record_other_intent", r);
    let mut r = base();
    r.signed_intent.intent.expires_at = 999;
    resign_all(&mut r);
    add("expired_intent", r);
    let mut r = base();
    r.signed_intent.intent.audience = "other-tenant".into();
    resign_all(&mut r);
    add("wrong_audience", r);
    let mut r = base();
    r.signed_intent.intent.policy_digest[0] ^= 1;
    resign_all(&mut r);
    add("wrong_policy", r);
    let mut r = base();
    r.action.amount_cents = 100_001;
    r.worker_record.action = r.action.clone();
    r.signed_intent.intent.action = r.action.clone();
    resign_all(&mut r);
    add("authenticated_overspend", r);
    let mut r = base();
    r.action.module_version = "2.0.0".into();
    r.worker_record.action = r.action.clone();
    r.signed_intent.intent.action = r.action.clone();
    resign_all(&mut r);
    add("module_version_cross_product", r);
    out
}
