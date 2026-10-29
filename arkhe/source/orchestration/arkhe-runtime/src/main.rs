use arkhe_core::{
    evidence::EvidenceReader, work::WorkIntent, worker::WorkerExecutionRecord, Digest32,
};
use arkhe_governance::{DevPolicyResolver, PolicyBinding};
use arkhe_kernel::ContainmentGate;
use arkhe_runtime::{Runtime, WorkCommitError};
use arkhe_wormgraph::{postgres::PgWormGraph, retention::RetentionPolicy};
use axum::{
    extract::{DefaultBodyLimit, Path, State},
    http::{HeaderMap, StatusCode},
    routing::{get, post},
    Json,
};
use serde::Deserialize;
use serde_json::{json, Value};
use std::{env, sync::Arc};

struct LiveState {
    runtime: Runtime<DevPolicyResolver>,
    store: PgWormGraph,
    policy: PolicyBinding,
    token: String,
    actor: String,
    retention: RetentionPolicy,
}
type ApiError = (StatusCode, &'static str);
fn authenticate(headers: &HeaderMap, state: &LiveState) -> Result<(), ApiError> {
    let expected = format!("Bearer {}", state.token);
    if headers.get("authorization").and_then(|v| v.to_str().ok()) != Some(&expected) {
        return Err((StatusCode::UNAUTHORIZED, "authentication required"));
    }
    Ok(())
}
fn digest(s: &str) -> Result<Digest32, ApiError> {
    let bytes = hex::decode(s).map_err(|_| (StatusCode::BAD_REQUEST, "invalid digest"))?;
    Ok(Digest32(bytes.try_into().map_err(|_| {
        (StatusCode::BAD_REQUEST, "invalid digest")
    })?))
}
async fn health(
    State(s): State<Arc<LiveState>>,
    headers: HeaderMap,
) -> Result<Json<Value>, ApiError> {
    authenticate(&headers, &s)?;
    s.store.health().await.map_err(|_| {
        (
            StatusCode::SERVICE_UNAVAILABLE,
            "evidence store unavailable",
        )
    })?;
    Ok(Json(json!({"status":"ok"})))
}
async fn retention(
    State(s): State<Arc<LiveState>>,
    headers: HeaderMap,
) -> Result<Json<Value>, ApiError> {
    authenticate(&headers, &s)?;
    Ok(Json(json!({
        "policy": s.retention,
        "storage_mode": "append-only-no-purge",
        "automatic_deletion": false,
        "external_archive_configured": false,
        "operational_retention_evidence": "NOT_MEASURED"
    })))
}
#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct ProposedWork {
    intent: WorkIntent,
    worker_record: WorkerExecutionRecord,
}
async fn commit(
    State(s): State<Arc<LiveState>>,
    headers: HeaderMap,
    Json(work): Json<ProposedWork>,
) -> Result<Json<Value>, ApiError> {
    authenticate(&headers, &s)?;
    if work.intent.requested_by != s.actor {
        return Err((StatusCode::FORBIDDEN, "request actor mismatch"));
    }
    let receipt = s
        .runtime
        .commit_proposed_work(&s.store, &work.intent, &work.worker_record, &s.policy)
        .await
        .map_err(|e| match e {
            WorkCommitError::Rejected(_) => (StatusCode::FORBIDDEN, "authorization rejected"),
            WorkCommitError::Storage(_) => {
                (StatusCode::SERVICE_UNAVAILABLE, "evidence commit failed")
            }
        })?;
    Ok(Json(
        json!({"record_hash":receipt.to_hex(),"intent_digest":work.intent.digest().to_hex(),"worker_digest":work.worker_record.digest().to_hex()}),
    ))
}
async fn read(
    State(s): State<Arc<LiveState>>,
    headers: HeaderMap,
    Path(hash): Path<String>,
) -> Result<Json<arkhe_core::evidence::EvidenceEnvelope>, ApiError> {
    authenticate(&headers, &s)?;
    s.store
        .get(digest(&hash)?)
        .await
        .map_err(|_| {
            (
                StatusCode::SERVICE_UNAVAILABLE,
                "evidence store unavailable",
            )
        })?
        .map(Json)
        .ok_or((StatusCode::NOT_FOUND, "evidence not found"))
}
async fn object(
    State(s): State<Arc<LiveState>>,
    headers: HeaderMap,
    Path((kind, hash)): Path<(String, String)>,
) -> Result<Vec<u8>, ApiError> {
    authenticate(&headers, &s)?;
    if !matches!(kind.as_str(), "WorkIntent" | "WorkerExecutionRecord") {
        return Err((StatusCode::NOT_FOUND, "object type not found"));
    }
    s.store
        .canonical_object(&kind, digest(&hash)?)
        .await
        .map_err(|_| {
            (
                StatusCode::SERVICE_UNAVAILABLE,
                "evidence store unavailable",
            )
        })?
        .ok_or((StatusCode::NOT_FOUND, "object not found"))
}
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    if env::args().nth(1).as_deref() == Some("migrate") {
        PgWormGraph::migrate(&env::var("DATABASE_URL")?)
            .await
            .map_err(std::io::Error::other)?;
        println!("arkhe-sql migrations applied and checksums verified");
        return Ok(());
    }
    let retention_policy = RetentionPolicy::from_settings(
        env::var("ARKHE_EVIDENCE_RETENTION_DAYS").ok().as_deref(),
        env::var("ARKHE_EVIDENCE_IMMEDIATE_DAYS").ok().as_deref(),
    )
    .map_err(std::io::Error::other)?;
    let token = env::var("ARKHE_API_TOKEN")?;
    if token.len() < 32 {
        return Err("ARKHE_API_TOKEN must contain at least 32 bytes".into());
    }
    let actor = env::var("ARKHE_ACTOR")?;
    if actor.trim().is_empty() {
        return Err("ARKHE_ACTOR is required".into());
    }
    let store = PgWormGraph::connect(&env::var("DATABASE_URL")?, &env::var("ARKHE_TENANT_ID")?)
        .await
        .map_err(std::io::Error::other)?;
    let policy = PolicyBinding {
        policy_id: "development-unprotected-v1".into(),
        version: 1,
        policy_digest: Digest32::blake3(
            b"AKG:DEV-POLICY:v0-REF\0",
            b"DraftDocument|QueryKnowledgeBase|Simulate",
        ),
    };
    let state = Arc::new(LiveState {
        runtime: Runtime {
            gate: ContainmentGate::new(DevPolicyResolver),
        },
        store,
        policy,
        token,
        actor,
        retention: retention_policy,
    });
    let app = arkhe_runtime::http_routes::versioned_routes(
        get(health),
        post(commit),
        get(read),
        get(object),
        get(retention),
    )
    .layer(DefaultBodyLimit::max(262144))
    .with_state(state);
    let listener = tokio::net::TcpListener::bind(
        env::var("ARKHE_LISTEN").unwrap_or_else(|_| "127.0.0.1:8788".into()),
    )
    .await?;
    println!("Arkhe runtime listening on {}", listener.local_addr()?);
    axum::serve(listener, app).await?;
    Ok(())
}
