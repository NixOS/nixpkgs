//! AKG-ASK-0001 e2e — the real router over the real pipeline, with trait
//! doubles at the two external frontiers (store, LLM) and the real
//! `CitationVerifier` in between.
//!
//! The two tests that matter for the portfolio story:
//! - a grounded answer passes with a citation proof;
//! - a hallucinating LLM is REFUSED with 422 and returns nothing.

use arkhe_ask::pipeline::{GeneratedAnswer, LlmProvider, StoredChunk};
use arkhe_ask::providers::{EchoProvider, InMemoryStore};
use arkhe_ask::router;
use arkhe_rag::ncm_harness::ClaimData;
use async_trait::async_trait;
use axum::body::Body;
use axum::http::{header, Request, StatusCode};
use axum::response::Response;
use http_body_util::BodyExt;
use tower::ServiceExt;

/// Always claims "Sydney is the capital of Australia" citing e1, whatever
/// the evidence actually says — the hallucination the verifier exists to
/// catch.
struct HallucinatingProvider;

#[async_trait]
impl LlmProvider for HallucinatingProvider {
    async fn answer(
        &self,
        _query: &str,
        _chunks: &[StoredChunk],
    ) -> Result<GeneratedAnswer, String> {
        Ok(GeneratedAnswer {
            answer: "Sydney is the capital of Australia.".into(),
            claims: vec![ClaimData {
                text: "Sydney is the capital of Australia".into(),
                evidence_id: "e1".into(),
            }],
        })
    }
}

async fn body_json(response: Response) -> serde_json::Value {
    let bytes = response
        .into_body()
        .collect()
        .await
        .expect("read body")
        .to_bytes();
    serde_json::from_slice(&bytes).expect("json body")
}

fn ask_request(query: &str, tenant: Option<&str>) -> Request<Body> {
    let mut builder = Request::post("/v1/ask").header(header::CONTENT_TYPE, "application/json");
    if let Some(tenant) = tenant {
        builder = builder.header("x-tenant-id", tenant);
    }
    builder
        .body(Body::from(serde_json::json!({"query": query}).to_string()))
        .unwrap()
}

fn store_with(chunk_text: &str) -> InMemoryStore {
    InMemoryStore {
        chunks: vec![StoredChunk {
            tenant_id: "demo-tenant".into(),
            id: "e1".into(),
            text: chunk_text.into(),
        }],
    }
}

#[tokio::test]
async fn grounded_answer_returns_with_citation_proof() {
    let app = router(
        Box::new(store_with("Sydney is the capital of Australia.")),
        Box::new(EchoProvider),
    );
    let response = app
        .oneshot(ask_request("capital of Australia", Some("demo-tenant")))
        .await
        .unwrap();
    assert_eq!(response.status(), StatusCode::OK);
    let body = body_json(response).await;
    assert_eq!(
        body["citation_proof"]["evidence_ids"],
        serde_json::json!(["e1"])
    );
    assert_eq!(
        body["citation_proof"]["record_digest"]
            .as_array()
            .map(|a| a.len()),
        Some(32)
    );
    assert_eq!(body["claims"][0]["evidence_id"], "e1");
}

#[tokio::test]
async fn hallucinated_entity_is_refused_with_nothing() {
    // Evidence says Melbourne; the LLM claims Sydney citing it.
    let app = router(
        Box::new(store_with("Melbourne is the capital of Australia.")),
        Box::new(HallucinatingProvider),
    );
    let response = app
        .oneshot(ask_request("capital of Australia", Some("demo-tenant")))
        .await
        .unwrap();
    assert_eq!(response.status(), StatusCode::UNPROCESSABLE_ENTITY);
    let body = body_json(response).await;
    assert_eq!(body["error"], "unsupported_claim");
    assert_eq!(body["entity"], "Sydney");
    assert!(body.get("claims").is_none(), "no claims may be returned");
    assert!(body.get("answer").is_none(), "no answer may be returned");
}

#[tokio::test]
async fn missing_tenant_is_unauthorized() {
    let app = router(
        Box::new(store_with("Sydney is the capital of Australia.")),
        Box::new(EchoProvider),
    );
    let response = app
        .oneshot(ask_request("capital of Australia", None))
        .await
        .unwrap();
    assert_eq!(response.status(), StatusCode::UNAUTHORIZED);
}

#[tokio::test]
async fn empty_query_is_bad_request() {
    let app = router(
        Box::new(store_with("Sydney is the capital of Australia.")),
        Box::new(EchoProvider),
    );
    let response = app
        .oneshot(ask_request("   ", Some("demo-tenant")))
        .await
        .unwrap();
    assert_eq!(response.status(), StatusCode::BAD_REQUEST);
}

#[tokio::test]
async fn pipeline_refuses_a_store_that_returns_another_tenants_chunk() {
    struct LeakingStore;
    #[async_trait]
    impl arkhe_ask::pipeline::ChunkStore for LeakingStore {
        async fn retrieve(&self, _: &str, _: &str, _: usize) -> Result<Vec<StoredChunk>, String> {
            Ok(vec![StoredChunk {
                tenant_id: "other".into(),
                id: "secret".into(),
                text: "Secret evidence.".into(),
            }])
        }
    }
    let result = arkhe_ask::pipeline::AskPipeline::new(LeakingStore, EchoProvider)
        .ask("demo-tenant", "evidence")
        .await;
    assert!(matches!(
        result,
        Err(arkhe_ask::pipeline::AskError::Store(_))
    ));
}

#[tokio::test]
async fn tenant_scoping_changes_proof_digest_even_for_identical_claims() {
    let pipeline = arkhe_ask::pipeline::AskPipeline::new(
        InMemoryStore {
            chunks: ["tenant-a", "tenant-b"]
                .into_iter()
                .map(|tenant| StoredChunk {
                    tenant_id: tenant.into(),
                    id: "e1".into(),
                    text: "Melbourne is in Victoria.".into(),
                })
                .collect(),
        },
        EchoProvider,
    );
    let a = pipeline.ask("tenant-a", "evidence").await.unwrap();
    let b = pipeline.ask("tenant-b", "evidence").await.unwrap();
    assert_eq!(a.citation_proof.tenant_id, "tenant-a");
    assert_eq!(b.citation_proof.tenant_id, "tenant-b");
    assert_ne!(
        a.citation_proof.record_digest,
        b.citation_proof.record_digest
    );
}
