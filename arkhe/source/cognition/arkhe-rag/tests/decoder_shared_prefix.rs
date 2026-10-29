//! AKG-NCM-0002 tests — backend selection and the anyOf discrimination.
//!
//! The xgrammar fast path is behind the `server` feature (C++ toolchain) and
//! additionally requires a real tokenizer info, so these default-build tests
//! cover: selection, the shared-prefix advisory (including nested schemas),
//! and llguidance's loud acceptance/rejection behavior at byte level.

use arkhe_rag::decoder::{has_shared_prefix_alternatives, ConstrainedDecoder, Target};
use llguidance::toktrie::ApproximateTokEnv;

fn tok_env() -> llguidance::toktrie::TokEnv {
    // Byte-level env, no download. Production builds this from the
    // deployment's NCM tokenizer.
    ApproximateTokEnv::single_byte_env()
}

#[test]
fn anyof_integer_number_is_llguidance_on_both_targets() {
    let schema = serde_json::json!({
        "anyOf": [{"type": "integer"}, {"type": "number"}]
    });
    let env = tok_env();

    let wasm = ConstrainedDecoder::for_schema(&schema, Target::Wasm, &env).unwrap();
    assert!(matches!(wasm, ConstrainedDecoder::LlGuidance(_)));

    let server = ConstrainedDecoder::for_schema(&schema, Target::Server, &env).unwrap();
    assert!(matches!(server, ConstrainedDecoder::LlGuidance(_)));
}

#[test]
fn plain_object_schema_selects_llguidance_in_default_build() {
    let schema = serde_json::json!({
        "type": "object",
        "properties": {
            "name": {"type": "string"},
            "age": {"type": "integer"}
        },
        "required": ["name", "age"]
    });
    let env = tok_env();
    let server = ConstrainedDecoder::for_schema(&schema, Target::Server, &env).unwrap();
    assert!(matches!(server, ConstrainedDecoder::LlGuidance(_)));
}

#[test]
fn nested_anyof_is_detected() {
    let schema = serde_json::json!({
        "type": "object",
        "properties": {
            "value": {
                "anyOf": [{"type": "integer"}, {"type": "number"}]
            }
        }
    });
    assert!(has_shared_prefix_alternatives(&schema));
}

#[test]
fn shared_prefix_advisory_matches_the_schema_shape() {
    // The shape that triggers XGrammar's over-rejection bug.
    assert!(has_shared_prefix_alternatives(&serde_json::json!({
        "anyOf": [{"type": "integer"}, {"type": "number"}]
    })));
    // Two same-type branches also share a first byte.
    assert!(has_shared_prefix_alternatives(&serde_json::json!({
        "oneOf": [{"type": "string"}, {"type": "string"}]
    })));
    // Disjoint types (string vs integer) do not share a first byte.
    assert!(!has_shared_prefix_alternatives(&serde_json::json!({
        "anyOf": [{"type": "string"}, {"type": "integer"}]
    })));
    // Plain objects and nested disjoint types are clean.
    assert!(!has_shared_prefix_alternatives(&serde_json::json!({
        "type": "object",
        "properties": {"name": {"type": "string"}}
    })));
}

#[test]
fn llguidance_accepts_1_5_for_anyof_integer_number() {
    let schema = serde_json::json!({
        "anyOf": [{"type": "integer"}, {"type": "number"}]
    });
    let env = tok_env();
    let decoder = ConstrainedDecoder::for_schema(&schema, Target::Wasm, &env).unwrap();
    let ConstrainedDecoder::LlGuidance(mut matcher) = decoder else {
        panic!("expected LlGuidance")
    };
    // Byte-level env: tokenize "1.5" and consume it. This is exactly the
    // input XGrammar rejects at byte 1 in the over-rejection bug; llguidance
    // must accept it.
    let tokens = env.tokenize_bytes(b"1.5");
    matcher
        .consume_tokens(&tokens)
        .expect("llguidance accepts 1.5 for anyOf integer/number");
    assert!(matcher.is_accepting().unwrap());
}

#[test]
fn llguidance_rejects_invalid_input_loudly() {
    let schema = serde_json::json!({
        "type": "object",
        "properties": {"name": {"type": "string"}},
        "required": ["name"]
    });
    let env = tok_env();
    let decoder = ConstrainedDecoder::for_schema(&schema, Target::Wasm, &env).unwrap();
    let ConstrainedDecoder::LlGuidance(mut matcher) = decoder else {
        panic!("expected LlGuidance")
    };
    // "xyz" is not a valid value for this schema: consumption must error,
    // not pass silently.
    let tokens = env.tokenize_bytes(b"xyz");
    assert!(
        matcher.consume_tokens(&tokens).is_err(),
        "llguidance must fail loudly on invalid input"
    );
}
