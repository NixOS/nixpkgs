mod support;
use arkhe_ask::{
    events::{EventPublisher, KafkaBus, PgProofJournal, ProofJournal, VerifiedEvent},
    pipeline::{CitationProof, GeneratedAnswer, LlmProvider, StoredChunk},
    providers::{EchoProvider, InMemoryStore},
    router_with_journal,
};
use arkhe_core::{evidence::EvidenceReader, Digest32};
use arkhe_rag::ncm_harness::ClaimData;
use async_trait::async_trait;
use axum::{
    body::Body,
    http::{Request, StatusCode},
};
use http_body_util::BodyExt;
use std::sync::{
    atomic::{AtomicUsize, Ordering},
    Arc,
};
use support::{cleanup, fixture};
use tower::ServiceExt;

struct Spy {
    calls: AtomicUsize,
    fail: bool,
}
#[async_trait]
impl ProofJournal for Spy {
    async fn record(&self, _: &CitationProof) -> Result<(), String> {
        self.calls.fetch_add(1, Ordering::SeqCst);
        if self.fail {
            Err("unavailable".into())
        } else {
            Ok(())
        }
    }
}
struct Hallucinating;
#[async_trait]
impl LlmProvider for Hallucinating {
    async fn answer(&self, _: &str, _: &[StoredChunk]) -> Result<GeneratedAnswer, String> {
        Ok(GeneratedAnswer {
            answer: "Sydney".into(),
            claims: vec![ClaimData {
                text: "Sydney is in Victoria.".into(),
                evidence_id: "e1".into(),
            }],
        })
    }
}
fn corpus() -> Box<InMemoryStore> {
    Box::new(InMemoryStore {
        chunks: vec![StoredChunk {
            tenant_id: "tenant-a".into(),
            id: "e1".into(),
            text: "Melbourne is in Victoria.".into(),
        }],
    })
}
fn request() -> Request<Body> {
    Request::post("/v1/ask")
        .header("content-type", "application/json")
        .header("x-tenant-id", "tenant-a")
        .body(Body::from(r#"{"query":"evidence"}"#))
        .unwrap()
}
#[tokio::test]
async fn only_verified_responses_are_journaled_and_storage_failure_withholds_answer() {
    let spy = Arc::new(Spy {
        calls: AtomicUsize::new(0),
        fail: false,
    });
    let refused = router_with_journal(corpus(), Box::new(Hallucinating), None, spy.clone())
        .oneshot(request())
        .await
        .unwrap();
    assert_eq!(refused.status(), StatusCode::UNPROCESSABLE_ENTITY);
    assert_eq!(spy.calls.load(Ordering::SeqCst), 0);
    let accepted = router_with_journal(corpus(), Box::new(EchoProvider), None, spy.clone())
        .oneshot(request())
        .await
        .unwrap();
    assert_eq!(accepted.status(), StatusCode::OK);
    assert_eq!(spy.calls.load(Ordering::SeqCst), 1);
    let failing = Arc::new(Spy {
        calls: AtomicUsize::new(0),
        fail: true,
    });
    let response = router_with_journal(corpus(), Box::new(EchoProvider), None, failing)
        .oneshot(request())
        .await
        .unwrap();
    assert_eq!(response.status(), StatusCode::SERVICE_UNAVAILABLE);
    let bytes = response.into_body().collect().await.unwrap().to_bytes();
    let body: serde_json::Value = serde_json::from_slice(&bytes).unwrap();
    assert_eq!(
        body,
        serde_json::json!({"error":"proof_journal_unavailable"})
    );
}

fn event() -> VerifiedEvent {
    VerifiedEvent::new(CitationProof {
        tenant_id: "tenant-a".into(),
        evidence_ids: vec!["e1".into()],
        record_digest: Digest32::blake3(b"test", b"verified"),
    })
}
struct Offline;
#[async_trait]
impl EventPublisher for Offline {
    async fn publish(&self, _: &VerifiedEvent) -> Result<(), String> {
        Err("offline".into())
    }
}

#[tokio::test]
#[ignore = "requires Postgres"]
async fn outbox_survives_publication_failure_and_detects_event_id_conflicts() {
    let (journal, admin, schema) = fixture().await;
    let event = event();
    journal.enqueue(&event).await.unwrap();
    journal.enqueue(&event).await.unwrap();
    assert!(journal.relay_once(&Offline).await.is_err());
    let (pending,): (i64,) =
        sqlx::query_as("SELECT count(*) FROM ask_verified_outbox WHERE published_at IS NULL")
            .fetch_one(journal.pool())
            .await
            .unwrap();
    let mut conflicting = event.clone();
    conflicting.proof.tenant_id = "tenant-b".into();
    let collision = journal.enqueue(&conflicting).await;
    cleanup(&journal, admin, schema).await;
    assert_eq!(pending, 1);
    assert!(collision.is_err());
}

#[tokio::test]
#[ignore = "requires Postgres and a provisioned single-partition Kafka topic in KAFKA_TEST_TOPIC"]
async fn kafka_replays_lost_ack_once_and_rehydrates_wormgraph() {
    let (journal, admin, schema) = fixture().await;
    let journal = Arc::new(journal);
    let topic = std::env::var("KAFKA_TEST_TOPIC").expect("dedicated empty test topic");
    let bus = KafkaBus::connect(
        std::env::var("KAFKA_BROKERS")
            .expect("KAFKA_BROKERS")
            .split(',')
            .map(str::to_string)
            .collect(),
        topic.clone(),
    )
    .await
    .unwrap();
    let initial = bus
        .partition
        .get_offset(rskafka::client::partition::OffsetAt::Latest)
        .await
        .unwrap();
    assert_eq!(initial, 0, "test topic must be fresh");
    // HTTP must enqueue an accepted proof and never enqueue a rejected answer.
    let response = router_with_journal(corpus(), Box::new(EchoProvider), None, journal.clone())
        .oneshot(request())
        .await
        .unwrap();
    assert_eq!(response.status(), StatusCode::OK);
    let refused = router_with_journal(corpus(), Box::new(Hallucinating), None, journal.clone())
        .oneshot(request())
        .await
        .unwrap();
    assert_eq!(refused.status(), StatusCode::UNPROCESSABLE_ENTITY);
    let (payload,): (serde_json::Value,) =
        sqlx::query_as("SELECT payload FROM ask_verified_outbox")
            .fetch_one(journal.pool())
            .await
            .unwrap();
    let event: VerifiedEvent = serde_json::from_value(payload).unwrap();
    struct LostAck<'a>(&'a KafkaBus);
    #[async_trait]
    impl EventPublisher for LostAck<'_> {
        async fn publish(&self, event: &VerifiedEvent) -> Result<(), String> {
            self.0.publish(event).await?;
            Err("simulated crash after broker ACK before database commit".into())
        }
    }
    assert!(journal.relay_once(&LostAck(&bus)).await.is_err());
    // SQLx rolls a dropped transaction back asynchronously. SKIP LOCKED may
    // transiently find no row, just as it can with another active relay.
    let mut published = false;
    for _ in 0..100 {
        if journal.relay_once(&bus).await.unwrap() {
            published = true;
            break;
        }
        tokio::time::sleep(std::time::Duration::from_millis(10)).await;
    }
    assert!(published, "pending event was not retried after rollback");
    assert!(!journal.relay_once(&bus).await.unwrap());
    let mut consumed = 0;
    for _ in 0..20 {
        consumed += journal.consume_once(&bus).await.unwrap();
        if consumed >= 2 {
            break;
        }
    }
    assert_eq!(consumed, 2);
    let (count,): (i64,) = sqlx::query_as("SELECT count(*) FROM ask_proof_anchors")
        .fetch_one(journal.pool())
        .await
        .unwrap();
    let envelope = event.envelope().unwrap();
    assert_eq!(
        journal.graph.get(envelope.record_hash).await.unwrap(),
        Some(envelope.clone())
    );
    let restored = PgProofJournal::connect(journal.pool().clone())
        .await
        .unwrap();
    assert_eq!(
        restored.graph.get(envelope.record_hash).await.unwrap(),
        Some(envelope)
    );
    assert_eq!(restored.consume_once(&bus).await.unwrap(), 0);
    // A broker writer cannot manufacture admitted proof events. Cursor must stop.
    let forged = VerifiedEvent::new(event.proof.clone());
    bus.publish(&forged).await.unwrap();
    assert!(restored.consume_once(&bus).await.is_err());
    let (offset,): (i64,) =
        sqlx::query_as("SELECT next_offset FROM ask_kafka_cursors WHERE topic=$1")
            .bind(&topic)
            .fetch_one(journal.pool())
            .await
            .unwrap();
    cleanup(&journal, admin, schema).await;
    assert_eq!(count, 1);
    assert_eq!(offset, 2);
    eprintln!("HTTP verified=1 refused=1; Kafka records=2; durable anchors=1; restart rehydrated; forged event blocked at offset=2");
}

