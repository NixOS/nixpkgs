use arkhe_core::{canonical::encode_value, worker::WorkerExecutionRecord, Digest32};
use ed25519_dalek::{Signature, Signer, SigningKey, VerifyingKey};
use serde::{Deserialize, Serialize};
pub mod provenance;

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TestRun {
    pub command: Vec<String>,
    pub exit_code: Option<i32>,
    pub passed: bool,
    pub stdout_digest: Digest32,
    pub stderr_digest: Digest32,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CareerRecord {
    pub schema: String,
    pub recorded_at: String,
    pub wer: WorkerExecutionRecord,
    pub test_run: TestRun,
    pub signer_public_key: String,
    pub signature: String,
}

impl CareerRecord {
    fn signing_bytes(&self) -> anyhow::Result<Vec<u8>> {
        let mut value = serde_json::to_value(self)?;
        value.as_object_mut().unwrap().remove("signature");
        let mut bytes = b"arkhe:twin:career-record:v1\0".to_vec();
        bytes.extend(encode_value(&value));
        Ok(bytes)
    }

    pub fn sign(&mut self, key: &SigningKey) -> anyhow::Result<()> {
        self.signer_public_key = hex::encode(key.verifying_key().as_bytes());
        self.signature = hex::encode(key.sign(&self.signing_bytes()?).to_bytes());
        Ok(())
    }

    pub fn verify(&self, trusted_public_key: &str) -> anyhow::Result<()> {
        anyhow::ensure!(
            self.schema == "arkhe:twin:career-record:v1",
            "unsupported schema"
        );
        let trusted: [u8; 32] = hex::decode(trusted_public_key)?
            .try_into()
            .map_err(|_| anyhow::anyhow!("public key must be 32 bytes"))?;
        anyhow::ensure!(
            hex::decode(&self.signer_public_key)? == trusted,
            "untrusted signer"
        );
        anyhow::ensure!(
            self.test_run.passed == (self.test_run.exit_code == Some(0)),
            "inconsistent test result"
        );
        let signature = Signature::from_slice(&hex::decode(&self.signature)?)?;
        VerifyingKey::from_bytes(&trusted)?.verify_strict(&self.signing_bytes()?, &signature)?;
        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use arkhe_core::worker::CognitiveOperation;

    #[test]
    fn signatures_bind_results_identity_and_metadata() {
        let key = SigningKey::from_bytes(&[7; 32]);
        let trusted = hex::encode(key.verifying_key().as_bytes());
        let mut record = CareerRecord {
            schema: "arkhe:twin:career-record:v1".into(),
            recorded_at: "2026-10-25T00:00:00Z".into(),
            wer: WorkerExecutionRecord {
                classification: None,
                operation: Some(CognitiveOperation::Execute),
                module_id: "rust-axum-api".into(),
                module_version: "1".into(),
                input_digest: Digest32::ZERO,
                output_digest: Digest32::ZERO,
                evidence_refs: vec![],
                confidence_bps: None,
                uncertainty_note: None,
                execution_id: "test".into(),
            },
            test_run: TestRun {
                command: vec!["test".into()],
                exit_code: Some(0),
                passed: true,
                stdout_digest: Digest32::ZERO,
                stderr_digest: Digest32::ZERO,
            },
            signer_public_key: String::new(),
            signature: String::new(),
        };
        record.sign(&key).unwrap();
        record.verify(&trusted).unwrap();
        assert!(record
            .verify(&hex::encode(
                SigningKey::from_bytes(&[8; 32]).verifying_key().as_bytes()
            ))
            .is_err());
        let mut changed = record.clone();
        changed.wer.module_id.push('x');
        assert!(changed.verify(&trusted).is_err());
        let mut changed = record.clone();
        changed.test_run.exit_code = Some(1);
        assert!(changed.verify(&trusted).is_err());
        record.recorded_at.push('x');
        assert!(record.verify(&trusted).is_err());
    }
}
