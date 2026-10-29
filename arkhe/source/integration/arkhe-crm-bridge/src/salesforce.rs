//! A producer-signed write intent binds the Salesforce version to a verified v2 bundle.
use crate::v2::{self, Bundle, Policy};
use anyhow::{ensure, Context, Result};
use ed25519_dalek::{Signature, Signer, SigningKey, VerifyingKey};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct WriteIntent {
    pub schema: u32,
    pub bundle: Bundle,
    pub expected_version: String,
    pub signature: String,
}

impl WriteIntent {
    fn canonical(&self) -> Result<Vec<u8>> {
        ensure!(self.schema == 1, "unsupported write intent");
        let stamp = chrono::DateTime::parse_from_rfc3339(&self.expected_version)?;
        ensure!(
            stamp.to_rfc3339_opts(chrono::SecondsFormat::Millis, true) == self.expected_version,
            "expected version must be exact UTC RFC3339 milliseconds ending Z"
        );
        let mut bytes = Vec::new();
        for part in [
            "arkhe.crm.salesforce.write.v1".to_owned(),
            self.bundle.request.event.hash()?,
            self.bundle.checkpoint.hash()?,
            self.expected_version.clone(),
        ] {
            bytes.extend_from_slice(&(part.len() as u64).to_be_bytes());
            bytes.extend_from_slice(part.as_bytes());
        }
        Ok(bytes)
    }

    pub fn sign(
        bundle: Bundle,
        expected_version: String,
        key: &SigningKey,
        policy: &Policy,
    ) -> Result<Self> {
        let mut intent = Self {
            schema: 1,
            bundle,
            expected_version,
            signature: String::new(),
        };
        intent.signature = hex::encode(key.sign(&intent.canonical()?).to_bytes());
        intent.verify(policy)?;
        Ok(intent)
    }

    /// Historical verification is allowed for reconciliation even after expiry.
    pub fn verify(&self, policy: &Policy) -> Result<()> {
        v2::verify(&self.bundle, policy)?;
        let producer = policy
            .producers
            .iter()
            .find(|p| p.id == self.bundle.request.event.producer_id)
            .context("unknown write producer")?;
        ensure!(self.signature.len() == 128, "invalid write signature");
        VerifyingKey::from_bytes(&v2::bytes32(&producer.public_key)?)?.verify_strict(
            &self.canonical()?,
            &Signature::from_slice(&hex::decode(&self.signature)?)?,
        )?;
        Ok(())
    }

    pub fn approval(&self, policy: &Policy, org_id: &str, now: u64) -> Result<Value> {
        self.verify(policy)?;
        let event = &self.bundle.request.event;
        event_request_fresh(&self.bundle, policy, now)?;
        let record = &event.record;
        ensure!(record.org_id == org_id, "write targets another org");
        ensure!(
            valid_id(org_id, "00D") && valid_id(&record.record_id, "00Q"),
            "18-character Salesforce IDs required"
        );
        ensure!(
            record.object == "Lead"
                && [
                    "LeadSource",
                    "Arkhe_Test_1__c",
                    "Arkhe_Test_2__c",
                    "Arkhe_Test_3__c",
                    "Arkhe_Test_4__c"
                ]
                .contains(&record.field.as_str()),
            "unsupported Salesforce scope"
        );
        ensure!(
            event.event_id.len() <= 255 && event.producer_id.len() <= 255,
            "Salesforce identity too long"
        );
        ensure!(
            record.value.is_null()
                || record
                    .value
                    .as_str()
                    .is_some_and(|s| !s.is_empty() && s.encode_utf16().count() <= 255),
            "only null or nonempty text up to 255 characters supported"
        );
        let expires = chrono::DateTime::from_timestamp(i64::try_from(event.expires_at)?, 0)
            .context("invalid expiry")?;
        Ok(
            json!({"Event_Id__c":event.event_id,"Org_Id__c":org_id,"Target_Lead__c":record.record_id,
            "Field_API_Name__c":record.field,"New_Value__c":record.value,"Is_Null__c":record.value.is_null(),
            "Expected_Version__c":self.expected_version,"Expires_At__c":expires.to_rfc3339_opts(chrono::SecondsFormat::Millis,true),
            "Checkpoint_Hash__c":self.bundle.checkpoint.hash()?,"Request_Hash__c":blake3::hash(&self.canonical()?).to_hex().to_string(),
            "Producer_Id__c":event.producer_id}),
        )
    }
}

fn event_request_fresh(bundle: &Bundle, policy: &Policy, now: u64) -> Result<()> {
    bundle.request.fresh_at(policy, now)?;
    ensure!(
        bundle.request.event.expires_at > now && bundle.request.event.expires_at - now <= 300,
        "approval expiry must be within the next five minutes"
    );
    ensure!(
        bundle.checkpoint.issued_at <= now.saturating_add(policy.future_skew_secs),
        "future checkpoint"
    );
    Ok(())
}

fn valid_id(value: &str, prefix: &str) -> bool {
    value.len() == 18
        && value.starts_with(prefix)
        && value.bytes().all(|b| b.is_ascii_alphanumeric())
}
