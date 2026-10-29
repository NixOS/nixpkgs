//! Structured lexical citation diagnostic over host-authorized retrieval chunks.
use arkhe_core::Digest32;
use arkhe_rag::{
    authorized_retrieval,
    citation::{CitationVerifier, Claim, Evidence, OverlapVerifier},
    retrieval::{Bm25Index, Document},
    RetrievalChunk,
};
use serde::Deserialize;
use serde_json::{json, Value};
use std::collections::HashSet;

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Chunk {
    id: String,
    tenant: String,
    readers: Vec<String>,
    text: String,
    expected_digest_hex: String,
    source_ref_hex: String,
}
#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct StructuredClaim {
    text: String,
    evidence_id: String,
}
#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Answer {
    claims: Vec<StructuredClaim>,
}
#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Input {
    tenant: String,
    subject: String,
    chunks: Vec<Chunk>,
    #[serde(default)]
    response_json: String,
    #[serde(default)]
    query: Option<String>,
    #[serde(default = "default_top_k")]
    top_k: usize,
}
fn default_top_k() -> usize {
    3
}
fn parse_digest(value: &str) -> Result<Digest32, String> {
    let bytes = hex::decode(value).map_err(|_| "invalid hex digest")?;
    Ok(Digest32(
        bytes
            .try_into()
            .map_err(|_| "digest must contain 32 bytes")?,
    ))
}
fn verify(input: Input) -> Result<Value, String> {
    if input.chunks.len() > 32 || input.response_json.len() > 65536 {
        return Err("input bounds exceeded".into());
    }
    let mut ids = HashSet::new();
    let mut chunks = vec![];
    for chunk in &input.chunks {
        if chunk.id.is_empty() || !ids.insert(&chunk.id) {
            return Err("empty or duplicate chunk id".into());
        }
        chunks.push(RetrievalChunk {
            tenant: chunk.tenant.clone(),
            readers: chunk.readers.clone(),
            content: chunk.text.as_bytes().to_vec(),
            expected_digest: parse_digest(&chunk.expected_digest_hex)?,
            source_ref: parse_digest(&chunk.source_ref_hex)?,
        });
    }
    let allowed =
        authorized_retrieval(&input.tenant, &input.subject, &chunks).map_err(str::to_string)?;
    let allowed_ids: HashSet<_> = allowed.iter().map(|c| c.expected_digest).collect();
    // Retain identity checks as well as content digest: two chunks with the same
    // text but different ACLs must not authorize one another by content alone.
    let mut evidence: Vec<_> = input
        .chunks
        .iter()
        .zip(&chunks)
        .filter(|(_, native)| allowed.iter().any(|a| std::ptr::eq(*a, *native)))
        .map(|(chunk, _)| Evidence {
            id: chunk.id.as_str(),
            text: chunk.text.as_str(),
        })
        .collect();
    if let Some(query) = &input.query {
        if query.trim().is_empty() || query.len() > 4096 || !(1..=8).contains(&input.top_k) {
            return Err("invalid retrieval query or top_k".into());
        }
        let index = Bm25Index::new(
            evidence
                .iter()
                .map(|e| Document {
                    id: e.id.to_string(),
                    text: e.text.to_string(),
                })
                .collect(),
            1.2,
            0.75,
        )?;
        let hits = index.search(query, input.top_k);
        evidence = hits
            .iter()
            .filter_map(|hit| evidence.iter().find(|e| e.id == hit.id).copied())
            .collect();
        if input.response_json.is_empty() {
            return Ok(
                json!({"phase":"authorized_retrieval", "retriever":"arkhe_rag::retrieval::Bm25Index",
                "chunks":evidence.iter().map(|e|json!({"id":e.id,"text":e.text})).collect::<Vec<_>>(),
                "tenant":input.tenant,"subject":input.subject,"capability_demonstrated":false}),
            );
        }
    }
    let answer: Answer = serde_json::from_str(&input.response_json)
        .map_err(|_| "response must contain only a claims array")?;
    if answer.claims.is_empty()
        || answer.claims.len() > 64
        || answer.claims.iter().any(|c| c.text.trim().is_empty())
    {
        return Err("nonempty bounded claims required".into());
    }
    let verifier = OverlapVerifier::default();
    let mut results = vec![];
    for claim in &answer.claims {
        let checked = verifier.verify(
            &[Claim {
                text: &claim.text,
                evidence_id: &claim.evidence_id,
            }],
            &evidence,
        );
        results.push(match checked {
            Ok(()) => json!({"status":"PASS_LEXICAL", "evidence_id":claim.evidence_id}),
            Err(error) => json!({"status":"FAIL_LEXICAL", "evidence_id":claim.evidence_id,"reason":format!("{error:?}")}),
        });
    }
    Ok(
        json!({"phase":"structured_citation_diagnostic", "verifier":"arkhe_rag::citation::OverlapVerifier",
        "status":if results.iter().all(|r| r["status"]=="PASS_LEXICAL") {"PASS_LEXICAL"} else {"FAIL_LEXICAL"},
        "scope":"EXPLICIT_CLAIMS_VS_AUTHORIZED_TEXT_CHUNKS", "claims":results,
        "authorized_chunks":evidence.iter().map(|e|e.id).collect::<Vec<_>>(),
        "authorized_content_digests":allowed_ids.len(), "semantic_entailment":"NOT_MEASURED",
        "source_factual_validity":"NOT_VERIFIED", "host_supplied_acl_and_digest_trust":true,
        "capability_demonstrated":false}),
    )
}

