//! Azure OpenAI provider — plain reqwest, no SDK.
//!
//! The Rust Azure OpenAI SDKs are early versions (`azure-openai-rs 0.1.0`);
//! the trait is the frontier, so the implementation talks HTTP directly and
//! stays replaceable. Conventions: `api-key` header (not Bearer), URL
//! `{endpoint}/openai/deployments/{deployment}/{path}?api-version={version}`.
//!
//! `answer` asks for a JSON object (`response_format: json_object`,
//! temperature 0) and refuses to return a `GeneratedAnswer` with zero
//! claims — an unverifiable answer is not returned.

use crate::pipeline::{GeneratedAnswer, LlmProvider, StoredChunk};
use arkhe_rag::ncm_harness::ClaimData;
use async_trait::async_trait;
use reqwest::Client;
use serde::{Deserialize, Serialize};
use std::time::Duration;

#[derive(Clone)]
pub struct AzureOpenAiProvider {
    client: Client,
    endpoint: String,
    deployment: String,
    embedding_deployment: String,
    api_version: String,
    api_key: String,
}

#[derive(Serialize)]
struct ChatRequest<'a> {
    messages: Vec<Message<'a>>,
    temperature: f32,
    max_tokens: u32,
    response_format: ResponseFormat,
}

#[derive(Serialize)]
struct ResponseFormat {
    #[serde(rename = "type")]
    kind: &'static str,
}

#[derive(Serialize)]
struct Message<'a> {
    role: &'a str,
    content: String,
}

#[derive(Deserialize)]
struct ChatResponse {
    choices: Vec<Choice>,
}

#[derive(Deserialize)]
struct Choice {
    message: ResponseMessage,
}

#[derive(Deserialize)]
struct ResponseMessage {
    content: String,
}

#[derive(Serialize)]
struct EmbeddingRequest<'a> {
    input: &'a str,
    dimensions: u32,
}

#[derive(Deserialize)]
struct EmbeddingResponse {
    data: Vec<EmbeddingData>,
}

#[derive(Deserialize)]
struct EmbeddingData {
    embedding: Vec<f32>,
}

#[derive(Deserialize)]
struct AnswerJson {
    answer: String,
    claims: Vec<ClaimData>,
}

impl AzureOpenAiProvider {
    /// Test/tooling constructor with explicit configuration.
    pub fn new(
        endpoint: &str,
        deployment: &str,
        api_version: &str,
        api_key: &str,
    ) -> Result<Self, String> {
        Ok(Self {
            client: Client::builder()
                .timeout(Duration::from_secs(30))
                .build()
                .map_err(|e| format!("http client: {e}"))?,
            endpoint: endpoint.trim_end_matches('/').to_string(),
            deployment: deployment.into(),
            embedding_deployment: deployment.into(),
            api_version: api_version.into(),
            api_key: api_key.into(),
        })
    }

    /// From AZURE_OPENAI_ENDPOINT / _DEPLOYMENT / _API_VERSION (default
    /// 2024-10-21) / _API_KEY.
    pub fn from_env() -> Result<Self, String> {
        let missing = |var: &str| format!("{var} not set or empty");
        let required = |var: &str| {
            std::env::var(var)
                .ok()
                .filter(|v| !v.trim().is_empty())
                .ok_or_else(|| missing(var))
        };
        let endpoint = required("AZURE_OPENAI_ENDPOINT")?;
        let deployment = required("AZURE_OPENAI_DEPLOYMENT")?;
        let api_key = required("AZURE_OPENAI_API_KEY")?;
        let api_version =
            std::env::var("AZURE_OPENAI_API_VERSION").unwrap_or_else(|_| "2024-10-21".into());
        let embedding_deployment = required("AZURE_OPENAI_EMBEDDING_DEPLOYMENT")?;
        Ok(Self::new(&endpoint, &deployment, &api_version, &api_key)?
            .with_embedding_deployment(&embedding_deployment))
    }

    /// Select a separate embedding model deployment.
    pub fn with_embedding_deployment(mut self, deployment: &str) -> Self {
        self.embedding_deployment = deployment.into();
        self
    }

    fn url(&self, path: &str) -> String {
        let deployment = if path == "embeddings" {
            &self.embedding_deployment
        } else {
            &self.deployment
        };
        format!(
            "{}/openai/deployments/{}/{}?api-version={}",
            self.endpoint, deployment, path, self.api_version
        )
    }

    async fn post_json<T: for<'de> Deserialize<'de>>(
        &self,
        url: &str,
        body: &impl Serialize,
    ) -> Result<T, String> {
        let resp = self
            .client
            .post(url)
            .header("api-key", &self.api_key)
            .json(body)
            .send()
            .await
            .map_err(|e| format!("transport: {e}"))?;
        let status = resp.status();
        if !status.is_success() {
            return Err(format!("upstream status {status}"));
        }
        resp.json().await.map_err(|e| format!("parse: {e}"))
    }
}

#[async_trait]
impl LlmProvider for AzureOpenAiProvider {
    async fn answer(&self, query: &str, chunks: &[StoredChunk]) -> Result<GeneratedAnswer, String> {
        let context = chunks
            .iter()
            .map(|c| format!("[{}] {}", c.id, c.text))
            .collect::<Vec<_>>()
            .join("\n");
        let system = "Answer ONLY with a JSON object {\"answer\": string, \"claims\": \
                      [{\"text\": string, \"evidence_id\": string}]}. Every claim must cite one of \
                      the provided chunk ids. Use only facts present in the context.";
        let user = format!("Context:\n{context}\n\nQuestion: {query}");
        let body = ChatRequest {
            messages: vec![
                Message {
                    role: "system",
                    content: system.into(),
                },
                Message {
                    role: "user",
                    content: user,
                },
            ],
            temperature: 0.0,
            max_tokens: 512,
            response_format: ResponseFormat {
                kind: "json_object",
            },
        };
        let parsed: ChatResponse = self.post_json(&self.url("chat/completions"), &body).await?;
        let content = parsed
            .choices
            .into_iter()
            .next()
            .ok_or("no choices")?
            .message
            .content;
        let answer: AnswerJson =
            serde_json::from_str(&content).map_err(|e| format!("answer json: {e}"))?;
        if answer.claims.is_empty() {
            return Err("model returned no claims; refusing unverifiable answer".into());
        }
        Ok(GeneratedAnswer {
            answer: answer.answer,
            claims: answer.claims,
        })
    }
}

#[async_trait]
impl crate::pipeline::Embedder for AzureOpenAiProvider {
    async fn embed(&self, text: &str) -> Result<Vec<f32>, String> {
        let parsed: EmbeddingResponse = self
            .post_json(
                &self.url("embeddings"),
                &EmbeddingRequest {
                    input: text,
                    dimensions: 1536,
                },
            )
            .await?;
        let embedding = parsed
            .data
            .into_iter()
            .next()
            .map(|d| d.embedding)
            .ok_or_else(|| "no embedding".to_string())?;
        if embedding.len() != 1536 {
            return Err(format!(
                "embedding dimension: expected 1536, got {}",
                embedding.len()
            ));
        }
        if embedding.iter().any(|v| !v.is_finite()) {
            return Err("embedding contains non-finite values".into());
        }
        Ok(embedding)
    }
}
