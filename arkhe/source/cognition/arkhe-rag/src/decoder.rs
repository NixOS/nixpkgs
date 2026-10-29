//! AKG-NCM-0002 — Constrained decoding backends for the NCM harness.
//!
//! Backend selection is deterministic:
//! - `llguidance` (pure Rust, compiles to wasm32): used for both targets by
//!   `for_schema`. It is also the only correct choice for schemas with
//!   `anyOf`/`oneOf` branches sharing a first-byte class (`integer` vs
//!   `number`, two `string` branches, …), where XGrammar has a known
//!   over-rejection bug, and it fails loudly where XGrammar does not.
//! - `xgrammar` (C++ binding, feature `server`): explicit opt-in for the
//!   server target on schemas without shared-prefix alternatives, where it
//!   is faster on plain JSON. Behind a feature so the default build (and
//!   WASM) never needs CMake/C++. In xgrammar 0.5 the raw-vocab
//!   `TokenizerInfo` constructor is private, so the caller must supply a
//!   real tokenizer info (`from_path`/`from_pretrained`/`from_backend_str`)
//!   — which for Arkhe is the deployment's NCM tokenizer, not an empty
//!   vocab.
//!
//! The compilation budget on the xgrammar path is a post-hoc detector, not a
//! preemptive guard: compilation has already run when it fires. The actual
//! prevention for CVE-2025-57809-style blowups is running a fixed upstream
//! version; the detector refuses to admit a matcher whose compilation took
//! unreasonably long.

use llguidance::toktrie::TokEnv;
use serde_json::Value;
#[cfg(feature = "server")]
use std::time::{Duration, Instant};

#[cfg(feature = "server")]
use xgrammar::TokenizerInfo as XgTokenizerInfo;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Target {
    Wasm,
    Server,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum DecoderError {
    TokenEnv(String),
    Grammar(String),
    Schema(String),
    CompilationTimeout,
}

pub enum ConstrainedDecoder {
    LlGuidance(llguidance::Matcher),
    #[cfg(feature = "server")]
    XGrammar(xgrammar::GrammarMatcher),
    /// Test fallback: no constraint is applied.
    NoOp,
}

impl ConstrainedDecoder {
    /// Deterministic selection. `llguidance` for both targets: it is the
    /// only backend that compiles to WASM and the only one known-correct on
    /// shared-prefix alternatives. Deployments wanting the xgrammar fast
    /// path on plain JSON opt in explicitly via [`for_xgrammar`] after
    /// checking [`has_shared_prefix_alternatives`] themselves.
    pub fn for_schema(
        schema: &Value,
        _target: Target,
        tok_env: &TokEnv,
    ) -> Result<Self, DecoderError> {
        Self::llguidance(schema, tok_env)
    }

    fn llguidance(schema: &Value, tok_env: &TokEnv) -> Result<Self, DecoderError> {
        use llguidance::{api::TopLevelGrammar, Matcher, ParserFactory};
        let grammar = TopLevelGrammar::from_json_schema(schema.clone());
        let factory =
            ParserFactory::new_simple(tok_env).map_err(|e| DecoderError::Grammar(e.to_string()))?;
        let parser = factory
            .create_parser(grammar)
            .map_err(|e| DecoderError::Grammar(e.to_string()))?;
        Ok(Self::LlGuidance(Matcher::new(Ok(parser))))
    }

    /// Server-only opt-in to the xgrammar C++ backend. The caller supplies
    /// the deployment's real tokenizer info; do not call this for schemas
    /// where [`has_shared_prefix_alternatives`] is true.
    #[cfg(feature = "server")]
    pub fn for_xgrammar(
        schema: &Value,
        tokenizer_info: &XgTokenizerInfo,
    ) -> Result<Self, DecoderError> {
        use xgrammar::{Grammar, GrammarCompiler, GrammarMatcher};
        let schema_str =
            serde_json::to_string(schema).map_err(|e| DecoderError::Schema(e.to_string()))?;
        let grammar = Grammar::from_json_schema(
            &schema_str,
            Some(true),                               // any_whitespace
            None,                                     // indent
            Some((",".to_string(), ":".to_string())), // separators
            Some(true),                               // strict_mode
            None,                                     // max_whitespace_cnt
            Some(false),                              // print_converted_ebnf
        )
        .map_err(|e| DecoderError::Grammar(e.to_string()))?;
        let compiler = GrammarCompiler::new(tokenizer_info);
        let start = Instant::now();
        let compiled = compiler
            .compile_grammar(&grammar)
            .map_err(|e| DecoderError::Grammar(e.to_string()))?;
        if start.elapsed() > Duration::from_secs(2) {
            return Err(DecoderError::CompilationTimeout);
        }
        Ok(Self::XGrammar(GrammarMatcher::new(&compiled)))
    }
}

/// True if the schema contains `anyOf`/`oneOf` where two branches share a
/// first-byte class (`integer` vs `number`, two branches of the same type,
/// …) — the shape that triggers XGrammar's over-rejection bug. Recursive:
/// nested `properties`, `items`, `allOf`, … are checked. Only branches that
/// declare a `type` are compared; untyped branches are conservatively not
/// flagged (llguidance handles them correctly either way).
pub fn has_shared_prefix_alternatives(schema: &Value) -> bool {
    if let Some(alts) = schema.get("anyOf").or_else(|| schema.get("oneOf")) {
        if let Some(arr) = alts.as_array() {
            let types: Vec<&str> = arr
                .iter()
                .filter_map(|b| b.get("type").and_then(|t| t.as_str()))
                .collect();
            for i in 0..types.len() {
                for j in (i + 1)..types.len() {
                    if first_byte_shared(types[i], types[j]) {
                        return true;
                    }
                }
            }
        }
    }
    match schema {
        Value::Object(map) => map.values().any(has_shared_prefix_alternatives),
        Value::Array(arr) => arr.iter().any(has_shared_prefix_alternatives),
        _ => false,
    }
}

fn first_byte_shared(a: &str, b: &str) -> bool {
    a == b || matches!((a, b), ("integer", "number") | ("number", "integer"))
}
