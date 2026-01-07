use anyhow::{anyhow, bail};
use rayon::slice::ParallelSliceMut;
use std::{cmp::Ordering, collections::HashSet, fmt, string::String};
use url::Url;
use yarn_lock_parser::{parse_str, Lockfile};

pub(super) fn packages(content: &str) -> anyhow::Result<Vec<Package>> {
    let lockfile: Lockfile = parse_str(&content)?;

    let mut packages: Vec<_> = match lockfile.version {
        1 => lockfile
            .entries
            .into_iter()
            .filter(|p| matches!(UrlOrString::new(p.resolved), Some(UrlOrString::Url(_))))
            .map(|p| Package {
                name: Some(String::from(p.name)),
                resolved: UrlOrString::new(p.resolved),
                integrity: {
                    let h = match p.integrity {
                        "" => "sha512-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==",
                        _ => p.integrity,
                    };
                    match HashCollection::from_str(h) {
                        Ok(Collection) => Some(Collection),
                        Err(_) => None
                    }
                },
            })
            .collect(),
        _ => bail!(
            "We don't support lockfile version {}, if it's not v1 please use yarn-berry tooling.",
            lockfile.version
        ),
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

#[derive(Debug, PartialEq, Eq)]
pub(super) struct Package {
    pub(super) name: Option<String>,
    pub(super) resolved: Option<UrlOrString>,
    pub(super) integrity: Option<HashCollection>,
}

#[derive(Debug, PartialEq, Eq, PartialOrd, Ord)]
pub(super) enum UrlOrString {
    Url(Url),
    String(String),
}

impl UrlOrString {
    fn new(s: impl AsRef<str>) -> Option<UrlOrString> {
        let sr = s.as_ref();
        match Url::parse(sr) {
            Ok(url) => Some(UrlOrString::Url(url)),
            Err(_) => Some(UrlOrString::String(String::from(sr))),
        }
    }
}

impl fmt::Display for UrlOrString {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            UrlOrString::Url(url) => url.fmt(f),
            UrlOrString::String(string) => string.fmt(f),
        }
    }
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

#[derive(Clone, Debug, PartialEq, Eq, Hash)]
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

#[cfg(test)]
mod tests {
    use super::{packages, Hash, HashCollection, Package, UrlOrString};
    use std::{cmp::Ordering, collections::HashSet};
    use url::Url;

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
        let packages = packages(
            r#"# THIS IS AN AUTOGENERATED FILE. DO NOT EDIT THIS FILE DIRECTLY.
# yarn lockfile v1


"@babel/highlight@^7.12.13":
  version "7.12.13"
  resolved "https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.12.13.tgz#8ab538393e00370b26271b01fa08f7f27f2e795c"
  integrity sha512-kocDQvIbgMKlWxXe9fof3TQ+gkIPOUSEYhJjqUjvKMez3krV7vbzYCDq39Oj11UAVK7JqPVGQPlgE85dPNlQww==
  dependencies:
    "@babel/helper-validator-identifier" "^7.12.11"
    chalk "^2.0.0"
    js-tokens "^4.0.0"
"#).unwrap();

        assert_eq!(packages.len(), 1);
        assert_eq!(
            packages[0].resolved,
            Some(UrlOrString::Url(
                Url::parse("https://registry.yarnpkg.com/@babel/highlight/-/highlight-7.12.13.tgz#8ab538393e00370b26271b01fa08f7f27f2e795c")
                    .unwrap()
            ))
        );
    }
}
