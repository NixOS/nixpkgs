use crate::regenerate::{AnchorError, CheckpointAnchor, CheckpointBinding};
use arkhe_core::canonical::encode_value;
use async_trait::async_trait;
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::json;

const CHECKPOINT_DOMAIN: &[u8] = b"AKG:WORMGRAPH:CHECKPOINT:v1\0";

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct CheckpointTrust {
    pub log_id: [u8; 32],
    pub public_key: [u8; 32],
    pub tenant_id: String,
    pub stream_id: String,
    pub minimum_leaf_count: u64,
    pub maximum_leaf_count: u64,
    pub earliest_issued_at: u64,
    pub latest_issued_at: u64,
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SignedCheckpoint {
    pub tenant_id: String,
    pub stream_id: String,
    pub leaf_count: u64,
    pub mmr_size: u64,
    pub root: [u8; 32],
    pub peaks: Vec<[u8; 32]>,
    pub profile_digest: [u8; 32],
    pub covered_up_to: [u8; 32],
    pub log_id: [u8; 32],
    pub issued_at: u64,
    pub signature_hex: String,
}

impl SignedCheckpoint {
    pub fn from_binding(
        binding: &CheckpointBinding,
        log_id: [u8; 32],
        issued_at: u64,
        signature_hex: String,
    ) -> Self {
        Self {
            tenant_id: binding.tenant_id.clone(),
            stream_id: binding.stream_id.clone(),
            leaf_count: binding.leaf_count,
            mmr_size: binding.mmr_size,
            root: binding.root.0,
            peaks: binding.peaks.iter().map(|peak| peak.0).collect(),
            profile_digest: binding.profile_digest.0,
            covered_up_to: binding.covered_up_to.0,
            log_id,
            issued_at,
            signature_hex,
        }
    }

    pub fn binding(&self) -> CheckpointBinding {
        CheckpointBinding {
            tenant_id: self.tenant_id.clone(),
            stream_id: self.stream_id.clone(),
            leaf_count: self.leaf_count,
            mmr_size: self.mmr_size,
            root: arkhe_core::Digest32(self.root),
            peaks: self
                .peaks
                .iter()
                .map(|peak| arkhe_core::Digest32(*peak))
                .collect(),
            profile_digest: arkhe_core::Digest32(self.profile_digest),
            covered_up_to: arkhe_core::Digest32(self.covered_up_to),
        }
    }

    pub fn signing_bytes(&self) -> Vec<u8> {
        let peaks: Vec<String> = self.peaks.iter().map(hex::encode).collect();
        let mut bytes = CHECKPOINT_DOMAIN.to_vec();
        bytes.extend(encode_value(&json!({
            "profile": "arkhe-mmr@1",
            "tenant_id": &self.tenant_id,
            "stream_id": &self.stream_id,
            "leaf_count": self.leaf_count,
            "mmr_size": self.mmr_size,
            "root": hex::encode(self.root),
            "peaks": peaks,
            "profile_digest": hex::encode(self.profile_digest),
            "covered_up_to": hex::encode(self.covered_up_to),
            "log_id": hex::encode(self.log_id),
            "issued_at": self.issued_at
        })));
        bytes
    }

    pub fn verify(
        &self,
        binding: &CheckpointBinding,
        trust: &CheckpointTrust,
    ) -> Result<(), AnchorError> {
        if &self.binding() != binding {
            return Err(AnchorError(
                "signed checkpoint does not match stored binding".into(),
            ));
        }
        binding
            .validate()
            .map_err(|reason| AnchorError(format!("invalid checkpoint: {reason:?}")))?;

        if trust.log_id == [0; 32]
            || self.log_id != trust.log_id
            || trust.public_key == [0; 32]
            || trust.tenant_id != binding.tenant_id
            || trust.stream_id != binding.stream_id
            || trust.minimum_leaf_count == 0
            || trust.minimum_leaf_count > trust.maximum_leaf_count
            || binding.leaf_count < trust.minimum_leaf_count
            || binding.leaf_count > trust.maximum_leaf_count
            || trust.earliest_issued_at > trust.latest_issued_at
            || self.issued_at < trust.earliest_issued_at
            || self.issued_at > trust.latest_issued_at
            || binding.root == arkhe_core::Digest32::ZERO
            || binding.covered_up_to == arkhe_core::Digest32::ZERO
        {
            return Err(AnchorError(
                "checkpoint trust binding or bounds rejected".into(),
            ));
        }

        let key = VerifyingKey::from_bytes(&trust.public_key)
            .map_err(|_| AnchorError("invalid trust key".into()))?;
        if key.is_weak() {
            return Err(AnchorError("weak trust key".into()));
        }
        let raw = hex::decode(&self.signature_hex)
            .map_err(|_| AnchorError("invalid signature hex".into()))?;
        let signature = Signature::from_slice(&raw)
            .map_err(|_| AnchorError("invalid signature length".into()))?;
        key.verify_strict(&self.signing_bytes(), &signature)
            .map_err(|_| AnchorError("checkpoint signature rejected".into()))
    }
}

#[derive(Debug, Clone)]
pub struct SignedCheckpointAnchor {
    trust: CheckpointTrust,
    checkpoint: SignedCheckpoint,
}

impl SignedCheckpointAnchor {
    pub fn new(trust: CheckpointTrust, checkpoint: SignedCheckpoint) -> Self {
        Self { trust, checkpoint }
    }

    pub fn checkpoint(&self) -> &SignedCheckpoint {
        &self.checkpoint
    }
}

#[async_trait]
impl CheckpointAnchor for SignedCheckpointAnchor {
    async fn verify(&self, checkpoint: &CheckpointBinding) -> Result<(), AnchorError> {
        self.checkpoint.verify(checkpoint, &self.trust)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use arkhe_core::Digest32;
    use arkhe_sql::mmr::profile::{mmr_size, PROFILE_DIGEST_HEX};
    use ed25519_dalek::{Signer, SigningKey};

    fn digest(hex: &str) -> Digest32 {
        let mut bytes = [0u8; 32];
        for (index, byte) in bytes.iter_mut().enumerate() {
            *byte = u8::from_str_radix(&hex[index * 2..index * 2 + 2], 16).unwrap();
        }
        Digest32(bytes)
    }

    fn leaf(value: u8) -> Digest32 {
        let mut bytes = [0u8; 32];
        bytes[31] = value;
        Digest32(bytes)
    }

    fn binding() -> CheckpointBinding {
        CheckpointBinding {
            tenant_id: "tenant-a".into(),
            stream_id: "wormgraph".into(),
            leaf_count: 7,
            mmr_size: mmr_size(7),
            root: digest("5b72738d4f0581752327a48be16dae227da624f7e0316b39f512f1f787fbdb64"),
            peaks: vec![
                digest("ff55b1c86c203cbc5c84a79803d4f921e317a8e72c0645535db4c1cc2e7d5d94"),
                digest("3e405514d5bd48d670e457b92c484d3f6089cb692472e9c2ffc6a68415ba1543"),
                digest("fbb0dc973121b4536952de0370b3dfd5cc1eb45c432d8b7c33e8142cc9fb91ed"),
            ],
            profile_digest: digest(PROFILE_DIGEST_HEX),
            covered_up_to: leaf(7),
        }
    }

    fn key() -> SigningKey {
        SigningKey::from_bytes(&[7u8; 32])
    }

    fn trust() -> CheckpointTrust {
        CheckpointTrust {
            log_id: [9u8; 32],
            public_key: key().verifying_key().to_bytes(),
            tenant_id: "tenant-a".into(),
            stream_id: "wormgraph".into(),
            minimum_leaf_count: 1,
            maximum_leaf_count: 1000,
            earliest_issued_at: 1_000,
            latest_issued_at: 2_000,
        }
    }

    fn signed() -> SignedCheckpoint {
        let mut checkpoint =
            SignedCheckpoint::from_binding(&binding(), [9u8; 32], 1_500, String::new());
        let signature = key().sign(&checkpoint.signing_bytes());
        checkpoint.signature_hex = hex::encode(signature.to_bytes());
        checkpoint
    }

    #[test]
    fn signed_checkpoint_accepts_exact_binding() {
        assert!(signed().verify(&binding(), &trust()).is_ok());
    }

    #[test]
    fn signed_checkpoint_rejects_tampered_root() {
        let mut checkpoint = signed();
        checkpoint.root[0] ^= 1;
        assert!(checkpoint.verify(&binding(), &trust()).is_err());
    }

    #[test]
    fn signed_checkpoint_rejects_wrong_tenant() {
        let mut trust = trust();
        trust.tenant_id = "tenant-b".into();
        assert!(signed().verify(&binding(), &trust).is_err());
    }

    #[test]
    fn signed_checkpoint_rejects_bad_signature() {
        let mut checkpoint = signed();
        checkpoint.signature_hex = "00".repeat(64);
        assert!(checkpoint.verify(&binding(), &trust()).is_err());
    }

    #[test]
    fn signed_checkpoint_rejects_stale_checkpoint() {
        let mut checkpoint = signed();
        checkpoint.issued_at = 999;
        assert!(checkpoint.verify(&binding(), &trust()).is_err());
    }

    #[tokio::test]
    async fn signed_anchor_wraps_verified_checkpoint() {
        let anchor = SignedCheckpointAnchor::new(trust(), signed());
        assert!(anchor.verify(&binding()).await.is_ok());
    }
}
