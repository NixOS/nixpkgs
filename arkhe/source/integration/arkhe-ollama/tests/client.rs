use arkhe_ollama::{Config, Error, OllamaClient};
use axum::{
    extract::State,
    http::StatusCode,
    response::{IntoResponse, Response},
    routing::{get, post},
    Json, Router,
};
use serde_json::{json, Value};
use std::sync::{
    atomic::{AtomicU8, AtomicUsize, Ordering},
    Arc,
};
#[derive(Default)]
struct Server {
    mode: AtomicU8,
    calls: AtomicUsize,
}
async fn tags(State(s): State<Arc<Server>>) -> Json<Value> {
    let mode = s.mode.load(Ordering::SeqCst);
    let mut model =
        json!({"name":"local:test","digest":if mode==1{"bb".repeat(32)}else{"aa".repeat(32)}});
    if mode == 10 {
        model["remote_host"] = json!("https://ollama.com");
    }
    let models = if mode == 12 {
        vec![model.clone(), model]
    } else {
        vec![model]
    };
    Json(json!({"models":models}))
}
async fn version() -> Json<Value> {
    Json(json!({"version":"test"}))
}
async fn chat(State(s): State<Arc<Server>>, Json(body): Json<Value>) -> Response {
    s.calls.fetch_add(1, Ordering::SeqCst);
    assert_eq!(body["stream"], false);
    assert_eq!(body["think"], false);
    assert!(body.get("tools").is_none());
    assert_eq!(body["options"]["num_ctx"], 4096);
    let mode = s.mode.load(Ordering::SeqCst);
    if mode == 7 {
        return StatusCode::SERVICE_UNAVAILABLE.into_response();
    }
    if mode == 9 {
        tokio::time::sleep(std::time::Duration::from_secs(2)).await;
    }
    let mut result = json!({"model":"local:test","done":true,"done_reason":"stop","message":{"role":"assistant","content":"local response"},"eval_count":3});
    match mode {
        2 => result["done_reason"] = json!("length"),
        3 => result["message"]["tool_calls"] = json!([{"function":{"name":"execute"}}]),
        4 => result["done"] = json!(false),
        5 => result["message"]["content"] = json!(""),
        6 => result["message"]["role"] = json!("system"),
        8 => result["model"] = json!("other"),
        11 => s.mode.store(1, Ordering::SeqCst),
        _ => (),
    };
    Json(result).into_response()
}
async fn start() -> (Config, Arc<Server>, tokio::task::JoinHandle<()>) {
    let s = Arc::new(Server::default());
    let listener = tokio::net::TcpListener::bind("127.0.0.1:0").await.unwrap();
    let port = listener.local_addr().unwrap().port();
    let app = Router::new()
        .route("/api/version", get(version))
        .route("/api/tags", get(tags))
        .route("/api/chat", post(chat))
        .with_state(s.clone());
    let task = tokio::spawn(async move {
        axum::serve(listener, app).await.unwrap();
    });
    (
        Config {
            base_url: format!("http://127.0.0.1:{port}"),
            model: "local:test".into(),
            model_digest: "aa".repeat(32),
            timeout_seconds: 5,
            context_tokens: 4096,
            max_output_tokens: 128,
        },
        s,
        task,
    )
}
#[tokio::test]
async fn local_status_and_chat_are_pinned_and_disable_tools() {
    let (c, s, t) = start().await;
    let client = OllamaClient::new(c).unwrap();
    assert_eq!(client.status().await.unwrap().version, "test");
    let r = client.chat("system", "hello", None).await.unwrap();
    assert_eq!(r.content, "local response");
    assert_eq!(s.calls.load(Ordering::SeqCst), 1);
    t.abort();
}
#[tokio::test]
async fn changed_model_is_rejected_before_inference() {
    let (c, s, t) = start().await;
    s.mode.store(1, Ordering::SeqCst);
    assert!(matches!(
        OllamaClient::new(c)
            .unwrap()
            .chat("system", "hello", None)
            .await,
        Err(Error::ModelMismatch)
    ));
    assert_eq!(s.calls.load(Ordering::SeqCst), 0);
    t.abort();
}
#[tokio::test]
async fn rejects_truncation_tool_calls_roles_empty_and_mismatched_responses() {
    let (c, s, t) = start().await;
    let client = OllamaClient::new(c).unwrap();
    for mode in [2, 3, 4, 5, 6, 8] {
        s.mode.store(mode, Ordering::SeqCst);
        assert!(matches!(
            client.chat("system", "hello", None).await,
            Err(Error::InvalidResponse(_))
        ));
    }
    t.abort();
}
#[tokio::test]
async fn errors_and_timeouts_do_not_retry() {
    let (mut c, s, t) = start().await;
    c.timeout_seconds = 1;
    let client = OllamaClient::new(c).unwrap();
    s.mode.store(7, Ordering::SeqCst);
    assert!(matches!(
        client.chat("s", "u", None).await,
        Err(Error::Http(503))
    ));
    s.mode.store(9, Ordering::SeqCst);
    assert!(matches!(
        client.chat("s", "u", None).await,
        Err(Error::Unavailable)
    ));
    assert_eq!(s.calls.load(Ordering::SeqCst), 2);
    t.abort();
}
#[tokio::test]
async fn remote_endpoint_is_not_a_local_provider() {
    let (mut c, _, t) = start().await;
    c.base_url = "https://example.com".into();
    assert!(OllamaClient::new(c).is_err());
    t.abort();
}

#[tokio::test]
async fn cloud_duplicate_catalog_entries_and_midflight_drift_are_rejected() {
    let (c, s, t) = start().await;
    for suffix in [":cloud", ":120b-cloud"] {
        let mut remote = c.clone();
        remote.model = format!("model{suffix}");
        assert!(OllamaClient::new(remote).is_err());
    }
    let client = OllamaClient::new(c).unwrap();
    for mode in [10, 12] {
        s.mode.store(mode, Ordering::SeqCst);
        assert!(matches!(
            client.chat("s", "u", None).await,
            Err(Error::ModelMismatch)
        ));
    }
    assert_eq!(s.calls.load(Ordering::SeqCst), 0);
    s.mode.store(11, Ordering::SeqCst);
    assert!(matches!(
        client.chat("s", "u", None).await,
        Err(Error::ModelMismatch)
    ));
    assert_eq!(s.calls.load(Ordering::SeqCst), 1);
    t.abort();
}
