use arkhe_verify_core::{
    c2pa::claim::canonicalize_claim_v2,
    gguf::canonical::canonicalize_metadata,
    hash::blake3_256,
    mmr::{build_root_and_proof, verify_proof},
};
use serde_json::Value;
#[test]
fn committed_ready_vectors_match_active_verifier() {
    let data: Value =
        serde_json::from_str(include_str!("../../../tests/golden_vectors.json")).unwrap();
    let mut checked = 0;
    for v in data["vectors"].as_array().unwrap() {
        // A documentary candidate is not promoted to a ready protocol by restructuring.
        if v["status"] != "READY" {
            continue;
        }
        checked += 1;
        let input = &v["input"];
        let expected = &v["expected_output"];
        match v["component"].as_str().unwrap() {
            "BLAKE3" => assert_eq!(
                hex::encode(blake3_256(
                    &hex::decode(input["data_hex"].as_str().unwrap()).unwrap()
                )),
                expected["hash_hex"],
                "{}",
                v["id"]
            ),
            "GGUF Canonicalization" => assert_eq!(
                hex::encode(canonicalize_metadata(&input["metadata"]).unwrap()),
                expected["canonical_cbor_hex"]
            ),
            "WormGraph MMR" => {
                let leaves: Vec<Vec<u8>> = input["leaves"]
                    .as_array()
                    .unwrap()
                    .iter()
                    .map(|x| hex::decode(x.as_str().unwrap()).unwrap())
                    .collect();
                for p in expected["proofs"].as_array().unwrap() {
                    let index = p["target_index"].as_u64().unwrap() as usize;
                    let (root, proof) = build_root_and_proof(&leaves, index).unwrap();
                    assert_eq!(hex::encode(root), expected["root_hash_hex"]);
                    assert!(verify_proof(&leaves[index], leaves.len(), &proof, &root).unwrap());
                    let hashes: Vec<_> = proof.iter().map(|s| hex::encode(s.hash)).collect();
                    let kinds: Vec<_> = proof.iter().map(|s| s.kind.clone()).collect();
                    let directions: Vec<_> = proof.iter().map(|s| s.direction.clone()).collect();
                    assert_eq!(serde_json::json!(hashes), p["inclusion_proof_hashes"]);
                    assert_eq!(serde_json::json!(kinds), p["inclusion_proof_kinds"]);
                    assert_eq!(
                        serde_json::json!(directions),
                        p["inclusion_proof_directions"]
                    );
                }
            }
            "C2PA Manifest Parsing" => {
                assert!(canonicalize_claim_v2(&input["claim_json"]).is_err())
            }
            _ => panic!("unhandled READY vector {}", v["id"]),
        }
    }
    assert!(checked > 0);
}
