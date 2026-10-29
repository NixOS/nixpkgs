use super::Error;
use serde::{Deserialize, Serialize};

fn hash(domain: &[u8], parts: &[&[u8]]) -> [u8; 32] {
    let mut h = blake3::Hasher::new();
    h.update(domain);
    for part in parts {
        h.update(part);
    }
    *h.finalize().as_bytes()
}
fn leaf(index: u64, record: &[u8; 32]) -> [u8; 32] {
    hash(b"AKG:MMR:LEAF:v3\0", &[&index.to_be_bytes(), record])
}
fn node(left: &[u8; 32], right: &[u8; 32]) -> [u8; 32] {
    hash(b"AKG:MMR:NODE:v3\0", &[left, right])
}

pub fn profile_digest() -> [u8; 32] {
    // This is a new profile. It never aliases arkhe-mmr v1.
    *blake3::hash(b"arkhe-rbb-mmr-v3:blake3-256;leaf=index-u64be+record32;node=left+right;bag=right-fold;root=count-u64be+bag;domains=AKG:MMR:{LEAF,NODE,BAG,ROOT}:v3:NUL").as_bytes()
}

fn mountains(count: u64) -> Vec<(u64, u32)> {
    let mut start = 0;
    let mut result = Vec::new();
    for height in (0..64).rev() {
        if count & (1u64 << height) != 0 {
            result.push((start, height));
            start += 1u64 << height;
        }
    }
    result
}

fn root_from_peaks(count: u64, peaks: &[[u8; 32]]) -> Result<[u8; 32], Error> {
    if count == 0 || peaks.len() != count.count_ones() as usize {
        return Err(Error::Mmr);
    }
    let mut bag = *peaks.last().ok_or(Error::Mmr)?;
    for peak in peaks.iter().rev().skip(1) {
        bag = hash(b"AKG:MMR:BAG:v3\0", &[peak, &bag]);
    }
    Ok(hash(b"AKG:MMR:ROOT:v3\0", &[&count.to_be_bytes(), &bag]))
}

#[derive(Debug, Clone, Default, PartialEq, Eq, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Frontier {
    pub count: u64,
    pub peaks: Vec<[u8; 32]>,
}

impl Frontier {
    pub fn validate(&self) -> Result<(), Error> {
        if self.peaks.len() != self.count.count_ones() as usize {
            return Err(Error::Mmr);
        }
        Ok(())
    }
    pub fn append(&mut self, record: &[u8; 32]) -> Result<u64, Error> {
        self.validate()?;
        let next_count = self.count.checked_add(1).ok_or(Error::ResourceLimit)?;
        let index = self.count;
        let mut current = leaf(index, record);
        for _ in 0..self.count.trailing_ones() {
            current = node(&self.peaks.pop().ok_or(Error::Mmr)?, &current);
        }
        self.peaks.push(current);
        self.count = next_count;
        Ok(index)
    }
    pub fn root(&self) -> Result<[u8; 32], Error> {
        root_from_peaks(self.count, &self.peaks)
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
pub struct Proof {
    pub leaf_index: u64,
    pub leaf_count: u64,
    pub siblings: Vec<[u8; 32]>,
    pub other_peaks: Vec<[u8; 32]>,
}

pub fn verify(
    record: &[u8; 32],
    proof: &Proof,
    signed_count: u64,
    expected_root: &[u8; 32],
) -> Result<(), Error> {
    if proof.siblings.len() > 63 || proof.other_peaks.len() > 63 {
        return Err(Error::ResourceLimit);
    }
    if signed_count == 0 || proof.leaf_count != signed_count || proof.leaf_index >= signed_count {
        return Err(Error::Mmr);
    }
    let shape = mountains(signed_count);
    let target = shape
        .iter()
        .position(|(start, height)| {
            proof.leaf_index >= *start && proof.leaf_index - start < (1u64 << height)
        })
        .ok_or(Error::Mmr)?;
    let (start, height) = shape[target];
    if proof.siblings.len() != height as usize || proof.other_peaks.len() + 1 != shape.len() {
        return Err(Error::Mmr);
    }
    let mut current = leaf(proof.leaf_index, record);
    let mut local = proof.leaf_index - start;
    for sibling in &proof.siblings {
        current = if local & 1 == 0 {
            node(&current, sibling)
        } else {
            node(sibling, &current)
        };
        local >>= 1;
    }
    let mut peaks = proof.other_peaks.clone();
    peaks.insert(target, current);
    if root_from_peaks(signed_count, &peaks)? != *expected_root {
        return Err(Error::Mmr);
    }
    Ok(())
}

/// Proof construction is bounded to local batches; persistent services retain historical nodes.
pub fn prove(records: &[[u8; 32]], index: usize) -> Result<Proof, Error> {
    if records.len() > 4096 {
        return Err(Error::ResourceLimit);
    }
    if index >= records.len() {
        return Err(Error::Mmr);
    }
    let mut peaks = Vec::new();
    let mut siblings = Vec::new();
    for (start, height) in mountains(records.len() as u64) {
        let end = start as usize + (1usize << height);
        let target = (start as usize..end).contains(&index);
        let mut level: Vec<_> = (start as usize..end)
            .map(|i| leaf(i as u64, &records[i]))
            .collect();
        let mut local = index.saturating_sub(start as usize);
        while level.len() > 1 {
            if target {
                siblings.push(level[local ^ 1]);
                local /= 2;
            }
            level = level
                .chunks_exact(2)
                .map(|pair| node(&pair[0], &pair[1]))
                .collect();
        }
        if !target {
            peaks.push(level[0]);
        }
    }
    Ok(Proof {
        leaf_index: index as u64,
        leaf_count: records.len() as u64,
        siblings,
        other_peaks: peaks,
    })
}

/// Recompute the extension from an authenticated previous frontier and bounded new records.
pub fn verify_extension(
    previous: &Frontier,
    previous_root: &[u8; 32],
    records: &[[u8; 32]],
    expected_count: u64,
    expected_root: &[u8; 32],
) -> Result<(), Error> {
    if records.is_empty() || records.len() > 4096 {
        return Err(Error::ResourceLimit);
    }
    previous.validate()?;
    if previous.count == 0 {
        if *previous_root != [0; 32] {
            return Err(Error::Mmr);
        }
    } else if previous.root()? != *previous_root {
        return Err(Error::Mmr);
    }
    let mut next = previous.clone();
    for record in records {
        next.append(record)?;
    }
    if next.count != expected_count || next.root()? != *expected_root {
        return Err(Error::Mmr);
    }
    Ok(())
}
