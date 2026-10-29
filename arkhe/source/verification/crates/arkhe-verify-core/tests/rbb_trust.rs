#![cfg(feature = "rbb-pqc")]
use arkhe_verify_core::rbb::trust::*;
use arkhe_verify_core::rbb::{keccak, mmr, Envelope, Error, Header, MLDSA_CONTEXT};
use ed25519_dalek::{Signer as _, SigningKey};
use fips204::{
    ml_dsa_44,
    traits::{KeyGen, SerDes, Signer as _},
};

fn material(seed: u8) -> (HybridKey, SigningKey, ml_dsa_44::PrivateKey) {
    let ed = SigningKey::from_bytes(&[seed; 32]);
    let (pk, sk) = ml_dsa_44::KG::keygen_from_seed(&[seed; 32]);
    (
        HybridKey {
            ed25519: ed.verifying_key().to_bytes(),
            mldsa: pk.into_bytes().to_vec(),
        },
        ed,
        sk,
    )
}
fn signatures(seed: u8, digest: &[u8; 32], context: &[u8]) -> (Vec<u8>, Vec<u8>) {
    let (_, ed, ml) = material(seed);
    (
        ed.sign(digest).to_bytes().to_vec(),
        ml.try_sign_with_seed(&[seed.wrapping_add(1); 32], digest, context)
            .unwrap()
            .to_vec(),
    )
}
fn votes(a: &Assessment, e: &Envelope) -> Vec<Vote> {
    (10..14)
        .map(|seed| {
            let (ed, ml) = signatures(seed, &a.digest(e).unwrap(), ATTEST_CONTEXT);
            Vote {
                witness_id: [seed; 32],
                ed25519_signature: ed,
                mldsa_signature: ml,
            }
        })
        .collect()
}
fn fixture() -> (Envelope, Keyset, Assessment, Vec<Vote>, Trust) {
    let raw: serde_json::Value = serde_json::from_str(include_str!(
        "../../../../integration/arkhe-rbb/fixtures/protocol-v3.json"
    ))
    .unwrap();
    let mut header: Header = serde_json::from_value(raw["header"].clone()).unwrap();
    let (key, _, _) = material(7);
    header.ed25519_key_id = keccak(&key.ed25519);
    header.mldsa_key_id = keccak(&key.mldsa);
    let (ed, ml) = signatures(7, &header.checkpoint_id().unwrap(), MLDSA_CONTEXT);
    let env = Envelope {
        header: header.clone(),
        ed25519_signature: ed,
        mldsa_signature: ml,
    };
    let keys = Keyset {
        org_id: header.org_id,
        version: 1,
        key,
        registered_block: 2,
        valid_from: 1600000000,
        valid_until: 1900000000,
        revoked_at: None,
    };
    let trust = Trust {
        config_digest: [42; 32],
        epoch: 1,
        chain_id: header.anchor_chain_id,
        genesis: header.anchor_genesis_hash,
        registry: header.registry_address,
        anchor: header.anchor_address,
        registry_code_hash: [1; 32],
        anchor_code_hash: [2; 32],
        policy_catalog_digest: [3; 32],
        mmr_profile_digest: mmr::profile_digest(),
        witnesses: (10..14)
            .map(|seed| Witness {
                id: [seed; 32],
                key: material(seed).0,
            })
            .collect(),
    };
    let assessment = Assessment {
        config_digest: trust.config_digest,
        epoch: 1,
        block_number: 100,
        block_hash: [4; 32],
        state_root: [5; 32],
        registry_code_hash: trust.registry_code_hash,
        anchor_code_hash: trust.anchor_code_hash,
        envelope_commitment: env.commitment().unwrap(),
        evidence_manifest_digest: [6; 32],
        keyset_digest: keys.digest().unwrap(),
        policy_catalog_digest: trust.policy_catalog_digest,
        watermark: 1,
        expected_events: 1,
        present_events: 1,
        gaps: 0,
        verified_properties: 0x3f,
        issued_at: 1700000100,
        expires_at: 1700003700,
        first_anchored_at: 1700000050,
        first_anchored_block: 50,
        previous_accepted_id: [0; 32],
    };
    let v = votes(&assessment, &env);
    (env, keys, assessment, v, trust)
}

#[test]
fn real_ed25519_and_mldsa44_verify_three_of_four_pinned_witnesses() {
    let (e, k, a, v, t) = fixture();
    let report = verify_attested_checkpoint(&e, &k, &a, &v[..3], &t, Some(1700000200)).unwrap();
    assert_eq!(report.fresh, Some(true));
    assert!(report.coverage_complete);
    assert_eq!(report.trust_mode, "TRUSTED_ATTESTATION");
    assert_eq!(report.reference_block, 100);
}

#[test]
fn two_votes_duplicate_votes_unknown_signers_and_reused_keys_do_not_form_quorum() {
    let (e, k, a, v, t) = fixture();
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &v[..2], &t, None),
        Err(Error::Quorum)
    );
    let duplicate = vec![v[0].clone(), v[0].clone(), v[1].clone()];
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &duplicate, &t, None),
        Err(Error::Quorum)
    );
    let mut unknown = v[..3].to_vec();
    unknown[2].witness_id = [99; 32];
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &unknown, &t, None),
        Err(Error::Quorum)
    );
    let mut same = t.clone();
    same.witnesses[3].key = same.witnesses[0].key.clone();
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &v[..3], &same, None),
        Err(Error::Quorum)
    );
}

