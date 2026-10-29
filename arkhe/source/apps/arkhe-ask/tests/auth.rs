use arkhe_ask::{
    auth::{self, KeycloakAuth, Tenant},
    pipeline::StoredChunk,
    providers::{EchoProvider, InMemoryStore},
    router_with_auth,
};
use axum::{
    body::Body,
    extract::Extension,
    http::{Request, StatusCode},
    middleware,
    routing::get,
    Json, Router,
};
use http_body_util::BodyExt;
use jsonwebtoken::{encode, Algorithm, EncodingKey, Header};
use serde_json::{json, Value};
use std::time::{SystemTime, UNIX_EPOCH};
use tower::ServiceExt;

async fn setup() -> (Router, String) {
    setup_with_store(Box::new(InMemoryStore {
        chunks: vec![StoredChunk {
            tenant_id: "tenant-a".into(),
            id: "e1".into(),
            text: "Melbourne is in Victoria.".into(),
        }],
    }))
    .await
}

async fn setup_with_store(store: Box<dyn arkhe_ask::pipeline::ChunkStore>) -> (Router, String) {
    let listener = tokio::net::TcpListener::bind("127.0.0.1:0").await.unwrap();
    let server = format!("http://{}", listener.local_addr().unwrap());
    let issuer = format!("{server}/realms/test");
    let metadata = json!({"issuer": issuer, "authorization_endpoint": format!("{server}/auth"),
        "jwks_uri": format!("{server}/keys"), "response_types_supported": ["code"],
        "subject_types_supported": ["public"], "id_token_signing_alg_values_supported": ["RS256"]});
    let keys: Value = serde_json::from_str(include_str!("fixtures/jwks.json")).unwrap();
    let oidc = Router::new()
        .route(
            "/realms/test/.well-known/openid-configuration",
            get(move || async move { Json(metadata) }),
        )
        .route("/keys", get(move || async move { Json(keys) }));
    tokio::spawn(async move {
        axum::serve(listener, oidc).await.unwrap();
    });
    let auth = KeycloakAuth::connect(&server, "test", "arkhe-ask")
        .await
        .unwrap();
    let app = router_with_auth(store, Box::new(EchoProvider), auth.clone());
    // Test-only probe proves the exact tenant placed in request extensions.
    let probe = Router::new()
        .route(
            "/tenant",
            get(|Extension(Tenant(tenant)): Extension<Tenant>| async move { tenant }),
        )
        .route_layer(middleware::from_fn_with_state(auth, auth::authenticate));
    (app.merge(probe), issuer)
}

fn claims(issuer: &str) -> Value {
    let now = SystemTime::now()
        .duration_since(UNIX_EPOCH)
        .unwrap()
        .as_secs();
    json!({"iss":issuer,"aud":"arkhe-ask","sub":"service-account","jti":"test",
        "iat":now,"exp":now+300,"typ":"Bearer","azp":"test-client","tenant_id":"tenant-a"})
}

fn sign(claims: &Value) -> String {
    let mut header = Header::new(Algorithm::RS256);
    header.kid = Some("test".into());
    encode(
        &header,
        claims,
        &EncodingKey::from_rsa_pem(include_bytes!("fixtures/test-only-rsa.pem")).unwrap(),
    )
    .unwrap()
}

