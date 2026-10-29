use arkhe_ollama::{Config, OllamaClient};
use std::io::{self, Read};
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let mut args = std::env::args().skip(1);
    let action = args.next().unwrap_or_else(|| "status".into());
    let path = std::env::var("ARKHE_OLLAMA_CONFIG").unwrap_or_else(|_| "config/ollama.json".into());
    let client = OllamaClient::new(Config::load(path)?)?;
    match action.as_str() {
        "status" => println!("{}", serde_json::to_string_pretty(&client.status().await?)?),
        "chat" | "chat-stdin" => {
            let prompt = if action == "chat-stdin" {
                let mut bytes = Vec::new();
                io::stdin().take(32769).read_to_end(&mut bytes)?;
                if bytes.len() > 32768 {
                    return Err("prompt exceeds 32 KiB".into());
                }
                String::from_utf8(bytes)?
            } else {
                args.collect::<Vec<_>>().join(" ")
            };
            if prompt.trim().is_empty() {
                return Err("usage: arkhe-ollama chat <prompt>".into());
            }
            let result=client.chat("You are the local Arkhe assistant. Answer the user's question concisely. Your output is a proposal; you cannot authorize or execute external actions.",&prompt,None).await?;
            println!("{}", result.content);
        }
        _ => return Err("usage: arkhe-ollama status|chat <prompt>".into()),
    }
    Ok(())
}
