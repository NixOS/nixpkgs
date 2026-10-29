//! v2 measurement has no researcher-controlled submission height. No mock crypto.
use super::{
    priority::{AnchorSource, AnchoredClaim, PrioritySnapshot},
    signed_poc::{MeasurementEnvelope, PocContext, PocSignatureTrust},
};
use arkhe_core::{canonical::encode_value, Digest32};
use async_trait::async_trait;
use serde::{Deserialize, Serialize};
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct PocMeasurement {
    pub chain_id: u64,
    pub fork_block: u64,
    pub target: [u8; 32],
    pub asset_id: [u8; 32],
    pub attacker_gain: u128,
    pub report_commitment: [u8; 32],
}
impl PocMeasurement {
    pub fn digest(&self) -> Digest32 {
        Digest32::blake3(
            b"AKG:POC:MEASUREMENT:v2\0",
            &encode_value(
                &serde_json::json!({"chain_id":self.chain_id,"fork_block":self.fork_block,"target":self.target,"asset_id":self.asset_id,"attacker_gain_decimal":self.attacker_gain.to_string(),"report_commitment":self.report_commitment}),
            ),
        )
    }
    pub fn with_anchor(&self, anchor: &VerifiedAnchor) -> Result<super::PocMeasurement, String> {
        if self.report_commitment != anchor.claim.commitment
            || self.chain_id != anchor.claim.chain_id
        {
            return Err("measurement/anchor commitment or chain mismatch".into());
        }
        Ok(super::PocMeasurement {
            chain_id: self.chain_id,
            fork_block: self.fork_block,
            submission_block: anchor.claim.submission_block,
            target: self.target,
            asset_id: self.asset_id,
            attacker_gain: self.attacker_gain,
        })
    }
}
/// The trusted source constructs claims; callers cannot directly construct this wrapper.
pub struct VerifiedAnchor {
    claim: AnchoredClaim,
}
impl VerifiedAnchor {
    pub async fn resolve<S: AnchorSource>(source: &S, report: [u8; 32]) -> Result<Self, String> {
        let claim = source.verified_anchor(report).await?;
        if report == [0; 32]
            || claim.report_digest != report
            || claim.log_id == [0; 32]
            || claim.commitment == [0; 32]
            || claim.chain_id == 0
        {
            return Err("invalid externally verified anchor binding".into());
        }
        Ok(Self { claim })
    }
    pub fn report_digest(&self) -> [u8; 32] {
        self.claim.report_digest
    }
    pub fn anchored_at(&self) -> u64 {
        self.claim.anchored_at
    }
    pub fn anchored_block(&self) -> u64 {
        self.claim.submission_block
    }
}
pub fn pre_existence_holds(
    anchor: &VerifiedAnchor,
    expected_commitment: [u8; 32],
    patched_at: u64,
) -> bool {
    anchor.claim.commitment == expected_commitment && anchor.claim.anchored_at < patched_at
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
impl SignedPocMeasurement {
    pub fn signing_bytes(&self) -> Vec<u8> {
        let mut b = b"AKG:POC:SIGNED-MEASUREMENT:v2\0".to_vec();
        b.extend(encode_value(&serde_json::json!({"version":self.version,"measurement_digest":self.measurement.digest().to_hex(),"context":self.context,"verifier_id":self.verifier_id,"public_key":self.public_key,"signed_at":self.signed_at})));
        b
    }
    pub fn verify(
        &self,
        expected: &PocContext,
        trust: &PocSignatureTrust<'_>,
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
        .verify(2, expected, trust)?;
        Ok(&self.measurement)
    }
}
// A single source lookup is reused during evaluation; no second mutable log read.
struct FrozenAnchor(AnchoredClaim);
#[async_trait]
impl AnchorSource for FrozenAnchor {
    async fn verified_anchor(&self, report: [u8; 32]) -> Result<AnchoredClaim, String> {
        if report == self.0.report_digest {
            Ok(self.0.clone())
        } else {
            Err("wrong frozen report".into())
        }
    }
    async fn verified_priority_snapshot(&self, _: [u8; 32]) -> Result<PrioritySnapshot, String> {
        Err("not a priority source".into())
    }
}
impl super::policy::ResolvedPocPolicy {
    // Keep the existing admission API rather than changing callers for a lint.
    #[allow(clippy::too_many_arguments)]
    pub async fn evaluate_signed_v2_admitted<
        R: arkhe_governance::PolicyResolver,
        E: arkhe_core::evidence::EvidenceReader,
        A: AnchorSource,
    >(
        &self,
        intent: &arkhe_core::work::WorkIntent,
        binding: &arkhe_governance::PolicyBinding,
        resolver: &R,
        evidence: &E,
        worker: &arkhe_core::worker::WorkerExecutionRecord,
        signed: &SignedPocMeasurement,
        trust: &PocSignatureTrust<'_>,
        source: &A,
    ) -> Result<super::PocVerdict, String> {
        let expected = PocContext {
            report_digest: intent.target.0,
            policy_digest: self.digest().0,
            operation_id: intent.operation_id().0,
            parameters_digest: intent.parameters_digest.0,
        };
        let measurement = signed.verify(&expected, trust)?;
        let anchor = VerifiedAnchor::resolve(source, intent.target.0).await?;
        let normalized = measurement.with_anchor(&anchor)?;
        self.evaluate_admitted(
            intent,
            binding,
            resolver,
            evidence,
            worker,
            &normalized,
            &FrozenAnchor(anchor.claim),
        )
        .await
    }
}

impl SignedPocMeasurement {
    pub fn receipt_digest(&self) -> Result<Digest32, String> {
        super::trust::receipt_digest(&self.signing_bytes(), &self.signature_hex)
    }
    pub fn verify_at_anchored_receipt(
        &self,
        expected: &PocContext,
        registry: &super::VerifierRegistry,
        time: &super::trust::AnchoredTime,
        max_age: u64,
        min_level: super::AttestationLevel,
    ) -> Result<&PocMeasurement, String> {
        let at = time.for_subject(self.receipt_digest()?)?;
        self.verify(
            expected,
            &PocSignatureTrust {
                registry,
                at,
                max_age,
                min_level,
            },
        )
    }
}
