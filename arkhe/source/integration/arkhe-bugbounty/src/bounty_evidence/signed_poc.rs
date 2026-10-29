//! Detached Ed25519 measurements. Registry authenticity and time are host inputs.
use super::{dh, AttestationLevel, PocMeasurement, VerifierRegistry};
use arkhe_core::canonical::encode_value;
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PocContext {
    pub report_digest: [u8; 32],
    pub policy_digest: [u8; 32],
    pub operation_id: [u8; 32],
    pub parameters_digest: [u8; 32],
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct SignedPocMeasurement {
    pub version: u16,
    pub measurement: PocMeasurement,
    pub context: PocContext,
    pub verifier_id: [u8; 32],
    pub public_key: [u8; 32],
    pub signed_at: u64,
    pub signature_hex: String,
}
pub fn key_id(public_key: &[u8; 32]) -> [u8; 32] {
    dh("ARKHE/POC-SIGNING-KEY/v1", &[public_key])
}
impl SignedPocMeasurement {
    pub fn signing_bytes(&self) -> Vec<u8> {
        let m = &self.measurement;
        let mut bytes = b"AKG:POC:SIGNED-MEASUREMENT:v1\0".to_vec();
        bytes.extend(encode_value(&serde_json::json!({"version":self.version,"context":self.context,"verifier_id":self.verifier_id,"public_key":self.public_key,"signed_at":self.signed_at,
   "chain_id":m.chain_id,"fork_block":m.fork_block,"submission_block":m.submission_block,"target":m.target,"asset_id":m.asset_id,"attacker_gain_decimal":m.attacker_gain.to_string()})));
        bytes
    }
    /// `at` and max_age are trusted host policy, not fields copied from the signature.
    /// Current revocation wins even if the signer claims an earlier signed_at.
    pub fn verify(
        &self,
        registry: &VerifierRegistry,
        expected: &PocContext,
        at: u64,
        max_age: u64,
        min_level: AttestationLevel,
    ) -> Result<&PocMeasurement, String> {
        MeasurementEnvelope {
            version: self.version,
            context: &self.context,
            verifier_id: &self.verifier_id,
            public_key: &self.public_key,
            signed_at: self.signed_at,
            signature_hex: &self.signature_hex,
            signing_bytes: &self.signing_bytes(),
        }
        .verify(
            1,
            expected,
            &PocSignatureTrust {
                registry,
                at,
                max_age,
                min_level,
            },
        )?;
        Ok(&self.measurement)
    }
}

/// Trusted verification inputs. Registry metadata must itself have approved origin.
pub struct PocSignatureTrust<'a> {
    pub registry: &'a VerifierRegistry,
    pub at: u64,
    pub max_age: u64,
    pub min_level: AttestationLevel,
}

pub(super) struct MeasurementEnvelope<'a> {
    pub version: u16,
    pub context: &'a PocContext,
    pub verifier_id: &'a [u8; 32],
    pub public_key: &'a [u8; 32],
    pub signed_at: u64,
    pub signature_hex: &'a str,
    pub signing_bytes: &'a [u8],
}
impl MeasurementEnvelope<'_> {
    pub fn verify(
        &self,
        expected_version: u16,
        expected: &PocContext,
        trust: &PocSignatureTrust<'_>,
    ) -> Result<(), String> {
        let PocSignatureTrust {
            registry,
            at,
            max_age,
            min_level,
        } = *trust;
        if self.version != expected_version
            || self.context != expected
            || expected.report_digest == [0; 32]
            || expected.policy_digest == [0; 32]
            || expected.operation_id == [0; 32]
            || expected.parameters_digest == [0; 32]
            || self.signed_at > at
            || at - self.signed_at > max_age
        {
            return Err("measurement context/version/freshness rejected".into());
        }
        let entry = registry
            .authenticate(self.verifier_id, &key_id(self.public_key), at, min_level)
            .map_err(|_| "measurement signer not registered, active or strong enough")?;
        if self.signed_at < entry.not_before || self.signed_at >= entry.not_after {
            return Err("measurement signing time outside key validity".into());
        }
        let key = VerifyingKey::from_bytes(self.public_key)
            .map_err(|_| "invalid measurement public key")?;
        if key.is_weak() {
            return Err("weak measurement public key".into());
        }
        let raw = hex::decode(self.signature_hex).map_err(|_| "invalid signature encoding")?;
        let signature = Signature::from_slice(&raw).map_err(|_| "invalid signature length")?;
        key.verify_strict(self.signing_bytes, &signature)
            .map_err(|_| "measurement signature rejected")?;

        Ok(())
    }
}
