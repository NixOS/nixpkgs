//! Strict Ed25519 JWT profile with caller-provisioned, issuer-bound keys.
use crate::Error;
use arkhe_core::Digest32;
use base64::{engine::general_purpose::URL_SAFE_NO_PAD as B64, Engine};
use ed25519_dalek::{Signature, Signer, SigningKey, VerifyingKey};
use serde::{Deserialize, Serialize};
use std::collections::{BTreeSet, HashSet};

pub const ID_JAG: &str = "oauth-id-jag+jwt";
pub const ACCESS: &str = "at+jwt";

#[derive(Clone, Serialize, Deserialize)]
pub struct Claims {
    pub iss: String,
    pub sub: String,
    pub aud: String,
    pub client_id: String,
    pub jti: String,
    pub iat: i64,
    pub exp: i64,
    pub auth_time: i64,
    pub email: String,
    pub email_verified: bool,
    #[serde(default)]
    pub scope: String,
    /// Service-local delegation identifier, bound to all derived tokens.
    #[serde(default)]
    pub registration_id: String,
}
#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct Header {
    alg: String,
    typ: String,
    kid: String,
}

/// Secrets are deliberately not Debug/Serialize. Signer custody belongs to the host.
pub struct Issuer {
    issuer: String,
    kid: String,
    key: SigningKey,
}
impl Issuer {
    pub fn new(issuer: String, kid: String, key: SigningKey) -> Self {
        Self { issuer, kid, key }
    }
    pub fn public_key(&self) -> VerifyingKey {
        self.key.verifying_key()
    }
    pub fn sign(&self, claims: &Claims, typ: &str) -> Result<String, Error> {
        if claims.iss != self.issuer || ![ID_JAG, ACCESS].contains(&typ) {
            return Err(Error::Untrusted);
        }
        let header = Header {
            alg: "EdDSA".into(),
            typ: typ.into(),
            kid: self.kid.clone(),
        };
        let h = B64.encode(serde_json::to_vec(&header).map_err(|_| Error::InvalidToken)?);
        let c = B64.encode(serde_json::to_vec(claims).map_err(|_| Error::InvalidToken)?);
        let input = format!("{h}.{c}");
        Ok(format!(
            "{input}.{}",
            B64.encode(self.key.sign(input.as_bytes()).to_bytes())
        ))
    }
}

pub struct Trust {
    pub issuer: String,
    pub kid: String,
    pub key: VerifyingKey,
    pub audience: String,
    pub client_id: String,
    pub max_lifetime: i64,
    pub max_auth_age: i64,
}

/// Process-local reference state. A multi-process host must supply durable atomic state.
#[derive(Default)]
pub struct TokenState {
    seen: HashSet<(String, String)>,
    revoked_tokens: HashSet<Digest32>,
    revoked_registrations: HashSet<(String, String)>,
}
impl TokenState {
    pub fn revoke_token(&mut self, token: &str) {
        self.revoked_tokens.insert(token_digest(token));
    }
    /// Invoke only after authenticated administration or verified provider event delivery.
    pub fn revoke_registration(&mut self, issuer: &str, registration: &str) {
        self.revoked_registrations
            .insert((issuer.into(), registration.into()));
    }
}

/// Constructible only by successful signature/claims verification. Never serializes bearer data.
pub struct VerifiedToken {
    claims: Claims,
    digest: Digest32,
    typ: String,
}
impl VerifiedToken {
    pub fn claims(&self) -> &Claims {
        &self.claims
    }
    pub fn digest(&self) -> Digest32 {
        self.digest
    }
    pub fn is_access(&self) -> bool {
        self.typ == ACCESS
    }
}
pub fn token_digest(token: &str) -> Digest32 {
    Digest32::blake3(b"AKG:AUTH:TOKEN:v1\0", token.as_bytes())
}

pub fn verify(
    token: &str,
    typ: &str,
    trust: &Trust,
    now: i64,
    required_scopes: &[&str],
    state: &mut TokenState,
) -> Result<VerifiedToken, Error> {
    if token.len() > 16384 || ![ID_JAG, ACCESS].contains(&typ) {
        return Err(Error::InvalidToken);
    }
    let parts: Vec<_> = token.split('.').collect();
    if parts.len() != 3 {
        return Err(Error::InvalidToken);
    }
    let decode = |s: &str| B64.decode(s).map_err(|_| Error::InvalidToken);
    let header: Header =
        serde_json::from_slice(&decode(parts[0])?).map_err(|_| Error::InvalidToken)?;
    if header.alg != "EdDSA" || header.typ != typ || header.kid != trust.kid {
        return Err(Error::Untrusted);
    }
    let sig = Signature::from_slice(&decode(parts[2])?).map_err(|_| Error::InvalidToken)?;
    trust
        .key
        .verify_strict(format!("{}.{}", parts[0], parts[1]).as_bytes(), &sig)
        .map_err(|_| Error::InvalidToken)?;
    let claims: Claims =
        serde_json::from_slice(&decode(parts[1])?).map_err(|_| Error::InvalidToken)?;
    if claims.iss != trust.issuer
        || claims.aud != trust.audience
        || claims.client_id != trust.client_id
    {
        return Err(Error::Untrusted);
    }
    if now < 0
        || claims.iat < 0
        || claims.auth_time < 0
        || claims.iat > now
        || claims.exp <= now
        || claims.exp <= claims.iat
        || trust.max_lifetime <= 0
        || claims.exp - claims.iat > trust.max_lifetime
        || claims.auth_time > now
        || trust.max_auth_age <= 0
        || now - claims.auth_time > trust.max_auth_age
    {
        return Err(Error::Expired);
    }
    if claims.sub.is_empty()
        || claims.jti.is_empty()
        || (typ == ACCESS && claims.registration_id.is_empty())
        || !claims.email_verified
        || !claims.email.contains('@')
    {
        return Err(Error::InvalidToken);
    }
    let scopes: BTreeSet<_> = claims.scope.split_ascii_whitespace().collect();
    if required_scopes.iter().any(|s| !scopes.contains(s)) {
        return Err(Error::Scope);
    }
    let digest = token_digest(token);
    if state.revoked_tokens.contains(&digest)
        || state
            .revoked_registrations
            .contains(&(claims.iss.clone(), claims.registration_id.clone()))
    {
        return Err(Error::Revoked);
    }
    Ok(VerifiedToken {
        claims,
        digest,
        typ: typ.into(),
    })
}

/// Only provider registration consumes the ID-JAG. Service assertions may be re-exchanged.
pub fn verify_registration(
    token: &str,
    trust: &Trust,
    now: i64,
    state: &mut TokenState,
) -> Result<VerifiedToken, Error> {
    let verified = verify(token, ID_JAG, trust, now, &[], state)?;
    if !state
        .seen
        .insert((verified.claims.iss.clone(), verified.claims.jti.clone()))
    {
        return Err(Error::Replay);
    }
    Ok(verified)
}
