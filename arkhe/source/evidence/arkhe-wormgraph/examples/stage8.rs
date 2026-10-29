use arkhe_core::Digest32;
use arkhe_wormgraph::detection::{checkpoint, demo, verify_export, SignedObservation};

fn bytes32(value: &str) -> Result<[u8; 32], String> {
    hex::decode(value)
        .map_err(|e| e.to_string())?
        .try_into()
        .map_err(|_| "expected 32 bytes".into())
}

#[tokio::main]
async fn main() -> Result<(), String> {
    let args: Vec<String> = std::env::args().skip(1).collect();
    match args.as_slice() {
        [command, path] if command == "demo" => {
            let events = demo().await?;
            let public = ed25519_dalek::SigningKey::from_bytes(&[8;32]).verifying_key().to_bytes();
            let pin = checkpoint(&events);
            verify_export(&events, public, pin)?;
            std::fs::write(path, serde_json::to_vec_pretty(&events).map_err(|e| e.to_string())?).map_err(|e| e.to_string())?;
            println!("5 admitted events; 1 causal alert; offline verification passed\npublic_key={}\ncheckpoint={}", hex::encode(public), pin.to_hex());
        }
        [command, path, public, pin] if command == "verify" => {
            let events: Vec<SignedObservation> = serde_json::from_slice(&std::fs::read(path).map_err(|e| e.to_string())?).map_err(|e| e.to_string())?;
            verify_export(&events, bytes32(public)?, Digest32(bytes32(pin)?))?;
            println!("VERIFIED: {} signed events, causal references and retained checkpoint", events.len());
        }
        _ => return Err("usage: stage8 demo <export.json> | verify <export.json> <trusted-public-key-hex> <retained-checkpoint-hex>".into()),
    }
    Ok(())
}
