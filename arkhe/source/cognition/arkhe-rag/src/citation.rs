//! AKG-CITE-0001 — Citation verification with exact entity matching.
//!
//! The NCM tokenizer swaps named entities and numerals ("Sydney" → "Melbourne",
//! "1956" → "1957"). Keyword overlap alone does not detect this. This module
//! adds a second layer: exact, case-sensitive substring verification of every
//! entity (proper noun, acronym, numeral) against the evidence chunk that the
//! claim cites.
//!
//! Two layers, both fail-closed:
//! 1. Entity exactness — every entity in a claim must occur literally in the
//!    cited chunk (case-sensitive, no normalization).
//! 2. Keyword overlap — generic claims must share enough non-stopword tokens
//!    with the cited chunk (Jaccard).
//!
//! Hand-rolled tokenizer. No `regex`. No new dependencies.
//!
//! This is support verification, not truth verification: a chunk that contains
//! "Sydney" may still be factually wrong; this module only proves the claim
//! did not invent the entity. Truth remains the corpus's and the RAG's
//! responsibility.

use std::collections::HashSet;

#[derive(Debug, Clone, PartialEq)]
pub enum CitationError {
    UnknownEvidence(String),
    EntityNotInEvidence { entity: String, chunk: String },
    InsufficientSupport { claim: String, score: f64 },
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum EntityKind {
    ProperNoun,
    Acronym,
    Numeral,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Entity {
    pub kind: EntityKind,
    pub text: String,
}

/// A view over a retrieval chunk. Decoupled from `RetrievalChunk` so the
/// verifier can be tested without the full `arkhe-rag` types.
#[derive(Debug, Clone, Copy)]
pub struct Evidence<'a> {
    pub id: &'a str,
    pub text: &'a str,
}

/// A claim extracted from a `RagResponse`. Borrows from the response.
#[derive(Debug, Clone, Copy)]
pub struct Claim<'a> {
    pub text: &'a str,
    pub evidence_id: &'a str,
}

pub trait CitationVerifier: Send + Sync {
    fn verify(&self, claims: &[Claim<'_>], evidence: &[Evidence<'_>]) -> Result<(), CitationError>;
}

pub struct OverlapVerifier {
    pub min_keyword_overlap: f64,
}

impl Default for OverlapVerifier {
    fn default() -> Self {
        Self {
            min_keyword_overlap: 0.5,
        }
    }
}

// ---- Tokenizer (hand-rolled) ----

#[derive(Debug, Clone, PartialEq, Eq)]
enum Token {
    Word(String),
    Numeral(String),
    Punct(char),
}

fn tokenize(input: &str) -> Vec<Token> {
    let chars: Vec<char> = input.chars().collect();
    let mut tokens = Vec::new();
    let mut i = 0;
    while i < chars.len() {
        let ch = chars[i];
        let is_num_start = ch.is_ascii_digit()
            || (ch == '-' && i + 1 < chars.len() && chars[i + 1].is_ascii_digit());
        if is_num_start {
            let start = i;
            i += 1;
            while i < chars.len() {
                let c = chars[i];
                if c.is_ascii_digit() {
                    i += 1;
                } else if (c == '.' || c == ',')
                    && i + 1 < chars.len()
                    && chars[i + 1].is_ascii_digit()
                {
                    i += 2;
                } else {
                    break;
                }
            }
            tokens.push(Token::Numeral(chars[start..i].iter().collect()));
        } else if ch.is_alphanumeric() || ch == '_' {
            let start = i;
            i += 1;
            while i < chars.len() && (chars[i].is_alphanumeric() || chars[i] == '_') {
                i += 1;
            }
            tokens.push(Token::Word(chars[start..i].iter().collect()));
        } else {
            tokens.push(Token::Punct(ch));
            i += 1;
        }
    }
    tokens
}

// ---- Entity extraction ----

