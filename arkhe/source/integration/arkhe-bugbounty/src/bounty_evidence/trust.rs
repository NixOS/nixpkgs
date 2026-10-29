//! Offline candidate profile: signed arkhe-mmr checkpoint, not a Rekor codec.
//! All time values in this profile are Unix milliseconds.
use super::{
    priority::{AnchorSource, AnchoredClaim, PrioritySnapshot},
    VerifierEntry, VerifierRegistry,
};
use arkhe_core::{canonical::encode_value, Digest32};
use arkhe_verify_core::mmr::{verify_proof, ProofStep};
use async_trait::async_trait;
use ed25519_dalek::{Signature, VerifyingKey};
#[derive(Debug, Clone)]
pub struct AnchorLeaf {
    pub claim: AnchoredClaim,
    pub subject_digest: Digest32,
}
impl AnchorLeaf {
    pub fn canonical_bytes(&self) -> Vec<u8> {
        let c = &self.claim;
        encode_value(
            &serde_json::json!({"profile":"AKG:BOUNTY:ANCHOR-LEAF:v1","log_id":c.log_id,"commitment":c.commitment,"report_digest":c.report_digest,"recipient":c.recipient,"anchored_at":c.anchored_at,"log_position":c.log_position,"chain_id":c.chain_id,"submission_block":c.submission_block,"subject_digest":self.subject_digest.to_hex()}),
        )
    }
}
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SignedCheckpoint {
    pub log_id: [u8; 32],
    pub root: [u8; 32],
    pub leaf_count: u64,
    pub issued_at: u64,
    pub signature_hex: String,
}
impl SignedCheckpoint {
    pub fn signing_bytes(&self) -> Vec<u8> {
        let mut b = b"AKG:BOUNTY:MMR-CHECKPOINT:v1\0".to_vec();
        b.extend(encode_value(&serde_json::json!({"profile":"arkhe-mmr/v1","log_id":self.log_id,"root":self.root,"leaf_count":self.leaf_count,"issued_at":self.issued_at})));
        b
    }
}
pub struct CheckpointTrust {
    pub log_id: [u8; 32],
    pub public_key: [u8; 32],
    pub minimum_leaf_count: u64,
    pub earliest_checkpoint: u64,
    pub latest_checkpoint: u64,
}
fn signature(key: &[u8; 32], bytes: &[u8], encoded: &str) -> Result<(), String> {
    let key = VerifyingKey::from_bytes(key).map_err(|_| "invalid trust key")?;
    if key.is_weak() {
        return Err("weak trust key".into());
    }
    let raw = hex::decode(encoded).map_err(|_| "invalid signature hex")?;
    let sig = Signature::from_slice(&raw).map_err(|_| "invalid signature length")?;
    key.verify_strict(bytes, &sig)
        .map_err(|_| "trust signature rejected".into())
}
/// No caller constructor or Deserialize: originates only from verified inclusion.
/// ```compile_fail,E0451
/// use arkhe_bugbounty::bounty_evidence::trust::AnchoredTime;
/// use arkhe_core::Digest32;
/// fn forge(subject: Digest32) -> AnchoredTime { AnchoredTime { value: 0, subject } }
/// ```
#[derive(Clone)]
pub struct AnchoredTime {
    value: u64,
    subject: Digest32,
}
impl AnchoredTime {
    pub fn for_subject(&self, expected: Digest32) -> Result<u64, String> {
        if expected == Digest32::ZERO || self.subject != expected {
            Err("anchored time belongs to another subject".into())
        } else {
            Ok(self.value)
        }
    }
}
/// ```compile_fail,E0451
/// use arkhe_bugbounty::bounty_evidence::trust::{ProofVerifiedAnchor, AnchorLeaf, AnchoredTime};
/// fn forge(leaf: AnchorLeaf, time: AnchoredTime) -> ProofVerifiedAnchor { ProofVerifiedAnchor { leaf, time } }
/// ```
/// This profile vouches for inclusion under an independently pinned log key.
/// It does not prove log consistency, latestness, or independent chain height.
#[derive(Clone)]
pub struct ProofVerifiedAnchor {
    leaf: AnchorLeaf,
    time: AnchoredTime,
}
impl ProofVerifiedAnchor {
    pub fn verify(
        leaf: AnchorLeaf,
        checkpoint: &SignedCheckpoint,
        proof: &[ProofStep],
        trust: &CheckpointTrust,
    ) -> Result<Self, String> {
        let c = &leaf.claim;
        if trust.log_id == [0; 32]
            || c.log_id != trust.log_id
            || checkpoint.log_id != trust.log_id
            || c.commitment == [0; 32]
            || c.report_digest == [0; 32]
            || c.chain_id == 0
            || leaf.subject_digest == Digest32::ZERO
            || checkpoint.leaf_count == 0
            || checkpoint.leaf_count > 1_000_000
            || checkpoint.leaf_count < trust.minimum_leaf_count
            || proof.len() > 128
            || c.log_position >= checkpoint.leaf_count
            || trust.earliest_checkpoint > trust.latest_checkpoint
            || checkpoint.issued_at < trust.earliest_checkpoint
            || checkpoint.issued_at > trust.latest_checkpoint
            || c.anchored_at > checkpoint.issued_at
        {
            return Err("checkpoint/leaf binding or freshness bounds rejected".into());
        }
        signature(
            &trust.public_key,
            &checkpoint.signing_bytes(),
            &checkpoint.signature_hex,
        )?;
        if !verify_proof(
            &leaf.canonical_bytes(),
            checkpoint.leaf_count as usize,
            proof,
            &checkpoint.root,
        )
        .map_err(|_| "invalid MMR proof")?
        {
            return Err("MMR inclusion rejected".into());
        }
        let time = AnchoredTime {
            value: c.anchored_at,
            subject: leaf.subject_digest,
        };
        Ok(Self { leaf, time })
    }
    pub fn time(&self) -> &AnchoredTime {
        &self.time
    }
    pub fn precedes_patch(&self, commitment: [u8; 32], patched_at: u64) -> bool {
        self.leaf.claim.commitment == commitment && self.leaf.claim.anchored_at < patched_at
    }
}
/// Immutable concrete source; no permissive signature/inclusion callback.
/// Priority completeness cannot be inferred from one inclusion proof.
#[async_trait]
impl AnchorSource for ProofVerifiedAnchor {
    async fn verified_anchor(&self, report: [u8; 32]) -> Result<AnchoredClaim, String> {
        if self.leaf.claim.report_digest == report {
            Ok(self.leaf.claim.clone())
        } else {
            Err("proof belongs to another report".into())
        }
    }
    async fn verified_priority_snapshot(&self, _: [u8; 32]) -> Result<PrioritySnapshot, String> {
        Err("single inclusion does not establish complete payout priority".into())
    }
}
#[derive(Debug, Clone)]
pub struct GovernedRegistryArtifact {
    pub version: u16,
    pub registry_id: String,
    pub valid_from: u64,
    pub valid_until: u64,
    pub operator_dids: Vec<String>,
    pub verifiers: Vec<VerifierEntry>,
}
pub fn operator_id(did: &str) -> Result<[u8; 32], String> {
    let mut parts = did.splitn(3, ':');
    if parts.next() != Some("did") {
        return Err("operator identifier must be a DID".into());
    }
    let method = parts.next().ok_or("missing DID method")?;
    let id = parts.next().ok_or("missing DID identifier")?;
    if method.is_empty()
        || !method
            .bytes()
            .all(|b| b.is_ascii_lowercase() || b.is_ascii_digit())
        || id.is_empty()
        || did.len() > 256
        || !id
            .bytes()
            .all(|b| b.is_ascii_alphanumeric() || b".-_:".contains(&b))
    {
        return Err("unsupported operator DID syntax".into());
    }
    Ok(Digest32::blake3(b"AKG:BOUNTY:OPERATOR-DID:v1\0", did.as_bytes()).0)
}
impl GovernedRegistryArtifact {
    pub fn digest(&self) -> Digest32 {
        let entries:Vec<_>=self.verifiers.iter().map(|v|serde_json::json!({"verifier_id":v.verifier_id,"operator_id":v.operator_id,"key_id":v.key_id,"level":match v.level {super::AttestationLevel::None=>"none",super::AttestationLevel::Workload=>"workload",super::AttestationLevel::Hardware=>"hardware"},"not_before":v.not_before,"not_after":v.not_after,"revoked":if v.revoked{"true"}else{"false"}})).collect();
        Digest32::blake3(
            b"AKG:BOUNTY:GOVERNED-REGISTRY:v1\0",
            &encode_value(
                &serde_json::json!({"version":self.version,"registry_id":self.registry_id,"valid_from":self.valid_from,"valid_until":self.valid_until,"operator_dids":self.operator_dids,"verifiers":entries}),
            ),
        )
    }
    pub fn approval_bytes(&self) -> Vec<u8> {
        let mut b = b"AKG:BOUNTY:REGISTRY-APPROVAL:v1\0".to_vec();
        b.extend_from_slice(&self.digest().0);
        b
    }
}
pub struct RegistryApproval {
    pub public_key: [u8; 32],
    pub signature_hex: String,
}
pub struct RegistryGovernanceTrust {
    pub public_keys: Vec<[u8; 32]>,
    pub threshold: usize,
}
/// Private registry wrapper: no raw insertion/rotation API after quorum verification.
/// ```compile_fail,E0599
/// use arkhe_bugbounty::bounty_evidence::{VerifierEntry, trust::GovernedVerifierRegistry};
/// fn arbitrary_insert(registry: &mut GovernedVerifierRegistry, entry: VerifierEntry) { registry.insert(entry); }
/// ```
pub struct GovernedVerifierRegistry {
    registry: VerifierRegistry,
    digest: Digest32,
    verified_at: u64,
}
impl GovernedVerifierRegistry {
    pub fn verify(
        artifact: &GovernedRegistryArtifact,
        approvals: &[RegistryApproval],
        trust: &RegistryGovernanceTrust,
        time: &AnchoredTime,
    ) -> Result<Self, String> {
        let digest = artifact.digest();
        let at = time.for_subject(digest)?;
        let roots: std::collections::BTreeSet<_> = trust.public_keys.iter().copied().collect();
        if trust.threshold < 2
            || roots.len() != trust.public_keys.len()
            || roots.len() > 32
            || trust.threshold > roots.len()
            || approvals.len() < trust.threshold
            || approvals.len() > roots.len()
            || artifact.version != 1
            || artifact.registry_id.trim().is_empty()
            || artifact.registry_id.len() > 128
            || artifact.valid_from >= artifact.valid_until
            || at < artifact.valid_from
            || at >= artifact.valid_until
            || artifact.operator_dids.is_empty()
            || artifact.operator_dids.len() > 256
            || artifact.verifiers.is_empty()
            || artifact.verifiers.len() > 1024
        {
            return Err("invalid registry governance quorum or validity".into());
        }
        for root in &roots {
            let key = VerifyingKey::from_bytes(root).map_err(|_| "invalid governance root")?;
            if key.is_weak() {
                return Err("weak governance root".into());
            }
        }
        let mut signers = std::collections::BTreeSet::new();
        for approval in approvals {
            if !roots.contains(&approval.public_key) || !signers.insert(approval.public_key) {
                return Err("untrusted or duplicate registry approver".into());
            }
            signature(
                &approval.public_key,
                &artifact.approval_bytes(),
                &approval.signature_hex,
            )?;
        }
        let mut operators = std::collections::BTreeSet::new();
        for did in &artifact.operator_dids {
            if !operators.insert(operator_id(did)?) {
                return Err("duplicate governed operator".into());
            }
        }
        let mut registry = VerifierRegistry::default();
        for entry in &artifact.verifiers {
            if !operators.contains(&entry.operator_id) {
                return Err("operator is not governance authorized".into());
            }
            registry
                .insert(entry.clone())
                .map_err(|_| "invalid governed verifier entry")?;
        }
        Ok(Self {
            registry,
            digest,
            verified_at: at,
        })
    }
    pub fn registry(&self) -> &VerifierRegistry {
        &self.registry
    }
    pub fn digest(&self) -> Digest32 {
        self.digest
    }
    pub fn verified_at(&self) -> u64 {
        self.verified_at
    }
}