fn request(token: Option<&str>, path: &str) -> Request<Body> {
    let mut req = Request::builder()
        .method(if path == "/v1/ask" { "POST" } else { "GET" })
        .uri(path)
        .header("content-type", "application/json")
        .header("x-tenant-id", "spoofed");
    if let Some(token) = token {
        req = req.header("authorization", format!("Bearer {token}"));
    }
    req.body(Body::from(r#"{"query":"evidence"}"#)).unwrap()
}

#[tokio::test]
async fn jwt_tenant_overrides_untrusted_header_and_health_is_public() {
    let (app, issuer) = setup().await;
    let token = sign(&claims(&issuer));
    let response = app
        .clone()
        .oneshot(request(Some(&token), "/tenant"))
        .await
        .unwrap();
    assert_eq!(response.status(), StatusCode::OK);
    assert_eq!(
        response.into_body().collect().await.unwrap().to_bytes(),
        "tenant-a"
    );
    assert_eq!(
        app.clone()
            .oneshot(request(Some(&token), "/v1/ask"))
            .await
            .unwrap()
            .status(),
        StatusCode::OK
    );
    assert_eq!(
        app.oneshot(request(None, "/healthz"))
            .await
            .unwrap()
            .status(),
        StatusCode::OK
    );
}

#[tokio::test]
async fn invalid_tokens_never_reach_the_pipeline() {
    let (app, issuer) = setup().await;
    let base = claims(&issuer);
    let mut cases = vec![("missing", None), ("malformed", Some("not-a-jwt".into()))];
    for (name, field, value) in [
        ("issuer", "iss", json!("https://other/realms/test")),
        ("audience", "aud", json!("other-service")),
        ("expired", "exp", json!(1)),
        ("future", "nbf", json!(u64::MAX / 2)),
        ("tenant-empty", "tenant_id", json!(" ")),
        ("tenant-type", "tenant_id", json!(123)),
        ("id-token", "typ", json!("ID")),
        ("subject", "sub", json!("")),
    ] {
        let mut altered = base.clone();
        altered[field] = value;
        cases.push((name, Some(sign(&altered))));
    }
    let mut missing = base.clone();
    missing.as_object_mut().unwrap().remove("tenant_id");
    cases.push(("tenant-missing", Some(sign(&missing))));
    let valid = sign(&base);
    let parts: Vec<_> = valid.split('.').collect();
    cases.push((
        "signature",
        Some(format!(
            "{}.{}.{}",
            parts[0],
            parts[1],
            "a".repeat(parts[2].len())
        )),
    ));
    for (name, token) in cases {
        let response = app
            .clone()
            .oneshot(request(token.as_deref(), "/v1/ask"))
            .await
            .unwrap();
        assert_eq!(response.status(), StatusCode::UNAUTHORIZED, "case {name}");
        let body = response.into_body().collect().await.unwrap().to_bytes();
        let json: Value = serde_json::from_slice(&body).unwrap();
        assert_eq!(json, json!({"error":"unauthorized"}), "case {name}");
    }
}

#[tokio::test]
#[ignore = "requires a live pgvector Postgres"]
async fn jwt_tenant_scopes_real_pgvector_evidence_despite_spoofed_header() {
    use arkhe_ask::{pipeline::Embedder, providers::pgvector::PgVectorStore};
    use std::sync::Arc;
    struct Fixed;
    #[async_trait::async_trait]
    impl Embedder for Fixed {
        async fn embed(&self, _: &str) -> Result<Vec<f32>, String> {
            let mut vector = vec![0.0; 1536];
            vector[0] = 1.0;
            Ok(vector)
        }
    }
    let pool = sqlx::postgres::PgPoolOptions::new()
        .max_connections(1)
        .connect(&std::env::var("DATABASE_URL").expect("DATABASE_URL"))
        .await
        .unwrap();
    sqlx::query("CREATE TEMP TABLE chunks (tenant_id TEXT NOT NULL, id TEXT NOT NULL, text TEXT NOT NULL, embedding vector(1536) NOT NULL, PRIMARY KEY(tenant_id,id))")
        .execute(&pool).await.unwrap();
    let store = PgVectorStore::new(pool.clone(), Arc::new(Fixed));
    store
        .insert("tenant-a", "same", "Melbourne is in Victoria.")
        .await
        .unwrap();
    store
        .insert("tenant-b", "same", "Sydney is in Australia.")
        .await
        .unwrap();
    let (app, issuer) = setup_with_store(Box::new(store)).await;
    for (tenant, expected) in [("tenant-a", "Melbourne"), ("tenant-b", "Sydney")] {
        let mut payload = claims(&issuer);
        payload["tenant_id"] = json!(tenant);
        let response = app
            .clone()
            .oneshot(request(Some(&sign(&payload)), "/v1/ask"))
            .await
            .unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        let bytes = response.into_body().collect().await.unwrap().to_bytes();
        let body: Value = serde_json::from_slice(&bytes).unwrap();
        assert!(body["answer"].as_str().unwrap().starts_with(expected));
        assert_eq!(body["citation_proof"]["tenant_id"], tenant);
    }
    pool.close().await;
}
