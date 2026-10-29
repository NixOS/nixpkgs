//! LOCAL TEST FIXTURE ONLY: deterministic public seeds, never a production signer.
//! Reads a Header JSON on stdin and emits a genuinely signed hybrid envelope.
#[cfg(feature = "rbb-pqc")]
fn main() -> Result<(), Box<dyn std::error::Error>> {
    use arkhe_verify_core::rbb::trust::{verify_hybrid, HybridKey};
    use arkhe_verify_core::rbb::{keccak, Envelope, Header, MLDSA_CONTEXT};
    use ed25519_dalek::{Signer as _, SigningKey};
    use fips204::{
        ml_dsa_44,
        traits::{KeyGen, SerDes, Signer as _},
    };
    use std::io::{self, Read};
    let mut input = Vec::new();
    io::stdin().take(32769).read_to_end(&mut input)?;
    if input.len() > 32768 {
        return Err("header input exceeds fixture limit".into());
    }
    let mut header: Header = serde_json::from_slice(&input)?;
    let ed = SigningKey::from_bytes(&[7; 32]);
    let (pk, sk) = ml_dsa_44::KG::keygen_from_seed(&[7; 32]);
    let key = HybridKey {
        ed25519: ed.verifying_key().to_bytes(),
        mldsa: pk.into_bytes().to_vec(),
    };
    header.ed25519_key_id = keccak(&key.ed25519);
    header.mldsa_key_id = keccak(&key.mldsa);
    let digest = header.checkpoint_id()?;
    let envelope = Envelope {
        header,
        ed25519_signature: ed.sign(&digest).to_bytes().to_vec(),
        mldsa_signature: sk
            .try_sign_with_seed(&[8; 32], &digest, MLDSA_CONTEXT)?
            .to_vec(),
    };
    verify_hybrid(
        &key,
        &digest,
        &envelope.ed25519_signature,
        &envelope.mldsa_signature,
        MLDSA_CONTEXT,
    )?;
    println!(
        "{}",
        serde_json::json!({"fixture_only":true,"envelope":envelope,"public_key":key,
        "checkpoint_id_hex":hex::encode(digest),"envelope_commitment_hex":hex::encode(envelope.commitment()?),
        "envelope_abi_hex":hex::encode(envelope.encode()?),"hybrid_signatures_verified":true})
    );
    Ok(())
}

#[cfg(not(feature = "rbb-pqc"))]
fn main() {
    eprintln!("rbb_sign_fixture requires --features rbb-pqc; test fixtures only");
    std::process::exit(2);
}
