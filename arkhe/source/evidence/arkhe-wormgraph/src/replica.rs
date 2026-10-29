//! Recoverable, signed snapshot. MMR membership is not content availability.
use crate::{
    anchor::{CheckpointTrust, SignedCheckpoint},
    regenerate::{verify_checkpoint, RegenerationStatus, SequencedRecord},
};
use arkhe_core::{
    canonical::encode_value,
    evidence::{EvidenceEnvelope, EvidenceReader},
    Digest32,
};
use async_trait::async_trait;
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReplicaObject {
    pub kind: String,
    pub digest: Digest32,
    pub bytes: Vec<u8>,
}
impl ReplicaObject {
    pub fn verify(&self) -> Result<(), String> {
        let domain: &[u8] = match self.kind.as_str() {
            "WorkIntent" => b"AKG:WORKINTENT:v1\0",
            "WorkerExecutionRecord" => b"AKG:WER:v1\0",
            "MemoObservationPackage/v1" => b"AKG:MEMO:STORED-PACKAGE:v1\0",
            _ => return Err("unsupported replica content type".into()),
        };
        if self.bytes.is_empty()
            || self.bytes.len() > 20_000_000
            || Digest32::blake3(domain, &self.bytes) != self.digest
        {
            return Err("replica content digest mismatch".into());
        }
        Ok(())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReplicaRecord {
    pub append_sequence: u64,
    pub writer_epoch: u64,
    pub envelope: EvidenceEnvelope,
    pub contents: Vec<ReplicaObject>,
}
impl ReplicaRecord {
    pub fn verify(&self) -> Result<(), String> {
        if self.append_sequence == 0 || self.writer_epoch == 0 {
            return Err("invalid journal sequence".into());
        }
        let e = &self.envelope;
        let mut objects = HashMap::new();
        for object in &self.contents {
            object.verify()?;
            if objects
                .insert((object.kind.as_str(), object.digest), object)
                .is_some()
            {
                return Err("duplicate replica content".into());
            }
        }
        let needed = match e.kind.as_str() {
            "WorkerExecutionRecord" if e.record_hash == e.payload_digest => "WorkerExecutionRecord",
            "work-authorization" if e.policy_digest.is_some() => {
                if !objects.contains_key(&("WorkIntent", e.subject)) {
                    return Err("missing WorkIntent content".into());
                }
                "WorkerExecutionRecord"
            }
            "MemoObservationPackage/v1" if e.record_hash == e.payload_digest => {
                "MemoObservationPackage/v1"
            }
            _ => return Err("unsupported or inconsistent journal record".into()),
        };
        if !objects.contains_key(&(needed, e.payload_digest)) {
            return Err("journal payload content missing".into());
        }
        Ok(())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReplicaBundle {
    pub schema: String,
    pub writer_epoch: u64,
    pub checkpoint: SignedCheckpoint,
    pub records: Vec<ReplicaRecord>,
    pub signature_hex: String,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ReplicaTrust {
    pub checkpoint: CheckpointTrust,
    /// Operator high-water mark from independently verified anchored history.
    /// Rekor does not expose a reliable "latest epoch" discovery primitive.
    pub minimum_writer_epoch: u64,
}
impl ReplicaBundle {
    pub fn signing_bytes(&self) -> Vec<u8> {
        let mut bytes = b"AKG:REPLICA:BUNDLE:v1\0".to_vec();
        bytes.extend(encode_value(&serde_json::json!({
            "schema": self.schema, "writer_epoch": self.writer_epoch,
            "checkpoint": self.checkpoint, "records": self.records,
        })));
        bytes
    }
    pub fn verify_contents(&self) -> Result<(), String> {
        if self.schema != "arkhe-replica-bundle-v1"
            || self.writer_epoch == 0
            || self.records.is_empty()
            || self.records.len() > 1_000_000
        {
            return Err("invalid replica profile".into());
        }
        for record in &self.records {
            if record.writer_epoch > self.writer_epoch {
                return Err("record epoch exceeds snapshot epoch".into());
            }
            record.verify()?;
        }
        if self
            .records
            .windows(2)
            .any(|pair| pair[0].writer_epoch > pair[1].writer_epoch)
        {
            return Err("journal writer epoch regressed".into());
        }
        let records: Vec<_> = self
            .records
            .iter()
            .map(|r| SequencedRecord {
                append_sequence: r.append_sequence,
                record_hash: r.envelope.record_hash,
            })
            .collect();
        if verify_checkpoint(&self.checkpoint.binding(), &records).status
            != RegenerationStatus::Verified
        {
            return Err("journal prefix does not match MMR checkpoint".into());
        }
        let positions: HashMap<_, _> = self
            .records
            .iter()
            .enumerate()
            .map(|(i, r)| (r.envelope.record_hash, i))
            .collect();
        for (i, record) in self.records.iter().enumerate() {
            if record
                .envelope
                .causal_parents
                .iter()
                .any(|p| positions.get(p).is_none_or(|&j| j >= i))
            {
                return Err("missing or noncausal journal parent".into());
            }
        }
        Ok(())
    }
    pub fn verify(&self, trust: &ReplicaTrust) -> Result<ReplicaReader, String> {
        if trust.minimum_writer_epoch == 0 || self.writer_epoch < trust.minimum_writer_epoch {
            return Err("replica epoch below trusted anchored high-water mark".into());
        }
        self.checkpoint
            .verify(&self.checkpoint.binding(), &trust.checkpoint)
            .map_err(|e| e.0)?;
        let key =
            VerifyingKey::from_bytes(&trust.checkpoint.public_key).map_err(|e| e.to_string())?;
        let raw = hex::decode(&self.signature_hex).map_err(|e| e.to_string())?;
        let signature = Signature::from_slice(&raw).map_err(|e| e.to_string())?;
        key.verify_strict(&self.signing_bytes(), &signature)
            .map_err(|e| e.to_string())?;
        self.verify_contents()?;
        Ok(ReplicaReader {
            records: self.records.clone(),
        })
    }
}
/// Constructible only after bundle verification; offline content reads.
pub struct ReplicaReader {
    records: Vec<ReplicaRecord>,
}
impl ReplicaReader {
    pub fn canonical_object(&self, kind: &str, digest: Digest32) -> Option<&[u8]> {
        self.records
            .iter()
            .flat_map(|r| &r.contents)
            .find(|o| o.kind == kind && o.digest == digest)
            .map(|o| o.bytes.as_slice())
    }
}
#[async_trait]
impl EvidenceReader for ReplicaReader {
    async fn get(&self, hash: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(self
            .records
            .iter()
            .find(|r| r.envelope.record_hash == hash)
            .map(|r| r.envelope.clone()))
    }
}