pub(super) fn verify_value(value: Value) -> Result<Value, String> {
    verify(serde_json::from_value(value).map_err(|_| "invalid structured citation input")?)
}

#[cfg(test)]
mod tests {
    use super::*;
    fn input(text: &str, claim: &str) -> Input {
        Input {
            tenant: "one".into(),
            subject: "reader".into(),
            chunks: vec![Chunk {
                id: "chunk1".into(),
                tenant: "one".into(),
                readers: vec!["reader".into()],
                text: text.into(),
                expected_digest_hex: Digest32::blake3(b"AKG:RAG:CHUNK:v1\0", text.as_bytes())
                    .to_hex(),
                source_ref_hex: "ab".repeat(32),
            }],
            response_json: json!({"claims":[{"text":claim,"evidence_id":"chunk1"}]}).to_string(),
            query: None,
            top_k: 3,
        }
    }
    #[test]
    fn explicit_claim_does_not_include_prompt_scaffolding() {
        assert_eq!(
            verify(input("Sydney has 5 offices.", "Sydney has 5 offices.")).unwrap()["claims"][0]
                ["status"],
            "PASS_LEXICAL"
        );
        assert_eq!(
            verify(input("Sydney has 5 offices.", "Melbourne has 5 offices.")).unwrap()["claims"]
                [0]["status"],
            "FAIL_LEXICAL"
        );
    }
    #[test]
    fn sentence_initial_name_is_not_silently_ignored() {
        assert!(arkhe_rag::citation::extract_entities("Sydney has offices")
            .iter()
            .any(|e| e.text == "Sydney"));
    }
    #[test]
    fn unauthorized_and_tampered_chunks_cannot_support_claims() {
        let mut private = input("Sydney has 5 offices.", "Sydney has 5 offices.");
        private.chunks[0].tenant = "another".into();
        assert_eq!(
            verify(private).unwrap()["claims"][0]["status"],
            "FAIL_LEXICAL"
        );
        let mut tampered = input("Sydney has 5 offices.", "Sydney has 5 offices.");
        tampered.chunks[0].text.push('!');
        assert!(verify(tampered).is_err());
    }
    #[test]
    fn same_content_does_not_bypass_chunk_acl() {
        let mut example = input("Sydney has 5 offices.", "Sydney has 5 offices.");
        let public = &example.chunks[0];
        example.chunks.push(Chunk {
            id: "private".into(),
            tenant: "another".into(),
            readers: vec!["reader".into()],
            text: public.text.clone(),
            expected_digest_hex: public.expected_digest_hex.clone(),
            source_ref_hex: public.source_ref_hex.clone(),
        });
        example.response_json =
            json!({"claims":[{"text":"Sydney has 5 offices.","evidence_id":"private"}]})
                .to_string();
        assert_eq!(
            verify(example).unwrap()["claims"][0]["status"],
            "FAIL_LEXICAL"
        );
    }
    #[test]
    fn metadata_or_empty_claims_do_not_pass_as_answer() {
        let mut empty = input("text", "text");
        empty.response_json = "{\"claims\":[]}".into();
        assert!(verify(empty).is_err());
        let mut hidden = input("text", "text");
        hidden.response_json =
            "{\"claims\":[{\"text\":\"text\",\"evidence_id\":\"chunk1\"}],\"answer\":\"hidden\"}"
                .into();
        assert!(verify(hidden).is_err());
    }
    #[test]
    fn bm25_retrieves_only_authorized_chunks_and_checks_selected_evidence() {
        let mut example = input("Sydney has 5 offices.", "Sydney has 5 offices.");
        example.query = Some("Sydney offices".into());
        example.response_json.clear();
        let result = verify(example).unwrap();
        assert_eq!(result["phase"], "authorized_retrieval");
        assert_eq!(result["chunks"][0]["id"], "chunk1");
        let mut private = input("Sydney has 5 offices.", "Sydney has 5 offices.");
        private.chunks[0].tenant = "another".into();
        private.query = Some("Sydney offices".into());
        private.response_json.clear();
        assert_eq!(verify(private).unwrap()["chunks"], json!([]));
        let mut absent = input("Sydney has 5 offices.", "Sydney has 5 offices.");
        absent.query = Some("unrelated topic".into());
        assert_eq!(
            verify(absent).unwrap()["claims"][0]["status"],
            "FAIL_LEXICAL"
        );
    }
}
