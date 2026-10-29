use arkhe_verify_core::gguf::supply_chain::*;
use ed25519_dalek::{Signer, SigningKey};

pub fn text(bytes: &mut Vec<u8>, value: &str) {
    bytes.extend((value.len() as u64).to_le_bytes());
    bytes.extend(value.as_bytes());
}

pub fn artifact() -> Vec<u8> {
    let mut bytes = b"GGUF".to_vec();
    bytes.extend(3u32.to_le_bytes());
    bytes.extend(1u64.to_le_bytes()); // one F32 tensor
    bytes.extend(2u64.to_le_bytes());
    for (key, value) in [
        ("general.architecture", "arkhe_lab"),
        ("general.name", "synthetic-stage10"),
    ] {
        text(&mut bytes, key);
        bytes.extend(8u32.to_le_bytes());
        text(&mut bytes, value);
    }
    text(&mut bytes, "lab.weight");
    bytes.extend(1u32.to_le_bytes()); // dimension count
    bytes.extend(1u64.to_le_bytes()); // one element
    bytes.extend(0u32.to_le_bytes()); // F32
    bytes.extend(0u64.to_le_bytes()); // offset relative to tensor section
    bytes.resize(bytes.len().div_ceil(32) * 32, 0);
    bytes.extend(1.0f32.to_le_bytes());
    bytes
}

/// Public, deterministic laboratory keys; these confer no production trust.
pub fn fixture() -> (Vec<u8>, Bundle, Trust) {
    let bytes = artifact();
    let builder = SigningKey::from_bytes(&[10; 32]);
    let log = SigningKey::from_bytes(&[11; 32]);
    let statement = statement(&bytes, "lab:arkhe:builder".into()).unwrap();
    let sig = hex::encode(
        builder
            .sign(&statement_bytes(&statement).unwrap())
            .to_bytes(),
    );
    let mut bundle = Bundle {
        statement,
        builder_signature_hex: sig,
        checkpoint: Checkpoint {
            log_id: "lab:arkhe:log".into(),
            tree_size: 2,
            root_hex: String::new(),
            issued_at: 1000,
            signature_hex: String::new(),
        },
        leaf_index: 0,
        inclusion_path: vec![hex::encode(leaf_hash(b"independent synthetic log entry"))],
    };
    let root = node_hash(
        &leaf_hash(&log_leaf(&bundle).unwrap()),
        &leaf_hash(b"independent synthetic log entry"),
    );
    bundle.checkpoint.root_hex = hex::encode(root);
    bundle.checkpoint.signature_hex = hex::encode(
        log.sign(&checkpoint_bytes(&bundle.checkpoint).unwrap())
            .to_bytes(),
    );
    let trust = Trust {
        builder_id: "lab:arkhe:builder".into(),
        builder_public_key_hex: hex::encode(builder.verifying_key().as_bytes()),
        log_id: "lab:arkhe:log".into(),
        log_public_key_hex: hex::encode(log.verifying_key().as_bytes()),
        minimum_tree_size: 2,
        earliest_issued_at: 900,
        latest_issued_at: 1100,
    };
    (bytes, bundle, trust)
}
