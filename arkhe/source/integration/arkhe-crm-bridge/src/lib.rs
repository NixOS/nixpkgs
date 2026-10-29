use anyhow::{ensure, Result};
use arkhe_verify_core::mmr::{build_root_and_proof, verify_proof, ProofStep};
use serde::{Deserialize, Serialize};
use serde_json::Value;

pub mod salesforce;
pub mod storage;
pub mod v2;

/// A single field observation, not an attestation by the named source.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct ProvenanceRecord {
    pub org_id: String,
    pub object: String,
    pub record_id: String,
    pub field: String,
    pub value: Value,
    pub source_system: String,
    pub observed_at: String,
}

impl ProvenanceRecord {
    pub fn hash(&self) -> Result<Vec<u8>> {
        for s in [
            &self.org_id,
            &self.object,
            &self.record_id,
            &self.field,
            &self.source_system,
        ] {
            ensure!(
                !s.trim().is_empty(),
                "identity and source fields must be nonempty"
            );
        }
        chrono::DateTime::parse_from_rfc3339(&self.observed_at)?;
        // Phase 1 accepts Salesforce scalar fields only. This avoids inventing a
        // cross-language canonicalization scheme for nested JSON and floats.
        ensure!(
            matches!(&self.value, Value::Null | Value::Bool(_) | Value::String(_))
                || self.value.as_i64().is_some()
                || self.value.as_u64().is_some(),
            "value must be null, boolean, string or integer"
        );
        let mut hasher = blake3::Hasher::new_derive_key("arkhe.crm.provenance.record.v1");
        hasher.update(&serde_json::to_vec(self)?);
        Ok(hasher.finalize().as_bytes().to_vec())
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Bundle {
    pub schema: u32,
    pub record: ProvenanceRecord,
    pub record_hash: String,
    pub leaf_count: usize,
    pub root: String,
    pub proof: Vec<ProofStep>,
}

pub fn anchor(records: &[ProvenanceRecord]) -> Result<Bundle> {
    ensure!(!records.is_empty(), "empty journal");
    let leaves = records
        .iter()
        .map(ProvenanceRecord::hash)
        .collect::<Result<Vec<_>>>()?;
    let (root, proof) = build_root_and_proof(&leaves, records.len() - 1)?;
    Ok(Bundle {
        schema: 1,
        record: records.last().unwrap().clone(),
        record_hash: hex::encode(leaves.last().unwrap()),
        leaf_count: leaves.len(),
        root: hex::encode(root),
        proof,
    })
}

/// Trust must come from a root obtained independently of the untrusted bundle.
pub fn verify(bundle: &Bundle, trusted_root: &str) -> Result<()> {
    ensure!(bundle.schema == 1, "unsupported schema");
    let root: [u8; 32] = hex::decode(trusted_root)?
        .try_into()
        .map_err(|_| anyhow::anyhow!("trusted root must be 32 bytes"))?;
    ensure!(
        hex::decode(&bundle.root)? == root,
        "root differs from trusted checkpoint"
    );
    let leaf = bundle.record.hash()?;
    ensure!(
        hex::encode(&leaf) == bundle.record_hash,
        "record hash mismatch"
    );
    ensure!(
        verify_proof(&leaf, bundle.leaf_count, &bundle.proof, &root)?,
        "invalid inclusion proof"
    );
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    fn record() -> ProvenanceRecord {
        serde_json::from_str(include_str!("../fixtures/lead.json")).unwrap()
    }
    #[test]
    fn roundtrip_and_tamper_detection() {
        let mut records = Vec::new();
        for i in 0..17 {
            let mut r = record();
            r.record_id = format!("lead-{i}");
            records.push(r);
            let b = anchor(&records).unwrap();
            verify(&b, &b.root).unwrap();
            let mut bad = b.clone();
            bad.record.value = Value::String("tampered".into());
            assert!(verify(&bad, &b.root).is_err());
            let mut bad = b.clone();
            bad.record.source_system = "forged".into();
            assert!(verify(&bad, &b.root).is_err());
            let mut bad = b.clone();
            bad.root = "00".repeat(32);
            assert!(verify(&bad, &b.root).is_err());
            if let Some(step) = bad.proof.first_mut() {
                step.hash[0] ^= 1;
            }
            bad.root = b.root.clone();
            if !bad.proof.is_empty() {
                assert!(verify(&bad, &b.root).is_err());
            }
        }
    }
    #[test]
    fn rejects_unsupported_values_and_invalid_identity() {
        let mut r = record();
        r.value = serde_json::json!({"nested":true});
        assert!(r.hash().is_err());
        r = record();
        r.observed_at = "yesterday".into();
        assert!(r.hash().is_err());
        r = record();
        r.org_id.clear();
        assert!(r.hash().is_err());
        assert!(anchor(&[]).is_err());
    }
}
