fn main() {
    let leaves = vec![b"one".to_vec(), b"two".to_vec(), b"three".to_vec()];
    let (root, proof) = arkhe_verify_core::mmr::build_root_and_proof(&leaves, 1).unwrap();
    println!(
        "{}",
        serde_json::json!({"leaf": leaves[1], "leaf_count": 3, "proof": proof, "root": root})
    );
}
