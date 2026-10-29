//! Offline experimental release admission. Does not authorize runtime execution.
//! Radicle evidence is observed by a separately trusted attestor, not parsed here.
use crate::hash::sha256;
use ed25519_dalek::{Signature, VerifyingKey};
use serde::{Deserialize, Serialize};

pub const PROFILE: &str = "arkhe-release-lab@1";
pub const MAX_ARTIFACT: usize = 16 * 1024 * 1024;
pub const ATTESTATION_DOMAIN: &[u8] = b"ARKHE:RELEASE:ATTESTATION:v1\0";
pub const APPROVAL_DOMAIN: &[u8] = b"ARKHE:RELEASE:LOCAL-APPROVAL:v1\0";

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Source {
    pub repository: String,
    pub patch: String,
    pub revision: String,
    pub commit: String,
    pub reviewer: String,
    pub review_evidence_sha256: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Statement {
    pub profile: String,
    pub product: String,
    pub sequence: u64,
    pub artifact_sha256: String,
    pub artifact_blake3: String,
    pub artifact_size: u64,
    pub source: Source,
    pub review_verdict: String,
    pub builder: String,
}

/// The exact UTF-8 payload is signed; no JSON recanonicalization at verification.
#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Envelope {
    pub payload: String,
    pub signature: String,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Trust {
    pub profile: String,
    pub tenant: String,
    pub product: String,
    pub source: Source,
    pub attestor_key: String,
    pub approver_key: String,
    pub builder: String,
    pub minimum_sequence: u64,
    pub maximum_artifact_bytes: u64,
    pub maximum_approval_seconds: u64,
}

#[derive(Clone, Debug, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Approval {
    pub profile: String,
    pub tenant: String,
    pub policy_sha256: String,
    pub statement_sha256: String,
    pub issued_at: u64,
    pub expires_at: u64,
    pub decision: String,
}

#[derive(Debug, Serialize)]
pub struct Verdict {
    pub profile: &'static str,
    pub status: &'static str,
    pub artifact_sha256: String,
    pub statement_sha256: String,
    pub sequence: u64,
    pub authorization_granted: bool,
    pub execution_authority: bool,
    pub executed: bool,
}

fn digest(bytes: &[u8]) -> String {
    hex::encode(sha256(bytes))
}

pub fn policy_digest(trust: &Trust) -> Result<String, String> {
    let value = serde_json::to_value(trust).map_err(|e| e.to_string())?;
    let bytes = crate::cbor::canonical::encode_json(&value).map_err(|e| e.to_string())?;
    Ok(digest(&bytes))
}

fn decode_hex<const N: usize>(text: &str) -> Result<[u8; N], String> {
    if text.len() != N * 2
        || text
            .bytes()
            .any(|b| !b.is_ascii_digit() && !(b'a'..=b'f').contains(&b))
    {
        return Err("invalid lowercase hexadecimal field".into());
    }
    hex::decode(text)
        .map_err(|e| e.to_string())?
        .try_into()
        .map_err(|_| "hex length".into())
}

fn authenticate(envelope: &Envelope, key: &str, domain: &[u8]) -> Result<(), String> {
    if envelope.payload.len() > 16 * 1024 {
        return Err("signed payload too large".into());
    }
    let key = VerifyingKey::from_bytes(&decode_hex::<32>(key)?).map_err(|e| e.to_string())?;
    if key.is_weak() {
        return Err("weak signing key".into());
    }
    let signature = Signature::from_bytes(&decode_hex::<64>(&envelope.signature)?);
    let mut bytes = domain.to_vec();
    bytes.extend_from_slice(envelope.payload.as_bytes());
    key.verify_strict(&bytes, &signature)
        .map_err(|_| "invalid signature".into())
}

