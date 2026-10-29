use arkhe_verify_core::{
    gov::{self, Bundle, Evidence},
    mmr::build_root_and_proof,
};
use ed25519_dalek::{Signer, SigningKey};
use serde_json::json;
fn main() {
    // PUBLIC TEST KEY ONLY. Never trust this key for real credentials.
    let key = SigningKey::from_bytes(&[71; 32]);
    if std::env::args().any(|a| a == "--trust") {
        println!("{}", hex::encode(key.verifying_key().to_bytes()));
        return;
    }
    let credentials: Vec<String> = (0..4)
        .map(|i| format!("ARKHE-SYNTHETIC-CIN-NOT-VIO:v1:fixture-{i}:nonce-20261021-{i}"))
        .collect();
    let records: Vec<Evidence> = credentials
        .iter()
        .map(|s| Evidence {
            profile: "arkhe-gov-synthetic-v1".into(),
            jurisdiction: "BR".into(),
            credential_type: "CIN_SYNTHETIC".into(),
            credential_digest: gov::credential_digest(s.as_bytes()),
            verifier: "fixture-only-not-vio".into(),
        })
        .collect();
    let leaves: Vec<Vec<u8>> = records
        .iter()
        .map(|r| gov::evidence_leaf(r).unwrap())
        .collect();
    let bundles: Vec<Bundle> = (0..4)
        .map(|i| {
            let (root, proof) = build_root_and_proof(&leaves, i).unwrap();
            Bundle {
                evidence: records[i].clone(),
                leaf_index: i as u32,
                leaf_count: 4,
                proof,
                checkpoint_root: root,
                checkpoint_signature_hex: hex::encode(
                    key.sign(&gov::checkpoint_payload(&root, 4)).to_bytes(),
                ),
            }
        })
        .collect();
    if std::env::args().any(|a| a == "--anchor") {
        let checkpoint = json!({"version":1,"profile_digest":arkhe_verify_core::mmr::profile::PROFILE_DIGEST_HEX,"tenant_id":"synthetic-gov-poc","stream_id":"cin-evidence-v1","leaf_count":4,"mmr_size":7,"mmr_root":hex::encode(bundles[3].checkpoint_root),"covered_up_to_hash":hex::encode(&leaves[3])});
        let canonical = arkhe_verify_core::cbor::canonical::encode_json(&checkpoint).unwrap();
        let mut preimage = b"AKG:CHECKPOINT:v1\0".to_vec();
        preimage.extend_from_slice(&canonical);
        println!("{}",serde_json::to_string_pretty(&json!({"checkpoint":checkpoint,"checkpoint_cbor_hex":hex::encode(canonical),"checkpoint_digest":hex::encode(arkhe_verify_core::hash::blake3_256(&preimage)),"leaf_hex":hex::encode(&leaves[3]),"proof":bundles[3].proof})).unwrap());
        return;
    }
    println!("{}",serde_json::to_string_pretty(&json!({"schema":"arkhe-gov-fixture/v1","synthetic":true,"qrEncoding":"plain-text-fixture-not-CIN-or-VIO","credentialPayloads":credentials,"bundles":bundles,"anchoring":"NOT_PERFORMED","governmentCredentialValidation":"NOT_PERFORMED"})).unwrap());
}
