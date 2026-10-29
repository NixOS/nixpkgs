use arkhe_verify_core::mmr::{build_root_and_proof, verify_proof, verify_proof_at};

#[test]
fn proof_roundtrip_for_1_3_4_5_7_leaves() {
    for n in [1usize, 3, 4, 5, 7] {
        let leaves = (1..=n)
            .map(|i| {
                let mut b = vec![0u8; 32];
                b[31] = i as u8;
                b
            })
            .collect::<Vec<_>>();

        for i in 0..n {
            let (root, proof) = build_root_and_proof(&leaves, i).unwrap();
            assert!(verify_proof(&leaves[i], n, &proof, &root).unwrap());
            assert!(verify_proof_at(&leaves[i], n, i, &proof, &root).unwrap());
            let mut changed = leaves[i].clone();
            changed[0] ^= 1;
            assert!(!verify_proof_at(&changed, n, i, &proof, &root).unwrap());
            for j in 0..n {
                if i != j {
                    assert!(verify_proof_at(&leaves[i], n, j, &proof, &root).is_err());
                }
            }
            for position in 0..proof.len() {
                let mut changed = proof.clone();
                changed[position].hash[0] ^= 1;
                assert!(!verify_proof(&leaves[i], n, &changed, &root).unwrap());
            }
            let mut extra = proof.clone();
            extra.push(arkhe_verify_core::mmr::ProofStep {
                kind: "node".into(),
                direction: "left".into(),
                hash: [0; 32],
            });
            assert!(verify_proof_at(&leaves[i], n, i, &extra, &root).is_err());
        }
    }
}

#[test]
fn single_leaf_root_cannot_claim_a_larger_tree_or_unbounded_count() {
    let (root, proof) = build_root_and_proof(&[b"leaf".to_vec()], 0).unwrap();
    assert!(verify_proof(b"leaf", 7, &proof, &root).is_err());
    assert!(verify_proof(b"leaf", usize::MAX, &proof, &root).is_err());
    assert!(verify_proof_at(b"leaf", 0, 0, &proof, &root).is_err());
}
