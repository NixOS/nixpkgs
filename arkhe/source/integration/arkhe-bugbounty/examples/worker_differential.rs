//! Bounded mutation campaign over the actual SignedWorkerVerifier; TEST keys only.
use arkhe_bugbounty::{postgres::WorkerVerifier, provenance::*};
use arkhe_core::{
    evidence::{EvidenceEnvelope, EvidenceReader},
    worker::{CognitiveOperation, WorkerExecutionRecord},
    Digest32,
};
use async_trait::async_trait;
use ed25519_dalek::{Signer, SigningKey};
use serde_json::json;
struct NoEvidence;
#[async_trait]
impl EvidenceReader for NoEvidence {
    async fn get(&self, _: Digest32) -> Result<Option<EvidenceEnvelope>, String> {
        Ok(None)
    }
}
struct Receipts(SignedWorkerReceipt);
#[async_trait]
impl ReceiptReader for Receipts {
    async fn receipts(&self, _: Digest32) -> Result<Vec<SignedWorkerReceipt>, String> {
        Ok(vec![self.0.clone()])
    }
}
#[tokio::main]
async fn main() {
    let count: usize = std::env::args()
        .nth(1)
        .unwrap_or_else(|| "4096".into())
        .parse()
        .expect("case count");
    assert!((16..=65536).contains(&count));
    let key = SigningKey::from_bytes(&[37; 32]);
    for i in 0..count {
        let mut record = WorkerExecutionRecord {
            classification: None,
            operation: Some(CognitiveOperation::Decide),
            module_id: "gov-verifier".into(),
            module_version: "1".into(),
            input_digest: Digest32::ZERO,
            output_digest: Digest32::blake3(b"mutation", &i.to_be_bytes()),
            evidence_refs: vec![],
            confidence_bps: None,
            uncertainty_note: None,
            execution_id: format!("case-{i}"),
        };
        let mut trust = TrustedWorkerKey {
            key_id: "test-worker".into(),
            public_key: key.verifying_key().to_bytes(),
            module_id: "gov-verifier".into(),
            module_version: "1".into(),
            allowed_operations: vec![CognitiveOperation::Decide],
            require_admitted_input: false,
            active: true,
        };
        let mode = i % 16;
        if mode == 1 {
            record.execution_id.push_str("-before-sign");
        }
        if mode == 8 {
            record.module_version = "unauthorized".into();
        }
        if mode == 9 {
            trust.active = false;
        }
        if mode == 11 {
            record.operation = None;
        }
        if mode == 13 {
            record.evidence_refs.push(Digest32([3; 32]));
        }
        if mode == 14 {
            trust.require_admitted_input = true;
        }
        if mode == 15 {
            record.execution_id = format!("日本語-ação-{i}");
        }
        let mut receipt = SignedWorkerReceipt {
            version: 1,
            tenant: "gov-synthetic".into(),
            key_id: "test-worker".into(),
            record_hash: record.digest(),
            completed_at_ms: 1000,
            outcome: ExecutionOutcome::Succeeded,
            signature_hex: String::new(),
        };
        if mode == 2 {
            receipt.tenant = "another-tenant".into();
        }
        if mode == 3 {
            receipt.version = 2;
        }
        if mode == 4 {
            receipt.outcome = ExecutionOutcome::Failed;
        }
        if mode == 5 {
            receipt.completed_at_ms = -1;
        }
        if mode == 10 {
            receipt.key_id = "unknown".into();
        }
        receipt.signature_hex = hex::encode(
            if mode == 12 {
                SigningKey::from_bytes(&[38; 32]).sign(&receipt.signing_bytes())
            } else {
                key.sign(&receipt.signing_bytes())
            }
            .to_bytes(),
        );
        if mode == 1 {
            record.execution_id.push_str("-after-sign");
        }
        if mode == 6 {
            let mut signature = hex::decode(&receipt.signature_hex).unwrap();
            signature[(i / 16) % 64] ^= 1 << ((i / 1024) % 8);
            receipt.signature_hex = hex::encode(signature);
        }
        if mode == 7 {
            receipt.signature_hex = "invalid-hex".into();
        }
        let verifier = SignedWorkerVerifier::new(
            "gov-synthetic".into(),
            vec![trust.clone()],
            Receipts(receipt.clone()),
            NoEvidence,
        )
        .unwrap();
        let actual = verifier.verify(&record).await.is_ok();
        assert_eq!(
            actual,
            mode == 0 || mode == 15,
            "mutation mode {mode}, case {i}"
        );
        println!(
            "{}",
            json!({"case":i,"mode":mode,"record":record,"recordDigest":record.digest().to_hex(),"receipt":receipt,"trust":trust,"signingBytesHex":hex::encode(receipt.signing_bytes()),"nativeAccepted":actual})
        );
    }
}