const CAPITALIZED_STOPWORDS: &[&str] = &[
    "The",
    "This",
    "That",
    "These",
    "Those",
    "However",
    "Therefore",
    "In",
    "On",
    "At",
    "For",
    "But",
    "And",
    "Or",
    "A",
    "An",
    "It",
    "We",
    "They",
    "He",
    "She",
    "I",
    "You",
    "If",
    "When",
    "While",
    "Although",
    "Because",
    "Since",
    "After",
    "Before",
    "During",
    "As",
    "By",
    "Of",
    "To",
    "With",
    "From",
    "Not",
    "No",
    "Yes",
];

pub fn extract_entities(claim_text: &str) -> Vec<Entity> {
    let mut entities = Vec::new();
    for tok in tokenize(claim_text) {
        match tok {
            Token::Numeral(n) => entities.push(Entity {
                kind: EntityKind::Numeral,
                text: n,
            }),
            Token::Word(w) => {
                let first = match w.chars().next() {
                    Some(c) => c,
                    None => continue,
                };
                if !first.is_uppercase() {
                    continue;
                }
                if CAPITALIZED_STOPWORDS.contains(&w.as_str()) {
                    continue;
                }
                let alpha: Vec<char> = w.chars().filter(|c| c.is_alphabetic()).collect();
                let is_all_caps = alpha.len() >= 2 && alpha.iter().all(|c| c.is_uppercase());
                let kind = if is_all_caps && alpha.len() <= 6 {
                    EntityKind::Acronym
                } else {
                    EntityKind::ProperNoun
                };
                entities.push(Entity { kind, text: w });
            }
            Token::Punct(_) => {}
        }
    }
    entities
}

// ---- Keyword overlap ----

const STOPWORDS_LOWER: &[&str] = &[
    "the", "a", "an", "is", "are", "was", "were", "be", "been", "being", "of", "to", "in", "on",
    "at", "for", "with", "by", "from", "as", "and", "or", "but", "not", "no", "if", "then", "than",
    "that", "this", "it", "its", "we", "they", "he", "she", "i", "you", "his", "her", "their",
    "our", "your", "my", "me", "us", "them", "him",
];

fn keyword_set(text: &str) -> HashSet<String> {
    tokenize(text)
        .into_iter()
        .filter_map(|t| match t {
            Token::Word(w) => Some(w.to_lowercase()),
            _ => None,
        })
        .filter(|w| !STOPWORDS_LOWER.contains(&w.as_str()))
        .collect()
}

pub fn keyword_overlap(a: &str, b: &str) -> f64 {
    let sa = keyword_set(a);
    let sb = keyword_set(b);
    let union = sa.union(&sb).count();
    if union == 0 {
        return 0.0;
    }
    let inter = sa.intersection(&sb).count();
    inter as f64 / union as f64
}

// ---- Verifier ----

impl CitationVerifier for OverlapVerifier {
    fn verify(&self, claims: &[Claim<'_>], evidence: &[Evidence<'_>]) -> Result<(), CitationError> {
        for claim in claims {
            // 1. Resolve the cited chunk.
            let chunk = evidence
                .iter()
                .find(|e| e.id == claim.evidence_id)
                .ok_or_else(|| CitationError::UnknownEvidence(claim.evidence_id.to_string()))?;

            // 2. Entity exactness — case-sensitive, no normalization.
            for entity in extract_entities(claim.text) {
                if !chunk.text.contains(&entity.text) {
                    return Err(CitationError::EntityNotInEvidence {
                        entity: entity.text,
                        chunk: chunk.id.to_string(),
                    });
                }
            }

            // 3. Keyword overlap for generic claims.
            let score = keyword_overlap(claim.text, chunk.text);
            if score < self.min_keyword_overlap {
                return Err(CitationError::InsufficientSupport {
                    claim: claim.text.to_string(),
                    score,
                });
            }
        }
        Ok(())
    }
}

/// Adapter from raw parts, for callers that do not have `Evidence` literals.
pub fn evidence_from_chunk<'a>(id: &'a str, text: &'a str) -> Evidence<'a> {
    Evidence { id, text }
}