#[test]
fn valid_attestation_cannot_be_reused_with_altered_snapshot_or_assessment() {
    let (e, k, a, v, t) = fixture();
    let mut forged = k.clone();
    forged.valid_until += 1;
    assert_eq!(
        verify_attested_checkpoint(&e, &forged, &a, &v[..3], &t, None),
        Err(Error::Binding)
    );
    let mut forged = a.clone();
    forged.block_hash = [99; 32];
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &forged, &v[..3], &t, None),
        Err(Error::Signature)
    );
    let mut forged = a.clone();
    forged.epoch += 1;
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &forged, &v[..3], &t, None),
        Err(Error::Binding)
    );
    let mut changed = e.clone();
    changed.header.org_id = [99; 32];
    assert_eq!(
        verify_attested_checkpoint(&changed, &k, &a, &v[..3], &t, None),
        Err(Error::Binding)
    );
}

#[test]
fn attackers_self_signed_keyset_and_votes_do_not_replace_external_trust() {
    let (mut e, mut k, mut a, _, t) = fixture();
    k.key = material(99).0;
    e.header.ed25519_key_id = keccak(&k.key.ed25519);
    e.header.mldsa_key_id = keccak(&k.key.mldsa);
    let (ed, ml) = signatures(99, &e.header.checkpoint_id().unwrap(), MLDSA_CONTEXT);
    e.ed25519_signature = ed;
    e.mldsa_signature = ml;
    a.keyset_digest = k.digest().unwrap();
    a.envelope_commitment = e.commitment().unwrap();
    let (ed, ml) = signatures(99, &a.digest(&e).unwrap(), ATTEST_CONTEXT);
    let attacker = Vote {
        witness_id: [99; 32],
        ed25519_signature: ed,
        mldsa_signature: ml,
    };
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &[attacker], &t, None),
        Err(Error::Quorum)
    );
}

#[test]
fn hybrid_requires_both_signatures_and_the_exact_mldsa_context() {
    let (e, k, _, _, _) = fixture();
    let id = e.header.checkpoint_id().unwrap();
    let mut ed = e.ed25519_signature.clone();
    ed[0] ^= 1;
    assert_eq!(
        verify_hybrid(&k.key, &id, &ed, &e.mldsa_signature, MLDSA_CONTEXT),
        Err(Error::Signature)
    );
    let mut ml = e.mldsa_signature.clone();
    ml[100] ^= 1;
    assert_eq!(
        verify_hybrid(&k.key, &id, &e.ed25519_signature, &ml, MLDSA_CONTEXT),
        Err(Error::Signature)
    );
    assert_eq!(
        verify_hybrid(
            &k.key,
            &id,
            &e.ed25519_signature,
            &e.mldsa_signature,
            ATTEST_CONTEXT
        ),
        Err(Error::Signature)
    );
    assert_eq!(
        verify_hybrid(
            &k.key,
            &id,
            &e.ed25519_signature,
            &e.mldsa_signature[..5],
            MLDSA_CONTEXT
        ),
        Err(Error::SignatureLength)
    );
}

#[test]
fn revocation_and_registration_block_prevent_backdated_acceptance() {
    let (e, mut k, mut a, _, t) = fixture();
    k.revoked_at = Some(1700000025);
    a.keyset_digest = k.digest().unwrap();
    let v = votes(&a, &e);
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &v[..3], &t, None),
        Err(Error::Time)
    );
    k.revoked_at = None;
    k.registered_block = 51;
    a.keyset_digest = k.digest().unwrap();
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &v[..3], &t, None),
        Err(Error::Binding)
    );
}

#[test]
fn offline_and_stale_attestations_do_not_claim_current_freshness() {
    let (e, k, a, v, t) = fixture();
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &v[..3], &t, None)
            .unwrap()
            .fresh,
        None
    );
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &v[..3], &t, Some(a.expires_at))
            .unwrap()
            .fresh,
        Some(false)
    );
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &a, &v[..3], &t, Some(a.issued_at - 301)),
        Err(Error::Time)
    );
    let mut changed = a.clone();
    changed.expires_at = changed.issued_at + 86401;
    assert_eq!(
        verify_attested_checkpoint(&e, &k, &changed, &v[..3], &t, None),
        Err(Error::Time)
    );
}

#[test]
fn coverage_gaps_are_reported_separately_from_checkpoint_authenticity() {
    let (e, k, mut a, _, t) = fixture();
    a.gaps = 1;
    a.expected_events = 2;
    let v = votes(&a, &e);
    assert!(
        !verify_attested_checkpoint(&e, &k, &a, &v[..3], &t, None)
            .unwrap()
            .coverage_complete
    );
    assert_eq!(a.canonical_cbor(&e).unwrap()[0], 0xae);
}
