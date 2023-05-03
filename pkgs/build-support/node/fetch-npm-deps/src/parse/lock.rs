use anyhow::{bail, Context};
use rayon::slice::ParallelSliceMut;
use serde::Deserialize;
use std::{collections::HashMap, fmt};
use url::Url;

pub(super) fn packages(content: &str) -> anyhow::Result<Vec<Package>> {
    let lockfile: Lockfile = serde_json::from_str(content)?;

    let mut packages = match lockfile.version {
        1 => {
            let initial_url = get_initial_url()?;

            lockfile
                .dependencies
                .map(|p| to_new_packages(p, &initial_url))
                .transpose()?
        }
        2 | 3 => lockfile.packages.map(|pkgs| {
            pkgs.into_iter()
                .filter(|(n, p)| !n.is_empty() && matches!(p.resolved, Some(UrlOrString::Url(_))))
                .map(|(n, p)| Package { name: Some(n), ..p })
                .collect()
        }),
        _ => bail!(
            "We don't support lockfile version {}, please file an issue.",
            lockfile.version
        ),
    }
    .expect("lockfile should have packages");

    packages.par_sort_by(|x, y| {
        x.resolved
            .partial_cmp(&y.resolved)
            .expect("resolved should be comparable")
    });

    packages.dedup_by(|x, y| x.resolved == y.resolved);

    Ok(packages)
}

#[derive(Deserialize)]
struct Lockfile {
    #[serde(rename = "lockfileVersion")]
    version: u8,
    dependencies: Option<HashMap<String, OldPackage>>,
    packages: Option<HashMap<String, Package>>,
}

#[derive(Deserialize)]
struct OldPackage {
    version: UrlOrString,
    #[serde(default)]
    bundled: bool,
    resolved: Option<UrlOrString>,
    integrity: Option<String>,
    dependencies: Option<HashMap<String, OldPackage>>,
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
pub(super) struct Package {
    #[serde(default)]
    pub(super) name: Option<String>,
    pub(super) resolved: Option<UrlOrString>,
    pub(super) integrity: Option<String>,
}

#[derive(Debug, Deserialize, PartialEq, Eq, PartialOrd, Ord)]
#[serde(untagged)]
pub(super) enum UrlOrString {
    Url(Url),
    String(String),
}

impl fmt::Display for UrlOrString {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            UrlOrString::Url(url) => url.fmt(f),
            UrlOrString::String(string) => string.fmt(f),
        }
    }
}

#[allow(clippy::case_sensitive_file_extension_comparisons)]
fn to_new_packages(
    old_packages: HashMap<String, OldPackage>,
    initial_url: &Url,
) -> anyhow::Result<Vec<Package>> {
    let mut new = Vec::new();

    for (name, mut package) in old_packages {
        // In some cases, a bundled dependency happens to have the same version as a non-bundled one, causing
        // the bundled one without a URL to override the entry for the non-bundled instance, which prevents the
        // dependency from being downloaded.
        if package.bundled {
            continue;
        }

        if let UrlOrString::Url(v) = &package.version {
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

                        UrlOrString::Url(new_url)
                    };

                    break;
                }
            }
        }

        new.push(Package {
            name: Some(name),
            resolved: if matches!(package.version, UrlOrString::Url(_)) {
                Some(package.version)
            } else {
                package.resolved
            },
            integrity: package.integrity,
        });

        if let Some(dependencies) = package.dependencies {
            new.append(&mut to_new_packages(dependencies, initial_url)?);
        }
    }

    Ok(new)
}

fn get_initial_url() -> anyhow::Result<Url> {
    Url::parse("git+ssh://git@a.b").context("initial url should be valid")
}

#[cfg(test)]
mod tests {
    use super::{get_initial_url, to_new_packages, OldPackage, Package, UrlOrString};
    use std::collections::HashMap;
    use url::Url;

    #[test]
    fn git_shorthand_v1() -> anyhow::Result<()> {
        let old = {
            let mut o = HashMap::new();
            o.insert(
                String::from("sqlite3"),
                OldPackage {
                    version: UrlOrString::Url(
                        Url::parse(
                            "github:mapbox/node-sqlite3#593c9d498be2510d286349134537e3bf89401c4a",
                        )
                        .unwrap(),
                    ),
                    bundled: false,
                    resolved: None,
                    integrity: None,
                    dependencies: None,
                },
            );
            o
        };

        let initial_url = get_initial_url()?;

        let new = to_new_packages(old, &initial_url)?;

        assert_eq!(new.len(), 1, "new packages map should contain 1 value");
        assert_eq!(new[0], Package {
            name: Some(String::from("sqlite3")),
            resolved: Some(UrlOrString::Url(Url::parse("git+ssh://git@github.com/mapbox/node-sqlite3.git#593c9d498be2510d286349134537e3bf89401c4a").unwrap())),
            integrity: None
        });

        Ok(())
    }
}
