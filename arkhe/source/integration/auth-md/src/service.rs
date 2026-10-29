//! Local registration → service assertion → access token flow. Host must persist state,
//! provision reviewed keys, authenticate claim sessions, and authorize requested scopes.
use crate::{
    claims::PendingClaim,
    token::{verify, verify_registration, Claims, Issuer, TokenState, Trust, ACCESS, ID_JAG},
    Error,
};
use rand_core::{OsRng, RngCore};
use serde::Serialize;
use std::collections::BTreeMap;

#[derive(Serialize)]
pub struct TokenResponse {
    pub access_token: String,
    pub token_type: String,
    pub expires_in: u32,
    pub scope: String,
}
#[derive(Serialize)]
pub struct Registration {
    pub registration_id: String,
    pub identity_assertion: String,
    pub assertion_expires: i64,
    pub scopes: Vec<String>,
}
struct Delegation {
    issuer: String,
    subject: String,
}
pub struct Service {
    issuer_url: String,
    resource: String,
    issuer: Issuer,
    trust: Trust,
    pub(crate) state: TokenState,
    delegations: BTreeMap<String, Delegation>,
}
fn nonce() -> String {
    let mut bytes = [0; 32];
    OsRng.fill_bytes(&mut bytes);
    bytes.iter().map(|b| format!("{b:02x}")).collect()
}
impl Service {
    pub fn new(
        issuer_url: String,
        resource: String,
        kid: String,
        key: ed25519_dalek::SigningKey,
    ) -> Self {
        let issuer = Issuer::new(issuer_url.clone(), kid.clone(), key);
        let trust = Trust {
            issuer: issuer_url.clone(),
            kid,
            key: issuer.public_key(),
            audience: issuer_url.clone(),
            client_id: "arkhe-auth-md".into(),
            max_lifetime: 600,
            max_auth_age: 3600,
        };
        Self {
            issuer_url,
            resource,
            issuer,
            trust,
            state: TokenState::default(),
            delegations: BTreeMap::new(),
        }
    }
    /// The scopes argument is trusted host policy, never copied from an agent request.
    /// This adapter uses an issuer+subject principal; it never links accounts by email.
    pub fn register_provider(
        &mut self,
        assertion: &str,
        provider: &Trust,
        now: i64,
        approved_scopes: &[String],
    ) -> Result<Registration, Error> {
        if provider.audience != self.issuer_url {
            return Err(Error::Untrusted);
        }
        let verified = verify_registration(assertion, provider, now, &mut self.state)?;
        let c = verified.claims();
        let subject = arkhe_core::Digest32::blake3(
            b"AKG:AUTH:PRINCIPAL:v1\0",
            &arkhe_core::canonical::encode_value(&serde_json::json!({"iss": c.iss, "sub": c.sub})),
        )
        .to_hex();
        self.mint(
            subject,
            c.email.clone(),
            c.auth_time,
            now,
            approved_scopes,
            c.iss.clone(),
            c.sub.clone(),
        )
    }
    pub fn register_claimed(
        &mut self,
        claim: &mut PendingClaim,
        verified_email: &str,
        now: i64,
        approved_scopes: &[String],
    ) -> Result<Registration, Error> {
        let subject = claim.take_subject(now)?;
        self.mint(
            subject.clone(),
            verified_email.into(),
            now,
            now,
            approved_scopes,
            self.issuer_url.clone(),
            subject,
        )
    }
    #[allow(clippy::too_many_arguments)]
    fn mint(
        &mut self,
        subject: String,
        email: String,
        auth_time: i64,
        now: i64,
        scopes: &[String],
        upstream_issuer: String,
        upstream_subject: String,
    ) -> Result<Registration, Error> {
        if !(0..=i64::MAX - 600).contains(&now)
            || !email.contains('@')
            || scopes.is_empty()
            || scopes
                .iter()
                .any(|s| s.is_empty() || s.chars().any(char::is_whitespace))
        {
            return Err(Error::InvalidToken);
        }
        let id = nonce();
        let claims = Claims {
            iss: self.issuer_url.clone(),
            sub: subject,
            aud: self.issuer_url.clone(),
            client_id: "arkhe-auth-md".into(),
            jti: nonce(),
            iat: now,
            exp: now + 600,
            auth_time,
            email,
            email_verified: true,
            scope: scopes.join(" "),
            registration_id: id.clone(),
        };
        let assertion = self.issuer.sign(&claims, ID_JAG)?;
        self.delegations.insert(
            id.clone(),
            Delegation {
                issuer: upstream_issuer,
                subject: upstream_subject,
            },
        );
        Ok(Registration {
            registration_id: id,
            identity_assertion: assertion,
            assertion_expires: claims.exp,
            scopes: scopes.to_vec(),
        })
    }
    pub fn exchange(
        &mut self,
        assertion: &str,
        resource: &str,
        now: i64,
    ) -> Result<TokenResponse, Error> {
        if resource != self.resource {
            return Err(Error::Untrusted);
        }
        let verified = verify(assertion, ID_JAG, &self.trust, now, &[], &mut self.state)?;
        if !self
            .delegations
            .contains_key(&verified.claims().registration_id)
        {
            return Err(Error::Untrusted);
        }
        let mut claims = verified.claims().clone();
        claims.aud = resource.into();
        claims.iat = now;
        claims.exp = now.saturating_add(300).min(claims.exp);
        claims.jti = nonce();
        Ok(TokenResponse {
            access_token: self.issuer.sign(&claims, ACCESS)?,
            token_type: "Bearer".into(),
            expires_in: (claims.exp - now) as u32,
            scope: claims.scope,
        })
    }
    pub fn revoke_token(&mut self, token: &str) {
        self.state.revoke_token(token);
    }
    /// Call only after verifying the upstream Security Event Token or an admin session.
    pub fn revoke_provider_subject(&mut self, issuer: &str, subject: &str) {
        for (id, delegation) in &self.delegations {
            if delegation.issuer == issuer && delegation.subject == subject {
                self.state.revoke_registration(&self.issuer_url, id);
            }
        }
    }
    pub fn access_trust(&self) -> Trust {
        Trust {
            audience: self.resource.clone(),
            max_lifetime: 300,
            issuer: self.trust.issuer.clone(),
            kid: self.trust.kid.clone(),
            key: self.trust.key,
            client_id: self.trust.client_id.clone(),
            max_auth_age: self.trust.max_auth_age,
        }
    }
    /// Resource server must consult the SAME revocation authority on every operation.
    pub fn token_state(&mut self) -> &mut TokenState {
        &mut self.state
    }
}
