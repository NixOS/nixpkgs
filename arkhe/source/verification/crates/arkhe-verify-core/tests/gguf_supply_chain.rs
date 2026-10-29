#[path = "support/gguf_fixture.rs"]
mod fixture;
use arkhe_verify_core::gguf::supply_chain::*;
use ed25519_dalek::{Signer, SigningKey};

fn fails_at(bytes: &[u8], bundle: &Bundle, trust: &Trust, gate: u8) {
    let error = verify(bytes, bundle, trust).unwrap_err().to_string();
    assert!(error.contains(&format!("gate {gate}:")), "{error}");
}

#[test]
fn synthetic_gguf_passes_all_four_gates() {
    let (bytes, bundle, trust) = fixture::fixture();
    let report = verify(&bytes, &bundle, &trust).unwrap();
    assert_eq!(report.gates_passed.len(), 4);
    assert_eq!(report.tree_size, 2);
}

#[test]
fn minimal_24_byte_header_is_not_an_accepted_model_in_the_lab_profile() {
    let mut header = b"GGUF".to_vec();
    header.extend(3u32.to_le_bytes());
    header.extend(0u64.to_le_bytes());
    header.extend(0u64.to_le_bytes());
    assert_eq!(header.len(), 24);
    assert!(inspect(&header)
        .unwrap_err()
        .to_string()
        .contains("count outside profile"));
    header[0] ^= 1;
    assert!(inspect(&header).is_err());
}

#[test]
fn rejects_truncation_unknown_versions_counts_and_trailing_bytes() {
    let (bytes, bundle, trust) = fixture::fixture();
    for length in 0..bytes.len() {
        fails_at(&bytes[..length], &bundle, &trust, 1);
    }
    let mut bad = bytes.clone();
    bad[4] = 2;
    fails_at(&bad, &bundle, &trust, 1);
    let mut bad = bytes.clone();
    bad[16..24].copy_from_slice(&u64::MAX.to_le_bytes());
    fails_at(&bad, &bundle, &trust, 1);
    let mut bad = bytes.clone();
    bad.push(0);
    fails_at(&bad, &bundle, &trust, 1);
    fails_at(&vec![0; MAX_ARTIFACT_BYTES + 1], &bundle, &trust, 1);
}

#[test]
fn rejects_unsafe_duplicate_and_unsupported_metadata() {
    let (bytes, bundle, trust) = fixture::fixture();
    // First key begins at byte 32; its value type follows the 20-byte key.
    let key_start = 32;
    let mut bad = bytes.clone();
    bad[key_start] = b'!';
    fails_at(&bad, &bundle, &trust, 1);
    let mut bad = bytes.clone();
    bad[52..56].copy_from_slice(&9u32.to_le_bytes());
    fails_at(&bad, &bundle, &trust, 1);
    // Insert another copy of the first metadata entry before the second.
    let first_end = 56 + 8 + "arkhe_lab".len();
    let mut bad = bytes.clone();
    bad.splice(first_end..first_end, bytes[24..first_end].iter().copied());
    bad[16..24].copy_from_slice(&3u64.to_le_bytes());
    fails_at(&bad, &bundle, &trust, 1);
    let mut bad = bytes.clone();
    bad[64] = 0;
    fails_at(&bad, &bundle, &trust, 1);
}

#[test]
fn rejects_tensor_dimension_overflow_alignment_and_type() {
    let (bytes, bundle, trust) = fixture::fixture();
    let tensor_name = bytes.windows(10).position(|w| w == b"lab.weight").unwrap();
    let dimensions = tensor_name + 10;
    let mut bad = bytes.clone();
    bad[dimensions..dimensions + 4].copy_from_slice(&0u32.to_le_bytes());
    fails_at(&bad, &bundle, &trust, 1);
    let mut bad = bytes.clone();
    bad[dimensions + 4..dimensions + 12].copy_from_slice(&u64::MAX.to_le_bytes());
    fails_at(&bad, &bundle, &trust, 1);
    let mut bad = bytes.clone();
    bad[dimensions + 12..dimensions + 16].copy_from_slice(&1u32.to_le_bytes());
    fails_at(&bad, &bundle, &trust, 1);
    let mut bad = bytes.clone();
    bad[dimensions + 16..dimensions + 24].copy_from_slice(&1u64.to_le_bytes());
    fails_at(&bad, &bundle, &trust, 1);
}

#[test]
fn rejects_overlapping_tensor_ranges() {
    let (bytes, bundle, trust) = fixture::fixture();
    let name = bytes.windows(10).position(|w| w == b"lab.weight").unwrap();
    let descriptor_start = name - 8;
    let descriptor_end = name + 10 + 24;
    let mut bad = bytes[..descriptor_end].to_vec();
    bad[8..16].copy_from_slice(&2u64.to_le_bytes());
    let mut second = bytes[descriptor_start..descriptor_end].to_vec();
    second[8..18].copy_from_slice(b"lab.weighu");
    bad.extend(second);
    bad.resize(bad.len().div_ceil(32) * 32, 0);
    bad.extend(1.0f32.to_le_bytes());
    fails_at(&bad, &bundle, &trust, 1);
}

