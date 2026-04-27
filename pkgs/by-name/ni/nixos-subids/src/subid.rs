use std::{
    collections::BTreeMap,
    fmt::Write as _,
    fs,
    io::Write as _,
    os::unix::fs::OpenOptionsExt,
    path::{Path, PathBuf},
};

use anyhow::{bail, Context, Result};

/// A half-open interval [start, start + count).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct Range {
    pub start: u64,
    pub count: u64,
}

impl Range {
    pub fn end(&self) -> u64 {
        self.start + self.count
    }

    /// Two half-open intervals `[start, start+count)` overlap iff each one's
    /// start lies strictly before the other's end:
    ///
    /// ```text
    ///   a: [-----)             [-----)       [-----------)
    ///   b:    [-----)    [-----)                [-----)
    /// ```
    pub fn overlaps(&self, other: &Range) -> bool {
        self.start < other.end() && other.start < self.end()
    }
}

/// In-memory representation of /etc/sub{u,g}id.
///
/// Preserves all entries found on disk, including those for users not in the
/// current config; like userborn we never shrink the file so that ranges can
/// never be reassigned to a different owner.
#[derive(Debug, Default)]
pub struct SubIdDb {
    /// owner name (or numeric uid as string) -> ranges
    entries: BTreeMap<String, Vec<Range>>,
}

impl SubIdDb {
    pub fn from_file(path: impl AsRef<Path>) -> Result<Self> {
        match fs::read_to_string(&path) {
            Ok(s) => Self::from_str(&s),
            Err(e) if e.kind() == std::io::ErrorKind::NotFound => Ok(Self::default()),
            Err(e) => Err(e).with_context(|| format!("Failed to read {}", path.as_ref().display())),
        }
    }

    pub fn from_str(s: &str) -> Result<Self> {
        let mut db = Self::default();
        for (lineno, line) in s.lines().enumerate() {
            let line = line.trim();
            if line.is_empty() || line.starts_with('#') {
                continue;
            }
            let mut parts = line.splitn(3, ':').fuse();
            let name = parts.next().unwrap_or_default();
            let start = parts.next().unwrap_or_default();
            let count = parts.next().unwrap_or_default();
            let (Ok(start), Ok(count)) = (start.parse::<u64>(), count.parse::<u64>()) else {
                log::warn!("ignoring malformed line {}: {line:?}", lineno + 1);
                continue;
            };
            db.entries
                .entry(name.to_owned())
                .or_default()
                .push(Range { start, count });
        }
        Ok(db)
    }

    pub fn ranges(&self, name: &str) -> &[Range] {
        self.entries.get(name).map(Vec::as_slice).unwrap_or(&[])
    }

    pub fn names(&self) -> impl Iterator<Item = &str> {
        self.entries.keys().map(String::as_str)
    }

    /// Replace all ranges for `name`.
    pub fn set(&mut self, name: &str, ranges: Vec<Range>) {
        if ranges.is_empty() {
            self.entries.remove(name);
        } else {
            self.entries.insert(name.to_owned(), ranges);
        }
    }

    /// Find an existing auto-style range for `name` (single range with the
    /// expected count), if any.
    pub fn auto_range(&self, name: &str, count: u64) -> Option<Range> {
        self.ranges(name).iter().find(|r| r.count == count).copied()
    }

    /// All ranges across all owners, sorted by start.
    pub fn occupied(&self) -> Vec<(String, Range)> {
        let mut v: Vec<_> = self
            .entries
            .iter()
            .flat_map(|(n, rs)| rs.iter().map(move |r| (n.clone(), *r)))
            .collect();
        v.sort_by_key(|(_, r)| r.start);
        v
    }

    pub fn to_buffer(&self) -> String {
        // Stable order: by lowest start, then by name. This keeps the file
        // byte-stable across runs as long as the set of ranges is unchanged.
        let mut owners: Vec<_> = self.entries.iter().collect();
        owners.sort_by(|(an, ar), (bn, br)| {
            let amin = ar.iter().map(|r| r.start).min().unwrap_or(u64::MAX);
            let bmin = br.iter().map(|r| r.start).min().unwrap_or(u64::MAX);
            amin.cmp(&bmin).then_with(|| an.cmp(bn))
        });
        let mut out = String::new();
        for (name, ranges) in owners {
            let mut ranges = ranges.clone();
            ranges.sort_by_key(|r| r.start);
            for r in ranges {
                let _ = writeln!(out, "{}:{}:{}", name, r.start, r.count);
            }
        }
        out
    }

