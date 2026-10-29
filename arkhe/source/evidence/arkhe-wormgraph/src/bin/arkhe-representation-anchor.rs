//! Local application evidence only: not a WER admission or an external timestamp.
use arkhe_core::{
    evidence::{EvidenceCommitter, EvidenceEnvelope, EvidenceReader},
    Digest32,
};
use arkhe_wormgraph::{regenerate::rebuild, WormGraph};
use ed25519_dalek::{Signature, VerifyingKey};
use serde::Deserialize;
use serde_json::json;
use std::io::{self, Read};

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Input {
    statement: String,
    public_key_hex: String,
    signature_hex: String,
}

async fn run(input: Input) -> Result<serde_json::Value, String> {
    if input.statement.len() > 16_384 {
        return Err("statement too large".into());
    }
    let key_bytes: [u8; 32] = hex::decode(input.public_key_hex)
        .map_err(|_| "invalid key")?
        .try_into()
        .map_err(|_| "invalid key length")?;
    let signature =
        Signature::from_slice(&hex::decode(input.signature_hex).map_err(|_| "invalid signature")?)
            .map_err(|_| "invalid signature length")?;
    VerifyingKey::from_bytes(&key_bytes)
        .map_err(|_| "invalid key")?
        .verify_strict(input.statement.as_bytes(), &signature)
        .map_err(|_| "invalid declaration signature")?;
    let statement: serde_json::Value =
        serde_json::from_str(&input.statement).map_err(|_| "invalid statement JSON")?;
    if statement["domain"] != "arkhe-enterprise/representation-declaration/v1" {
        return Err("invalid declaration domain".into());
    }
    let documents = statement["documents"]
        .as_array()
        .filter(|docs| (2..=4).contains(&docs.len()))
        .ok_or("invalid documents")?;
    let cnpj = statement["cnpj"].as_str().ok_or("missing CNPJ")?;
    let subject = Digest32::blake3(b"arkhe-enterprise/company/v1\0", cnpj.as_bytes());
    let graph = WormGraph::new();
    let mut envelopes = Vec::new();
    let mut hashes = Vec::new();
    for document in documents {
        let bytes = serde_json::to_vec(document).map_err(|_| "invalid document")?;
        let record_hash =
            Digest32::blake3(b"arkhe-enterprise/representation-document/v1\0", &bytes);
        let envelope = EvidenceEnvelope {
            record_hash,
            kind: "EnterpriseRepresentationDocumentHash".into(),
            subject,
            payload_digest: record_hash,
            policy_digest: None,
            causal_parents: vec![],
        };
        graph.append_verified(envelope.clone()).await?;
        envelopes.push(envelope);
        hashes.push(record_hash);
    }
    let declaration_digest = Digest32::blake3(
        b"arkhe-enterprise/representation-declaration/v1\0",
        input.statement.as_bytes(),
    );
    let declaration = EvidenceEnvelope {
        record_hash: declaration_digest,
        kind: "EnterpriseRepresentationSelfDeclaration".into(),
        subject,
        payload_digest: declaration_digest,
        policy_digest: None,
        causal_parents: hashes.clone(),
    };
    graph.append_verified(declaration.clone()).await?;
    if graph.get(declaration_digest).await? != Some(declaration.clone()) {
        return Err("WormGraph readback mismatch".into());
    }
    hashes.push(declaration_digest);
    envelopes.push(declaration);
    let snapshot = rebuild(&hashes).map_err(|_| "checkpoint rebuild failed")?;
    Ok(json!({
        "format":"arkhe-enterprise/local-wormgraph-representation/v1",
        "scope":"self-declaration; local application evidence; no external timestamp or WER admission",
        "declarationDigest":declaration_digest.to_hex(),
        "root":snapshot.root.to_hex(), "leafCount":snapshot.leaf_count,
        "mmrSize":snapshot.mmr_size,
        "profileDigest":arkhe_verify_core::mmr::profile::PROFILE_DIGEST_HEX,
        "recordHashes":hashes.iter().map(|hash| hash.to_hex()).collect::<Vec<_>>(),
        "envelopes":envelopes,
    }))
}

#[tokio::main(flavor = "current_thread")]
async fn main() {
    let mut bytes = Vec::new();
    let result = io::stdin()
        .take(32_769)
        .read_to_end(&mut bytes)
        .map_err(|_| "input unavailable".to_string());
    let result = match result {
        Ok(_) if bytes.len() <= 32_768 => match serde_json::from_slice(&bytes) {
            Ok(input) => run(input).await,
            Err(_) => Err("invalid input".into()),
        },
        _ => Err("input too large or unavailable".into()),
    };
    match result {
        Ok(value) => println!("{value}"),
        Err(error) => {
            eprintln!("{error}");
            std::process::exit(1);
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use ed25519_dalek::{Signer, SigningKey};

    fn fixture() -> Input {
        let key = SigningKey::from_bytes(&[7; 32]);
        let statement = json!({"domain":"arkhe-enterprise/representation-declaration/v1","cnpj":"12ABC34501DE35","documents":[{"kind":"constitution","sha256":"a".repeat(64)},{"kind":"identity","sha256":"b".repeat(64)}]}).to_string();
        let signature = key.sign(statement.as_bytes());
        Input {
            statement,
            public_key_hex: hex::encode(key.verifying_key().to_bytes()),
            signature_hex: hex::encode(signature.to_bytes()),
        }
    }

    #[tokio::test]
    async fn real_wormgraph_records_rebuild_a_deterministic_checkpoint() {
        let first = run(fixture()).await.unwrap();
        let second = run(fixture()).await.unwrap();
        assert_eq!(first, second);
        assert_eq!(first["leafCount"], 3);
        assert_eq!(first["envelopes"].as_array().unwrap().len(), 3);
        assert_eq!(first["root"].as_str().unwrap().len(), 64);
    }

    #[tokio::test]
    async fn changed_signature_and_domain_fail_closed() {
        let mut bad = fixture();
        bad.statement.push(' ');
        assert!(run(bad).await.is_err());
        let mut bad = fixture();
        let key = SigningKey::from_bytes(&[7; 32]);
        bad.statement = bad.statement.replace("declaration/v1", "declaration/v2");
        bad.signature_hex = hex::encode(key.sign(bad.statement.as_bytes()).to_bytes());
        assert!(run(bad).await.is_err());
    }
}
