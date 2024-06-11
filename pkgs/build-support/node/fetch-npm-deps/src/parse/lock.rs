use crate::lockfile::{NpmDependency, NpmLockfile, NpmPackage};
use anyhow::{anyhow, Context};
use rayon::slice::ParallelSliceMut;
use serde::{
    de::{self, Visitor},
    Deserialize, Deserializer,
};
use std::{
    cmp::Ordering,
    collections::{HashMap, HashSet},
    fmt,
};
use url::Url;

pub(super) fn extract_packages(content: &str) -> anyhow::Result<Vec<NpmPackage>> {
    let lockfile: NpmLockfile = serde_json::from_str(content)?;

    let mut packages = match lockfile {
        NpmLockfile::V1(lock) => {
            let initial_url = get_initial_url()?;

            to_new_packages(lock.dependencies, &initial_url)?
        }
        NpmLockfile::V2(lock) => get_valid_external_dependencies(lock.packages),
        NpmLockfile::V3(lock) => get_valid_external_dependencies(lock.packages),
    };

    packages.par_sort_by(|x, y| {
        x.resolved
            .partial_cmp(&y.resolved)
            .expect("resolved should be comparable")
            .then(
                // v1 lockfiles can contain multiple references to the same version of a package, with
                // different integrity values (e.g. a SHA-1 and a SHA-512 in one, but just a SHA-512 in another)
                y.integrity
                    .partial_cmp(&x.integrity)
                    .expect("integrity should be comparable"),
            )
    });

    packages.dedup_by(|x, y| x.resolved == y.resolved);

    Ok(packages)
}

fn get_valid_external_dependencies(packages: HashMap<String, NpmPackage>) -> Vec<NpmPackage> {
    packages
        .into_iter()
        .filter(|(n, p)| {
            !n.is_empty() && matches!(p.resolved.as_ref().map(|r| Url::parse(&r)), Some(Ok(_)))
        })
        .map(|(n, p)| NpmPackage { name: Some(n), ..p })
        .collect()
}

#[derive(Debug, PartialEq, Eq)]
pub struct HashCollection(HashSet<Hash>);

impl HashCollection {
    pub fn from_str(s: impl AsRef<str>) -> anyhow::Result<HashCollection> {
        let hashes = s
            .as_ref()
            .split_ascii_whitespace()
            .map(Hash::new)
            .collect::<anyhow::Result<_>>()?;

        Ok(HashCollection(hashes))
    }

    pub fn into_best(self) -> Option<Hash> {
        self.0.into_iter().max()
    }
}

impl PartialOrd for HashCollection {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        let lhs = self.0.iter().max()?;
        let rhs = other.0.iter().max()?;

        lhs.partial_cmp(rhs)
    }
}

impl<'de> Deserialize<'de> for HashCollection {
    fn deserialize<D>(deserializer: D) -> Result<HashCollection, D::Error>
    where
        D: Deserializer<'de>,
    {
        deserializer.deserialize_string(HashCollectionVisitor)
    }
}

struct HashCollectionVisitor;

impl<'de> Visitor<'de> for HashCollectionVisitor {
    type Value = HashCollection;

    fn expecting(&self, formatter: &mut fmt::Formatter) -> fmt::Result {
        formatter.write_str("a single SRI hash or a collection of them (separated by spaces)")
    }

    fn visit_str<E>(self, value: &str) -> Result<HashCollection, E>
    where
        E: de::Error,
    {
        HashCollection::from_str(value).map_err(E::custom)
    }
}

#[derive(Clone, Debug, Deserialize, PartialEq, Eq, Hash)]
pub struct Hash(String);

// Hash algorithms, in ascending preference.
const ALGOS: &[&str] = &["sha1", "sha512"];

impl Hash {
    fn new(s: impl AsRef<str>) -> anyhow::Result<Hash> {
        let algo = s
            .as_ref()
            .split_once('-')
            .ok_or_else(|| anyhow!("expected SRI hash, got {:?}", s.as_ref()))?
            .0;

        if ALGOS.iter().any(|&a| algo == a) {
            Ok(Hash(s.as_ref().to_string()))
        } else {
            Err(anyhow!("unknown hash algorithm {algo:?}"))
        }
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}

impl fmt::Display for Hash {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        self.as_str().fmt(f)
    }
}

#[allow(clippy::non_canonical_partial_ord_impl)]
impl PartialOrd for Hash {
    fn partial_cmp(&self, other: &Hash) -> Option<Ordering> {
        let lhs = self.0.split_once('-')?.0;
        let rhs = other.0.split_once('-')?.0;

        ALGOS
            .iter()
            .position(|&s| lhs == s)?
            .partial_cmp(&ALGOS.iter().position(|&s| rhs == s)?)
    }
}

impl Ord for Hash {
    fn cmp(&self, other: &Hash) -> Ordering {
        self.partial_cmp(other).unwrap()
    }
}

