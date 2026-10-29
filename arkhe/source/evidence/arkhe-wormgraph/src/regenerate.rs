use arkhe_core::Digest32;
use arkhe_sql::mmr::profile::{mmr_size as profile_mmr_size, PROFILE_DIGEST_HEX};
use async_trait::async_trait;
use std::collections::HashSet;

pub const DEFAULT_STREAM_ID: &str = "wormgraph";

const LEAF_DOMAIN: &[u8] = &[0x00];
const NODE_DOMAIN: &[u8] = &[0x01];
const BAG_DOMAIN: &[u8] = &[0x02];

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct CheckpointBinding {
    pub tenant_id: String,
    pub stream_id: String,
    pub leaf_count: u64,
    pub mmr_size: u64,
    pub root: Digest32,
    pub peaks: Vec<Digest32>,
    pub profile_digest: Digest32,
    pub covered_up_to: Digest32,
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SequencedRecord {
    pub append_sequence: u64,
    pub record_hash: Digest32,
}

#[async_trait]
pub trait OrderedRecordSource {
    async fn prefix(
        &self,
        tenant_id: &str,
        stream_id: &str,
        limit: u64,
    ) -> Result<Vec<SequencedRecord>, SourceError>;
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct SourceError(pub String);

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct RegenerationLimits {
    pub max_leaf_count: u64,
}

impl Default for RegenerationLimits {
    fn default() -> Self {
        Self {
            max_leaf_count: 1_000_000,
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct MmrSnapshot {
    pub leaf_count: u64,
    pub mmr_size: u64,
    pub root: Digest32,
    pub peaks: Vec<Digest32>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum Divergence {
    LeafCount {
        expected: u64,
        actual: u64,
    },
    MmrSize {
        expected: u64,
        actual: u64,
    },
    Root {
        expected: Digest32,
        actual: Digest32,
    },
    Peak {
        index: usize,
        expected: Digest32,
        actual: Digest32,
    },
    CoveredUpTo {
        expected: Digest32,
        actual: Digest32,
    },
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum IncompleteReason {
    MissingLeaves { expected: u64, actual: u64 },
    SequenceNotIncreasing { index: usize },
    DuplicateRecordHash { index: usize },
    Source(String),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum RefusalReason {
    EmptyCheckpoint,
    ProfileMismatch,
    MmrSizeMismatch,
    PeakCountMismatch,
    LimitExceeded,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub enum RegenerationStatus {
    Verified,
    Mismatch(Divergence),
    Incomplete(IncompleteReason),
    Refused(RefusalReason),
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct RegenerationReport {
    pub status: RegenerationStatus,
    pub actual: Option<MmrSnapshot>,
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AnchorError(pub String);

#[async_trait]
pub trait CheckpointAnchor {
    async fn verify(&self, checkpoint: &CheckpointBinding) -> Result<(), AnchorError>;
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct AnchoredCheckpoint {
    checkpoint: CheckpointBinding,
}

impl AnchoredCheckpoint {
    pub fn binding(&self) -> &CheckpointBinding {
        &self.checkpoint
    }

    pub fn into_binding(self) -> CheckpointBinding {
        self.checkpoint
    }
}

pub async fn anchor_checkpoint<A: CheckpointAnchor + ?Sized>(
    checkpoint: CheckpointBinding,
    anchor: &A,
) -> Result<AnchoredCheckpoint, AnchorError> {
    anchor.verify(&checkpoint).await?;
    Ok(AnchoredCheckpoint { checkpoint })
}

impl CheckpointBinding {
    pub fn validate(&self) -> Result<(), RefusalReason> {
        if self.leaf_count == 0 {
            return Err(RefusalReason::EmptyCheckpoint);
        }
        if self.profile_digest.to_hex() != PROFILE_DIGEST_HEX {
            return Err(RefusalReason::ProfileMismatch);
        }
        if self.mmr_size != profile_mmr_size(self.leaf_count) {
            return Err(RefusalReason::MmrSizeMismatch);
        }
        if self.peaks.len() != self.leaf_count.count_ones() as usize {
            return Err(RefusalReason::PeakCountMismatch);
        }
        Ok(())
    }
}

fn leaf_hash(record_hash: &Digest32) -> Digest32 {
    Digest32::blake3(LEAF_DOMAIN, &record_hash.0)
}

fn node_hash(left: &Digest32, right: &Digest32) -> Digest32 {
    let mut payload = Vec::with_capacity(64);
    payload.extend_from_slice(&left.0);
    payload.extend_from_slice(&right.0);
    Digest32::blake3(NODE_DOMAIN, &payload)
}

fn bag_hash(left: &Digest32, right: &Digest32, mmr_size: u64) -> Digest32 {
    let mut payload = Vec::with_capacity(72);
    payload.extend_from_slice(&mmr_size.to_be_bytes());
    payload.extend_from_slice(&left.0);
    payload.extend_from_slice(&right.0);
    Digest32::blake3(BAG_DOMAIN, &payload)
}

fn peak_widths(leaf_count: u64) -> Vec<u64> {
    let mut widths = Vec::new();
    let mut remaining = leaf_count;
    while remaining > 0 {
        let width = 1u64 << (63 - remaining.leading_zeros());
        widths.push(width);
        remaining -= width;
    }
    widths
}

fn perfect_root(hashes: &[Digest32]) -> Digest32 {
    debug_assert!(!hashes.is_empty());
    debug_assert!(hashes.len().is_power_of_two());

    let mut level = hashes.to_vec();
    while level.len() > 1 {
        level = level
            .chunks_exact(2)
            .map(|pair| node_hash(&pair[0], &pair[1]))
            .collect();
    }
    level[0]
}

fn root_from_peaks(peaks: &[Digest32], leaf_count: u64) -> Digest32 {
    debug_assert!(!peaks.is_empty());

    let mut root = *peaks.last().expect("non-empty peaks");
    for peak in peaks[..peaks.len() - 1].iter().rev() {
        root = bag_hash(peak, &root, profile_mmr_size(leaf_count));
    }
    root
}

pub fn rebuild(record_hashes: &[Digest32]) -> Result<MmrSnapshot, RegenerationStatus> {
    if record_hashes.is_empty() {
        return Err(RegenerationStatus::Refused(RefusalReason::EmptyCheckpoint));
    }

    let leaf_hashes: Vec<Digest32> = record_hashes.iter().map(leaf_hash).collect();
    let leaf_count = record_hashes.len() as u64;
    let mut peaks = Vec::new();
    let mut start = 0usize;

    for width in peak_widths(leaf_count) {
        let end = start + width as usize;
        peaks.push(perfect_root(&leaf_hashes[start..end]));
        start = end;
    }

    let mmr_size = profile_mmr_size(leaf_count);
    Ok(MmrSnapshot {
        leaf_count,
        mmr_size,
        root: root_from_peaks(&peaks, leaf_count),
        peaks,
    })
}

pub fn verify_checkpoint(
    checkpoint: &CheckpointBinding,
    records: &[SequencedRecord],
) -> RegenerationReport {
    if let Err(reason) = checkpoint.validate() {
        return RegenerationReport {
            status: RegenerationStatus::Refused(reason),
            actual: None,
        };
    }

    if (records.len() as u64) < checkpoint.leaf_count {
        return RegenerationReport {
            status: RegenerationStatus::Incomplete(IncompleteReason::MissingLeaves {
                expected: checkpoint.leaf_count,
                actual: records.len() as u64,
            }),
            actual: None,
        };
    }

    if (records.len() as u64) > checkpoint.leaf_count {
        return RegenerationReport {
            status: RegenerationStatus::Mismatch(Divergence::LeafCount {
                expected: checkpoint.leaf_count,
                actual: records.len() as u64,
            }),
            actual: None,
        };
    }

    let mut seen = HashSet::with_capacity(records.len());
    for (index, record) in records.iter().enumerate() {
        if index > 0 && record.append_sequence <= records[index - 1].append_sequence {
            return RegenerationReport {
                status: RegenerationStatus::Incomplete(IncompleteReason::SequenceNotIncreasing {
                    index,
                }),
                actual: None,
            };
        }
        if !seen.insert(record.record_hash) {
            return RegenerationReport {
                status: RegenerationStatus::Incomplete(IncompleteReason::DuplicateRecordHash {
                    index,
                }),
                actual: None,
            };
        }
    }

    let actual_covered = records
        .last()
        .expect("non-empty prefix after length check")
        .record_hash;
    if actual_covered != checkpoint.covered_up_to {
        return RegenerationReport {
            status: RegenerationStatus::Mismatch(Divergence::CoveredUpTo {
                expected: checkpoint.covered_up_to,
                actual: actual_covered,
            }),
            actual: None,
        };
    }

    let record_hashes: Vec<Digest32> = records.iter().map(|r| r.record_hash).collect();
    let actual = match rebuild(&record_hashes) {
        Ok(snapshot) => snapshot,
        Err(status) => {
            return RegenerationReport {
                status,
                actual: None,
            }
        }
    };

    if actual.mmr_size != checkpoint.mmr_size {
        return RegenerationReport {
            status: RegenerationStatus::Mismatch(Divergence::MmrSize {
                expected: checkpoint.mmr_size,
                actual: actual.mmr_size,
            }),
            actual: Some(actual),
        };
    }
    if actual.root != checkpoint.root {
        return RegenerationReport {
            status: RegenerationStatus::Mismatch(Divergence::Root {
                expected: checkpoint.root,
                actual: actual.root,
            }),
            actual: Some(actual),
        };
    }
    for (index, (expected, found)) in checkpoint.peaks.iter().zip(actual.peaks.iter()).enumerate() {
        if expected != found {
            return RegenerationReport {
                status: RegenerationStatus::Mismatch(Divergence::Peak {
                    index,
                    expected: *expected,
                    actual: *found,
                }),
                actual: Some(actual),
            };
        }
    }

    RegenerationReport {
        status: RegenerationStatus::Verified,
        actual: Some(actual),
    }
}

pub async fn regenerate<S: OrderedRecordSource + ?Sized>(
    source: &S,
    checkpoint: &CheckpointBinding,
    limits: &RegenerationLimits,
) -> RegenerationReport {
    if let Err(reason) = checkpoint.validate() {
        return RegenerationReport {
            status: RegenerationStatus::Refused(reason),
            actual: None,
        };
    }
    if checkpoint.leaf_count > limits.max_leaf_count {
        return RegenerationReport {
            status: RegenerationStatus::Refused(RefusalReason::LimitExceeded),
            actual: None,
        };
    }

    let records = match source
        .prefix(
            &checkpoint.tenant_id,
            &checkpoint.stream_id,
            checkpoint.leaf_count,
        )
        .await
    {
        Ok(records) => records,
        Err(error) => {
            return RegenerationReport {
                status: RegenerationStatus::Incomplete(IncompleteReason::Source(error.0)),
                actual: None,
            }
        }
    };

    verify_checkpoint(checkpoint, &records)
}

pub async fn regenerate_anchored<S: OrderedRecordSource + ?Sized>(
    source: &S,
    checkpoint: &AnchoredCheckpoint,
    limits: &RegenerationLimits,
) -> RegenerationReport {
    regenerate(source, checkpoint.binding(), limits).await
}

#[cfg(test)]
mod tests {
    use super::*;

    fn digest(hex: &str) -> Digest32 {
        assert_eq!(hex.len(), 64);
        let mut bytes = [0u8; 32];
        for (index, byte) in bytes.iter_mut().enumerate() {
            *byte = u8::from_str_radix(&hex[index * 2..index * 2 + 2], 16).unwrap();
        }
        Digest32(bytes)
    }

    fn leaf(value: u8) -> Digest32 {
        let mut bytes = [0u8; 32];
        bytes[31] = value;
        Digest32(bytes)
    }

    fn records() -> Vec<SequencedRecord> {
        (1..=7)
            .map(|value| SequencedRecord {
                append_sequence: value as u64,
                record_hash: leaf(value),
            })
            .collect()
    }

    fn checkpoint() -> CheckpointBinding {
        CheckpointBinding {
            tenant_id: "tenant-a".into(),
            stream_id: "stream-a".into(),
            leaf_count: 7,
            mmr_size: 11,
            root: digest("5b72738d4f0581752327a48be16dae227da624f7e0316b39f512f1f787fbdb64"),
            peaks: vec![
                digest("ff55b1c86c203cbc5c84a79803d4f921e317a8e72c0645535db4c1cc2e7d5d94"),
                digest("3e405514d5bd48d670e457b92c484d3f6089cb692472e9c2ffc6a68415ba1543"),
                digest("fbb0dc973121b4536952de0370b3dfd5cc1eb45c432d8b7c33e8142cc9fb91ed"),
            ],
            profile_digest: digest(PROFILE_DIGEST_HEX),
            covered_up_to: leaf(7),
        }
    }

    #[test]
    fn rebuild_matches_golden_vector() {
        let hashes: Vec<Digest32> = records().iter().map(|r| r.record_hash).collect();
        let snapshot = rebuild(&hashes).unwrap();

        assert_eq!(snapshot.leaf_count, 7);
        assert_eq!(snapshot.mmr_size, 11);
        assert_eq!(
            snapshot.root.to_hex(),
            "5b72738d4f0581752327a48be16dae227da624f7e0316b39f512f1f787fbdb64"
        );
        assert_eq!(
            snapshot
                .peaks
                .iter()
                .map(|peak| peak.to_hex())
                .collect::<Vec<_>>(),
            vec![
                "ff55b1c86c203cbc5c84a79803d4f921e317a8e72c0645535db4c1cc2e7d5d94",
                "3e405514d5bd48d670e457b92c484d3f6089cb692472e9c2ffc6a68415ba1543",
                "fbb0dc973121b4536952de0370b3dfd5cc1eb45c432d8b7c33e8142cc9fb91ed",
            ]
        );
    }

    #[test]
    fn rebuild_matches_other_golden_roots() {
        let cases = [
            (
                1,
                "60499eb380feaca0c5b5385982e20abe3b4b3ef7ff5037dfad344b5f8a802c7b",
            ),
            (
                3,
                "edf432b5854467f8ceaa0102e37dae99200e96c9b184b02681ad4145ac4cbbf0",
            ),
            (
                4,
                "ff55b1c86c203cbc5c84a79803d4f921e317a8e72c0645535db4c1cc2e7d5d94",
            ),
            (
                5,
                "3686670ec4a843bc3caaf0d302906e7cb161f791ddbd739ffa0dbeda61f069bf",
            ),
        ];

        for (leaf_count, expected_root) in cases {
            let hashes: Vec<Digest32> = (1..=leaf_count).map(leaf).collect();
            assert_eq!(rebuild(&hashes).unwrap().root.to_hex(), expected_root);
        }
    }

    #[test]
    fn verify_accepts_matching_checkpoint() {
        assert_eq!(
            verify_checkpoint(&checkpoint(), &records()).status,
            RegenerationStatus::Verified
        );
    }

    #[test]
    fn verify_rejects_tampered_leaf() {
        let mut records = records();
        records[4].record_hash = leaf(99);

        assert!(matches!(
            verify_checkpoint(&checkpoint(), &records).status,
            RegenerationStatus::Mismatch(Divergence::Root { .. })
        ));
    }

    #[test]
    fn verify_rejects_tampered_root() {
        let mut checkpoint = checkpoint();
        checkpoint.root =
            digest("0000000000000000000000000000000000000000000000000000000000000000");

        assert!(matches!(
            verify_checkpoint(&checkpoint, &records()).status,
            RegenerationStatus::Mismatch(Divergence::Root { .. })
        ));
    }

    #[test]
    fn verify_rejects_reordered_records() {
        let mut records = records();
        records.swap(0, 1);

        assert_eq!(
            verify_checkpoint(&checkpoint(), &records).status,
            RegenerationStatus::Incomplete(IncompleteReason::SequenceNotIncreasing { index: 1 })
        );
    }

    #[test]
    fn verify_rejects_missing_records() {
        let records = &records()[..6];

        assert_eq!(
            verify_checkpoint(&checkpoint(), records).status,
            RegenerationStatus::Incomplete(IncompleteReason::MissingLeaves {
                expected: 7,
                actual: 6,
            })
        );
    }

    #[test]
    fn verify_refuses_wrong_profile() {
        let mut checkpoint = checkpoint();
        checkpoint.profile_digest =
            digest("0000000000000000000000000000000000000000000000000000000000000000");

        assert_eq!(
            verify_checkpoint(&checkpoint, &records()).status,
            RegenerationStatus::Refused(RefusalReason::ProfileMismatch)
        );
    }

    #[test]
    fn verify_refuses_empty_checkpoint() {
        let mut checkpoint = checkpoint();
        checkpoint.leaf_count = 0;

        assert_eq!(
            verify_checkpoint(&checkpoint, &records()).status,
            RegenerationStatus::Refused(RefusalReason::EmptyCheckpoint)
        );
    }

    #[test]
    fn verify_rejects_tampered_covered_hash() {
        let mut checkpoint = checkpoint();
        checkpoint.covered_up_to = leaf(6);

        assert!(matches!(
            verify_checkpoint(&checkpoint, &records()).status,
            RegenerationStatus::Mismatch(Divergence::CoveredUpTo { .. })
        ));
    }

    #[test]
    fn verify_rejects_duplicate_record_hash() {
        let mut records = records();
        records[6].record_hash = records[5].record_hash;
        records[6].append_sequence = 8;

        assert_eq!(
            verify_checkpoint(&checkpoint(), &records).status,
            RegenerationStatus::Incomplete(IncompleteReason::DuplicateRecordHash { index: 6 })
        );
    }

    struct StaticSource(Vec<SequencedRecord>);

    #[async_trait]
    impl OrderedRecordSource for StaticSource {
        async fn prefix(
            &self,
            _tenant_id: &str,
            _stream_id: &str,
            limit: u64,
        ) -> Result<Vec<SequencedRecord>, SourceError> {
            Ok(self.0.iter().take(limit as usize).copied().collect())
        }
    }

    #[tokio::test]
    async fn regenerate_verifies_ordered_source() {
        let source = StaticSource(records());
        let report = regenerate(&source, &checkpoint(), &RegenerationLimits::default()).await;
        assert_eq!(report.status, RegenerationStatus::Verified);
    }

    #[tokio::test]
    async fn regenerate_refuses_limit_before_reading() {
        let source = StaticSource(records());
        let limits = RegenerationLimits { max_leaf_count: 6 };

        let report = regenerate(&source, &checkpoint(), &limits).await;
        assert_eq!(
            report.status,
            RegenerationStatus::Refused(RefusalReason::LimitExceeded)
        );
    }

    struct AcceptingAnchor;

    #[async_trait]
    impl CheckpointAnchor for AcceptingAnchor {
        async fn verify(&self, _checkpoint: &CheckpointBinding) -> Result<(), AnchorError> {
            Ok(())
        }
    }

    struct RejectingAnchor;

    #[async_trait]
    impl CheckpointAnchor for RejectingAnchor {
        async fn verify(&self, _checkpoint: &CheckpointBinding) -> Result<(), AnchorError> {
            Err(AnchorError("anchor mismatch".into()))
        }
    }

    #[tokio::test]
    async fn anchored_checkpoint_requires_anchor_acceptance() {
        let anchored = anchor_checkpoint(checkpoint(), &AcceptingAnchor)
            .await
            .unwrap();
        assert_eq!(anchored.binding(), &checkpoint());

        let error = anchor_checkpoint(checkpoint(), &RejectingAnchor)
            .await
            .unwrap_err();
        assert_eq!(error, AnchorError("anchor mismatch".into()));
    }

    #[tokio::test]
    async fn regenerate_anchored_uses_verified_binding() {
        let anchored = anchor_checkpoint(checkpoint(), &AcceptingAnchor)
            .await
            .unwrap();
        let source = StaticSource(records());

        let report = regenerate_anchored(&source, &anchored, &RegenerationLimits::default()).await;
        assert_eq!(report.status, RegenerationStatus::Verified);
    }
}