/// `trust`, `now` and `high_water` come from the local operator, never the package.
pub fn verify(
    artifact: &[u8],
    envelope: &Envelope,
    trust: &Trust,
    approval: Option<&Envelope>,
    now: u64,
    high_water: u64,
) -> Result<Verdict, String> {
    if trust.profile != PROFILE
        || trust.tenant.is_empty()
        || trust.product.is_empty()
        || trust.attestor_key == trust.approver_key
        || trust.maximum_artifact_bytes == 0
        || trust.maximum_artifact_bytes > MAX_ARTIFACT as u64
        || trust.maximum_approval_seconds == 0
        || trust.maximum_approval_seconds > 86400
    {
        return Err("invalid local trust policy".into());
    }
    // Validate both trust keys even in verify-only mode.
    for text in [&trust.attestor_key, &trust.approver_key] {
        let key = VerifyingKey::from_bytes(&decode_hex::<32>(text)?).map_err(|e| e.to_string())?;
        if key.is_weak() {
            return Err("weak trust key".into());
        }
    }
    authenticate(envelope, &trust.attestor_key, ATTESTATION_DOMAIN)?;
    let statement: Statement =
        serde_json::from_str(&envelope.payload).map_err(|e| e.to_string())?;
    let source = &statement.source;
    if !source.repository.starts_with("rad:") || !source.reviewer.starts_with("did:key:") {
        return Err("missing Radicle source identity".into());
    }
    for id in [&source.commit, &source.patch, &source.revision] {
        decode_hex::<20>(id)?;
    }
    decode_hex::<32>(&source.review_evidence_sha256)?;
    if statement.profile != PROFILE
        || statement.product != trust.product
        || statement.source != trust.source
        || statement.review_verdict != "accept"
        || statement.builder != trust.builder
    {
        return Err("source, review or builder differs from local trust".into());
    }
    if statement.sequence < trust.minimum_sequence.max(high_water) {
        return Err("obsolete release sequence".into());
    }
    if artifact.len() > trust.maximum_artifact_bytes as usize
        || artifact.len() as u64 != statement.artifact_size
        || digest(artifact) != statement.artifact_sha256
        || hex::encode(crate::hash::blake3_256(artifact)) != statement.artifact_blake3
    {
        return Err("artifact digest or size mismatch".into());
    }
    let statement_sha256 = digest(envelope.payload.as_bytes());
    if let Some(signed) = approval {
        authenticate(signed, &trust.approver_key, APPROVAL_DOMAIN)?;
        let a: Approval = serde_json::from_str(&signed.payload).map_err(|e| e.to_string())?;
        if a.profile != PROFILE
            || a.tenant != trust.tenant
            || a.decision != "admit"
            || a.policy_sha256 != policy_digest(trust)?
            || a.statement_sha256 != statement_sha256
            || a.issued_at > now
            || a.expires_at <= now
            || a.expires_at <= a.issued_at
            || a.expires_at - a.issued_at > trust.maximum_approval_seconds
        {
            return Err("local approval binding or validity mismatch".into());
        }
    }
    Ok(Verdict {
        profile: PROFILE,
        status: if approval.is_some() {
            "ADMITTED_LOCAL"
        } else {
            "VERIFIED_ONLY"
        },
        artifact_sha256: statement.artifact_sha256,
        statement_sha256,
        sequence: statement.sequence,
        authorization_granted: approval.is_some(),
        execution_authority: false,
        executed: false,
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use ed25519_dalek::{Signer, SigningKey};

    fn sign<T: Serialize>(value: &T, key: &SigningKey, domain: &[u8]) -> Envelope {
        let payload = serde_json::to_string(value).unwrap();
        let bytes = [domain, payload.as_bytes()].concat();
        Envelope {
            payload,
            signature: hex::encode(key.sign(&bytes).to_bytes()),
        }
    }

    fn fixture() -> (Vec<u8>, Statement, Trust, SigningKey, SigningKey) {
        let publisher = SigningKey::from_bytes(&[71; 32]);
        let approver = SigningKey::from_bytes(&[72; 32]);
        let artifact = b"release specimen".to_vec();
        let source = Source {
            repository: "rad:zDemo".into(),
            patch: "a".repeat(40),
            revision: "b".repeat(40),
            commit: "c".repeat(40),
            reviewer: "did:key:zReviewer".into(),
            review_evidence_sha256: "d".repeat(64),
        };
        let statement = Statement {
            profile: PROFILE.into(),
            product: "demo".into(),
            sequence: 2,
            artifact_sha256: digest(&artifact),
            artifact_blake3: hex::encode(crate::hash::blake3_256(&artifact)),
            artifact_size: artifact.len() as u64,
            source: source.clone(),
            review_verdict: "accept".into(),
            builder: "lab".into(),
        };
        let trust = Trust {
            profile: PROFILE.into(),
            tenant: "local".into(),
            product: "demo".into(),
            source,
            attestor_key: hex::encode(publisher.verifying_key().to_bytes()),
            approver_key: hex::encode(approver.verifying_key().to_bytes()),
            builder: "lab".into(),
            minimum_sequence: 1,
            maximum_artifact_bytes: 1024,
            maximum_approval_seconds: 300,
        };
        (artifact, statement, trust, publisher, approver)
    }

    #[test]
    fn verify_is_not_admission_and_keys_are_separate() {
        let (artifact, s, t, p, a) = fixture();
        let e = sign(&s, &p, ATTESTATION_DOMAIN);
        let v = verify(&artifact, &e, &t, None, 100, 0).unwrap();
        assert!(!v.authorization_granted && !v.execution_authority);
        let approval = Approval {
            profile: PROFILE.into(),
            tenant: t.tenant.clone(),
            policy_sha256: policy_digest(&t).unwrap(),
            statement_sha256: digest(e.payload.as_bytes()),
            issued_at: 90,
            expires_at: 120,
            decision: "admit".into(),
        };
        let signed = sign(&approval, &a, APPROVAL_DOMAIN);
        assert!(
            verify(&artifact, &e, &t, Some(&signed), 100, 0)
                .unwrap()
                .authorization_granted
        );
        assert!(verify(
            &artifact,
            &e,
            &t,
            Some(&sign(&approval, &p, APPROVAL_DOMAIN)),
            100,
            0
        )
        .is_err());
        assert!(verify(&artifact, &e, &t, Some(&signed), 120, 0).is_err());
        assert!(verify(&artifact, &e, &t, Some(&signed), 89, 0).is_err());
    }

    #[test]
    fn rejects_tamper_substitution_rollback_and_policy_changes() {
        let (artifact, mut s, mut t, p, a) = fixture();
        let e = sign(&s, &p, ATTESTATION_DOMAIN);
        assert!(verify(b"tampered", &e, &t, None, 100, 0).is_err());
        assert!(verify(&artifact, &e, &t, None, 100, 3).is_err());
        let approval = Approval {
            profile: PROFILE.into(),
            tenant: t.tenant.clone(),
            policy_sha256: policy_digest(&t).unwrap(),
            statement_sha256: digest(e.payload.as_bytes()),
            issued_at: 90,
            expires_at: 120,
            decision: "admit".into(),
        };
        let signed = sign(&approval, &a, APPROVAL_DOMAIN);
        t.tenant = "other".into();
        assert!(verify(&artifact, &e, &t, Some(&signed), 100, 0).is_err());
        s.source.commit = "e".repeat(40);
        assert!(verify(
            &artifact,
            &sign(&s, &p, ATTESTATION_DOMAIN),
            &t,
            None,
            100,
            0
        )
        .is_err());
        s.source = t.source.clone();
        s.review_verdict = "reject".into();
        assert!(verify(
            &artifact,
            &sign(&s, &p, ATTESTATION_DOMAIN),
            &t,
            None,
            100,
            0
        )
        .is_err());
        let mut altered = e.clone();
        altered.payload.push(' ');
        assert!(verify(&artifact, &altered, &t, None, 100, 0).is_err());
        t.approver_key = t.attestor_key.clone();
        assert!(verify(&artifact, &e, &t, None, 100, 0).is_err());
    }
}
