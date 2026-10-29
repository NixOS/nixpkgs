//! arkhe-ask — job-plan endpoint: `POST /v1/ask`.
//!
//! retrieve (chunk store) → generate (LLM) → verify citations (real, from
//! arkhe-rag) → answer + citation proof, or 422 with nothing.
//!
//! Every external frontier is a trait with an in-memory default (see
//! `pipeline` and `providers`); the verification layer is the real one.

pub mod auth;
pub mod events;
pub mod pipeline;
pub mod providers;
pub mod telemetry;

use auth::{KeycloakAuth, Tenant};
use axum::extract::State;
use axum::http::StatusCode;
use axum::response::{IntoResponse, Response};
use axum::routing::{get, post};
use axum::{middleware, Extension};
use axum::{Json, Router};
use pipeline::{AskError, AskPipeline, ChunkStore, LlmProvider};
use serde::Deserialize;
use serde_json::json;
use std::sync::Arc;
use tracing::Instrument;

#[derive(Clone)]
struct AppState {
    journal: Option<Arc<dyn events::ProofJournal>>,
    pipeline: Arc<AskPipeline<Box<dyn ChunkStore>, Box<dyn LlmProvider>>>,
}

#[derive(Deserialize)]
struct AskRequest {
    query: String,
}

async fn ask(
    State(state): State<AppState>,
    Extension(Tenant(tenant)): Extension<Tenant>,
    Json(req): Json<AskRequest>,
) -> Response {
    match state.pipeline.ask(&tenant, &req.query).await {
        Ok(response) => {
            metrics::counter!("arkhe_gate_decisions_total","decision"=>"accepted").increment(1);
            if let Some(journal) = &state.journal {
                if let Err(err) = journal
                    .record(&response.citation_proof)
                    .instrument(tracing::info_span!("arkhe.ask.proof.enqueue"))
                    .await
                {
                    eprintln!("verified outbox persistence failed: {err}");
                    return (
                        StatusCode::SERVICE_UNAVAILABLE,
                        Json(json!({"error":"proof_journal_unavailable"})),
                    )
                        .into_response();
                }
            }
            (StatusCode::OK, Json(response)).into_response()
        }
        Err(err) => {
            if matches!(err, AskError::UnsupportedClaim(_)) {
                metrics::counter!("arkhe_gate_decisions_total","decision"=>"refused").increment(1);
            }
            err.into_response()
        }
    }
}

impl IntoResponse for AskError {
    fn into_response(self) -> Response {
        use AskError::*;
        let (status, body) = match self {
            EmptyQuery => (StatusCode::BAD_REQUEST, json!({"error": "empty_query"})),
            Unauthorized => (StatusCode::UNAUTHORIZED, json!({"error": "unauthorized"})),
            Store(detail) => (
                StatusCode::BAD_GATEWAY,
                json!({"error": "store", "detail": detail}),
            ),
            Llm(detail) => (
                StatusCode::BAD_GATEWAY,
                json!({"error": "llm", "detail": detail}),
            ),
            UnsupportedClaim(pipeline::CitationError::EntityNotInEvidence { entity, chunk }) => (
                StatusCode::UNPROCESSABLE_ENTITY,
                json!({"error": "unsupported_claim", "entity": entity, "chunk": chunk}),
            ),
            UnsupportedClaim(pipeline::CitationError::InsufficientSupport { claim, score }) => (
                StatusCode::UNPROCESSABLE_ENTITY,
                json!({"error": "insufficient_support", "claim": claim, "score": score}),
            ),
            UnsupportedClaim(pipeline::CitationError::UnknownEvidence(id)) => (
                StatusCode::UNPROCESSABLE_ENTITY,
                json!({"error": "unknown_evidence", "evidence_id": id}),
            ),
        };
        (status, Json(body)).into_response()
    }
}

/// Explicit development/test router using the X-Tenant-Id placeholder.
pub fn router(store: Box<dyn ChunkStore>, llm: Box<dyn LlmProvider>) -> Router {
    telemetry::instrument(
        routes(store, llm, None)
            .route_layer(middleware::from_fn(auth::dev_identity))
            .merge(public_routes()),
    )
}

/// Production router: only verified bearer tokens provide tenant identity.
pub fn router_with_auth(
    store: Box<dyn ChunkStore>,
    llm: Box<dyn LlmProvider>,
    auth: KeycloakAuth,
) -> Router {
    telemetry::instrument(
        routes(store, llm, None)
            .route_layer(middleware::from_fn_with_state(auth, auth::authenticate))
            .merge(public_routes()),
    )
}

fn public_routes() -> Router {
    Router::new().route("/healthz", get(|| async { "ok" }))
}

pub fn router_with_journal(
    store: Box<dyn ChunkStore>,
    llm: Box<dyn LlmProvider>,
    auth: Option<KeycloakAuth>,
    journal: Arc<dyn events::ProofJournal>,
) -> Router {
    let app = routes(store, llm, Some(journal));
    let app = if let Some(auth) = auth {
        app.route_layer(middleware::from_fn_with_state(auth, auth::authenticate))
    } else {
        app.route_layer(middleware::from_fn(auth::dev_identity))
    };
    telemetry::instrument(app.merge(public_routes()))
}

fn routes(
    store: Box<dyn ChunkStore>,
    llm: Box<dyn LlmProvider>,
    journal: Option<Arc<dyn events::ProofJournal>>,
) -> Router {
    Router::new()
        .route("/v1/ask", post(ask))
        .with_state(AppState {
            journal,
            pipeline: Arc::new(AskPipeline::new(store, llm)),
        })
}
