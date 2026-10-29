use arkhe_verify_core::gguf::canonical::canonicalize_metadata;
use serde_json::json;

#[test]
fn gguf_golden_cbor() {
    let v = json!({
        "architecture":"llama",
        "context_length":4096,
        "license":"MIT"
    });
    assert_eq!(
        hex::encode(canonicalize_metadata(&v).unwrap()),
        "a3676c6963656e7365634d49546c617263686974656374757265656c6c616d616e636f6e746578745f6c656e677468191000"
    );
}
