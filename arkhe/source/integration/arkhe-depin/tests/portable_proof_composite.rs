use arkhe_depin::{
    adapters::gensyn::{GensynAdapter, VerdeReceipt},
    proof::{CompositeProof, Mmr},
    types::{AttestedReceipt, HardwareAttestation},
};

fn receipt() -> AttestedReceipt {
    let raw: VerdeReceipt = serde_json::from_str(include_str!(
        "../fixtures/gensyn_verde_receipt.synthetic.json"
    ))
    .unwrap();
    AttestedReceipt {
        receipt: GensynAdapter::normalize(&raw).unwrap(),
        hardware_attestation: None,
    }
}

#[test]
fn normalization_is_deterministic_and_rejects_invalid_fields() {
    let receipt = receipt().receipt;
    GensynAdapter::validate(&receipt).unwrap();
    let mut raw: VerdeReceipt = serde_json::from_slice(&receipt.payload).unwrap();
    assert_eq!(
        raw.to_native_receipt().unwrap().receipt_hash,
        receipt.receipt_hash
    );
    raw.providers.push(raw.providers[0].clone());
    assert!(raw.to_native_receipt().is_err());
    raw.providers.pop();
    raw.referee_signature.clear();
    assert!(raw.to_native_receipt().is_err());
}

#[test]
fn offline_roundtrip_across_mmr_peak_boundaries() {
    let mut mmr = Mmr::new();
    assert!(mmr.checkpoint().is_err());
    for i in 0..9 {
        let mut attested = receipt();
        if i % 2 == 0 {
            attested.hardware_attestation = Some(HardwareAttestation {
                nras_jwt: Some("opaque-unverified-token".into()),
                ppcie_report: None,
                nonce: [i; 32],
                gpu_measurement: None,
            });
        }
        let proof = CompositeProof::anchor(&attested, &mut mmr).unwrap();
        let trusted = mmr.checkpoint().unwrap();
        let exported = serde_json::to_vec(&proof).unwrap();
        let imported: CompositeProof = serde_json::from_slice(&exported).unwrap();
        imported.verify(&trusted).unwrap();
    }
}

#[test]
fn rejects_content_hardware_checkpoint_and_path_tampering() {
    let mut mmr = Mmr::new();
    CompositeProof::anchor(&receipt(), &mut mmr).unwrap();
    let proof = CompositeProof::anchor(&receipt(), &mut mmr).unwrap();
    let trusted = mmr.checkpoint().unwrap();
    let mut changed = proof.clone();
    changed.attested.receipt.payload[0] ^= 1;
    assert!(changed.verify(&trusted).is_err());
    let mut changed = proof.clone();
    changed.attested.receipt.issued_at += 1;
    assert!(changed.verify(&trusted).is_err());
    let mut changed = proof.clone();
    changed.attested.hardware_attestation = Some(HardwareAttestation {
        nras_jwt: None,
        ppcie_report: None,
        nonce: [0; 32],
        gpu_measurement: None,
    });
    assert!(changed.verify(&trusted).is_err());
    let mut changed = proof.clone();
    changed.inclusion_proof.steps[0].hash[0] ^= 1;
    assert!(changed.verify(&trusted).is_err());
    let mut changed = trusted.clone();
    changed.root[0] ^= 1;
    assert!(proof.verify(&changed).is_err());
    let mut changed = proof.clone();
    changed.inclusion_proof.checkpoint.leaf_count += 1;
    assert!(changed.verify(&trusted).is_err());
}

#[test]
fn invalid_receipt_does_not_mutate_mmr() {
    let mut mmr = Mmr::new();
    CompositeProof::anchor(&receipt(), &mut mmr).unwrap();
    let before = mmr.checkpoint().unwrap();
    let mut invalid = receipt();
    invalid.receipt.receipt_hash.0[0] ^= 1;
    assert!(CompositeProof::anchor(&invalid, &mut mmr).is_err());
    assert_eq!(before, mmr.checkpoint().unwrap());
}