#[allow(clippy::case_sensitive_file_extension_comparisons)]
fn to_new_packages(
    old_packages: HashMap<String, NpmDependency>,
    initial_url: &Url,
) -> anyhow::Result<Vec<NpmPackage>> {
    let mut new = Vec::new();

    for (name, mut package) in old_packages {
        // In some cases, a bundled dependency happens to have the same version as a non-bundled one, causing
        // the bundled one without a URL to override the entry for the non-bundled instance, which prevents the
        // dependency from being downloaded.
        if package.bundled {
            continue;
        }

        if let Some(Ok(v)) = package.version.as_ref().map(|v| Url::parse(v)) {
            if v.scheme() == "npm" {
                if let Some(Ok(url)) = &package.resolved.as_deref().map(Url::parse) {
                    package.version = Some(url.to_string());
                }
            } else {
                for (scheme, host) in [
                    ("github", "github.com"),
                    ("bitbucket", "bitbucket.org"),
                    ("gitlab", "gitlab.com"),
                ] {
                    if v.scheme() == scheme {
                        package.version = {
                            let mut new_url = initial_url.clone();

                            new_url.set_host(Some(host))?;

                            if v.path().ends_with(".git") {
                                new_url.set_path(v.path());
                            } else {
                                new_url.set_path(&format!("{}.git", v.path()));
                            }

                            new_url.set_fragment(v.fragment());

                            Some(new_url.to_string())
                        };

                        break;
                    }
                }
            }
        }

        new.push(NpmPackage {
            name: Some(name),
            resolved: if let Some(Ok(_)) = package.version.as_ref().map(|v| Url::parse(&v)) {
                package.version
            } else {
                package.resolved
            },
            integrity: package.integrity,
            ..Default::default()
        });

        if !package.dependencies.is_empty() {
            new.append(&mut to_new_packages(package.dependencies, initial_url)?);
        }
    }

    Ok(new)
}

fn get_initial_url() -> anyhow::Result<Url> {
    Url::parse("git+ssh://git@a.b").context("initial url should be valid")
}

#[cfg(test)]
mod tests {
    use super::{get_initial_url, extract_packages, to_new_packages, Hash, HashCollection};
    use crate::lockfile::{NpmDependency, NpmPackage};
    use std::{
        cmp::Ordering,
        collections::{HashMap, HashSet},
    };

    #[test]
    fn git_shorthand_v1() -> anyhow::Result<()> {
        let old = {
            let mut o = HashMap::new();
            o.insert(
                String::from("sqlite3"),
                NpmDependency {
                    version: Some(
                        "github:mapbox/node-sqlite3#593c9d498be2510d286349134537e3bf89401c4a"
                            .to_string(),
                    ),
                    ..Default::default()
                },
            );
            o
        };

        let initial_url = get_initial_url()?;

        let new = to_new_packages(old, &initial_url)?;

        assert_eq!(new.len(), 1, "new packages map should contain 1 value");
        assert_eq!(new[0], NpmPackage {
            name: Some(String::from("sqlite3")),
            resolved: Some("git+ssh://git@github.com/mapbox/node-sqlite3.git#593c9d498be2510d286349134537e3bf89401c4a".to_string()),
            ..Default::default()
        });

        Ok(())
    }

    #[test]
    fn hash_preference() {
        assert_eq!(
            Hash(String::from("sha1-foo")).partial_cmp(&Hash(String::from("sha512-foo"))),
            Some(Ordering::Less)
        );

        assert_eq!(
            HashCollection({
                let mut set = HashSet::new();
                set.insert(Hash(String::from("sha512-foo")));
                set.insert(Hash(String::from("sha1-bar")));
                set
            })
            .into_best(),
            Some(Hash(String::from("sha512-foo")))
        );
    }

    #[test]
    fn parse_lockfile_correctly() {
        let packages = extract_packages(
            r#"{
                "name": "node-ddr",
                "version": "1.0.0",
                "lockfileVersion": 1,
                "requires": true,
                "dependencies": {
                    "string-width-cjs": {
                        "version": "npm:string-width@4.2.3",
                        "resolved": "https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz",
                        "integrity": "sha512-wKyQRQpjJ0sIp62ErSZdGsjMJWsap5oRNihHhu6G7JVO/9jIB6UyevL+tXuOqrng8j/cxKTWyWUwvSTriiZz/g==",
                        "requires": {
                            "emoji-regex": "^8.0.0",
                            "is-fullwidth-code-point": "^3.0.0",
                            "strip-ansi": "^6.0.1"
                        }
                    }
                }
            }"#).unwrap();

        assert_eq!(packages.len(), 1);
        assert_eq!(
            packages[0].resolved,
            Some("https://registry.npmjs.org/string-width/-/string-width-4.2.3.tgz".to_string())
        );
    }
}
