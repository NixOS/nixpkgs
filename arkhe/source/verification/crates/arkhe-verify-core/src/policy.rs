//! Authenticated policy profile, shared by native tests and the production WASM.
//! Host-owned trust/context is mandatory. Pure admission does not consume a nonce;
//! replay/dispatch atomicity remains the responsibility of the operation journal.
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
use sha2::{Digest, Sha256};
use std::collections::{BTreeMap, BTreeSet};

pub type Hash = [u8; 32];

/// Migrated executors receive this exact typed action, not independent parameters.
pub fn legacy_parameters_digest(action: &Action) -> arkhe_core::Digest32 {
    arkhe_core::Digest32::blake3(
        b"AKG:LEGACY:POLICY:PARAMETERS:v1\0",
        &action.canonical_bytes(),
    )
}
pub fn verify_legacy(
    request: &Request,
    ctx: &Context,
    intent: &arkhe_core::work::WorkIntent,
    worker: &arkhe_core::worker::WorkerExecutionRecord,
    binding: arkhe_core::Digest32,
) -> Result<(), String> {
    evaluate(request, ctx).map_err(|e| e.to_string())?;
    if request.signed_intent.intent.principal_id != intent.requested_by
        || request.action.operation_id != intent.operation_id().to_hex()
        || request.action.module_id != worker.module_id
        || request.action.module_version != worker.module_version
        || legacy_parameters_digest(&request.action) != intent.parameters_digest
        || binding.0 != ctx.policy.digest()
    {
        return Err("authenticated action does not bind legacy intent/worker/policy".into());
    }
    Ok(())
}
fn hash(bytes: &[u8]) -> Hash {
    Sha256::digest(bytes).into()
}
fn field(out: &mut Vec<u8>, bytes: &[u8]) {
    out.extend_from_slice(&(bytes.len() as u64).to_be_bytes());
    out.extend_from_slice(bytes);
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Action {
    pub operation_id: String,
    pub amount_cents: u64,
    pub module_id: String,
    pub module_version: String,
    pub payload: Vec<u8>,
}
impl Action {
    pub fn canonical_bytes(&self) -> Vec<u8> {
        let mut out = b"AKG:POLICY:ACTION:v1\0".to_vec();
        field(&mut out, self.operation_id.as_bytes());
        out.extend_from_slice(&self.amount_cents.to_be_bytes());
        field(&mut out, self.module_id.as_bytes());
        field(&mut out, self.module_version.as_bytes());
        field(&mut out, &self.payload);
        out
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Policy {
    pub policy_id: String,
    pub max_amount_cents: u64,
    /// Module/version pairs, not independent lists allowing a cross product.
    pub allowed: BTreeSet<(String, String)>,
}
impl Policy {
    pub fn digest(&self) -> Hash {
        let mut out = b"AKG:POLICY:RULES:v1\0".to_vec();
        field(&mut out, self.policy_id.as_bytes());
        out.extend_from_slice(&self.max_amount_cents.to_be_bytes());
        out.extend_from_slice(&(self.allowed.len() as u64).to_be_bytes());
        for (module, version) in &self.allowed {
            field(&mut out, module.as_bytes());
            field(&mut out, version.as_bytes());
        }
        hash(&out)
    }
    pub fn permits_action(&self, action: &Action) -> bool {
        action.amount_cents <= self.max_amount_cents
            && self
                .allowed
                .contains(&(action.module_id.clone(), action.module_version.clone()))
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Intent {
    pub principal_id: String,
    pub audience: String,
    pub policy_digest: Hash,
    pub not_before: i64,
    pub expires_at: i64,
    pub action: Action,
}
impl Intent {
    pub fn signed_message(&self) -> Vec<u8> {
        let mut out = b"AKG:POLICY:INTENT:v1\0".to_vec();
        field(&mut out, self.principal_id.as_bytes());
        field(&mut out, self.audience.as_bytes());
        out.extend_from_slice(&self.policy_digest);
        out.extend_from_slice(&self.not_before.to_be_bytes());
        out.extend_from_slice(&self.expires_at.to_be_bytes());
        field(&mut out, &self.action.canonical_bytes());
        out
    }
    pub fn digest(&self) -> Hash {
        hash(&self.signed_message())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SignedIntent {
    pub intent: Intent,
    pub signature: Vec<u8>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct WorkerRecord {
    pub worker_id: String,
    pub action: Action,
    pub intent_digest: Hash,
    pub signature: Vec<u8>,
}
impl WorkerRecord {
    pub fn signed_message(&self) -> Vec<u8> {
        let mut out = b"AKG:POLICY:WORKER:v1\0".to_vec();
        field(&mut out, self.worker_id.as_bytes());
        field(&mut out, &self.action.canonical_bytes());
        out.extend_from_slice(&self.intent_digest);
        out
    }
    pub fn digest(&self) -> Hash {
        hash(&self.signed_message())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Request {
    pub action: Action,
    pub parameters_digest: Hash,
    pub record_hash: Hash,
    pub worker_record: WorkerRecord,
    pub signed_intent: SignedIntent,
}

/// Trusted input from the host, never accepted as authority from an agent.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Context {
    pub policy: Policy,
    pub principal_keys: BTreeMap<String, Hash>,
    pub worker_keys: BTreeMap<String, Hash>,
    pub audience: String,
    pub now: i64,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize, thiserror::Error)]
pub enum Rejection {
    #[error("principal not authorized")]
    Principal,
    #[error("invalid principal signature")]
    IntentSignature,
    #[error("wrong audience or policy")]
    Context,
    #[error("intent not currently valid")]
    Time,
    #[error("request differs from authenticated intent")]
    IntentBinding,
    #[error("worker not authorized")]
    Worker,
    #[error("invalid worker signature")]
    WorkerSignature,
    #[error("worker record differs from request or intent")]
    RecordBinding,
    #[error("record hash mismatch")]
    RecordHash,
    #[error("action outside policy")]
    Policy,
}

fn signature_ok(key: &Hash, message: &[u8], signature: &[u8]) -> bool {
    let Ok(key) = VerifyingKey::from_bytes(key) else {
        return false;
    };
    let Ok(sig) = Signature::from_slice(signature) else {
        return false;
    };
    key.verify_strict(message, &sig).is_ok()
}

pub fn evaluate(request: &Request, ctx: &Context) -> Result<(), Rejection> {
    let signed = &request.signed_intent;
    let intent = &signed.intent;
    let key = ctx
        .principal_keys
        .get(&intent.principal_id)
        .ok_or(Rejection::Principal)?;
    if !signature_ok(key, &intent.signed_message(), &signed.signature) {
        return Err(Rejection::IntentSignature);
    }
    if intent.audience != ctx.audience || intent.policy_digest != ctx.policy.digest() {
        return Err(Rejection::Context);
    }
    if intent.not_before > ctx.now
        || intent.expires_at <= ctx.now
        || intent.expires_at <= intent.not_before
    {
        return Err(Rejection::Time);
    }
    if request.action != intent.action || request.parameters_digest != intent.digest() {
        return Err(Rejection::IntentBinding);
    }
    let record = &request.worker_record;
    let worker_key = ctx
        .worker_keys
        .get(&record.worker_id)
        .ok_or(Rejection::Worker)?;
    if !signature_ok(worker_key, &record.signed_message(), &record.signature) {
        return Err(Rejection::WorkerSignature);
    }
    if record.action != request.action || record.intent_digest != intent.digest() {
        return Err(Rejection::RecordBinding);
    }
    if request.record_hash != record.digest() {
        return Err(Rejection::RecordHash);
    }
    if !ctx.policy.permits_action(&request.action) {
        return Err(Rejection::Policy);
    }
    Ok(())
}

/// Migration evidence is separate from runtime permissions. Reasons grant no access.
#[derive(Debug, Clone)]
pub struct VersionRestriction {
    pub old_policy: Hash,
    pub new_policy: Hash,
    pub module_id: String,
    pub removed_version: String,
    pub reason: String,
}
pub fn compatible_for(
    old: &Policy,
    new: &Policy,
    action: &Action,
    reasons: &[VersionRestriction],
) -> bool {
    !old.permits_action(action) || new.permits_action(action) || reasons.iter().any(|r| {
        !r.reason.trim().is_empty() && r.old_policy == old.digest() && r.new_policy == new.digest()
            && r.module_id == action.module_id && r.removed_version == action.module_version
            // Only a version removal is explained; lowered spending limits are not.
            && new.max_amount_cents >= action.amount_cents
            && old.allowed.contains(&(r.module_id.clone(), r.removed_version.clone()))
            && !new.allowed.contains(&(r.module_id.clone(), r.removed_version.clone()))
    })
}
