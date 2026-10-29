use crate::{error::VerifyError, hash::blake3_256, mmr::profile::mmr_size};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone, Serialize, Deserialize, PartialEq, Eq)]
pub struct ProofStep {
    pub kind: String,
    pub direction: String,
    pub hash: [u8; 32],
}

fn leaf_hash(x: &[u8]) -> [u8; 32] {
    let mut b = Vec::with_capacity(1 + x.len());
    b.push(0x00);
    b.extend_from_slice(x);
    blake3_256(&b)
}

fn node_hash(l: &[u8; 32], r: &[u8; 32]) -> [u8; 32] {
    let mut b = Vec::with_capacity(65);
    b.push(0x01);
    b.extend_from_slice(l);
    b.extend_from_slice(r);
    blake3_256(&b)
}

fn bag_hash(l: &[u8; 32], r: &[u8; 32], n: usize) -> [u8; 32] {
    let mut b = Vec::with_capacity(73);
    b.push(0x02);
    b.extend_from_slice(&mmr_size(n as u64).to_be_bytes());
    b.extend_from_slice(l);
    b.extend_from_slice(r);
    blake3_256(&b)
}

fn peak_widths(n: usize) -> Vec<usize> {
    let mut out = Vec::new();
    let mut bit = 1usize << (usize::BITS - 1 - n.leading_zeros());
    let mut rem = n;
    while bit > 0 {
        if rem >= bit {
            out.push(bit);
            rem -= bit;
        }
        bit >>= 1;
    }
    out
}

fn perfect_root_and_path(hashes: &[[u8; 32]], mut idx: usize) -> ([u8; 32], Vec<ProofStep>) {
    let mut level = hashes.to_vec();
    let mut steps = Vec::new();
    while level.len() > 1 {
        let sib = idx ^ 1;
        let direction = if sib < idx { "left" } else { "right" };
        steps.push(ProofStep {
            kind: "node".into(),
            direction: direction.into(),
            hash: level[sib],
        });
        level = level
            .chunks_exact(2)
            .map(|p| node_hash(&p[0], &p[1]))
            .collect();
        idx /= 2;
    }
    (level[0], steps)
}

pub fn build_root_and_proof(
    leaves: &[Vec<u8>],
    target: usize,
) -> Result<([u8; 32], Vec<ProofStep>), VerifyError> {
    if leaves.is_empty() {
        return Err(VerifyError::InvalidInput("empty MMR".into()));
    }
    if target >= leaves.len() {
        return Err(VerifyError::InvalidInput("target out of range".into()));
    }

    let hashes: Vec<[u8; 32]> = leaves.iter().map(|x| leaf_hash(x)).collect();
    let mut peaks = Vec::<(usize, usize, [u8; 32])>::new();
    let mut start = 0;
    for w in peak_widths(leaves.len()) {
        let (r, _) = perfect_root_and_path(&hashes[start..start + w], 0);
        peaks.push((start, w, r));
        start += w;
    }

    let mut root = peaks.last().unwrap().2;
    for p in peaks[..peaks.len() - 1].iter().rev() {
        root = bag_hash(&p.2, &root, leaves.len());
    }

    let (peak_i, start, width) = peaks
        .iter()
        .enumerate()
        .find_map(|(i, (s, w, _))| {
            if *s <= target && target < *s + *w {
                Some((i, *s, *w))
            } else {
                None
            }
        })
        .unwrap();

    let (_, mut proof) = perfect_root_and_path(&hashes[start..start + width], target - start);

    if peak_i < peaks.len() - 1 {
        let mut acc = peaks.last().unwrap().2;
        for p in peaks[peak_i + 1..peaks.len() - 1].iter().rev() {
            acc = bag_hash(&p.2, &acc, leaves.len());
        }
        proof.push(ProofStep {
            kind: "bag".into(),
            direction: "right".into(),
            hash: acc,
        });
    }

    for p in peaks[..peak_i].iter().rev() {
        proof.push(ProofStep {
            kind: "bag".into(),
            direction: "left".into(),
            hash: p.2,
        });
    }

    Ok((root, proof))
}

pub fn verify_proof(
    leaf: &[u8],
    leaf_count: usize,
    proof: &[ProofStep],
    expected_root: &[u8; 32],
) -> Result<bool, VerifyError> {
    if leaf_count == 0 {
        return Err(VerifyError::InvalidInput("empty MMR".into()));
    }
    // Bound untrusted counts before size arithmetic, including on wasm32.
    if (leaf_count as u64) > u64::MAX / 2 {
        return Err(VerifyError::InvalidInput("MMR size overflow".into()));
    }
    if !valid_shape(leaf_count, proof, None) {
        return Err(VerifyError::InvalidInput("invalid MMR proof shape".into()));
    }
    let mut cur = leaf_hash(leaf);
    for step in proof {
        cur = match (step.kind.as_str(), step.direction.as_str()) {
            ("node", "left") => node_hash(&step.hash, &cur),
            ("node", "right") => node_hash(&cur, &step.hash),
            ("bag", "left") => bag_hash(&step.hash, &cur, leaf_count),
            ("bag", "right") => bag_hash(&cur, &step.hash, leaf_count),
            _ => return Err(VerifyError::InvalidInput("invalid proof step".into())),
        };
    }
    Ok(&cur == expected_root)
}

/// Verify both membership and the claimed leaf position under the frozen profile.
pub fn verify_proof_at(
    leaf: &[u8],
    leaf_count: usize,
    leaf_index: usize,
    proof: &[ProofStep],
    expected_root: &[u8; 32],
) -> Result<bool, VerifyError> {
    if leaf_index >= leaf_count || !valid_shape(leaf_count, proof, Some(leaf_index)) {
        return Err(VerifyError::InvalidInput(
            "invalid MMR leaf position".into(),
        ));
    }
    verify_proof(leaf, leaf_count, proof, expected_root)
}

fn valid_shape(n: usize, proof: &[ProofStep], index: Option<usize>) -> bool {
    if n == 0 || proof.len() > 2 * usize::BITS as usize {
        return false;
    }
    let widths = peak_widths(n);
    let node_count = proof.iter().take_while(|step| step.kind == "node").count();
    let mut start = 0;
    for (peak, &width) in widths.iter().enumerate() {
        let depth = width.trailing_zeros() as usize;
        let right = usize::from(peak + 1 < widths.len());
        if depth == node_count
            && proof.len() == depth + right + peak
            && index.is_none_or(|i| i >= start && i - start < width)
        {
            let offset = index.map(|i| i - start);
            let nodes_ok = proof[..depth].iter().enumerate().all(|(level, step)| {
                step.kind == "node"
                    && match offset {
                        Some(i) => {
                            step.direction
                                == if (i >> level) & 1 == 1 {
                                    "left"
                                } else {
                                    "right"
                                }
                        }
                        None => matches!(step.direction.as_str(), "left" | "right"),
                    }
            });
            let bags_ok = proof[depth..].iter().enumerate().all(|(i, step)| {
                step.kind == "bag"
                    && step.direction
                        == if right == 1 && i == 0 {
                            "right"
                        } else {
                            "left"
                        }
            });
            if nodes_ok && bags_ok {
                return true;
            }
        }
        start += width;
    }
    false
}
