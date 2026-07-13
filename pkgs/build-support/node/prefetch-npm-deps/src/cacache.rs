use anyhow::anyhow;
use data_encoding::BASE64;
use digest::{Digest, Update};
use serde::{Deserialize, Serialize};
use sha1::Sha1;
use sha2::{Sha256, Sha512};
use std::{
    collections::HashMap,
    fmt::Write as FmtWrite,
    fs,
    io::Write,
    path::{Path, PathBuf},
    sync::{Arc, Mutex},
};
use tempfile::NamedTempFile;
use url::Url;

#[allow(clippy::struct_field_names)]
#[derive(Serialize, Deserialize)]
pub(super) struct Key {
    pub(super) key: String,
    pub(super) integrity: String,
    pub(super) time: u8,
    pub(super) size: usize,
    pub(super) metadata: Metadata,
}

#[derive(Serialize, Deserialize)]
pub(super) struct Metadata {
    pub(super) url: Url,
    #[serde(rename = "reqHeaders", skip_serializing_if = "Option::is_none")]
    pub(super) req_headers: Option<ReqHeaders>,
    pub(super) options: Options,
}

#[derive(Serialize, Deserialize, Clone)]
pub struct ReqHeaders {
    pub accept: String,
}

#[derive(Serialize, Deserialize)]
pub(super) struct Options {
    pub(super) compress: bool,
}

pub struct Cache {
    path: PathBuf,
    /// Per-bucket-file locks to serialise concurrent upserts within one process (rayon threads).
    locks: Mutex<HashMap<PathBuf, Arc<Mutex<()>>>>,
}

fn push_hash_segments(path: &mut PathBuf, hash: &str) {
    path.push(&hash[0..2]);
    path.push(&hash[2..4]);
    path.push(&hash[4..]);
}

fn hex_string(bytes: &[u8]) -> String {
    bytes.iter().fold(String::new(), |mut out, n| {
        let _ = write!(out, "{n:02x}");
        out
    })
}

/// Compare two `req_headers` values for equivalence (both None, or both Some with same accept).
fn req_headers_match(a: &Option<ReqHeaders>, b: &Option<ReqHeaders>) -> bool {
    match (a, b) {
        (None, None) => true,
        (Some(a), Some(b)) => a.accept == b.accept,
        _ => false,
    }
}

impl Cache {
    pub fn new(path: PathBuf) -> Cache {
        Cache {
            path,
            locks: Mutex::new(HashMap::new()),
        }
    }

    pub fn init(&self) -> anyhow::Result<()> {
        fs::create_dir_all(self.path.join("content-v2"))?;
        fs::create_dir_all(self.path.join("index-v5"))?;

        Ok(())
    }

    /// Compute the index-v5 bucket file path for a given cache key.
    fn index_path(&self, key: &str) -> PathBuf {
        let mut p = self.path.join("index-v5");
        push_hash_segments(&mut p, &hex_string(&Sha256::new().chain(key).finalize()));
        p
    }

    /// Get (or create) the per-bucket mutex for serialising upserts.
    fn bucket_lock(&self, path: &Path) -> Arc<Mutex<()>> {
        let mut locks = self.locks.lock().unwrap();
        locks.entry(path.to_path_buf()).or_default().clone()
    }

    /// Read all index entries for a given key from its bucket file.
    ///
    /// Returns an empty vec if the bucket file does not exist yet.
    pub(super) fn read_index(&self, key: &str) -> anyhow::Result<Vec<Key>> {
        let index_path = self.index_path(key);
        let content = match fs::read_to_string(&index_path) {
            Ok(c) => c,
            Err(e) if e.kind() == std::io::ErrorKind::NotFound => return Ok(Vec::new()),
            Err(e) => return Err(e.into()),
        };

        let mut entries = Vec::new();
        for line in content.lines() {
            if line.is_empty() {
                continue;
            }
            let json_part = line
                .split_once('\t')
                .map(|(_, json)| json)
                .ok_or_else(|| anyhow!("invalid cache index entry: missing tab separator"))?;
            let entry: Key = serde_json::from_str(json_part)?;
            if entry.key == key {
                entries.push(entry);
            }
        }
        Ok(entries)
    }