    /// Atomically write to `path`, ensuring the result is a regular file.
    ///
    /// shadow-utils' newuidmap opens /etc/subuid with O_NOFOLLOW, so we must
    /// not leave a symlink in place.
    ///
    /// Skips the write entirely when the on-disk content already matches, to
    /// avoid mtime churn and spurious inotify events on every activation.
    pub fn to_file(&self, path: impl AsRef<Path>) -> Result<()> {
        let path = path.as_ref();
        let buffer = self.to_buffer();

        if let Ok(md) = fs::symlink_metadata(path) {
            if md.file_type().is_file() {
                if let Ok(existing) = fs::read_to_string(path) {
                    if existing == buffer {
                        log::debug!("{} already up to date", path.display());
                        return Ok(());
                    }
                }
            }
        }

        let dir = path.parent().unwrap_or_else(|| Path::new("/"));
        let mut tmp = PathBuf::from(dir);
        tmp.push(format!(
            ".{}.tmp",
            path.file_name().and_then(|s| s.to_str()).unwrap_or("subid")
        ));

        {
            let mut f = fs::OpenOptions::new()
                .write(true)
                .create(true)
                .truncate(true)
                .mode(0o644)
                .open(&tmp)
                .with_context(|| format!("Failed to create {}", tmp.display()))?;
            f.write_all(buffer.as_bytes())?;
            f.sync_all()?;
        }

        // If the target is a symlink, remove it so rename() produces a
        // regular file at the final path.
        if let Ok(md) = fs::symlink_metadata(path) {
            if md.file_type().is_symlink() {
                fs::remove_file(path)
                    .with_context(|| format!("Failed to remove symlink {}", path.display()))?;
            }
        }

        fs::rename(&tmp, path)
            .with_context(|| format!("Failed to rename {} to {}", tmp.display(), path.display()))?;
        Ok(())
    }
}

/// Returns the first pair of overlapping ranges across owners, if any.
pub fn find_overlap(occupied: &[(String, Range)]) -> Option<((String, Range), (String, Range))> {
    for i in 0..occupied.len() {
        for j in (i + 1)..occupied.len() {
            let (an, ar) = &occupied[i];
            let (bn, br) = &occupied[j];
            if an == bn {
                // Same owner is allowed to have overlapping or adjacent
                // ranges; that's the owner's business.
                continue;
            }
            if ar.overlaps(br) {
                return Some(((an.clone(), *ar), (bn.clone(), *br)));
            }
        }
    }
    None
}

/// Allocate a `count`-wide range >= `base` that does not overlap any of
/// `occupied`. Occupied must be sorted by start.
pub fn allocate(base: u64, count: u64, occupied: &[(String, Range)]) -> Result<Range> {
    // 31-bit ceiling per https://systemd.io/UIDS-GIDS/.
    const MAX: u64 = 0x8000_0000;

    let mut candidate = base;
    'outer: loop {
        if candidate.checked_add(count).is_none_or(|end| end > MAX) {
            bail!("no free {count}-wide range available above {base}");
        }
        let probe = Range {
            start: candidate,
            count,
        };
        for (_, r) in occupied {
            if probe.overlaps(r) {
                candidate = r.end();
                continue 'outer;
            }
        }
        return Ok(probe);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_roundtrip() {
        let input = "alice:100000:65536\nbob:165536:65536\n";
        let db = SubIdDb::from_str(input).unwrap();
        assert_eq!(
            db.ranges("alice"),
            &[Range {
                start: 100000,
                count: 65536
            }]
        );
        assert_eq!(db.to_buffer(), input);
    }

    #[test]
    fn parse_skips_garbage() {
        let db = SubIdDb::from_str("\n# comment\nbad line\nalice:100000:65536\n").unwrap();
        assert_eq!(db.entries.len(), 1);
    }

    #[test]
    fn alloc_skips_occupied() {
        let occ = vec![(
            "root".into(),
            Range {
                start: 1_000_000,
                count: 1_000_000_000,
            },
        )];
        let r = allocate(100_000, 65536, &occ).unwrap();
        assert_eq!(r.start, 100_000);
        // base inside the huge root range -> jumps past it
        let r = allocate(2_000_000, 65536, &occ).unwrap();
        assert_eq!(r.start, 1_001_000_000);
    }

    #[test]
    fn alloc_packs_after_existing() {
        let occ = vec![
            (
                "a".into(),
                Range {
                    start: 100_000,
                    count: 65536,
                },
            ),
            (
                "b".into(),
                Range {
                    start: 165_536,
                    count: 65536,
                },
            ),
        ];
        let r = allocate(100_000, 65536, &occ).unwrap();
        assert_eq!(r.start, 231_072);
    }

    #[test]
    fn overlap_detected() {
        let occ = vec![
            (
                "a".into(),
                Range {
                    start: 100_000,
                    count: 65536,
                },
            ),
            (
                "b".into(),
                Range {
                    start: 100_100,
                    count: 65536,
                },
            ),
        ];
        assert!(find_overlap(&occ).is_some());
    }

    #[test]
    fn overlap_same_owner_ignored() {
        let occ = vec![
            (
                "a".into(),
                Range {
                    start: 100_000,
                    count: 65536,
                },
            ),
            (
                "a".into(),
                Range {
                    start: 100_100,
                    count: 65536,
                },
            ),
        ];
        assert!(find_overlap(&occ).is_none());
    }

    #[test]
    fn alloc_exhausted() {
        let occ = vec![(
            "x".into(),
            Range {
                start: 0,
                count: 0x8000_0000,
            },
        )];
        assert!(allocate(100_000, 65536, &occ).is_err());
    }
}
