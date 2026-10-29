use crate::{adapters::gensyn::GensynAdapter, types::AttestedReceipt, Error};
use arkhe_core::Digest32;
use arkhe_verify_core::mmr::{build_root_and_proof, verify_proof, ProofStep};
use serde::{Deserialize, Serialize};

/// Root and size must be obtained through an independently trusted channel.
#[derive(Debug, Clone, PartialEq, Eq, Serialize, Deserialize)]
pub struct Checkpoint {
    pub root: [u8; 32],
    pub leaf_count: usize,
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct PortableInclusionProof {
    pub checkpoint: Checkpoint,
    pub steps: Vec<ProofStep>,
}

/// Small in-memory builder using the repository's existing MMR profile.
#[derive(Default)]
pub struct Mmr {
    leaves: Vec<Vec<u8>>,
}
impl Mmr {
    pub fn new() -> Self {
        Self::default()
    }
    pub fn checkpoint(&self) -> Result<Checkpoint, Error> {
        let (root, _) =
            build_root_and_proof(&self.leaves, 0).map_err(|e| Error::Mmr(e.to_string()))?;
        Ok(Checkpoint {
            root,
            leaf_count: self.leaves.len(),
        })
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct CompositeProof {
    pub attested: AttestedReceipt,
    pub mmr_leaf: Digest32,
    pub inclusion_proof: PortableInclusionProof,
}

fn commitment(attested: &AttestedReceipt) -> Result<Digest32, Error> {
    GensynAdapter::validate(&attested.receipt)?;
    // Typed JSON commits all receipt metadata and the presence/absence of hardware.
    Ok(Digest32::blake3(
        b"ARKHE/DEPIN/COMPOSITE/v1",
        &serde_json::to_vec(attested)?,
    ))
}

impl CompositeProof {
    pub fn anchor(attested: &AttestedReceipt, mmr: &mut Mmr) -> Result<Self, Error> {
        let leaf = commitment(attested)?;
        let index = mmr.leaves.len();
        mmr.leaves.push(leaf.0.to_vec());
        let result = build_root_and_proof(&mmr.leaves, index);
        let (root, steps) = match result {
            Ok(result) => result,
            Err(error) => {
                mmr.leaves.pop();
                return Err(Error::Mmr(error.to_string()));
            }
        };
        Ok(Self {
            attested: attested.clone(),
            mmr_leaf: leaf,
            inclusion_proof: PortableInclusionProof {
                checkpoint: Checkpoint {
                    root,
                    leaf_count: mmr.leaves.len(),
                },
                steps,
            },
        })
    }

    /// Verifies integrity/inclusion only; provider signatures and TEE claims remain unverified.
    pub fn verify(&self, trusted: &Checkpoint) -> Result<(), Error> {
        if &self.inclusion_proof.checkpoint != trusted
            || commitment(&self.attested)? != self.mmr_leaf
        {
            return Err(Error::InvalidProof);
        }
        let valid = verify_proof(
            &self.mmr_leaf.0,
            trusted.leaf_count,
            &self.inclusion_proof.steps,
            &trusted.root,
        )
        .map_err(|e| Error::Mmr(e.to_string()))?;
        if !valid {
            return Err(Error::InvalidProof);
        }
        Ok(())
    }
}