#[tokio::test]
#[ignore = "requires Postgres and a fresh KAFKA_TRACE_TEST_TOPIC"]
async fn durable_trace_context_survives_journal_restart_and_kafka() {
    use opentelemetry::{global, trace::TracerProvider};
    use opentelemetry_sdk::{
        propagation::TraceContextPropagator,
        trace::{InMemorySpanExporter, SdkTracerProvider},
    };
    use tracing::instrument::WithSubscriber;
    use tracing_subscriber::layer::SubscriberExt;
    global::set_text_map_propagator(TraceContextPropagator::new());
    let exporter = InMemorySpanExporter::default();
    let provider = SdkTracerProvider::builder()
        .with_simple_exporter(exporter.clone())
        .build();
    let dispatch =
        tracing::Dispatch::new(tracing_subscriber::registry().with(
            tracing_opentelemetry::layer().with_tracer(provider.tracer("durable-trace-test")),
        ));
    // Mirror the binary's process-wide subscriber. The other integration
    // tests run concurrently and also create these same tracing callsites.
    tracing::dispatcher::set_global_default(dispatch.clone()).unwrap();
    let (journal, admin, schema) = fixture().await;
    let journal = Arc::new(journal);
    let mut req = request();
    req.headers_mut().insert(
        "traceparent",
        "00-abcdef0123456789abcdef0123456789-0123456789abcdef-01"
            .parse()
            .unwrap(),
    );
    let response = router_with_journal(corpus(), Box::new(EchoProvider), None, journal.clone())
        .oneshot(req)
        .with_subscriber(dispatch.clone())
        .await
        .unwrap();
    assert_eq!(response.status(), StatusCode::OK);
    response.into_body().collect().await.unwrap();
    let (context,): (serde_json::Value,) =
        sqlx::query_as("SELECT trace_context FROM ask_verified_outbox")
            .fetch_one(journal.pool())
            .await
            .unwrap();
    assert!(
        context["traceparent"]
            .as_str()
            .is_some_and(|v| v.contains("abcdef0123456789abcdef0123456789")),
        "missing durable context: {context}; spans={:?}",
        exporter.get_finished_spans().unwrap()
    );
    let pool = journal.pool().clone();
    drop(journal);
    let restored = PgProofJournal::connect(pool).await.unwrap();
    let bus = KafkaBus::connect(
        std::env::var("KAFKA_BROKERS")
            .unwrap()
            .split(',')
            .map(str::to_string)
            .collect(),
        std::env::var("KAFKA_TRACE_TEST_TOPIC").expect("fresh trace topic"),
    )
    .await
    .unwrap();
    assert_eq!(
        bus.partition
            .get_offset(rskafka::client::partition::OffsetAt::Latest)
            .await
            .unwrap(),
        0
    );
    assert!(restored
        .relay_once(&bus)
        .with_subscriber(dispatch.clone())
        .await
        .unwrap());
    let (records, _) = bus
        .partition
        .fetch_records(0, 1..1_048_576, 100)
        .await
        .unwrap();
    assert_eq!(records.len(), 1);
    assert!(
        String::from_utf8(records[0].record.headers["traceparent"].clone())
            .unwrap()
            .contains("abcdef0123456789abcdef0123456789")
    );
    assert_eq!(
        restored
            .consume_once(&bus)
            .with_subscriber(dispatch)
            .await
            .unwrap(),
        1
    );
    provider.force_flush().unwrap();
    let spans = exporter.get_finished_spans().unwrap();
    let tree: Vec<_> = spans
        .iter()
        .filter(|s| s.span_context.trace_id().to_string() == "abcdef0123456789abcdef0123456789")
        .collect();
    let find = |name: &str| tree.iter().find(|s| s.name == name).unwrap();
    let root = find("POST /v1/ask");
    let enqueue = find("arkhe.ask.proof.enqueue");
    for name in [
        "arkhe.ask.rag.retrieve",
        "arkhe.ask.rag.generate",
        "arkhe.ask.rag.verify",
        "arkhe.ask.proof.enqueue",
    ] {
        assert_eq!(
            find(name).parent_span_id,
            root.span_context.span_id(),
            "incorrect sibling {name}"
        );
    }
    let publish = find("arkhe.ask.proof.publish");
    let consume = find("arkhe.ask.proof.consume");
    let anchor = find("arkhe.ask.proof.anchor");
    assert_eq!(publish.parent_span_id, enqueue.span_context.span_id());
    assert_eq!(consume.parent_span_id, publish.span_context.span_id());
    assert_eq!(anchor.parent_span_id, consume.span_context.span_id());
    let tree_json:Vec<_>=tree.iter().map(|s|serde_json::json!({
        "name":s.name,"span_id":s.span_context.span_id().to_string(),"parent_span_id":s.parent_span_id.to_string()
    })).collect();
    cleanup(&restored, admin, schema).await;
    provider.shutdown().unwrap();
    eprintln!(
        "Durable W3C trace tree after journal restart: {}",
        serde_json::to_string(&tree_json).unwrap()
    );
}
