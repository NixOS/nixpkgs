//! Version 2 uses a length-framed binary canonical contract, not JSON bytes.
use crate::ProvenanceRecord;
use anyhow::{ensure, Context, Result};
use arkhe_verify_core::mmr::{verify_proof, ProofStep};
use ed25519_dalek::{Signature, Signer, SigningKey, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::Value;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Event {
    pub schema: u32,
    pub log_id: String,
    pub event_id: String,
    pub producer_id: String,
    pub issued_at: u64,
    pub expires_at: u64,
    pub record: ProvenanceRecord,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Request {
    pub event: Event,
    pub signature: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Producer {
    pub id: String,
    pub public_key: String,
    pub org_id: String,
    pub source_system: String,
    pub object: String,
    pub fields: Vec<String>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Policy {
    pub schema: u32,
    pub log_id: String,
    pub bridge_public_key: String,
    pub producers: Vec<Producer>,
    pub max_age_secs: u64,
    pub max_ttl_secs: u64,
    pub future_skew_secs: u64,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Checkpoint {
    pub schema: u32,
    pub log_id: String,
    pub root: String,
    pub leaf_count: u64,
    pub previous_checkpoint_hash: String,
    pub issued_at: u64,
    pub policy_hash: String,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Bundle {
    pub schema: u32,
    pub request: Request,
    pub record_hash: String,
    pub checkpoint: Checkpoint,
    pub checkpoint_signature: String,
    pub proof: Vec<ProofStep>,
}

// Every item is u64be(byte_length) || bytes, including domain and integers.
fn frame(out: &mut Vec<u8>, bytes: &[u8]) {
    out.extend_from_slice(&(bytes.len() as u64).to_be_bytes());
    out.extend_from_slice(bytes);
}
fn text(out: &mut Vec<u8>, value: &str) {
    frame(out, value.as_bytes());
}
fn number(out: &mut Vec<u8>, value: u64) {
    frame(out, &value.to_be_bytes());
}
fn domain(name: &str) -> Vec<u8> {
    let mut out = Vec::new();
    text(&mut out, name);
    out
}
fn digest(bytes: &[u8]) -> String {
    blake3::hash(bytes).to_hex().to_string()
}
pub fn bytes32(value: &str) -> Result<[u8; 32]> {
    ensure!(
        value.len() == 64
            && value
                .bytes()
                .all(|b| b.is_ascii_digit() || (b'a'..=b'f').contains(&b)),
        "expected lowercase 32-byte hex"
    );
    hex::decode(value)?
        .try_into()
        .map_err(|_| anyhow::anyhow!("expected 32 bytes"))
}
pub fn signing_key(value: &str) -> Result<SigningKey> {
    Ok(SigningKey::from_bytes(&bytes32(value.trim())?))
}
pub fn public_key(key: &SigningKey) -> String {
    hex::encode(key.verifying_key().as_bytes())
}
fn signature_check(key: &str, bytes: &[u8], signature: &str) -> Result<()> {
    let key = VerifyingKey::from_bytes(&bytes32(key)?)?;
    ensure!(
        signature.len() == 128
            && signature
                .bytes()
                .all(|b| b.is_ascii_digit() || (b'a'..=b'f').contains(&b)),
        "invalid signature encoding"
    );
    key.verify_strict(bytes, &Signature::from_slice(&hex::decode(signature)?)?)
        .context("invalid Ed25519 signature")
}

impl Event {
    pub fn canonical(&self) -> Result<Vec<u8>> {
        ensure!(self.schema == 2, "unsupported event schema");
        for s in [
            &self.log_id,
            &self.event_id,
            &self.producer_id,
            &self.record.org_id,
            &self.record.object,
            &self.record.record_id,
            &self.record.field,
            &self.record.source_system,
        ] {
            ensure!(
                !s.trim().is_empty() && s.len() <= 1024,
                "invalid identity length"
            );
        }
        ensure!(
            self.expires_at >= self.issued_at,
            "expiry precedes issue time"
        );
        let timestamp = chrono::DateTime::parse_from_rfc3339(&self.record.observed_at)?;
        ensure!(
            timestamp.to_rfc3339_opts(chrono::SecondsFormat::Secs, true) == self.record.observed_at,
            "observed_at must be UTC RFC3339 seconds ending Z"
        );
        let mut out = domain("arkhe.crm.event.v2");
        number(&mut out, 2);
        for s in [&self.log_id, &self.event_id, &self.producer_id] {
            text(&mut out, s);
        }
        number(&mut out, self.issued_at);
        number(&mut out, self.expires_at);
        for s in [
            &self.record.org_id,
            &self.record.object,
            &self.record.record_id,
            &self.record.field,
        ] {
            text(&mut out, s);
        }
        match &self.record.value {
            Value::Null => text(&mut out, "null"),
            Value::Bool(v) => {
                text(&mut out, "bool");
                frame(&mut out, &[u8::from(*v)]);
            }
            Value::String(v) => {
                ensure!(v.len() <= 65536, "value too large");
                text(&mut out, "string");
                text(&mut out, v);
            }
            Value::Number(v) => {
                ensure!(
                    v.as_i64().is_some() || v.as_u64().is_some(),
                    "only integer numbers supported"
                );
                text(&mut out, "integer");
                text(&mut out, &v.to_string());
            }
            _ => anyhow::bail!("unsupported value type"),
        }
        text(&mut out, &self.record.source_system);
        text(&mut out, &self.record.observed_at);
        Ok(out)
    }
    pub fn hash(&self) -> Result<String> {
        Ok(digest(&self.canonical()?))
    }
}

impl Request {
    pub fn sign(event: Event, key: &SigningKey) -> Result<Self> {
        let signature = hex::encode(key.sign(&event.canonical()?).to_bytes());
        Ok(Self { event, signature })
    }
    pub fn authenticate(&self, policy: &Policy) -> Result<()> {
        policy.validate()?;
        ensure!(self.event.log_id == policy.log_id, "wrong log");
        let producer = policy
            .producers
            .iter()
            .find(|p| p.id == self.event.producer_id)
            .context("unknown producer")?;
        let r = &self.event.record;
        ensure!(
            producer.org_id == r.org_id
                && producer.source_system == r.source_system
                && producer.object == r.object
                && producer.fields.contains(&r.field),
            "producer scope denied"
        );
        signature_check(
            &producer.public_key,
            &self.event.canonical()?,
            &self.signature,
        )
    }
    pub fn fresh_at(&self, policy: &Policy, now: u64) -> Result<()> {
        let event = &self.event;
        ensure!(event.expires_at >= event.issued_at, "invalid time window");
        ensure!(
            event.expires_at - event.issued_at <= policy.max_ttl_secs,
            "TTL exceeds policy"
        );
        ensure!(
            event.issued_at <= now.saturating_add(policy.future_skew_secs),
            "event from future"
        );
        ensure!(
            now <= event.expires_at && now.saturating_sub(event.issued_at) <= policy.max_age_secs,
            "expired event"
        );
        Ok(())
    }
}

impl Policy {
    pub fn validate(&self) -> Result<()> {
        ensure!(
            self.schema == 2 && !self.log_id.trim().is_empty() && self.log_id.len() <= 1024,
            "invalid policy"
        );
        VerifyingKey::from_bytes(&bytes32(&self.bridge_public_key)?)?;
        ensure!(
            self.max_age_secs > 0 && self.max_ttl_secs > 0,
            "invalid time policy"
        );
        let mut ids = std::collections::HashSet::new();
        for p in &self.producers {
            ensure!(
                !p.id.trim().is_empty() && ids.insert(&p.id),
                "duplicate/empty producer id"
            );
            VerifyingKey::from_bytes(&bytes32(&p.public_key)?)?;
            ensure!(!p.fields.is_empty(), "empty producer scope");
        }
        Ok(())
    }
    pub fn hash(&self) -> Result<String> {
        self.validate()?;
        let mut out = domain("arkhe.crm.policy.v2");
        number(&mut out, 2);
        text(&mut out, &self.log_id);
        text(&mut out, &self.bridge_public_key);
        number(&mut out, self.max_age_secs);
        number(&mut out, self.max_ttl_secs);
        number(&mut out, self.future_skew_secs);
        let mut producers = self.producers.clone();
        producers.sort_by(|a, b| a.id.cmp(&b.id));
        number(&mut out, producers.len() as u64);
        for p in producers {
            for s in [&p.id, &p.public_key, &p.org_id, &p.source_system, &p.object] {
                text(&mut out, s);
            }
            let mut fields = p.fields;
            fields.sort();
            fields.dedup();
            number(&mut out, fields.len() as u64);
            for f in fields {
                text(&mut out, &f);
            }
        }
        Ok(digest(&out))
    }
}

impl Checkpoint {
    pub fn canonical(&self) -> Result<Vec<u8>> {
        ensure!(
            self.schema == 2 && self.leaf_count > 0,
            "invalid checkpoint"
        );
        let mut out = domain("arkhe.crm.checkpoint.v2");
        number(&mut out, 2);
        text(&mut out, &self.log_id);
        frame(&mut out, &bytes32(&self.root)?);
        number(&mut out, self.leaf_count);
        frame(&mut out, &bytes32(&self.previous_checkpoint_hash)?);
        number(&mut out, self.issued_at);
        frame(&mut out, &bytes32(&self.policy_hash)?);
        Ok(out)
    }
    pub fn hash(&self) -> Result<String> {
        Ok(digest(&self.canonical()?))
    }
    pub fn sign(&self, key: &SigningKey) -> Result<String> {
        Ok(hex::encode(key.sign(&self.canonical()?).to_bytes()))
    }
}

pub fn verify(bundle: &Bundle, policy: &Policy) -> Result<()> {
    ensure!(bundle.schema == 2, "unsupported bundle schema");
    let cp = &bundle.checkpoint;
    ensure!(
        cp.log_id == policy.log_id && cp.policy_hash == policy.hash()?,
        "checkpoint policy/log mismatch"
    );
    signature_check(
        &policy.bridge_public_key,
        &cp.canonical()?,
        &bundle.checkpoint_signature,
    )?;
    bundle.request.authenticate(policy)?;
    bundle.request.fresh_at(policy, cp.issued_at)?;
    ensure!(
        bundle.record_hash == bundle.request.event.hash()?,
        "event hash mismatch"
    );
    ensure!(bundle.proof.len() <= 128, "proof too long");
    let count = usize::try_from(cp.leaf_count)?;
    ensure!(
        verify_proof(
            &bytes32(&bundle.record_hash)?,
            count,
            &bundle.proof,
            &bytes32(&cp.root)?
        )?,
        "invalid inclusion proof"
    );
    Ok(())
}
