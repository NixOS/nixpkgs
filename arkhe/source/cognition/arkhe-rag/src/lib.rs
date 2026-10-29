use arkhe_cognition_sdk::{worker::WorkerExecutionRecord, Digest32};

pub mod citation;
pub mod decoder;
pub mod ncm_harness;
pub mod retrieval;
pub mod vq_tokenv;

#[derive(Debug, Clone)]
pub struct Citation {
    pub source_ref: Digest32,
    pub chunk_digest: Digest32,
}

#[derive(Debug, Clone)]
pub struct RagResponse {
    pub answer_digest: Digest32,
    pub citations: Vec<Citation>,
    pub grounded: bool,
}

pub fn build_response(
    query: &[u8],
    answer: &[u8],
    citations: Vec<Citation>,
) -> (RagResponse, WorkerExecutionRecord) {
    let input_digest = Digest32::blake3(b"AKG:RAG:QUERY:v0\0", query);
    let answer_digest = Digest32::blake3(b"AKG:RAG:ANSWER:v0\0", answer);
    let grounded = !citations.is_empty();
    let refs = citations.iter().map(|c| c.source_ref).collect();
    let response = RagResponse {
        answer_digest,
        citations,
        grounded,
    };
    let record = WorkerExecutionRecord {
        classification: None,
        operation: None,
        module_id: "arkhe-rag".into(),
        module_version: env!("CARGO_PKG_VERSION").into(),
        input_digest,
        output_digest: answer_digest,
        evidence_refs: refs,
        confidence_bps: None,
        uncertainty_note: if grounded {
            None
        } else {
            Some("response has no citations".into())
        },
        execution_id: format!("rag:{}", answer_digest.to_hex()),
    };
    (response, record)
}
/// A candidate must be authorized before its bytes are used to assemble a prompt.
/// This does not classify malicious natural language; retrieved content remains untrusted.
pub struct RetrievalChunk {
    pub tenant: String,
    pub readers: Vec<String>,
    pub content: Vec<u8>,
    pub expected_digest: Digest32,
    pub source_ref: Digest32,
}
pub fn authorized_retrieval<'a>(
    tenant: &str,
    subject: &str,
    chunks: &'a [RetrievalChunk],
) -> Result<Vec<&'a RetrievalChunk>, &'static str> {
    if tenant.trim().is_empty() || subject.trim().is_empty() {
        return Err("identity required");
    }
    let mut result = Vec::new();
    for chunk in chunks {
        if chunk.tenant != tenant || !chunk.readers.iter().any(|s| s == subject) {
            continue;
        }
        if chunk.content.len() > 32768
            || Digest32::blake3(b"AKG:RAG:CHUNK:v1\0", &chunk.content) != chunk.expected_digest
        {
            return Err("invalid retrieved chunk");
        }
        result.push(chunk);
    }
    if result.len() > 32 {
        return Err("retrieval budget exceeded");
    }
    Ok(result)
}
