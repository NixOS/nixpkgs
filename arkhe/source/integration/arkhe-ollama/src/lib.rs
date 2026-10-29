//! Local inference provider. Its output is untrusted data, never authorization.
use reqwest::{Client, Url};
use serde::{Deserialize, Serialize};
use serde_json::{json, Value};
use std::time::Duration;

#[derive(Debug, thiserror::Error)]
pub enum Error {
    #[error("Ollama configuration: {0}")]
    Configuration(String),
    #[error("Ollama is unavailable or request timed out")]
    Unavailable,
    #[error("Ollama HTTP {0}")]
    Http(u16),
    #[error("Ollama response rejected: {0}")]
    InvalidResponse(String),
    #[error("configured model is missing or its digest changed")]
    ModelMismatch,
}
#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Config {
    pub base_url: String,
    pub model: String,
    pub model_digest: String,
    pub timeout_seconds: u64,
    pub context_tokens: u32,
    pub max_output_tokens: u32,
}
impl Config {
    pub fn load(path: impl AsRef<std::path::Path>) -> Result<Self, Error> {
        let text =
            std::fs::read_to_string(path).map_err(|e| Error::Configuration(e.to_string()))?;
        serde_json::from_str(&text).map_err(|e| Error::Configuration(e.to_string()))
    }
}
#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Completion {
    pub model: String,
    pub model_digest: String,
    pub content: String,
    pub eval_count: Option<u64>,
    pub total_duration: Option<u64>,
}
#[derive(Debug, Serialize)]
pub struct Status {
    pub base_url: String,
    pub version: String,
    pub model: String,
    pub model_digest: String,
}
pub struct OllamaClient {
    client: Client,
    base: Url,
    config: Config,
}
impl OllamaClient {
    pub fn new(config: Config) -> Result<Self, Error> {
        let mut base = Url::parse(&config.base_url)
            .map_err(|_| Error::Configuration("invalid endpoint".into()))?;
        if !matches!(base.scheme(), "http" | "https")
            || !matches!(base.host_str(), Some("127.0.0.1" | "localhost" | "[::1]"))
            || base.path() != "/"
            || base.query().is_some()
            || base.fragment().is_some()
            || !base.username().is_empty()
            || base.password().is_some()
        {
            return Err(Error::Configuration(
                "a loopback HTTP(S) origin without credentials is required".into(),
            ));
        }
        if config.model.is_empty()
            || config.model.ends_with(":cloud")
            || config.model.ends_with("-cloud")
            || config.model_digest.len() != 64
            || !config.model_digest.bytes().all(|b| b.is_ascii_hexdigit())
            || !(1..=600).contains(&config.timeout_seconds)
            || !(512..=32768).contains(&config.context_tokens)
            || !(1..=8192).contains(&config.max_output_tokens)
        {
            return Err(Error::Configuration(
                "invalid model pin or generation bounds".into(),
            ));
        }
        base.set_path("/");
        let client = Client::builder()
            .connect_timeout(Duration::from_secs(5))
            .timeout(Duration::from_secs(config.timeout_seconds))
            .no_proxy()
            .redirect(reqwest::redirect::Policy::none())
            .retry(reqwest::retry::never())
            .build()
            .map_err(|_| Error::Configuration("HTTP client failed".into()))?;
        Ok(Self {
            client,
            base,
            config,
        })
    }
    pub fn config(&self) -> &Config {
        &self.config
    }
    fn endpoint(&self, path: &str) -> Result<Url, Error> {
        self.base
            .join(path)
            .map_err(|_| Error::Configuration("invalid API path".into()))
    }
    async fn body(&self, mut response: reqwest::Response) -> Result<Value, Error> {
        if !response.status().is_success() {
            return Err(Error::Http(response.status().as_u16()));
        }
        const MAX: usize = 1024 * 1024;
        if response.content_length().is_some_and(|n| n > MAX as u64) {
            return Err(Error::InvalidResponse("body exceeds 1 MiB".into()));
        }
        let mut bytes = Vec::new();
        while let Some(chunk) = response.chunk().await.map_err(|_| Error::Unavailable)? {
            if bytes.len() + chunk.len() > MAX {
                return Err(Error::InvalidResponse("body exceeds 1 MiB".into()));
            }
            bytes.extend_from_slice(&chunk);
        }
        let value: Value = serde_json::from_slice(&bytes)
            .map_err(|_| Error::InvalidResponse("invalid JSON".into()))?;
        if value.get("error").is_some() {
            return Err(Error::InvalidResponse("provider returned an error".into()));
        }
        Ok(value)
    }
    async fn get(&self, path: &str) -> Result<Value, Error> {
        let response = self
            .client
            .get(self.endpoint(path)?)
            .send()
            .await
            .map_err(|_| Error::Unavailable)?;
        self.body(response).await
    }
    pub async fn validate_model(&self) -> Result<(), Error> {
        let tags = self.get("api/tags").await?;
        let models = tags
            .get("models")
            .and_then(Value::as_array)
            .ok_or_else(|| Error::InvalidResponse("missing model list".into()))?;
        let mut matching = models
            .iter()
            .filter(|m| m.get("name").and_then(Value::as_str) == Some(self.config.model.as_str()));
        let found = matching.next();
        if matching.next().is_some()
            || found.is_some_and(|m| {
                ["remote_host", "remote_model"]
                    .iter()
                    .any(|field| m.get(field).is_some_and(|v| !v.is_null()))
            })
        {
            return Err(Error::ModelMismatch);
        }
        if !found.is_some_and(|m| {
            m.get("digest").and_then(Value::as_str) == Some(self.config.model_digest.as_str())
        }) {
            return Err(Error::ModelMismatch);
        }
        Ok(())
    }
    pub async fn status(&self) -> Result<Status, Error> {
        let version = self
            .get("api/version")
            .await?
            .get("version")
            .and_then(Value::as_str)
            .ok_or_else(|| Error::InvalidResponse("missing version".into()))?
            .to_string();
        self.validate_model().await?;
        Ok(Status {
            base_url: self.config.base_url.clone(),
            version,
            model: self.config.model.clone(),
            model_digest: self.config.model_digest.clone(),
        })
    }
    pub async fn chat(
        &self,
        system: &str,
        user: &str,
        schema: Option<Value>,
    ) -> Result<Completion, Error> {
        if system.len() + user.len() > 32 * 1024 {
            return Err(Error::Configuration("prompt exceeds 32 KiB".into()));
        }
        self.validate_model().await?;
        let mut request = json!({"model":self.config.model,"stream":false,"think":false,"keep_alive":"5m","messages":[{"role":"system","content":system},{"role":"user","content":user}],"options":{"temperature":0,"num_ctx":self.config.context_tokens,"num_predict":self.config.max_output_tokens}});
        if let Some(schema) = schema {
            request["format"] = schema;
        }
        let response = self
            .client
            .post(self.endpoint("api/chat")?)
            .json(&request)
            .send()
            .await
            .map_err(|_| Error::Unavailable)?;
        let response = self.body(response).await?;
        if response.get("done").and_then(Value::as_bool) != Some(true)
            || response
                .get("done_reason")
                .and_then(Value::as_str)
                .is_some_and(|r| r != "stop")
            || response.get("model").and_then(Value::as_str) != Some(self.config.model.as_str())
        {
            return Err(Error::InvalidResponse(
                "incomplete, truncated, or unexpected model response".into(),
            ));
        }
        let message = response
            .get("message")
            .ok_or_else(|| Error::InvalidResponse("missing message".into()))?;
        if message.get("role").and_then(Value::as_str) != Some("assistant")
            || message
                .get("tool_calls")
                .is_some_and(|t| t.as_array().is_none_or(|a| !a.is_empty()))
        {
            return Err(Error::InvalidResponse("unexpected role/tool call".into()));
        }
        let content = message
            .get("content")
            .and_then(Value::as_str)
            .filter(|s| !s.trim().is_empty())
            .ok_or_else(|| Error::InvalidResponse("empty model output".into()))?
            .to_string();
        // Detect observable tag drift during inference. This is not atomic weight attestation.
        self.validate_model().await?;
        Ok(Completion {
            model: self.config.model.clone(),
            model_digest: self.config.model_digest.clone(),
            content,
            eval_count: response.get("eval_count").and_then(Value::as_u64),
            total_duration: response.get("total_duration").and_then(Value::as_u64),
        })
    }
}
