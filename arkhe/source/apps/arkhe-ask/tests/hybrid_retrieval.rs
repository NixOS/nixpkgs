use arkhe_ask::pipeline::{AskResponse, ChunkStore, StoredChunk};
use arkhe_ask::providers::{invariant::InvariantRetriever, EchoProvider};
use async_trait::async_trait;
use axum::{
    body::Body,
    http::{Request, StatusCode},
};
use http_body_util::BodyExt;
use tower::ServiceExt;
mod support;

fn chunk(tenant: &str, id: &str, text: &str) -> StoredChunk {
    StoredChunk {
        tenant_id: tenant.into(),
        id: id.into(),
        text: text.into(),
    }
}
fn corpus() -> Vec<StoredChunk> {
    vec![
        chunk("a", "pay", "Pagamentos exigem aprovação humana."),
        chunk("a", "logs", "Logs preservam evidências de execução."),
        chunk("b", "pay", "Pagamentos secretos do outro tenant."),
    ]
}
struct Dense(Result<Vec<StoredChunk>, String>);
#[async_trait]
impl ChunkStore for Dense {
    async fn retrieve(&self, _: &str, _: &str, _: usize) -> Result<Vec<StoredChunk>, String> {
        self.0.clone()
    }
}
fn store(dense: Result<Vec<StoredChunk>, String>) -> InvariantRetriever<Dense> {
    InvariantRetriever::new(Dense(dense), corpus(), 1.2, 0.75, 60, 32).unwrap()
}

#[tokio::test]
async fn question_through_http_hybrid_reranking_citations_and_inclusion() {
    // Dense deliberately ranks the irrelevant invariant first.
    let snapshot = corpus();
    let retriever = store(Ok(vec![snapshot[1].clone(), snapshot[0].clone()]));
    let root = retriever.snapshot_root("a").unwrap();
    let app = arkhe_ask::router(Box::new(retriever), Box::new(EchoProvider));
    let response = app
        .oneshot(
            Request::post("/v1/ask")
                .header("content-type", "application/json")
                .header("x-tenant-id", "a")
                .body(Body::from(
                    r#"{"query":"Pagamentos exigem aprovação humana?"}"#,
                ))
                .unwrap(),
        )
        .await
        .unwrap();
    assert_eq!(response.status(), StatusCode::OK);
    let bytes = response.into_body().collect().await.unwrap().to_bytes();
    let answer: AskResponse = serde_json::from_slice(&bytes).unwrap();
    assert_eq!(answer.answer, snapshot[0].text);
    assert_eq!(answer.citation_proof.evidence_ids, ["pay"]);
    assert_eq!(answer.chunk_evidence.len(), 1);
    let proof = &answer.chunk_evidence[0];
    assert!(proof.verify("a", &root));
    assert!(!proof.verify("b", &root));
    assert!(!proof.verify("a", &[0; 32]));
    let mut tampered = proof.clone();
    tampered.text.push('!');
    assert!(!tampered.verify("a", &root));
    let mut tampered = proof.clone();
    tampered.id = "logs".into();
    assert!(!tampered.verify("a", &root));
    let mut tampered = proof.clone();
    tampered.inclusion_proof.leaf_index = 99;
    assert!(!tampered.verify("a", &root));
    let mut tampered = proof.clone();
    tampered.inclusion_proof.leaf_count = 0;
    assert!(!tampered.verify("a", &root));
    let mut tampered = proof.clone();
    tampered.inclusion_proof.steps[0].hash[0] ^= 1;
    assert!(!tampered.verify("a", &root));
}

#[tokio::test]
async fn dense_outage_is_lexical_fallback_but_forged_evidence_is_rejected() {
    let batch = store(Err("offline".into()))
        .retrieve_evidenced("a", "aprovação", 4)
        .await
        .unwrap();
    assert_eq!(batch.chunks[0].id, "pay");
    assert_eq!(batch.evidence.len(), 1);
    for forged in [
        chunk("b", "pay", "Pagamentos secretos do outro tenant."),
        chunk("a", "pay", "conteúdo divergente"),
        chunk("a", "unknown", "aprovação"),
    ] {
        assert!(store(Ok(vec![forged]))
            .retrieve("a", "aprovação", 4)
            .await
            .is_err());
    }
    assert!(store(Err("offline".into()))
        .retrieve("unknown", "aprovação", 4)
        .await
        .unwrap()
        .is_empty());
    assert!(store(Err("offline".into()))
        .retrieve("", "aprovação", 4)
        .await
        .is_err());
    assert!(store(Err("offline".into()))
        .retrieve("a", "aprovação", 0)
        .await
        .unwrap()
        .is_empty());
}

