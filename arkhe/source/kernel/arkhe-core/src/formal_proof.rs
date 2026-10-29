//! Data for opt-in transparent license and role-validated AP2 payment predicates.
//! Neither the data nor the producer grants authority. No ZK backend is implied.
use crate::{canonical::encode_value, Digest32};
use serde::{Deserialize, Serialize};
use std::collections::{BTreeMap, BTreeSet};

pub fn commitment(domain: &[u8], value: &impl Serialize) -> Digest32 {
    Digest32::blake3(
        domain,
        &encode_value(&serde_json::to_value(value).expect("typed proof data")),
    )
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct LicensePolicy {
    pub version: u16,
    /// Governance-authored semantics, not an obligation table supplied by SPDX.
    pub obligations: BTreeMap<String, BTreeSet<String>>,
    pub permitted_obligations: BTreeSet<String>,
    pub require_zk: bool,
}
impl LicensePolicy {
    pub fn digest(&self) -> Digest32 {
        commitment(b"AKG:LICENSE:POLICY:v1\0", self)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct LicenseInput {
    pub spdx_json: String,
    pub artifact: Vec<u8>,
}
impl LicenseInput {
    pub fn digest(&self) -> Digest32 {
        commitment(b"AKG:LICENSE:INPUT:v1\0", self)
    }
    pub fn sbom_digest(&self) -> Digest32 {
        Digest32::blake3(b"AKG:LICENSE:SPDX:v1\0", self.spdx_json.as_bytes())
    }
    pub fn artifact_digest(&self) -> Digest32 {
        Digest32::blake3(b"AKG:LICENSE:ARTIFACT:v1\0", &self.artifact)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct LicenseOutput {
    pub compatible: bool,
    pub sbom_digest: Digest32,
    pub artifact_digest: Digest32,
}
impl LicenseOutput {
    pub fn digest(&self) -> Digest32 {
        commitment(b"AKG:LICENSE:OUTPUT:v1\0", self)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct LicenseProof {
    pub checker: String,
    pub policy_digest: Digest32,
    pub spec_digest: Digest32,
    pub intent_digest: Digest32,
    pub worker_digest: Digest32,
    pub input: LicenseInput,
    pub output: LicenseOutput,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "kind", content = "spec", deny_unknown_fields)]
pub enum FormalPredicate {
    License(LicensePolicy),
    PaymentMandate(PaymentPolicy),
}
impl FormalPredicate {
    pub fn digest(&self) -> Digest32 {
        commitment(b"AKG:FORMAL:SPEC:v1\0", self)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(tag = "kind", content = "proof", deny_unknown_fields)]
pub enum ProofCarryingOutput {
    License(Box<LicenseProof>),
    PaymentMandate(Box<PaymentProof>),
}

#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(tag = "mode", deny_unknown_fields)]
pub enum Ap2Flow {
    Direct,
    Autonomous,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaymentExecution {
    pub network: String,
    pub payee: String,
    pub currency: String,
    pub amount_minor: u64,
    pub instrument_digest: Digest32,
    pub checkout_sha256: [u8; 32],
}
impl PaymentExecution {
    pub fn digest(&self) -> Digest32 {
        commitment(b"AKG:AP2:EXECUTION:v1\0", self)
    }
}

/// Signed by a trusted AP2 role AFTER its protocol verifier has validated
/// credentials, disclosures, signatures, vct, checkout binding and constraints.
/// This is an Arkhe bridge attestation, not an AP2 Payment Receipt or JWT.
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Ap2RoleAttestation {
    pub bridge_profile: String,
    pub ap2_version: String,
    pub role_id: String,
    pub flow: Ap2Flow,
    pub principal: String,
    pub operation_id: Digest32,
    pub policy_digest: Digest32,
    pub closed_sha256: [u8; 32],
    /// Role-authenticated credential identity, stable across SD-JWT presentations
    /// and disclosure/key-binding variants. Used for single-use consumption.
    pub closed_mandate_id: Digest32,
    pub open_sha256: Option<[u8; 32]>,
    pub execution: PaymentExecution,
    pub signatures_validated: bool,
    pub constraints_validated: bool,
    pub checkout_binding_validated: bool,
    pub open_issued_at: Option<i64>,
    pub closed_issued_at: i64,
    pub validated_at: i64,
    pub expires_at: i64,
}
impl Ap2RoleAttestation {
    pub fn digest(&self) -> Digest32 {
        commitment(b"AKG:AP2:ROLE:v1\0", self)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaymentCheckpoint {
    pub profile_digest: String,
    pub root: [u8; 32],
    pub leaf_count: u32,
    pub issued_at: i64,
}
impl PaymentCheckpoint {
    pub fn digest(&self) -> Digest32 {
        commitment(b"AKG:AP2:CHECKPOINT:v1\0", self)
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaymentPolicy {
    pub version: u16,
    pub role_id: String,
    pub role_public_key: [u8; 32],
    pub log_public_key: [u8; 32],
    pub retained_checkpoint: PaymentCheckpoint,
    pub now: i64,
    pub max_role_age: i64,
    pub max_checkpoint_age: i64,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaymentStep {
    pub kind: String,
    pub direction: String,
    pub hash: [u8; 32],
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PaymentProof {
    pub role: Ap2RoleAttestation,
    pub role_signature: Vec<u8>,
    pub closed_sd_jwt: String,
    pub open_sd_jwt: Option<String>,
    pub checkout_jwt: String,
    pub checkpoint_signature: Vec<u8>,
    pub leaf_index: u32,
    pub steps: Vec<PaymentStep>,
}
impl ProofCarryingOutput {
    pub fn digest(&self) -> Digest32 {
        commitment(b"AKG:FORMAL:PROOF:v1\0", self)
    }
}
