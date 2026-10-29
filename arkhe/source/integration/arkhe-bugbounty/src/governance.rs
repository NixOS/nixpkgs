//! Opt-in signed governance profile. Deployment supplies independently trusted roots.
use crate::classification::ClassificationPolicy;
use arkhe_core::{
    canonical::encode_value,
    work::{WorkIntent, WorkIntentType},
    worker::CognitiveOperation,
    Digest32,
};
use arkhe_governance::{EvidenceKindRequirement, PolicyBinding, PolicyResolver, PolicyVerdict};
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TriagePolicyProfile {
    pub version: u16,
    pub policy_id: String,
    pub policy_version: u64,
    pub requested_by: String,
    pub classification_policy: ClassificationPolicy,
    pub allowed_modules: Vec<String>,
    pub required_evidence: Vec<RequiredTriageEvidence>,
    pub valid_from_ms: i64,
    pub valid_until_ms: i64,
}
#[derive(Debug, Clone, Copy, PartialEq, Eq, Serialize, Deserialize)]
pub enum RequiredTriageEvidence {
    ClassificationDigest,
    ClassificationPolicyDigest,
}
impl TriagePolicyProfile {
    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:TRIAGE:GOVERNANCE-PROFILE:v1\0",
            &encode_value(&serde_json::json!({
                "version":self.version,"policy_id":self.policy_id,"policy_version":self.policy_version,
                "requested_by":self.requested_by,"classification_policy":self.classification_policy.digest().to_hex(),
                "allowed_modules":self.allowed_modules,"required_evidence":self.required_evidence,"valid_from_ms":self.valid_from_ms,"valid_until_ms":self.valid_until_ms
            })),
        )
    }
    pub fn validate(&self) -> Result<(), String> {
        self.classification_policy
            .validate()
            .map_err(|e| e.to_string())?;
        if self.version != 1
            || self.policy_version == 0
            || self.policy_id.trim().is_empty()
            || self.policy_id.len() > 128
            || self.requested_by.trim().is_empty()
            || self.requested_by.len() > 256
            || self.allowed_modules.is_empty()
            || self.allowed_modules.len() > 32
            || self
                .allowed_modules
                .iter()
                .any(|id| id.trim().is_empty() || id.len() > 128)
            || self
                .allowed_modules
                .iter()
                .enumerate()
                .any(|(i, id)| self.allowed_modules[..i].contains(id))
            || self.valid_from_ms < 0
            || self.valid_until_ms <= self.valid_from_ms
            || self.required_evidence.len() != 2
            || !self
                .required_evidence
                .contains(&RequiredTriageEvidence::ClassificationDigest)
            || !self
                .required_evidence
                .contains(&RequiredTriageEvidence::ClassificationPolicyDigest)
        {
            return Err("invalid triage governance profile".into());
        }
        Ok(())
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SignedTriagePolicyProfile {
    pub profile: TriagePolicyProfile,
    pub registry_digest: Digest32,
    pub approvals: Vec<GovernanceApproval>,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct GovernanceApproval {
    pub key_id: String,
    pub signature_hex: String,
}
impl SignedTriagePolicyProfile {
    pub fn signing_bytes(&self, key_id: &str) -> Vec<u8> {
        let mut bytes = b"AKG:TRIAGE:GOVERNANCE-APPROVAL:v1\0".to_vec();
        bytes.extend(encode_value(&serde_json::json!({"profile_digest":self.profile.digest().to_hex(),"registry_digest":self.registry_digest.to_hex(),"key_id":key_id})));
        bytes
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct TrustedGovernanceKey {
    pub key_id: String,
    pub public_key: [u8; 32],
    pub active: bool,
    pub policy_ids: Vec<String>,
    pub valid_from_ms: i64,
    pub valid_until_ms: i64,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct GovernanceTrustRegistry {
    pub version: u16,
    pub registry_id: String,
    pub threshold: u16,
    pub keys: Vec<TrustedGovernanceKey>,
}
impl GovernanceTrustRegistry {
    pub fn digest(&self) -> Digest32 {
        let keys:Vec<_> = self.keys.iter().map(|key|serde_json::json!({
            "key_id":key.key_id,"public_key":key.public_key,"active":if key.active {"true"} else {"false"},
            "policy_ids":key.policy_ids,"valid_from_ms":key.valid_from_ms,"valid_until_ms":key.valid_until_ms
        })).collect();
        Digest32::blake3(
            b"AKG:TRIAGE:GOVERNANCE-REGISTRY:v1\0",
            &encode_value(&serde_json::json!({
                "version":self.version,"registry_id":self.registry_id,"threshold":self.threshold,"keys":keys
            })),
        )
    }
    pub fn validate(&self) -> Result<(), String> {
        if self.version != 1
            || self.registry_id.trim().is_empty()
            || self.registry_id.len() > 128
            || self.threshold < 2
            || usize::from(self.threshold) > self.keys.len()
            || self.keys.len() > 32
        {
            return Err(
                "registry requires at least two distinct governance keys and a valid quorum".into(),
            );
        }
        for (i, key) in self.keys.iter().enumerate() {
            let public =
                VerifyingKey::from_bytes(&key.public_key).map_err(|_| "invalid registry key")?;
            if key.key_id.trim().is_empty()
                || key.key_id.len() > 128
                || public.is_weak()
                || key.policy_ids.is_empty()
                || key.policy_ids.len() > 32
                || key
                    .policy_ids
                    .iter()
                    .any(|id| id.trim().is_empty() || id.len() > 128)
                || key.valid_from_ms < 0
                || key.valid_until_ms <= key.valid_from_ms
                || self.keys[..i]
                    .iter()
                    .any(|other| other.key_id == key.key_id || other.public_key == key.public_key)
            {
                return Err("duplicate, weak, unscoped or invalid registry key".into());
            }
        }
        Ok(())
    }
}
pub fn now_ms() -> i64 {
    std::time::SystemTime::now()
        .duration_since(std::time::UNIX_EPOCH)
        .map(|d| d.as_millis().min(i64::MAX as u128) as i64)
        .unwrap_or(-1)
}
/// Cannot be constructed from an unsigned profile or a key supplied inside that profile.
pub struct VerifiedTriagePolicy {
    profile: TriagePolicyProfile,
    approval_valid_until_ms: i64,
}
impl VerifiedTriagePolicy {
    pub fn verify(
        signed: SignedTriagePolicyProfile,
        registry: &GovernanceTrustRegistry,
        independently_pinned_registry_digest: Digest32,
    ) -> Result<Self, String> {
        signed.profile.validate()?;
        registry.validate()?;
        if independently_pinned_registry_digest == Digest32::ZERO
            || registry.digest() != independently_pinned_registry_digest
            || signed.registry_digest != independently_pinned_registry_digest
        {
            return Err("registry does not match independently pinned trust root".into());
        }
        if signed.approvals.len() < usize::from(registry.threshold)
            || signed.approvals.len() > registry.keys.len()
        {
            return Err("governance quorum not met".into());
        }
        let mut seen = std::collections::HashSet::new();
        let mut approval_valid_until_ms = signed.profile.valid_until_ms;
        let now = now_ms();
        for approval in &signed.approvals {
            if !seen.insert(&approval.key_id) {
                return Err("duplicate governance signer".into());
            }
            let root = registry
                .keys
                .iter()
                .find(|key| key.key_id == approval.key_id)
                .ok_or("unknown governance signer")?;
            if !root.active
                || !root.policy_ids.contains(&signed.profile.policy_id)
                || now < root.valid_from_ms
                || now >= root.valid_until_ms
            {
                return Err("governance signer revoked, expired or outside policy scope".into());
            }
            let key =
                VerifyingKey::from_bytes(&root.public_key).map_err(|_| "invalid governance key")?;
            let signature = Signature::from_slice(
                &hex::decode(&approval.signature_hex)
                    .map_err(|_| "invalid approval signature encoding")?,
            )
            .map_err(|_| "invalid approval signature length")?;
            key.verify_strict(&signed.signing_bytes(&approval.key_id), &signature)
                .map_err(|_| "governance approval signature rejected")?;
            approval_valid_until_ms = approval_valid_until_ms.min(root.valid_until_ms);
        }
        let result = Self {
            profile: signed.profile,
            approval_valid_until_ms,
        };
        if !result.current() {
            return Err("governance profile expired or not yet valid".into());
        }
        Ok(result)
    }
    fn current(&self) -> bool {
        let now = now_ms();
        now >= self.profile.valid_from_ms && now < self.approval_valid_until_ms
    }
    fn matches(&self, intent: &WorkIntent, binding: &PolicyBinding) -> bool {
        self.current()
            && intent.intent_type == WorkIntentType::TriageReport
            && intent.requested_by == self.profile.requested_by
            && binding.policy_id == self.profile.policy_id
            && binding.version == self.profile.policy_version
            && binding.policy_digest == self.profile.digest()
    }
    pub fn binding(&self) -> PolicyBinding {
        PolicyBinding {
            policy_id: self.profile.policy_id.clone(),
            version: self.profile.policy_version,
            policy_digest: self.profile.digest(),
        }
    }
    pub fn classification_policy(&self) -> &ClassificationPolicy {
        &self.profile.classification_policy
    }
}
impl PolicyResolver for VerifiedTriagePolicy {
    fn required_classification_policy(
        &self,
        intent: &WorkIntent,
        binding: &PolicyBinding,
    ) -> Option<Digest32> {
        self.matches(intent, binding)
            .then(|| self.profile.classification_policy.digest())
    }
    fn required_worker_evidence(
        &self,
        intent: &WorkIntent,
        binding: &PolicyBinding,
    ) -> Option<EvidenceKindRequirement> {
        self.matches(intent, binding)
            .then(|| EvidenceKindRequirement {
                allowed_modules: self.profile.allowed_modules.clone(),
                allowed_operations: vec![CognitiveOperation::Decide],
            })
    }
    fn resolve(&self, intent: &WorkIntent, binding: &PolicyBinding) -> PolicyVerdict {
        if self.matches(intent, binding) {
            PolicyVerdict::Allow
        } else {
            PolicyVerdict::Deny(
                "triage profile is inactive or does not match caller and binding".into(),
            )
        }
    }
}
