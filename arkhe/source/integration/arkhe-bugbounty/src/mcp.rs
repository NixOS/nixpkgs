//! Explicitly version-pinned Streamable HTTP transport. No tool calls without reviewed pins.
//! Wire normalization is supplied after authenticating and inspecting the actual deployment.
use crate::{HackenProofError, HackenProofMcpClient, ReportDetails, TriageParams, TriageResponse};
use arkhe_core::Digest32;
use async_trait::async_trait;
use reqwest::{
    header::{HeaderMap, HeaderValue},
    Client, Response, Url,
};
use serde_json::{json, Value};
use std::{collections::BTreeMap, time::Duration};
use tokio::sync::Mutex;
/// Integration policy is independent of discovery and caller-supplied digest pins.
pub const HACKENPROOF_TOOL_ALLOWLIST: &[&str] = &[
    "get_report_details",
    "triage_report",
    "get_program_info",
    "list_reports",
];
const PROTOCOL: &str = "2025-11-25";
const MAX_BODY: usize = 2 * 1024 * 1024;
const MAX_TOOLS: usize = 256;

fn error(reason: &str) -> HackenProofError {
    HackenProofError::Permanent(reason.into())
}
/// Full definition pin: description, input/output schemas, annotations and all extension fields.
/// Uses sorted-key JSON with serde_json number/string encoding; not RFC 8785 or WER CBOR.
pub fn tool_digest(tool: &Value) -> Result<Digest32, HackenProofError> {
    if tool.get("name").and_then(Value::as_str).is_none() {
        return Err(error("tool lacks a name"));
    }
    fn ordered(v: &Value) -> Value {
        match v {
            Value::Object(map) => Value::Object(
                map.iter()
                    .map(|(k, v)| (k.clone(), ordered(v)))
                    .collect::<BTreeMap<_, _>>()
                    .into_iter()
                    .collect(),
            ),
            Value::Array(a) => Value::Array(a.iter().map(ordered).collect()),
            _ => v.clone(),
        }
    }
    let bytes = serde_json::to_vec(&ordered(tool)).map_err(|_| error("invalid tool definition"))?;
    Ok(Digest32::blake3(b"AKG:MCP:TOOL:JSON:v1\0", &bytes))
}
#[derive(Clone)]
pub struct ToolPins(BTreeMap<String, Digest32>);
impl ToolPins {
    /// Caller supplies reviewed expected digests. Never learned automatically on connection.
    pub fn new(pins: BTreeMap<String, Digest32>) -> Result<Self, HackenProofError> {
        if pins.is_empty()
            || pins
                .keys()
                .any(|s| !HACKENPROOF_TOOL_ALLOWLIST.contains(&s.as_str()))
        {
            return Err(error(
                "reviewed pins must use the HackenProof tool allowlist",
            ));
        }
        Ok(Self(pins))
    }
    fn verify(&self, tools: &[Value], name: &str) -> Result<(), HackenProofError> {
        if !HACKENPROOF_TOOL_ALLOWLIST.contains(&name) {
            return Err(error("tool outside HackenProof allowlist"));
        }
        let expected = self
            .0
            .get(name)
            .ok_or_else(|| error("tool not in reviewed manifest"))?;
        let mut matching = tools
            .iter()
            .filter(|t| t.get("name").and_then(Value::as_str) == Some(name));
        let tool = matching
            .next()
            .ok_or_else(|| error("pinned tool disappeared"))?;
        if matching.next().is_some() || tool_digest(tool)? != *expected {
            return Err(error("tool description/schema pin changed"));
        }
        Ok(())
    }
}
struct State {
    id: u64,
    session: Option<HeaderValue>,
}
pub struct AuthenticatedMcp {
    client: Client,
    endpoint: Url,
    pins: ToolPins,
    state: Mutex<State>,
    timeout: Duration,
}
impl AuthenticatedMcp {
    /// Read-only schema discovery. Returns untrusted candidate data, never approved pins.
    pub async fn inspect_catalog(endpoint: &str, api_key: &str) -> Result<Value, HackenProofError> {
        let client = Self::connect_inner(endpoint, api_key, ToolPins(BTreeMap::new())).await?;
        let mut state = client.state.lock().await;
        let tools = client.tools(&mut state).await?;
        let mut candidates = BTreeMap::new();
        for tool in &tools {
            let name = tool
                .get("name")
                .and_then(Value::as_str)
                .ok_or_else(|| error("tool lacks name"))?;
            if candidates
                .insert(name.to_owned(), tool_digest(tool)?.to_hex())
                .is_some()
            {
                return Err(error("duplicate MCP tool names"));
            }
        }
        Ok(
            json!({"status":"UNTRUSTED_CANDIDATE_REQUIRES_REVIEW","protocol_version":PROTOCOL,"endpoint":endpoint,"tools":tools,"candidate_digests":candidates}),
        )
    }
    pub async fn connect_from_env(
        endpoint: &str,
        pins: ToolPins,
    ) -> Result<Self, HackenProofError> {
        let key = std::env::var("HACKENPROOF_API_KEY")
            .map_err(|_| error("HACKENPROOF_API_KEY is unavailable"))?;
        Self::connect(endpoint, &key, pins).await
    }
    pub async fn connect(
        endpoint: &str,
        api_key: &str,
        pins: ToolPins,
    ) -> Result<Self, HackenProofError> {
        Self::connect_inner(endpoint, api_key, pins).await
    }
    async fn connect_inner(
        endpoint: &str,
        api_key: &str,
        pins: ToolPins,
    ) -> Result<Self, HackenProofError> {
        let endpoint = Url::parse(endpoint).map_err(|_| error("invalid MCP endpoint"))?;
        let loopback = matches!(
            endpoint.host_str(),
            Some("127.0.0.1" | "localhost" | "[::1]")
        );
        if (!loopback && endpoint.scheme() != "https")
            || !endpoint.username().is_empty()
            || endpoint.password().is_some()
            || endpoint.query().is_some()
            || endpoint.fragment().is_some()
        {
            return Err(error(
                "MCP endpoint requires HTTPS without URL credentials/query/fragment",
            ));
        }
        if api_key.trim().is_empty() {
            return Err(error("API key is empty"));
        }
        let mut key =
            HeaderValue::from_str(api_key).map_err(|_| error("invalid API key header"))?;
        key.set_sensitive(true);
        let mut headers = HeaderMap::new();
        headers.insert("X-Api-Key", key);
        headers.insert(
            "Accept",
            HeaderValue::from_static("application/json, text/event-stream"),
        );
        headers.insert("MCP-Protocol-Version", HeaderValue::from_static(PROTOCOL));
        let timeout = Duration::from_secs(15);
        let client = Client::builder()
            .default_headers(headers)
            .redirect(reqwest::redirect::Policy::none())
            .retry(reqwest::retry::never())
            .timeout(timeout)
            .build()
            .map_err(|_| error("HTTP client construction failed"))?;
        let this = Self {
            client,
            endpoint,
            pins,
            state: Mutex::new(State {
                id: 0,
                session: None,
            }),
            timeout,
        };
        {
            let mut state = this.state.lock().await;
            let initialized=this.rpc(&mut state,"initialize",json!({"protocolVersion":PROTOCOL,"capabilities":{},"clientInfo":{"name":"arkhe-bugbounty","version":env!("CARGO_PKG_VERSION")}})).await?;
            if initialized.get("protocolVersion").and_then(Value::as_str) != Some(PROTOCOL) {
                return Err(error(
                    "server does not support the explicitly pinned MCP protocol version",
                ));
            }
            let mut request = this
                .client
                .post(this.endpoint.clone())
                .json(&json!({"jsonrpc":"2.0","method":"notifications/initialized"}));
            if let Some(session) = &state.session {
                request = request.header("MCP-Session-Id", session);
            }
            let response = request.send().await.map_err(|e| this.transport_error(e))?;
            if response.status().as_u16() != 202 && response.status().as_u16() != 204 {
                return Err(error("MCP initialized notification not accepted"));
            }
        }
        Ok(this)
    }
    fn transport_error(&self, e: reqwest::Error) -> HackenProofError {
        if e.is_timeout() {
            HackenProofError::Timeout(self.timeout)
        } else {
            HackenProofError::Transient("MCP transport failed; outcome may be unknown".into())
        }
    }
    async fn rpc(
        &self,
        state: &mut State,
        method: &str,
        params: Value,
    ) -> Result<Value, HackenProofError> {
        state.id = state
            .id
            .checked_add(1)
            .ok_or_else(|| error("MCP request counter exhausted"))?;
        let id = state.id;
        let mut request = self
            .client
            .post(self.endpoint.clone())
            .json(&json!({"jsonrpc":"2.0","id":id,"method":method,"params":params}));
        if let Some(session) = &state.session {
            request = request.header("MCP-Session-Id", session);
        }
        let response = request.send().await.map_err(|e| self.transport_error(e))?;
        let code = response.status().as_u16();
        match code {
            401 | 403 => {
                return Err(HackenProofError::Unauthorized(
                    "MCP authentication rejected".into(),
                ))
            }
            404 => {
                return Err(HackenProofError::NotFound(
                    "MCP endpoint/session unavailable".into(),
                ))
            }
            409 => return Err(HackenProofError::Conflict),
            429 | 500..=599 => {
                return Err(HackenProofError::Transient(format!(
                    "MCP HTTP {code}; no retry was performed"
                )))
            }
            200 => (),
            _ => return Err(error("unexpected MCP HTTP status")),
        }
        if method == "initialize" {
            if let Some(session) = response.headers().get("MCP-Session-Id") {
                if session.as_bytes().len() > 256 {
                    return Err(error("MCP session header too long"));
                }
                state.session = Some(session.clone());
            }
        }
        let message = self.read_rpc(response, id).await?;
        if message.get("jsonrpc").and_then(Value::as_str) != Some("2.0")
            || message.get("id").and_then(Value::as_u64) != Some(id)
        {
            return Err(error("MCP response ID/version mismatch"));
        }
        if message.get("error").is_some() {
            return Err(error("MCP JSON-RPC error; remote error text withheld"));
        }
        message
            .get("result")
            .cloned()
            .ok_or_else(|| error("MCP result missing"))
    }
    async fn read_rpc(&self, mut response: Response, id: u64) -> Result<Value, HackenProofError> {
        if response
            .content_length()
            .is_some_and(|n| n > MAX_BODY as u64)
        {
            return Err(error("MCP response exceeds size bound"));
        }
        let kind = response
            .headers()
            .get("content-type")
            .and_then(|s| s.to_str().ok())
            .unwrap_or("")
            .to_ascii_lowercase();
        let sse = kind.starts_with("text/event-stream");
        if !sse && !kind.starts_with("application/json") {
            return Err(error("unsupported MCP response content type"));
        }
        let mut body = Vec::new();
        while let Some(chunk) = response
            .chunk()
            .await
            .map_err(|e| self.transport_error(e))?
        {
            if body.len() + chunk.len() > MAX_BODY {
                return Err(error("MCP response exceeds size bound"));
            }
            body.extend_from_slice(&chunk);
            if sse {
                let text = match std::str::from_utf8(&body) {
                    Ok(text) => text.replace("\r\n", "\n"),
                    Err(e) if e.error_len().is_none() => continue,
                    Err(_) => return Err(error("invalid MCP SSE UTF-8")),
                };
                for event in text.split("\n\n").take(text.matches("\n\n").count()) {
                    let data = event
                        .lines()
                        .filter_map(|l| l.strip_prefix("data:"))
                        .map(str::trim_start)
                        .collect::<Vec<_>>()
                        .join("\n");
                    if data.is_empty() {
                        continue;
                    }
                    let message: Value =
                        serde_json::from_str(&data).map_err(|_| error("invalid MCP SSE JSON"))?;
                    if message.get("id").and_then(Value::as_u64) == Some(id) {
                        return Ok(message);
                    }
                }
            }
        }
        if sse {
            return Err(error("MCP SSE ended without matching response"));
        }
        serde_json::from_slice(&body).map_err(|_| error("invalid MCP JSON"))
    }
    async fn tools(&self, state: &mut State) -> Result<Vec<Value>, HackenProofError> {
        let mut tools = Vec::new();
        let mut cursor = None::<String>;
        for _ in 0..16 {
            let result = self
                .rpc(
                    state,
                    "tools/list",
                    cursor.as_ref().map_or(json!({}), |c| json!({"cursor":c})),
                )
                .await?;
            let page = result
                .get("tools")
                .and_then(Value::as_array)
                .ok_or_else(|| error("invalid tools/list result"))?;
            tools.extend(page.iter().cloned());
            if tools.len() > MAX_TOOLS {
                return Err(error("MCP tool catalog exceeds bound"));
            }
            match result.get("nextCursor") {
                None | Some(Value::Null) => return Ok(tools),
                Some(Value::String(c)) if !c.is_empty() && Some(c) != cursor.as_ref() => {
                    cursor = Some(c.clone())
                }
                _ => return Err(error("invalid MCP tool pagination")),
            }
        }
        Err(error("MCP pagination exceeds bound"))
    }
    pub async fn call_tool(&self, name: &str, arguments: Value) -> Result<Value, HackenProofError> {
        if !HACKENPROOF_TOOL_ALLOWLIST.contains(&name) {
            return Err(error("tool outside HackenProof allowlist"));
        }
        let mut state = self.state.lock().await;
        let tools = self.tools(&mut state).await?;
        self.pins.verify(&tools, name)?;
        let result = self
            .rpc(
                &mut state,
                "tools/call",
                json!({"name":name,"arguments":arguments}),
            )
            .await?;
        if result.get("isError").and_then(Value::as_bool) == Some(true) {
            return Err(error("MCP tool reported failure"));
        }
        Ok(result)
    }
}
/// Normalize only after the authenticated deployment's actual schema has been reviewed.
pub trait HackenProofWireCodec: Send + Sync {
    fn program_call(&self, _report_id: &str) -> Result<(String, Value), HackenProofError> {
        Err(error("program scope wire contract not configured"))
    }
    fn program(&self, _result: Value) -> Result<crate::scope::ProgramScope, HackenProofError> {
        Err(error("program scope wire contract not configured"))
    }
    fn read_call(&self, report_id: &str) -> (String, Value);
    fn triage_call(
        &self,
        report_id: &str,
        params: TriageParams,
        operation: Digest32,
    ) -> (String, Value);
    fn report(&self, result: Value) -> Result<ReportDetails, HackenProofError>;
    fn receipt(&self, result: Value) -> Result<TriageResponse, HackenProofError>;
}
pub struct HttpHackenProofClient<W> {
    pub transport: AuthenticatedMcp,
    pub codec: W,
}
#[async_trait]
impl<W: HackenProofWireCodec> HackenProofMcpClient for HttpHackenProofClient<W> {
    async fn get_program_info(
        &self,
        id: &str,
    ) -> Result<crate::scope::ProgramScope, HackenProofError> {
        let (name, args) = self.codec.program_call(id)?;
        if name != "get_program_info" {
            return Err(error("program discovery must use get_program_info"));
        }
        self.codec
            .program(self.transport.call_tool(&name, args).await?)
    }
    async fn get_report_details(&self, id: &str) -> Result<ReportDetails, HackenProofError> {
        let (name, args) = self.codec.read_call(id);
        if name != "get_report_details" {
            return Err(error("report discovery must use get_report_details"));
        }
        self.codec
            .report(self.transport.call_tool(&name, args).await?)
    }
    async fn triage_report(
        &self,
        id: &str,
        params: TriageParams,
        op: Digest32,
    ) -> Result<TriageResponse, HackenProofError> {
        let (name, args) = self.codec.triage_call(id, params, op);
        if name != "triage_report" {
            return Err(error("triage must use triage_report"));
        }
        self.codec
            .receipt(self.transport.call_tool(&name, args).await?)
    }
}
