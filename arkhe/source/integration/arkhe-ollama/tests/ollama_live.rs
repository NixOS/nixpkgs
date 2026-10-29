//! Explicit real-provider gate; default tests use a loopback fixture server.
use arkhe_ollama::{Config, OllamaClient};
#[tokio::test]
async fn real_local_model_generates_schema_constrained_json() {
    let path = std::env::var("ARKHE_OLLAMA_CONFIG")
        .expect("real-provider gate requires ARKHE_OLLAMA_CONFIG");
    let client = OllamaClient::new(Config::load(path).unwrap()).unwrap();
    client.status().await.unwrap();
    let schema = serde_json::json!({"type":"object","properties":{"ok":{"type":"boolean"}},"required":["ok"],"additionalProperties":false});
    let output = client
        .chat(
            "Return only JSON. Set ok to true.",
            "Confirm the local Arkhe provider integration.",
            Some(schema),
        )
        .await
        .unwrap();
    let parsed: serde_json::Value = serde_json::from_str(&output.content).unwrap();
    assert_eq!(parsed, serde_json::json!({"ok":true}));
    println!(
        "Verified actual Ollama JSON inference: model={}, digest={}, tokens={:?}",
        output.model, output.model_digest, output.eval_count
    );
}