#[test]
fn snapshot_identity_is_order_independent_and_tenant_bound() {
    let first = store(Err("offline".into()));
    let mut reversed = corpus();
    reversed.reverse();
    let second =
        InvariantRetriever::new(Dense(Err("offline".into())), reversed, 1.2, 0.75, 60, 32).unwrap();
    assert_eq!(first.snapshot_root("a"), second.snapshot_root("a"));
    assert_ne!(first.snapshot_root("a"), first.snapshot_root("b"));
    let duplicate = vec![corpus()[0].clone(), corpus()[0].clone()];
    assert!(InvariantRetriever::new(Dense(Ok(vec![])), duplicate, 1.2, 0.75, 60, 32).is_err());
}

#[tokio::test]
#[ignore = "requires live pgvector PostgreSQL via DATABASE_URL; uses an isolated temporary schema"]
async fn pgvector_hybrid_question_returns_verified_snapshot_evidence() {
    use arkhe_ask::pipeline::{AskPipeline, Embedder};
    use arkhe_ask::providers::pgvector::PgVectorStore;
    use std::sync::Arc;
    struct FixtureEmbedder;
    #[async_trait]
    impl Embedder for FixtureEmbedder {
        async fn embed(&self, text: &str) -> Result<Vec<f32>, String> {
            let mut vector = vec![0.0; 1536];
            vector[0] = 1.0;
            // Deliberately wrong dense ranking for the question.
            if text.starts_with("Pagamentos exigem") {
                vector[1] = 1.0;
            }
            Ok(vector)
        }
    }
    let (journal, admin, schema) = support::fixture().await;
    let dense = PgVectorStore::new(journal.pool().clone(), Arc::new(FixtureEmbedder));
    dense.migrate().await.unwrap();
    for entry in corpus() {
        dense
            .insert(&entry.tenant_id, &entry.id, &entry.text)
            .await
            .unwrap();
    }
    let query = "Quem deve aprovar pagamentos? aprovação humana";
    assert_eq!(dense.retrieve("a", query, 2).await.unwrap()[0].id, "logs");
    let retriever = InvariantRetriever::new(dense, corpus(), 1.2, 0.75, 60, 32).unwrap();
    let root = retriever.snapshot_root("a").unwrap();
    let response = AskPipeline::new(retriever, EchoProvider)
        .ask("a", query)
        .await
        .unwrap();
    assert_eq!(response.citation_proof.evidence_ids, ["pay"]);
    assert!(response.chunk_evidence[0].verify("a", &root));
    support::cleanup(&journal, admin, schema).await;
}

#[tokio::test]
async fn pipeline_rejects_tampered_inclusion_before_generation() {
    use arkhe_ask::pipeline::{AskPipeline, GeneratedAnswer, LlmProvider, RetrievalBatch};
    struct Corrupt;
    #[async_trait]
    impl ChunkStore for Corrupt {
        async fn retrieve(&self, _: &str, _: &str, _: usize) -> Result<Vec<StoredChunk>, String> {
            unreachable!()
        }
        async fn retrieve_evidenced(
            &self,
            tenant: &str,
            query: &str,
            k: usize,
        ) -> Result<RetrievalBatch, String> {
            let mut batch = store(Err("offline".into()))
                .retrieve_evidenced(tenant, query, k)
                .await?;
            batch.evidence[0].inclusion_proof.root[0] ^= 1;
            Ok(batch)
        }
    }
    struct NeverGenerate;
    #[async_trait]
    impl LlmProvider for NeverGenerate {
        async fn answer(&self, _: &str, _: &[StoredChunk]) -> Result<GeneratedAnswer, String> {
            panic!("invalid evidence reached generator")
        }
    }
    assert!(AskPipeline::new(Corrupt, NeverGenerate)
        .ask("a", "aprovação")
        .await
        .is_err());
}
