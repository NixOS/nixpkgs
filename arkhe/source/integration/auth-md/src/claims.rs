//! Reference service_auth ceremony. No assertion is issued before authenticated confirmation.
use crate::Error;
use rand_core::{OsRng, RngCore};

pub struct PendingClaim {
    code: String,
    expires_at: i64,
    attempts: u8,
    subject: Option<String>,
    consumed: bool,
}
impl PendingClaim {
    /// The host must bind this object to an unguessable claim_token and rate-limit creation/polling.
    pub fn new(now: i64) -> Result<(Self, String), Error> {
        if !(0..=i64::MAX - 600).contains(&now) {
            return Err(Error::Claim);
        }
        // Rejection sampling avoids modulo bias.
        let sample = loop {
            let n = OsRng.next_u32();
            if n < u32::MAX - u32::MAX % 1_000_000 {
                break n;
            }
        };
        let code = format!("{:06}", sample % 1_000_000);
        Ok((
            Self {
                code: code.clone(),
                expires_at: now + 600,
                attempts: 0,
                subject: None,
                consumed: false,
            },
            code,
        ))
    }
    /// authenticated_subject MUST come from the host session, never the agent's request body.
    pub fn confirm(
        &mut self,
        code: &str,
        authenticated_subject: &str,
        now: i64,
    ) -> Result<(), Error> {
        if now < 0
            || now >= self.expires_at
            || self.attempts >= 5
            || self.subject.is_some()
            || self.consumed
            || authenticated_subject.is_empty()
        {
            return Err(Error::Claim);
        }
        self.attempts += 1;
        if code != self.code {
            return Err(Error::Claim);
        }
        self.subject = Some(authenticated_subject.into());
        Ok(())
    }
    /// Consume once; the host can now mint a service identity_assertion for this subject.
    pub fn take_subject(&mut self, now: i64) -> Result<String, Error> {
        if now < 0 || now >= self.expires_at || self.consumed {
            return Err(Error::Claim);
        }
        let subject = self.subject.clone().ok_or(Error::Claim)?;
        self.consumed = true;
        Ok(subject)
    }
}