#[test]
fn binds_both_artifact_digests_and_metadata_digest() {
    let (mut bytes, bundle, trust) = fixture::fixture();
    let last = bytes.len() - 1;
    bytes[last] ^= 1;
    fails_at(&bytes, &bundle, &trust, 2);
    let (bytes, mut bundle, trust) = fixture::fixture();
    bundle.statement.artifact_blake3 = "00".repeat(32);
    fails_at(&bytes, &bundle, &trust, 2);
    let (_, mut bundle, _) = fixture::fixture();
    bundle.statement.artifact_sha256 = "00".repeat(32);
    fails_at(&bytes, &bundle, &trust, 2);
    let (_, mut bundle, _) = fixture::fixture();
    bundle.statement.metadata_sha256 = "00".repeat(32);
    fails_at(&bytes, &bundle, &trust, 2);
}

#[test]
fn rejects_wrong_builder_identity_key_and_signature() {
    let (bytes, mut bundle, mut trust) = fixture::fixture();
    trust.builder_id = "attacker".into();
    fails_at(&bytes, &bundle, &trust, 3);
    let (_, _, mut trust) = fixture::fixture();
    trust.builder_public_key_hex =
        hex::encode(SigningKey::from_bytes(&[12; 32]).verifying_key().as_bytes());
    fails_at(&bytes, &bundle, &trust, 3);
    let (_, _, trust) = fixture::fixture();
    bundle.builder_signature_hex = "00".repeat(64);
    fails_at(&bytes, &bundle, &trust, 3);
}

#[test]
fn rejects_wrong_log_key_identity_signature_and_stale_checkpoint() {
    let (bytes, bundle, mut trust) = fixture::fixture();
    trust.log_id = "untrusted-log".into();
    fails_at(&bytes, &bundle, &trust, 4);
    let (_, _, mut trust) = fixture::fixture();
    trust.log_public_key_hex =
        hex::encode(SigningKey::from_bytes(&[12; 32]).verifying_key().as_bytes());
    fails_at(&bytes, &bundle, &trust, 4);
    let (_, mut bundle, trust) = fixture::fixture();
    bundle.checkpoint.signature_hex = "00".repeat(64);
    fails_at(&bytes, &bundle, &trust, 4);
    let (_, bundle, mut trust) = fixture::fixture();
    trust.earliest_issued_at = 1001;
    fails_at(&bytes, &bundle, &trust, 4);
    let (_, _, mut trust) = fixture::fixture();
    trust.minimum_tree_size = 3;
    fails_at(&bytes, &bundle, &trust, 4);
}

#[test]
fn rejects_inclusion_tampering_even_with_valid_checkpoint_signature() {
    let (bytes, mut bundle, trust) = fixture::fixture();
    bundle.inclusion_path[0] = "00".repeat(32);
    fails_at(&bytes, &bundle, &trust, 4);
    let (_, mut bundle, _) = fixture::fixture();
    bundle.inclusion_path.clear();
    fails_at(&bytes, &bundle, &trust, 4);
    let (_, mut bundle, _) = fixture::fixture();
    bundle.leaf_index = 2;
    fails_at(&bytes, &bundle, &trust, 4);
    let (_, mut bundle, _) = fixture::fixture();
    bundle.checkpoint.root_hex = "00".repeat(32);
    bundle.checkpoint.signature_hex = hex::encode(
        SigningKey::from_bytes(&[11; 32])
            .sign(&checkpoint_bytes(&bundle.checkpoint).unwrap())
            .to_bytes(),
    );
    fails_at(&bytes, &bundle, &trust, 4);
}

#[test]
fn rfc6962_unbalanced_tree_and_exact_path_consumption() {
    let leaves = [leaf_hash(b"a"), leaf_hash(b"b"), leaf_hash(b"c")];
    let left = node_hash(&leaves[0], &leaves[1]);
    let root = node_hash(&left, &leaves[2]);
    // Frozen independent hashlib calculation of SHA256(01 || SHA256(01 ||
    // SHA256(00 || a) || SHA256(00 || b)) || SHA256(00 || c)).
    assert_eq!(
        hex::encode(root),
        "36642e73c2540ab121e3a6bf9545b0a24982cd830eb13d3cd19de3ce6c021ec1"
    );
    assert!(verify_inclusion(b"a", 0, 3, &[leaves[1], leaves[2]], root).is_ok());
    assert!(verify_inclusion(b"b", 1, 3, &[leaves[0], leaves[2]], root).is_ok());
    assert!(verify_inclusion(b"c", 2, 3, &[left], root).is_ok());
    assert!(verify_inclusion(b"c", 2, 3, &[left, leaves[0]], root).is_err());
    assert!(verify_inclusion(b"c", 2, 3, &[], root).is_err());
    assert!(verify_inclusion(b"a", 0, 1, &[], leaves[0]).is_ok());
    assert!(verify_inclusion(b"a", 0, 0, &[], leaves[0]).is_err());
}
