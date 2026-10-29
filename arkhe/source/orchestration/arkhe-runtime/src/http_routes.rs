//! Versioned aliases reuse the exact MethodRouter, including handlers/auth.
use axum::{routing::MethodRouter, Router};

pub fn versioned_routes<S: Clone + Send + Sync + 'static>(
    health: MethodRouter<S>,
    work: MethodRouter<S>,
    evidence: MethodRouter<S>,
    objects: MethodRouter<S>,
    retention: MethodRouter<S>,
) -> Router<S> {
    Router::new()
        .route("/health", health.clone())
        .route("/work", work.clone())
        .route("/evidence/{digest}", evidence.clone())
        .route("/objects/{kind}/{digest}", objects.clone())
        .route("/v1/health", health)
        .route("/v1/work", work)
        .route("/v1/evidence/{digest}", evidence)
        .route("/v1/objects/{kind}/{digest}", objects)
        .route("/v1/retention", retention)
}
