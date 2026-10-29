mod support;
use arkhe_ask::{
    events::{KafkaBus, PgProofJournal},
    pipeline::StoredChunk,
    providers::{EchoProvider, InMemoryStore},
    router_with_journal,
};
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
use tracing_subscriber::layer::SubscriberExt;

const TRACE: &str = "11112222333344445555666677778888";
const TEST: &str = "crash_between_enqueue_and_publish_keeps_trace_context";

fn tracing_setup() -> (SdkTracerProvider, InMemorySpanExporter) {
    global::set_text_map_propagator(TraceContextPropagator::new());
    let exporter = InMemorySpanExporter::default();
    let provider = SdkTracerProvider::builder()
        .with_simple_exporter(exporter.clone())
        .build();
    let subscriber = tracing_subscriber::registry()
        .with(tracing_opentelemetry::layer().with_tracer(provider.tracer("process-crash-test")));
    tracing::subscriber::set_global_default(subscriber).unwrap();
    (provider, exporter)
}

#[tokio::test]
#[ignore = "requires Postgres, real Kafka and a fresh KAFKA_CRASH_TEST_TOPIC; terminates only its own helper subprocess"]
async fn crash_between_enqueue_and_publish_keeps_trace_context() {
    if std::env::var("ARKHE_CRASH_CHILD").as_deref() == Ok("enqueue-then-exit") {
        let schema = std::env::var("ARKHE_TEST_SCHEMA").unwrap();
        assert!(
            schema.starts_with("ask_event_test_")
                && schema
                    .bytes()
                    .all(|c| c.is_ascii_alphanumeric() || c == b'_')
        );
        let (_provider, _exporter) = tracing_setup();
        let path = format!("SET search_path TO {schema}, public");
        let pool = sqlx::postgres::PgPoolOptions::new()
            .max_connections(2)
            .after_connect(move |conn, _| {
                let path = path.clone();
                Box::pin(async move {
                    sqlx::query(&path).execute(conn).await?;
                    Ok(())
                })
            })
            .connect(&std::env::var("DATABASE_URL").unwrap())
            .await
            .unwrap();
        let journal = Arc::new(PgProofJournal::connect(pool).await.unwrap());
        let app = router_with_journal(
            Box::new(InMemoryStore {
                chunks: vec![StoredChunk {
                    tenant_id: "tenant-a".into(),
                    id: "e1".into(),
                    text: "Melbourne is in Victoria.".into(),
                }],
            }),
            Box::new(EchoProvider),
            None,
            journal.clone(),
        );
        let request = Request::post("/v1/ask")
            .header("content-type", "application/json")
            .header("x-tenant-id", "tenant-a")
            .header("traceparent", format!("00-{TRACE}-0123456789abcdef-01"))
            .body(Body::from(r#"{"query":"evidence"}"#))
            .unwrap();
        let response = app.oneshot(request).await.unwrap();
        assert_eq!(response.status(), StatusCode::OK);
        response.into_body().collect().await.unwrap();
        // The HTTP handler awaited the outbox INSERT. No relay exists in this
        // process. Deliberately bypass Rust drops, runtime and SDK shutdown.
        std::process::exit(73);
    }

    let (journal, admin, schema) = support::fixture().await;
    let executable = std::env::current_exe().unwrap();
    let child_schema = schema.clone();
    let output = tokio::task::spawn_blocking(move || {
        std::process::Command::new(executable)
            .args(["--exact", TEST, "--ignored", "--nocapture"])
            .env("ARKHE_CRASH_CHILD", "enqueue-then-exit")
            .env("ARKHE_TEST_SCHEMA", child_schema)
            .output()
            .unwrap()
    })
    .await
    .unwrap();
    assert_eq!(
        output.status.code(),
        Some(73),
        "helper did not reach the crash point: {}",
        String::from_utf8_lossy(&output.stderr)
    );
    let (pending,): (i64,) =
        sqlx::query_as("SELECT count(*) FROM ask_verified_outbox WHERE published_at IS NULL")
            .fetch_one(journal.pool())
            .await
            .unwrap();
    let (context,): (serde_json::Value,) =
        sqlx::query_as("SELECT trace_context FROM ask_verified_outbox")
            .fetch_one(journal.pool())
            .await
            .unwrap();
    let parent = context["traceparent"]
        .as_str()
        .unwrap()
        .split('-')
        .nth(2)
        .unwrap()
        .to_string();
    assert!(context["traceparent"].as_str().unwrap().contains(TRACE));
    assert_eq!(pending, 1);
    let (pool, old_graph) = (journal.pool().clone(), journal.graph.clone());
    drop(journal);
    drop(old_graph);
    let (provider, exporter) = tracing_setup();
    let recovered = PgProofJournal::connect(pool).await.unwrap();
    let bus = KafkaBus::connect(
        std::env::var("KAFKA_BROKERS")
            .unwrap()
            .split(',')
            .map(str::to_string)
            .collect(),
        std::env::var("KAFKA_CRASH_TEST_TOPIC").expect("fresh crash topic"),
    )
    .await
    .unwrap();
    let before = bus
        .partition
        .get_offset(rskafka::client::partition::OffsetAt::Latest)
        .await
        .unwrap();
    assert_eq!(before, 0, "topic must be empty before recovery");
    assert!(recovered.relay_once(&bus).await.unwrap());
    assert_eq!(recovered.consume_once(&bus).await.unwrap(), 1);
    let (anchors,): (i64,) = sqlx::query_as("SELECT count(*) FROM ask_proof_anchors")
        .fetch_one(recovered.pool())
        .await
        .unwrap();
    assert_eq!(anchors, 1);
    let (records, _) = bus
        .partition
        .fetch_records(0, 1..1_048_576, 100)
        .await
        .unwrap();
    assert_eq!(records.len(), 1);
    let header = String::from_utf8(records[0].record.headers["traceparent"].clone()).unwrap();
    assert!(header.contains(TRACE));
    provider.force_flush().unwrap();
    let spans = exporter.get_finished_spans().unwrap();
    let find = |name: &str| {
        spans
            .iter()
            .find(|s| s.name == name && s.span_context.trace_id().to_string() == TRACE)
            .unwrap()
    };
    let publish = find("arkhe.ask.proof.publish");
    let consume = find("arkhe.ask.proof.consume");
    let anchor = find("arkhe.ask.proof.anchor");
    assert_eq!(publish.parent_span_id.to_string(), parent);
    assert_eq!(consume.parent_span_id, publish.span_context.span_id());
    assert_eq!(anchor.parent_span_id, consume.span_context.span_id());
    let tree: Vec<_> = [publish, consume, anchor]
        .iter()
        .map(|s| {
            serde_json::json!({
                "name":s.name,"span_id":s.span_context.span_id().to_string(),
                "parent_span_id":s.parent_span_id.to_string()
            })
        })
        .collect();
    let evidence = serde_json::json!({
        "scenario":"helper process exits after committed HTTP enqueue and before any publish",
        "child_exit_code":73,"rust_destructors_and_sdk_shutdown_bypassed":true,
        "pending_after_child_exit":pending,"kafka_records_before_recovery":before,
        "kafka_records_after_recovery":records.len(),"durable_anchors_after_recovery":anchors,
        "trace_id":TRACE,"persisted_enqueue_span_id":parent,"kafka_traceparent":header,
        "recovered_span_tree":tree,
        "limits":"process termination with database and broker kept running; not broker outage, power failure or guaranteed export of pre-crash spans"
    });
    if let Ok(path) = std::env::var("ARKHE_CRASH_EVIDENCE_PATH") {
        std::fs::write(path, serde_json::to_vec_pretty(&evidence).unwrap()).unwrap();
    }
    support::cleanup(&recovered, admin, schema).await;
    provider.shutdown().unwrap();
    eprintln!("Process crash recovery verified: {evidence}");
}
