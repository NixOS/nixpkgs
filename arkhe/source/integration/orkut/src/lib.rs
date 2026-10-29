//! Orkut adapter candidates. No connection to or authorization from orkut.com is implied.
use arkhe_auth_md::token::{verify, TokenState, Trust, ACCESS};
use arkhe_core::{
    canonical::encode_value,
    work::{ContextEntry, ContextKind, RequestIdentity, WorkIntent, WorkIntentType},
    Digest32,
};
use serde::{Deserialize, Serialize};
pub mod executor;

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error(transparent)]
    Auth(#[from] arkhe_auth_md::Error),
    #[error("humanity evidence missing, expired, untrusted or bound to another subject")]
    Humanity,
    #[error("invalid community or post")]
    InvalidInput,
    #[error("execution rejected: {0}")]
    Execution(String),
}
#[derive(Clone, Serialize, Deserialize)]
pub enum Action {
    Join,
    Post {
        content: String,
        provenance: Option<Digest32>,
    },
}

/// Returned only by a host verifier that validates actual Passport/ZK evidence.
/// A score in a request body must never be treated as verified humanity.
pub struct HumanityEvidence {
    pub subject: String,
    pub audience: String,
    pub score: u16,
    pub expires_at: i64,
    pub digest: Digest32,
}
pub trait HumanityVerifier {
    fn verify(&self, proof: &[u8], now: i64) -> Result<HumanityEvidence, Error>;
}
pub struct CommunityPolicy {
    pub resource: String,
    pub minimum_humanity_score: u16,
}

/// Sealed validated proposal. The executor revalidates the original inputs at dispatch time.
pub struct Proposal {
    intent: WorkIntent,
    action: Action,
}
impl Proposal {
    pub fn intent(&self) -> &WorkIntent {
        &self.intent
    }
    pub fn action(&self) -> &Action {
        &self.action
    }
}

/// Builds a proposal after checking credentials and humanity; kernel authorization and
/// durable dispatch are still mandatory before any community write.
#[allow(clippy::too_many_arguments)]
pub fn propose(
    policy: &CommunityPolicy,
    community: &str,
    action: Action,
    bearer: &str,
    trust: &Trust,
    state: &mut TokenState,
    humanity: &dyn HumanityVerifier,
    proof: &[u8],
    request: RequestIdentity,
    now: i64,
) -> Result<Proposal, Error> {
    if community.is_empty() || community.len() > 256 || community.chars().any(char::is_control) {
        return Err(Error::InvalidInput);
    }
    let (intent_type, scope) = match &action {
        Action::Join => (WorkIntentType::CommunityJoin, "community:join"),
        Action::Post { content, .. } => {
            if content.trim().is_empty() || content.len() > 65536 {
                return Err(Error::InvalidInput);
            }
            (WorkIntentType::CommunityPost, "community:post")
        }
    };
    if trust.audience != policy.resource {
        return Err(Error::Auth(arkhe_auth_md::Error::Untrusted));
    }
    let token = verify(bearer, ACCESS, trust, now, &[scope], state)?;
    let evidence = humanity.verify(proof, now)?;
    if evidence.subject != token.claims().sub
        || evidence.audience != policy.resource
        || evidence.score < policy.minimum_humanity_score
        || evidence.expires_at <= now
        || evidence.digest == Digest32::ZERO
    {
        return Err(Error::Humanity);
    }
    let mut context = vec![
        ContextEntry {
            kind: ContextKind::AuthToken,
            hash: token.digest(),
        },
        ContextEntry {
            kind: ContextKind::HumanityProof,
            hash: evidence.digest,
        },
    ];
    if let Action::Post {
        provenance: Some(hash),
        ..
    } = &action
    {
        context.push(ContextEntry {
            kind: ContextKind::ContentProvenance,
            hash: *hash,
        });
    }
    let parameters_digest = Digest32::blake3(
        b"AKG:ORKUT:ACTION:v1\0",
        &encode_value(&serde_json::to_value(&action).map_err(|_| Error::InvalidInput)?),
    );
    Ok(Proposal {
        action,
        intent: WorkIntent {
            requested_by: token.claims().sub.clone(),
            intent_type,
            target: Digest32::blake3(
                b"AKG:ORKUT:COMMUNITY:v1\0",
                &encode_value(
                    &serde_json::json!({"resource": policy.resource, "community": community}),
                ),
            ),
            parameters_digest,
            context,
            context_refs: vec![],
            request_identity: request,
            claimed_created_at: now,
        },
    })
}