    /// Check whether an entry for `key` exists in the cache.
    ///
    /// If `integrity` is `Some`, only returns true if an entry with that exact
    /// integrity string exists. If `integrity` is `None`, returns true if any
    /// entry for the key exists (used for git deps where integrity is computed
    /// from the tarball data).
    pub fn has(&self, key: &str, integrity: Option<&str>) -> bool {
        match self.read_index(key) {
            Ok(entries) => entries
                .iter()
                .any(|e| integrity.map_or(true, |i| e.integrity == i)),
            Err(_) => false,
        }
    }

    /// Check whether an entry for `key` with a specific `accept` header exists.
    ///
    /// Used for packuments, which are cached under the same key but with
    /// different `req_headers.accept` values (corgi vs full doc).
    pub fn has_with_headers(&self, key: &str, accept: &str) -> bool {
        match self.read_index(key) {
            Ok(entries) => entries
                .iter()
                .any(|e| e.metadata.req_headers.as_ref().is_some_and(|h| h.accept == accept)),
            Err(_) => false,
        }
    }

    pub fn put(
        &self,
        key: String,
        url: Url,
        data: &[u8],
        integrity: Option<String>,
        req_headers: Option<ReqHeaders>,
    ) -> anyhow::Result<()> {
        let (algo, hash, integrity) = if let Some(integrity) = integrity {
            let (algo, hash) = integrity
                .split_once('-')
                .expect("hash should be SRI format");

            (algo.to_string(), BASE64.decode(hash.as_bytes())?, integrity)
        } else {
            let hash = Sha512::new().chain(data).finalize();

            (
                String::from("sha512"),
                hash.to_vec(),
                format!("sha512-{}", BASE64.encode(&hash)),
            )
        };

        // --- Content write (idempotent, content-addressed) ---
        let content_path = {
            let mut p = self.path.join("content-v2");

            p.push(algo);

            push_hash_segments(&mut p, &hex_string(&hash));

            p
        };

        fs::create_dir_all(content_path.parent().unwrap())?;

        fs::write(&content_path, data)?;

        // --- Index write (upsert: read-modify-write with atomic rename) ---
        let index_path = self.index_path(&key);
        fs::create_dir_all(index_path.parent().unwrap())?;

        let key_struct = Key {
            key: key.clone(),
            integrity,
            time: 0,
            size: data.len(),
            metadata: Metadata {
                url,
                req_headers,
                options: Options { compress: true },
            },
        };
        let serialized = serde_json::to_string(&key_struct)?;
        let new_line = format!(
            "{:x}\t{serialized}",
            Sha1::new().chain(&serialized).finalize()
        );

        // Serialise upserts to the same bucket file across rayon threads.
        let lock = self.bucket_lock(&index_path);
        let _guard = lock.lock().unwrap();

        // Read existing bucket content (may not exist yet).
        let existing = fs::read_to_string(&index_path).unwrap_or_default();

        // Rebuild: keep all lines except those matching (key, req_headers),
        // then append our single new line.
        // cacache format uses newline as entry separator (see cacache entry-index.js).
        // First entry has no leading newline; subsequent entries are \n-separated.
        let mut new_content = String::new();
        let mut first = true;
        for line in existing.lines() {
            if line.is_empty() {
                continue;
            }
            let json_part = match line.split_once('\t') {
                Some((_, json)) => json,
                None => continue, // skip malformed lines
            };
            let entry: Key = match serde_json::from_str(json_part) {
                Ok(e) => e,
                Err(_) => continue, // skip malformed lines
            };
            // Drop entries with same key AND same req_headers (upsert).
            if entry.key == key && req_headers_match(&entry.metadata.req_headers, &key_struct.metadata.req_headers)
            {
                continue;
            }
            if !first {
                new_content.push('\n');
            }
            new_content.push_str(line);
            first = false;
        }
        if !first {
            new_content.push('\n');
        }
        new_content.push_str(&new_line);

        // Atomic write: temp file in same dir, then rename.
        let dir = index_path.parent().unwrap();
        let mut tmp = NamedTempFile::new_in(dir)?;
        tmp.write_all(new_content.as_bytes())?;
        tmp.as_file().sync_all()?;
        tmp.persist(&index_path)
            .map_err(|e| anyhow!("failed to persist index file: {e}"))?;

        Ok(())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn make_cache() -> (tempfile::TempDir, Cache) {
        let dir = tempfile::tempdir().unwrap();
        let cache = Cache::new(dir.path().join("_cacache"));
        cache.init().unwrap();
        (dir, cache)
    }

    #[test]
    fn put_same_key_twice_has_one_entry() {
        let (_dir, cache) = make_cache();
        let url = Url::parse("https://example.com/foo.tgz").unwrap();
        let key = String::from("make-fetch-happen:request-cache:https://example.com/foo.tgz");

        cache
            .put(
                key.clone(),
                url.clone(),
                b"data1",
                Some("sha512-aaaa".into()),
                None,
            )
            .unwrap();
        cache
            .put(key.clone(), url, b"data1", Some("sha512-aaaa".into()), None)
            .unwrap();

        let entries = cache.read_index(&key).unwrap();
        assert_eq!(entries.len(), 1, "duplicate put should result in one entry");
    }

    #[test]
    fn put_different_headers_both_present() {
        let (_dir, cache) = make_cache();
        let url = Url::parse("https://registry.npmjs.org/foo").unwrap();
        let key = String::from("make-fetch-happen:request-cache:https://registry.npmjs.org/foo");

        cache
            .put(
                key.clone(),
                url.clone(),
                b"data",
                None,
                Some(ReqHeaders {
                    accept: "corgi".into(),
                }),
            )
            .unwrap();
        cache
            .put(
                key.clone(),
                url,
                b"data",
                None,
                Some(ReqHeaders {
                    accept: "full".into(),
                }),
            )
            .unwrap();

        let entries = cache.read_index(&key).unwrap();
        assert_eq!(
            entries.len(),
            2,
            "different req_headers should coexist under same key"
        );
    }

    #[test]
    fn has_returns_correct() {
        let (_dir, cache) = make_cache();
        let url = Url::parse("https://example.com/foo.tgz").unwrap();
        let key = String::from("make-fetch-happen:request-cache:https://example.com/foo.tgz");

        assert!(!cache.has(&key, Some("sha512-aaaa")));
        assert!(!cache.has(&key, None));

        cache
            .put(
                key.clone(),
                url,
                b"data",
                Some("sha512-aaaa".into()),
                None,
            )
            .unwrap();

        assert!(cache.has(&key, Some("sha512-aaaa")));
        assert!(cache.has(&key, None));
        assert!(!cache.has(&key, Some("sha512-bbbb")));
    }

    #[test]
    fn has_with_headers_returns_correct() {
        let (_dir, cache) = make_cache();
        let url = Url::parse("https://registry.npmjs.org/foo").unwrap();
        let key = String::from("make-fetch-happen:request-cache:https://registry.npmjs.org/foo");

        assert!(!cache.has_with_headers(&key, "corgi"));
        assert!(!cache.has_with_headers(&key, "full"));

        cache
            .put(
                key.clone(),
                url,
                b"data",
                None,
                Some(ReqHeaders {
                    accept: "corgi".into(),
                }),
            )
            .unwrap();

        assert!(cache.has_with_headers(&key, "corgi"));
        assert!(!cache.has_with_headers(&key, "full"));
    }

    #[test]
    fn two_different_keys_both_survive() {
        let (_dir, cache) = make_cache();
        let url1 = Url::parse("https://example.com/foo.tgz").unwrap();
        let url2 = Url::parse("https://example.com/bar.tgz").unwrap();
        let key1 = String::from("make-fetch-happen:request-cache:https://example.com/foo.tgz");
        let key2 = String::from("make-fetch-happen:request-cache:https://example.com/bar.tgz");

        cache
            .put(
                key1.clone(),
                url1,
                b"data1",
                Some("sha512-aaaa".into()),
                None,
            )
            .unwrap();
        cache
            .put(
                key2.clone(),
                url2,
                b"data2",
                Some("sha512-bbbb".into()),
                None,
            )
            .unwrap();

        assert!(cache.has(&key1, Some("sha512-aaaa")));
        assert!(cache.has(&key2, Some("sha512-bbbb")));
    }

    #[test]
    fn put_replaces_stale_entry() {
        // Putting with different integrity for the same key should replace, not duplicate.
        let (_dir, cache) = make_cache();
        let url = Url::parse("https://example.com/foo.tgz").unwrap();
        let key = String::from("make-fetch-happen:request-cache:https://example.com/foo.tgz");

        cache
            .put(
                key.clone(),
                url.clone(),
                b"data1",
                Some("sha512-aaaa".into()),
                None,
            )
            .unwrap();
        cache
            .put(key.clone(), url, b"data2", Some("sha512-bbbb".into()), None)
            .unwrap();

        let entries = cache.read_index(&key).unwrap();
        assert_eq!(entries.len(), 1, "upsert should replace, not duplicate");
        assert_eq!(entries[0].integrity, "sha512-bbbb");
    }
}
