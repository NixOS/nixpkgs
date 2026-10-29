use arkhe_ask::{
    events::ProofJournal,
    pipeline::{CitationProof, StoredChunk},
    providers::{EchoProvider, InMemoryStore},
    router_with_journal,
};
use async_trait::async_trait;
use axum::{
    body::Body,
    http::{Request, StatusCode},
};
use http_body_util::BodyExt;
use opentelemetry::{global, trace::TracerProvider};
use opentelemetry_sdk::{
    propagation::TraceContextPropagator,
    trace::{InMemorySpanExporter, SdkTracerProvider},
};
use std::sync::Arc;
use tower::ServiceExt;
use tracing::instrument::WithSubscriber;
use tracing_subscriber::layer::SubscriberExt;

struct Journal;
#[async_trait]
impl ProofJournal for Journal {
    async fn record(&self, _: &CitationProof) -> Result<(), String> {
        Ok(())
    }
}

#[tokio::test]
async fn metrics_and_spans_include_failures_and_pipeline_without_sensitive_labels() {
    global::set_text_map_propagator(TraceContextPropagator::new());
    let exporter = InMemorySpanExporter::default();
    let provider = SdkTracerProvider::builder()
        .with_simple_exporter(exporter.clone())
        .build();
    let subscriber = tracing_subscriber::registry()
        .with(tracing_opentelemetry::layer().with_tracer(provider.tracer("test")));
    let app = router_with_journal(
        Box::new(InMemoryStore {
            chunks: vec![StoredChunk {
                tenant_id: "tenant-sensitive".into(),
                id: "e1".into(),
                text: "Melbourne is in Victoria.".into(),
            }],
        }),
        Box::new(EchoProvider),
        None,
        Arc::new(Journal),
    );
    let request = Request::post("/v1/ask?secret_query_marker=1")
        .header("content-type", "application/json")
        .header("x-tenant-id", "tenant-sensitive")
        .header("authorization", "Bearer token-sensitive")
        .header(
            "traceparent",
            "00-0123456789abcdef0123456789abcdef-0123456789abcdef-01",
        )
        .body(Body::from(r#"{"query":"body-sensitive"}"#))
        .unwrap();
    async {
        let response = app.clone().oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        response.into_body().collect().await.unwrap();
        let unauthorized = app
            .clone()
            .oneshot(
                Request::post("/v1/ask")
                    .header("content-type", "application/json")
                    .body(Body::from(r#"{"query":"x"}"#))
                    .unwrap(),
            )
            .await
            .unwrap();
        assert_eq!(unauthorized.status(), StatusCode::UNAUTHORIZED);
        unauthorized.into_body().collect().await.unwrap();
        app.clone()
            .oneshot(
                Request::get("/unknown/path-sensitive")
                    .body(Body::empty())
                    .unwrap(),
            )
            .await
            .unwrap()
            .into_body()
            .collect()
            .await
            .unwrap();
        let response = app
            .oneshot(Request::get("/metrics").body(Body::empty()).unwrap())
            .await
            .unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        assert!(response.headers()["content-type"]
            .to_str()
            .unwrap()
            .starts_with("text/plain"));
        let bytes = response.into_body().collect().await.unwrap().to_bytes();
        let metrics = String::from_utf8(bytes.to_vec()).unwrap();
        assert!(metrics.contains("axum_http_requests_total"));
        assert!(metrics.contains("arkhe_gate_decisions_total"));
        assert!(metrics.contains("status=\"401\""));
        assert!(metrics.contains("axum_http_requests_duration_seconds_bucket"));
        assert!(metrics.contains("unmatched"));
        for secret in [
            "tenant-sensitive",
            "token-sensitive",
            "secret_query_marker",
            "body-sensitive",
            "path-sensitive",
        ] {
            assert!(!metrics.contains(secret), "metric leaked {secret}");
        }
    }
    .with_subscriber(subscriber)
    .await;
    provider.force_flush().unwrap();
    let spans = exporter.get_finished_spans().unwrap();
    for expected in [
        "POST /v1/ask",
        "arkhe.ask.rag.retrieve",
        "arkhe.ask.rag.generate",
        "arkhe.ask.rag.verify",
        "arkhe.ask.proof.enqueue",
    ] {
        assert!(
            spans.iter().any(|s| s.name == expected),
            "missing {expected}"
        );
    }
    let traced: Vec<_> = spans
        .iter()
        .filter(|s| s.span_context.trace_id().to_string() == "0123456789abcdef0123456789abcdef")
        .collect();
    assert_eq!(
        traced.len(),
        5,
        "HTTP and its four pipeline child spans must share the supplied trace"
    );
    let root = traced.iter().find(|s| s.name == "POST /v1/ask").unwrap();
    assert_eq!(root.parent_span_id.to_string(), "0123456789abcdef");
    for child in traced.iter().filter(|s| s.name != "POST /v1/ask") {
        assert_eq!(
            child.parent_span_id,
            root.span_context.span_id(),
            "{} is not a sibling under HTTP",
            child.name
        );
    }
    let attributes = format!(
        "{:?}",
        spans.iter().map(|s| &s.attributes).collect::<Vec<_>>()
    );
    for secret in [
        "tenant-sensitive",
        "token-sensitive",
        "secret_query_marker",
        "body-sensitive",
        "path-sensitive",
    ] {
        assert!(!attributes.contains(secret), "span leaked {secret}");
    }
    provider.shutdown().unwrap();
}