impl GovernedVerifierRegistry {
    pub fn authenticate(
        &self,
        verifier_id: &[u8; 32],
        key_id: &[u8; 32],
        minimum: super::AttestationLevel,
    ) -> Result<&VerifierEntry, super::RegistryError> {
        self.registry
            .authenticate(verifier_id, key_id, self.verified_at, minimum)
    }
}
/// Exact signed receipt is the transparency subject, not merely the report.
pub fn receipt_digest(bytes: &[u8], signature_hex: &str) -> Result<Digest32, String> {
    let signature = hex::decode(signature_hex).map_err(|_| "invalid receipt hex")?;
    if signature.len() != 64 {
        return Err("invalid receipt length".into());
    }
    let mut payload = bytes.to_vec();
    payload.extend(signature);
    Ok(Digest32::blake3(b"AKG:POC:SIGNED-RECEIPT:v1\0", &payload))
}

impl SignedCheckpoint {
    pub fn verify(&self, trust: &CheckpointTrust) -> Result<(), String> {
        if self.log_id != trust.log_id
            || trust.log_id == [0; 32]
            || self.leaf_count == 0
            || self.leaf_count > 1_000_000
            || self.leaf_count < trust.minimum_leaf_count
            || trust.earliest_checkpoint > trust.latest_checkpoint
            || self.issued_at < trust.earliest_checkpoint
            || self.issued_at > trust.latest_checkpoint
        {
            return Err("checkpoint binding/bounds rejected".into());
        }
        signature(
            &trust.public_key,
            &self.signing_bytes(),
            &self.signature_hex,
        )
    }
}
