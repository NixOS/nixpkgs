//! HTTP route contract with test handlers; no assertion about PostgreSQL uptime.
use arkhe_runtime::http_routes::versioned_routes;
use axum::{
    body::{to_bytes, Body},
    http::{HeaderMap, Request, StatusCode},
    routing::{get, post},
};
use tower::ServiceExt;

async fn guarded(headers: HeaderMap) -> Result<&'static str, StatusCode> {
    if headers.get("authorization").and_then(|v| v.to_str().ok()) != Some("Bearer synthetic-token")
    {
        return Err(StatusCode::UNAUTHORIZED);
    }
    Ok("same handler")
}

#[tokio::test]
async fn v1_and_legacy_routes_share_method_and_authentication_contract() {
    let app = versioned_routes(
        get(guarded),
        post(guarded),
        get(guarded),
        get(guarded),
        get(guarded),
    );
    for (method, path) in [
        ("GET", "/health"),
        ("GET", "/v1/health"),
        ("POST", "/work"),
        ("POST", "/v1/work"),
        ("GET", "/evidence/hash"),
        ("GET", "/v1/evidence/hash"),
        ("GET", "/objects/WorkIntent/hash"),
        ("GET", "/v1/objects/WorkIntent/hash"),
        ("GET", "/v1/retention"),
    ] {
        let denied = app
            .clone()
            .oneshot(
                Request::builder()
                    .method(method)
                    .uri(path)
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap();
        assert_eq!(denied.status(), StatusCode::UNAUTHORIZED, "{path}");
        let accepted = app
            .clone()
            .oneshot(
                Request::builder()
                    .method(method)
                    .uri(path)
                    .header("authorization", "Bearer synthetic-token")
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap();
        assert_eq!(accepted.status(), StatusCode::OK, "{path}");
        assert_eq!(
            to_bytes(accepted.into_body(), 1024).await.unwrap(),
            "same handler"
        );
    }
    let missing = app
        .oneshot(
            Request::builder()
                .uri("/v2/health")
                .body(Body::empty())
                .unwrap(),
        )
        .await
        .unwrap();
    assert_eq!(missing.status(), StatusCode::NOT_FOUND);
}
