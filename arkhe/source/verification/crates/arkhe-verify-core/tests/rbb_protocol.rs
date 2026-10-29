use arkhe_verify_core::rbb::{self, mmr, Envelope, Error, Header};
use serde_json::Value;

fn vector() -> Value {
    serde_json::from_str(include_str!(
        "../../../../integration/arkhe-rbb/fixtures/protocol-v3.json"
    ))
    .unwrap()
}
fn header() -> Header {
    serde_json::from_value(vector()["header"].clone()).unwrap()
}
fn envelope() -> Envelope {
    Envelope {
        header: header(),
        ed25519_signature: vec![0x55; 64],
        mldsa_signature: vec![0xaa; 2420],
    }
}

#[test]
fn python_abi_keccak_and_rust_match_byte_for_byte() {
    let v = vector();
    let h = header();
    let e = envelope();
    assert_eq!(
        hex::encode(h.encode().unwrap()),
        v["header_abi_hex"].as_str().unwrap()
    );
    assert_eq!(
        hex::encode(h.checkpoint_id().unwrap()),
        v["checkpoint_id_hex"].as_str().unwrap()
    );
    assert_eq!(
        hex::encode(e.encode().unwrap()),
        v["envelope_abi_hex"].as_str().unwrap()
    );
    assert_eq!(
        hex::encode(e.commitment().unwrap()),
        v["envelope_commitment_hex"].as_str().unwrap()
    );
    assert_eq!(Header::decode(&h.encode().unwrap()).unwrap(), h);
    assert_eq!(Envelope::decode(&e.encode().unwrap()).unwrap(), e);
}

#[test]
fn rejects_padding_offsets_trailing_data_and_oversized_input() {
    let raw = envelope().encode().unwrap();
    for i in [0, 32, 4 * 32, 24 * 32, 864, 896, 928, 1024, 3487] {
        let mut bad = raw.clone();
        bad[i] ^= 0x80;
        assert!(Envelope::decode(&bad).is_err(), "byte {i}");
    }
    let mut extra = raw.clone();
    extra.push(0);
    assert_eq!(Envelope::decode(&extra), Err(Error::NonCanonical));
    assert!(Envelope::decode(&raw[..raw.len() - 1]).is_err());
    assert!(Header::decode(&vec![0; 1_000_000]).is_err());
}

#[test]
fn rejects_invalid_intervals_flags_algorithms_and_zero_identifiers() {
    let mut bad = header();
    bad.first_leaf_index = u64::MAX;
    bad.batch_leaf_count = 2;
    assert!(bad.validate().is_err());
    let mut bad = header();
    bad.sequence = 0;
    assert!(bad.validate().is_err());
    let mut bad = header();
    bad.prev_present = true;
    assert!(bad.validate().is_err());
    let mut bad = header();
    bad.source_kind = 2;
    assert!(bad.validate().is_err());
    let mut bad = header();
    bad.profile_id = 4;
    assert_eq!(bad.validate(), Err(Error::Profile));
    let mut bad = header();
    bad.ed25519_key_id = [0; 32];
    assert!(bad.validate().is_err());
    let mut bad = envelope();
    bad.mldsa_signature.pop();
    assert_eq!(bad.encode(), Err(Error::SignatureLength));
}

#[test]
fn identity_changes_with_every_header_word_and_is_independent_of_signature_randomness() {
    let h = header();
    let raw = h.encode().unwrap();
    let id = h.checkpoint_id().unwrap();
    for word in 0..27 {
        let mut altered = raw.clone();
        altered[word * 32 + 31] ^= 1;
        if let Ok(changed) = Header::decode(&altered) {
            assert_ne!(changed.checkpoint_id().unwrap(), id);
        }
    }
    let e = envelope();
    let mut changed = e.clone();
    changed.mldsa_signature[0] ^= 1;
    assert_eq!(changed.header.checkpoint_id().unwrap(), id);
    assert_ne!(changed.commitment().unwrap(), e.commitment().unwrap());
    assert_ne!(rbb::keccak(b"a"), rbb::keccak(b"b"));
}

#[test]
fn mmr_matches_independent_python_and_checks_every_position() {
    let v = vector();
    for item in v["mmr"].as_array().unwrap() {
        let n = item["count"].as_u64().unwrap() as usize;
        let records: Vec<_> = (0..n).map(|i| [(i + 1) as u8; 32]).collect();
        let mut frontier = mmr::Frontier::default();
        for (i, r) in records.iter().enumerate() {
            assert_eq!(frontier.append(r).unwrap(), i as u64);
        }
        let root = frontier.root().unwrap();
        assert_eq!(hex::encode(root), item["root_hex"].as_str().unwrap());
        for (i, r) in records.iter().enumerate() {
            let proof = mmr::prove(&records, i).unwrap();
            mmr::verify(r, &proof, n as u64, &root).unwrap();
            let mut bad = proof.clone();
            bad.leaf_count += 1;
            assert!(mmr::verify(r, &bad, n as u64, &root).is_err());
            let mut bad = proof.clone();
            bad.siblings.push([0; 32]);
            assert!(mmr::verify(r, &bad, n as u64, &root).is_err());
            let mut bad = proof.clone();
            bad.other_peaks.push([0; 32]);
            assert!(mmr::verify(r, &bad, n as u64, &root).is_err());
            assert!(mmr::verify(&[255; 32], &proof, n as u64, &root).is_err());
        }
    }
}

#[test]
fn mmr_extension_requires_authenticated_previous_frontier_and_exact_count() {
    let records: Vec<_> = (1..=13).map(|i| [i; 32]).collect();
    let mut previous = mmr::Frontier::default();
    for r in &records[..5] {
        previous.append(r).unwrap();
    }
    let old = previous.root().unwrap();
    let mut next = previous.clone();
    for r in &records[5..] {
        next.append(r).unwrap();
    }
    mmr::verify_extension(&previous, &old, &records[5..], 13, &next.root().unwrap()).unwrap();
    assert!(mmr::verify_extension(
        &previous,
        &[0; 32],
        &records[5..],
        13,
        &next.root().unwrap()
    )
    .is_err());
    assert!(
        mmr::verify_extension(&previous, &old, &records[5..], 12, &next.root().unwrap()).is_err()
    );
    let mut invalid = previous.clone();
    invalid.peaks.clear();
    assert!(invalid.append(&[0; 32]).is_err());
    let mut max = mmr::Frontier {
        count: u64::MAX,
        peaks: vec![[1; 32]; 64],
    };
    assert_eq!(max.append(&[2; 32]), Err(Error::ResourceLimit));
}

proptest::proptest! {
    #[test]
    fn arbitrary_bytes_do_not_panic(raw in proptest::collection::vec(proptest::num::u8::ANY, 0..4000)) {
        let _=Header::decode(&raw); let _=Envelope::decode(&raw);
    }
}
