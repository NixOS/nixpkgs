//! Deterministic public test material only. Never use these keys outside tests.
use arkhe_crm_bridge_cli::v2::{self, Event, Request};
use ed25519_dalek::SigningKey;
fn main() {
    let event: Event = serde_json::from_str(include_str!("../fixtures/event-v2.json")).unwrap();
    let key = SigningKey::from_bytes(&[2; 32]);
    let request = Request::sign(event, &key).unwrap();
    println!(
        "{}",
        serde_json::to_string_pretty(&serde_json::json!({
            "schema": 2,
            "canonical_hex": hex::encode(request.event.canonical().unwrap()),
            "event_hash": request.event.hash().unwrap(),
            "producer_public_key": v2::public_key(&key),
            "signature": request.signature
        }))
        .unwrap()
    );
}
