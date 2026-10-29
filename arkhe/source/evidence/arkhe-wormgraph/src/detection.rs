//! Stage 8 laboratory: authenticated observations and a reproducible causal alert.
use crate::WormGraph;
use arkhe_core::{
    canonical::encode_value,
    evidence::{EvidenceCommitter, EvidenceEnvelope},
    Digest32,
};
use ed25519_dalek::{Signature, Signer, SigningKey, VerifyingKey};
use serde::{Deserialize, Serialize};
use std::collections::HashSet;

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Observation {
    pub sequence: u64,
    pub subject: String,
    pub timestamp: u64,
    pub kind: String,
    pub parents: Vec<Digest32>,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SignedObservation {
    pub observation: Observation,
    pub signature_hex: String,
}

impl SignedObservation {
    fn bytes(&self) -> Vec<u8> {
        let mut bytes = b"ARKHE:STAGE8:OBSERVATION:v1\0".to_vec();
        bytes.extend(encode_value(
            &serde_json::to_value(&self.observation).unwrap(),
        ));
        bytes
    }

    pub fn sign(observation: Observation, key: &SigningKey) -> Self {
        let mut event = Self {
            observation,
            signature_hex: String::new(),
        };
        event.signature_hex = hex::encode(key.sign(&event.bytes()).to_bytes());
        event
    }

    pub fn hash(&self) -> Digest32 {
        Digest32::blake3(
            b"ARKHE:STAGE8:RECORD:v1\0",
            &encode_value(&serde_json::to_value(self).unwrap()),
        )
    }

    fn verify_signature(&self, key: &VerifyingKey) -> Result<(), String> {
        let raw = hex::decode(&self.signature_hex).map_err(|_| "invalid signature hex")?;
        let signature = Signature::from_slice(&raw).map_err(|_| "invalid signature length")?;
        key.verify_strict(&self.bytes(), &signature)
            .map_err(|_| "signature rejected".into())
    }
}

/// External retention of this digest binds the complete ordered export, including its length.
pub fn checkpoint(events: &[SignedObservation]) -> Digest32 {
    Digest32::blake3(
        b"ARKHE:STAGE8:EXPORT:v1\0",
        &encode_value(&serde_json::to_value(events).unwrap()),
    )
}

fn expected_alert(events: &[SignedObservation]) -> Option<Vec<Digest32>> {
    let success = events.last()?;
    if success.observation.kind != "login_success" {
        return None;
    }
    let failures: Vec<_> = events
        .iter()
        .rev()
        .skip(1)
        .filter(|e| e.observation.subject == success.observation.subject)
        .take_while(|e| {
            e.observation.kind == "login_failure"
                && success
                    .observation
                    .timestamp
                    .saturating_sub(e.observation.timestamp)
                    <= 60
        })
        .take(3)
        .collect();
    if failures.len() != 3 {
        return None;
    }
    let mut parents: Vec<_> = failures
        .into_iter()
        .rev()
        .map(SignedObservation::hash)
        .collect();
    parents.push(success.hash());
    Some(parents)
}

fn validate_next(
    events: &[SignedObservation],
    event: &SignedObservation,
    key: &VerifyingKey,
) -> Result<(), String> {
    event.verify_signature(key)?;
    let o = &event.observation;
    if o.sequence != events.len() as u64 + 1 || o.subject.is_empty() {
        return Err("invalid sequence or empty subject".into());
    }
    if events
        .last()
        .is_some_and(|e| e.observation.timestamp > o.timestamp)
    {
        return Err("timestamp regression".into());
    }
    let unique: HashSet<_> = o.parents.iter().collect();
    if unique.len() != o.parents.len()
        || o.parents
            .iter()
            .any(|p| !events.iter().any(|e| e.hash() == *p))
    {
        return Err("duplicate or missing causal parent".into());
    }
    match o.kind.as_str() {
        "login_failure" | "login_success" if o.parents.is_empty() => Ok(()),
        "alert.bruteforce_success.v1" => {
            let parents = expected_alert(events).ok_or("alert rule not satisfied")?;
            let success = &events.last().unwrap().observation;
            if o.parents != parents
                || o.subject != success.subject
                || o.timestamp != success.timestamp
            {
                return Err("alert causal binding rejected".into());
            }
            Ok(())
        }
        _ => Err("unsupported event or parents on raw observation".into()),
    }
}

pub fn verify_export(
    events: &[SignedObservation],
    public_key: [u8; 32],
    expected: Digest32,
) -> Result<(), String> {
    let key = VerifyingKey::from_bytes(&public_key).map_err(|_| "invalid public key")?;
    if key.is_weak() || events.is_empty() {
        return Err("weak key or empty export".into());
    }
    for (index, event) in events.iter().enumerate() {
        validate_next(&events[..index], event, &key)?;
    }
    if checkpoint(events) != expected {
        return Err("checkpoint mismatch".into());
    }
    Ok(())
}

/// Dedicated admission boundary. Callers cannot insert unchecked observations into this trail.
pub struct DetectionTrail {
    graph: WormGraph,
    key: VerifyingKey,
    events: Vec<SignedObservation>,
}

impl DetectionTrail {
    pub fn new(public_key: [u8; 32]) -> Result<Self, String> {
        let key = VerifyingKey::from_bytes(&public_key).map_err(|_| "invalid public key")?;
        if key.is_weak() {
            return Err("weak key".into());
        }
        Ok(Self {
            graph: WormGraph::new(),
            key,
            events: vec![],
        })
    }
    pub fn events(&self) -> &[SignedObservation] {
        &self.events
    }
    pub async fn admit(&mut self, event: SignedObservation) -> Result<Digest32, String> {
        validate_next(&self.events, &event, &self.key)?;
        let id = event.hash();
        let o = &event.observation;
        self.graph
            .append_verified(EvidenceEnvelope {
                record_hash: id,
                kind: o.kind.clone(),
                subject: Digest32::blake3(b"ARKHE:STAGE8:SUBJECT:v1\0", o.subject.as_bytes()),
                payload_digest: Digest32::blake3(b"ARKHE:STAGE8:PAYLOAD:v1\0", &event.bytes()),
                policy_digest: Some(Digest32::blake3(
                    b"ARKHE:STAGE8:POLICY:v1\0",
                    b"3 failures then success; same subject; 60 seconds",
                )),
                causal_parents: o.parents.clone(),
            })
            .await?;
        self.events.push(event);
        Ok(id)
    }
}

pub async fn demo() -> Result<Vec<SignedObservation>, String> {
    // Public fixture key: intentionally unsuitable for production.
    let key = SigningKey::from_bytes(&[8; 32]);
    let mut trail = DetectionTrail::new(key.verifying_key().to_bytes())?;
    for (index, kind) in [
        "login_failure",
        "login_failure",
        "login_failure",
        "login_success",
    ]
    .iter()
    .enumerate()
    {
        trail
            .admit(SignedObservation::sign(
                Observation {
                    sequence: index as u64 + 1,
                    subject: "synthetic:alice".into(),
                    timestamp: 1000 + index as u64 * 10,
                    kind: (*kind).into(),
                    parents: vec![],
                },
                &key,
            ))
            .await?;
    }
    let parents = expected_alert(trail.events()).ok_or("demo did not trigger")?;
    trail
        .admit(SignedObservation::sign(
            Observation {
                sequence: 5,
                subject: "synthetic:alice".into(),
                timestamp: 1030,
                kind: "alert.bruteforce_success.v1".into(),
                parents,
            },
            &key,
        ))
        .await?;
    Ok(trail.events)
}

#[cfg(test)]
mod tests {
    use super::*;
    #[tokio::test]
    async fn offline_export_rejects_mutation_removal_reordering_and_wrong_signer() {
        let events = demo().await.unwrap();
        let key = SigningKey::from_bytes(&[8; 32]);
        let public = key.verifying_key().to_bytes();
        let pin = checkpoint(&events);
        assert!(verify_export(&events, public, pin).is_ok());
        let mut changed = events.clone();
        changed[0].observation.subject = "mallory".into();
        assert!(verify_export(&changed, public, pin).is_err());
        assert!(verify_export(&events[..4], public, pin).is_err());
        let mut changed = events.clone();
        changed.swap(0, 1);
        assert!(verify_export(&changed, public, pin).is_err());
        assert!(verify_export(
            &events,
            SigningKey::from_bytes(&[9; 32]).verifying_key().to_bytes(),
            pin
        )
        .is_err());
        let mut changed = events.clone();
        changed[4].observation.parents.pop();
        changed[4] = SignedObservation::sign(changed[4].observation.clone(), &key);
        assert!(verify_export(&changed, public, checkpoint(&changed)).is_err());
    }

    #[tokio::test]
    async fn admission_is_fail_closed_and_rule_respects_time_and_subject() {
        let events = demo().await.unwrap();
        let key = SigningKey::from_bytes(&[8; 32]);
        let mut trail = DetectionTrail::new(key.verifying_key().to_bytes()).unwrap();
        let mut bad = events[0].clone();
        bad.signature_hex = "00".repeat(64);
        assert!(trail.admit(bad).await.is_err());
        assert!(trail.events().is_empty());
        trail.admit(events[0].clone()).await.unwrap();
        assert!(trail.admit(events[0].clone()).await.is_err());
        let mut changed = events[..4].to_vec();
        changed[3].observation.timestamp = 1100;
        assert!(expected_alert(&changed).is_none());
        changed[3].observation.timestamp = 1030;
        changed[1].observation.subject = "bob".into();
        assert!(expected_alert(&changed).is_none());
    }
}
