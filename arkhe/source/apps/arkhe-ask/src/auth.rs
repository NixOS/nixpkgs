//! Keycloak authentication. Never derive a JWT tenant from caller headers.
use axum::{
    extract::{Request, State},
    middleware::Next,
    response::Response,
};
use axum_keycloak_auth::{
    instance::{KeycloakAuthInstance, KeycloakConfig},
    layer::KeycloakAuthLayer,
    PassthroughMode, Url,
};
use serde::Deserialize;
use std::{
    sync::Arc,
    time::{Duration, SystemTime, UNIX_EPOCH},
};

#[derive(Clone)]
pub struct Tenant(pub String);

#[derive(Clone, Deserialize)]
struct TenantClaims {
    tenant_id: Option<String>,
    nbf: Option<u64>,
}

#[derive(Clone)]
pub struct KeycloakAuth {
    validator: Arc<KeycloakAuthLayer<String, TenantClaims>>,
    issuer: String,
}

impl KeycloakAuth {
    pub async fn connect(server: &str, realm: &str, audience: &str) -> Result<Self, String> {
        if realm.trim().is_empty() || audience.trim().is_empty() {
            return Err("Keycloak realm and audience are required".into());
        }
        let server = Url::parse(server).map_err(|_| "invalid KEYCLOAK_URL")?;
        if !matches!(server.scheme(), "http" | "https") || server.host_str().is_none() {
            return Err("KEYCLOAK_URL must be an HTTP(S) base URL".into());
        }
        let issuer = format!("{}/realms/{realm}", server.as_str().trim_end_matches('/'));
        let instance = Arc::new(KeycloakAuthInstance::new(
            KeycloakConfig::builder()
                .server(server)
                .realm(realm.to_string())
                .retry((2, 1))
                .build(),
        ));
        tokio::time::timeout(Duration::from_secs(15), async {
            while !instance.is_operational().await {
                tokio::time::sleep(Duration::from_millis(50)).await;
            }
        })
        .await
        .map_err(|_| "Keycloak discovery did not become operational")?;
        let validator = KeycloakAuthLayer::<String, TenantClaims>::builder()
            .instance(instance)
            .passthrough_mode(PassthroughMode::Block)
            .persist_raw_claims(true)
            .expected_audiences(vec![audience.to_string()])
            .build();
        Ok(Self {
            validator: Arc::new(validator),
            issuer,
        })
    }

    pub async fn from_env() -> Result<Self, String> {
        let required = |name| {
            std::env::var(name)
                .ok()
                .filter(|v| !v.trim().is_empty())
                .ok_or_else(|| format!("{name} is required"))
        };
        Self::connect(
            &required("KEYCLOAK_URL")?,
            &required("KEYCLOAK_REALM")?,
            &required("KEYCLOAK_AUDIENCE")?,
        )
        .await
    }
}

pub async fn authenticate(
    State(auth): State<KeycloakAuth>,
    mut request: Request,
    next: Next,
) -> Response {
    let unauthorized = || {
        use axum::response::IntoResponse;
        (
            axum::http::StatusCode::UNAUTHORIZED,
            [(axum::http::header::WWW_AUTHENTICATE, "Bearer")],
            axum::Json(serde_json::json!({"error": "unauthorized"})),
        )
            .into_response()
    };
    let Some(raw) = request
        .headers()
        .get(axum::http::header::AUTHORIZATION)
        .and_then(|v| v.to_str().ok())
        .and_then(|v| v.strip_prefix("Bearer "))
        .filter(|v| !v.is_empty())
    else {
        return unauthorized();
    };
    let Ok(Ok((claims, token))) = tokio::time::timeout(
        Duration::from_secs(10),
        auth.validator.validate_raw_token(raw),
    )
    .await
    else {
        return unauthorized();
    };
    // 0.8.1 verifies signature/audience/expiry, but does not enforce issuer or nbf.
    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap_or_default()
        .as_secs();
    if token.issuer != auth.issuer
        || token.subject.trim().is_empty()
        || token.extra.nbf.is_some_and(|nbf| nbf > now)
        || claims
            .as_ref()
            .and_then(|c| c.get("typ"))
            .and_then(|v| v.as_str())
            != Some("Bearer")
    {
        return unauthorized();
    }
    let Some(tenant) = token.extra.tenant_id.filter(|t| !t.trim().is_empty()) else {
        return unauthorized();
    };
    request.extensions_mut().insert(Tenant(tenant));
    next.run(request).await
}

/// Explicitly opted-in development/test identity only.
pub async fn dev_identity(mut request: Request, next: Next) -> Response {
    let tenant = request
        .headers()
        .get("x-tenant-id")
        .and_then(|v| v.to_str().ok())
        .unwrap_or("")
        .to_string();
    request.extensions_mut().insert(Tenant(tenant));
    next.run(request).await
}
