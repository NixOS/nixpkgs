//! E01 synthetic fixtures; stdout is JSON, no network or keys.
use arkhe_verify_core::mmr::{build_root_and_proof, verify_proof};
use serde_json::json;
use std::time::Instant;

fn main() {
    let mut batches = Vec::new();
    for n in [1000usize, 5000, 10000] {
        let leaves: Vec<Vec<u8>> = (0..n)
            .map(|i| format!("arkhe-e01/v1/seed-20261019/{n}/{i}").into_bytes())
            .collect();
        let mut dataset = Vec::new();
        for leaf in &leaves {
            dataset.extend_from_slice(&(leaf.len() as u32).to_be_bytes());
            dataset.extend_from_slice(leaf);
        }
        let start = Instant::now();
        let (root, _) = build_root_and_proof(&leaves, 0).unwrap();
        let build_us = start.elapsed().as_micros() as u64;
        let mut proofs = Vec::new();
        for sample in 0..100usize {
            let index = sample * (n - 1) / 99;
            let (computed, proof) = build_root_and_proof(&leaves, index).unwrap();
            assert_eq!(root, computed);
            let start = Instant::now();
            assert!(verify_proof(&leaves[index], n, &proof, &root).unwrap());
            let verify_ns = start.elapsed().as_nanos() as u64;
            let steps: Vec<_> = proof
                .iter()
                .map(|s| {
                    json!({
                        "kind":s.kind,"direction":s.direction,"hashHex":hex::encode(s.hash)
                    })
                })
                .collect();
            proofs.push(json!({"index":index,"native_verify_ns":verify_ns,
                "request":{"leafHex":hex::encode(&leaves[index]),"leafCount":n,
                "expectedRootHex":hex::encode(root),"proof":steps}}));
        }
        use sha2::{Digest, Sha256};
        let dataset_sha256 = hex::encode(Sha256::digest(&dataset));
        batches.push(
            json!({"leaf_count":n,"leaves_hex":leaves.iter().map(hex::encode).collect::<Vec<_>>(),
            "dataset_encoding":"u32be(length)||leaf, repeated in index order",
            "dataset_sha256":dataset_sha256,
            "root_hex":hex::encode(root),"root_build_us":build_us,"proofs":proofs}),
        );
    }
    println!(
        "{}",
        json!({"schema":1,"seed":"seed-20261019","synthetic":true,"batches":batches})
    );
}
