//! AKG-NCM-0003 — VQ-VAE level codebook as a `TokenizerEnv` for llguidance.
//!
//! The NCM tokenizer is not a HuggingFace tokenizer: it is a multiscale
//! VQ-VAE with **one codebook per level**, and generation emits codes level
//! by level. llguidance constrains decoding through the `TokenizerEnv`
//! trait, whose real contract (verified against toktrie 1.9.1) requires
//! exactly two methods: `tok_trie` and `tokenize_bytes`.
//!
//! The adapter here models one level: token `i` is code `i`, whose bytes are
//! the text fragment that code decodes to, plus one synthetic EOS marker
//! token (`\xFF<|level-end|>`, the toktrie special-token convention). A
//! production deployment builds one `LevelCodebookTokEnv` per level of the
//! loaded checkpoint.
//!
//! What is deliberately NOT here: extracting the codebooks from the
//! `tokenizer.pt` checkpoint. That file is a PyTorch pickle; reading it from
//! Rust needs `tch`/`candle` (heavy, and untestable without the checkpoint).
//! The constructor takes already-extracted codebooks, so this module is
//! compilable and testable today, and the extraction step remains an
//! explicit, documented gap.
//!
//! Tokenization is greedy longest-match over the codebook fragments — the
//! same approximation `ApproximateTokEnv` uses — and is therefore not
//! canonical.

use std::sync::Arc;

use llguidance::toktrie::{TokEnv, TokRxInfo, TokTrie, TokenId, TokenizerEnv};

/// One level's VQ codebook as a tokenizer environment.
pub struct LevelCodebookTokEnv {
    trie: TokTrie,
    codebook: Vec<Vec<u8>>,
    eos: TokenId,
    level: u8,
}

impl LevelCodebookTokEnv {
    /// `codebook[i]` is the byte fragment code `i` decodes to. Codes should
    /// be non-empty and should not start with `\xFF` (the special-token
    /// marker); both are properties of the extracted checkpoint, not
    /// enforced here.
    pub fn new(level: u8, codebook: Vec<Vec<u8>>) -> Self {
        let mut words = codebook.clone();
        words.push(b"\xFF<|level-end|>".to_vec());
        let eos = codebook.len() as TokenId;
        let info = TokRxInfo {
            vocab_size: words.len() as u32,
            tok_eos: eos,
            tok_bos: None,
            tok_pad: None,
            tok_unk: None,
            tok_end_of_turn: None,
        };
        let trie = TokTrie::from(&info, &words);
        Self {
            trie,
            codebook,
            eos,
            level,
        }
    }

    pub fn level(&self) -> u8 {
        self.level
    }

    pub fn eos(&self) -> TokenId {
        self.eos
    }

    pub fn code_count(&self) -> usize {
        self.codebook.len()
    }

    /// Concatenated decoding of a code sequence. `None` on an unknown code.
    pub fn decode_codes(&self, codes: &[TokenId]) -> Option<Vec<u8>> {
        let mut out = Vec::new();
        for &code in codes {
            out.extend_from_slice(self.codebook.get(code as usize)?);
        }
        Some(out)
    }

    pub fn into_env(self) -> TokEnv {
        Arc::new(self)
    }
}

impl TokenizerEnv for LevelCodebookTokEnv {
    fn tok_trie(&self) -> &TokTrie {
        &self.trie
    }

    fn tokenize_bytes(&self, s: &[u8]) -> Vec<TokenId> {
        self.trie.greedy_tokenize(s)
    }

    /// Greedy longest-match over learned fragments is an approximation.
    fn tokenize_is_canonical(&self) -> bool {
        false
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use llguidance::api::TopLevelGrammar;
    use llguidance::{Matcher, ParserFactory};

    #[test]
    fn greedy_tokenization_uses_longest_codes() {
        let env =
            LevelCodebookTokEnv::new(1, vec![b"Sy".to_vec(), b"Syd".to_vec(), b"dne".to_vec()]);
        // Greedy: at position 0 "Syd" (longest) wins over "Sy"; "dne" follows.
        let tokens = env.tokenize_bytes(b"Syddne");
        assert_eq!(tokens, vec![1, 2]);
        assert_eq!(env.decode_codes(&tokens).as_deref(), Some(&b"Syddne"[..]));
        // "Sy" alone matches the shorter code exactly.
        assert_eq!(env.tokenize_bytes(b"Sy"), vec![0]);
    }

    #[test]
    fn eos_is_synthetic_and_last() {
        let env = LevelCodebookTokEnv::new(2, vec![b"a".to_vec(), b"b".to_vec()]);
        assert_eq!(env.level(), 2);
        assert_eq!(env.code_count(), 2);
        assert_eq!(env.eos(), 2);
        let shared = env.into_env();
        assert_eq!(shared.eos_token(), 2);
    }

    /// The whole point of the adapter: llguidance accepts the codebook env
    /// and a code sequence whose concatenated bytes satisfy the grammar.
    #[test]
    fn llguidance_matches_codes_against_the_schema() {
        // One code whose bytes are a complete JSON string value.
        let codebook = vec![b"\"abc\"".to_vec(), b"\"xy\"".to_vec()];
        let env = LevelCodebookTokEnv::new(1, codebook).into_env();
        let factory = ParserFactory::new_simple(&env).expect("codebook env accepted");
        let schema = serde_json::json!({"type": "string"});
        let parser = factory
            .create_parser(TopLevelGrammar::from_json_schema(schema))
            .expect("schema compiles");
        let mut matcher = Matcher::new(Ok(parser));
        matcher.consume_token(0).expect("code 0 is a valid string");
        assert!(matcher.is_accepting().unwrap());
        // A second string value after a complete one must not be accepted
        // at token level (the root value is already complete).
        assert!(matcher.consume_token(1).is_err() || !matcher.is_accepting().unwrap());
    }
}
