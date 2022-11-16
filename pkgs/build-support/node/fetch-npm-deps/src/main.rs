#![warn(clippy::pedantic)]

use crate::cacache::Cache;
use anyhow::{anyhow, Context};
use rayon::prelude::*;
use serde::Deserialize;
use std::{
    collections::{HashMap, HashSet},
    env, fmt, fs,
    path::Path,
    process::{self, Command},
};
use tempfile::tempdir;
use url::Url;

mod cacache;
#[cfg(test)]
mod tests;

#[derive(Deserialize)]
struct PackageLock {
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
struct Package {
    resolved: Option<UrlOrString>,
    integrity: Option<String>,
}

#[derive(Debug, Deserialize, PartialEq, Eq)]
#[serde(untagged)]
enum UrlOrString {
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
) -> anyhow::Result<HashMap<String, Package>> {
    let mut new = HashMap::new();

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

        new.insert(
            format!("{name}-{}", package.version),
            Package {
                resolved: if matches!(package.version, UrlOrString::Url(_)) {
                    Some(package.version)
                } else {
                    package.resolved
                },
                integrity: package.integrity,
            },
        );

        if let Some(dependencies) = package.dependencies {
            new.extend(to_new_packages(dependencies, initial_url)?);
        }
    }

    Ok(new)
}

#[allow(clippy::case_sensitive_file_extension_comparisons)]
fn get_hosted_git_url(url: &Url) -> Option<Url> {
    if ["git", "http", "git+ssh", "git+https", "ssh", "https"].contains(&url.scheme()) {
        let mut s = url.path_segments()?;

        match url.host_str()? {
            "github.com" => {
                let user = s.next()?;
                let mut project = s.next()?;
                let typ = s.next();
                let mut commit = s.next();

                if typ.is_none() {
                    commit = url.fragment();
                } else if typ.is_some() && typ != Some("tree") {
                    return None;
                }

                if project.ends_with(".git") {
                    project = project.strip_suffix(".git")?;
                }

                let commit = commit.unwrap();

                Some(
                    Url::parse(&format!(
                        "https://codeload.github.com/{user}/{project}/tar.gz/{commit}"
                    ))
                    .ok()?,
                )
            }
            "bitbucket.org" => {
                let user = s.next()?;
                let mut project = s.next()?;
                let aux = s.next();

                if aux == Some("get") {
                    return None;
                }

                if project.ends_with(".git") {
                    project = project.strip_suffix(".git")?;
                }

                let commit = url.fragment()?;

                Some(
                    Url::parse(&format!(
                        "https://bitbucket.org/{user}/{project}/get/{commit}.tar.gz"
                    ))
                    .ok()?,
                )
            }
            "gitlab.com" => {
                let path = &url.path()[1..];

                if path.contains("/~/") || path.contains("/archive.tar.gz") {
                    return None;
                }

                let user = s.next()?;
                let mut project = s.next()?;

                if project.ends_with(".git") {
                    project = project.strip_suffix(".git")?;
                }

                let commit = url.fragment()?;

                Some(
                    Url::parse(&format!(
                    "https://gitlab.com/{user}/{project}/repository/archive.tar.gz?ref={commit}"
                ))
                    .ok()?,
                )
            }
            "git.sr.ht" => {
                let user = s.next()?;
                let mut project = s.next()?;
                let aux = s.next();

                if aux == Some("archive") {
                    return None;
                }

                if project.ends_with(".git") {
                    project = project.strip_suffix(".git")?;
                }

                let commit = url.fragment()?;

                Some(
                    Url::parse(&format!(
                        "https://git.sr.ht/{user}/{project}/archive/{commit}.tar.gz"
                    ))
                    .ok()?,
                )
            }
            _ => None,
        }
    } else {
        None
    }
}

fn get_ideal_hash(integrity: &str) -> anyhow::Result<&str> {
    let split: Vec<_> = integrity.split_ascii_whitespace().collect();

    if split.len() == 1 {
        Ok(split[0])
    } else {
        for hash in ["sha512-", "sha1-"] {
            if let Some(h) = split.iter().find(|s| s.starts_with(hash)) {
                return Ok(h);
            }
        }

        Err(anyhow!("not sure which hash to select out of {split:?}"))
    }
}

fn get_initial_url() -> anyhow::Result<Url> {
    Url::parse("git+ssh://git@a.b").context("initial url should be valid")
}

fn main() -> anyhow::Result<()> {
    let args = env::args().collect::<Vec<_>>();

    if args.len() < 2 {
        println!("usage: {} <path/to/package-lock.json>", args[0]);
        println!();
        println!("Prefetches npm dependencies for usage by fetchNpmDeps.");

        process::exit(1);
    }

    let lock_content = fs::read_to_string(&args[1])?;
    let lock: PackageLock = serde_json::from_str(&lock_content)?;

    let out_tempdir;

    let (out, print_hash) = if let Some(path) = args.get(2) {
        (Path::new(path), false)
    } else {
        out_tempdir = tempdir()?;

        (out_tempdir.path(), true)
    };

    let agent = ureq::agent();

    eprintln!("lockfile version: {}", lock.version);

    let packages = match lock.version {
        1 => {
            let initial_url = get_initial_url()?;

            lock.dependencies
                .map(|p| to_new_packages(p, &initial_url))
                .transpose()?
        }
        2 | 3 => lock.packages,
        _ => panic!(
            "We don't support lockfile version {}, please file an issue.",
            lock.version
        ),
    };

    if packages.is_none() {
        return Ok(());
    }

    let packages = {
        let mut seen = HashSet::new();
        let mut new_packages = HashMap::new();

        for (dep, package) in packages.unwrap().drain() {
            if let (false, Some(UrlOrString::Url(resolved))) = (dep.is_empty(), &package.resolved) {
                if !seen.contains(resolved) {
                    seen.insert(resolved.clone());
                    new_packages.insert(dep, package);
                }
            }
        }

        new_packages
    };

    let cache = Cache::new(out.join("_cacache"));

    packages.into_par_iter().try_for_each(|(dep, package)| {
        eprintln!("{dep}");

        let mut resolved = match package.resolved {
            Some(UrlOrString::Url(url)) => url,
            _ => unreachable!(),
        };

        if let Some(hosted_git_url) = get_hosted_git_url(&resolved) {
            resolved = hosted_git_url;
        }

        let mut data = Vec::new();

        agent
            .get(resolved.as_str())
            .call()?
            .into_reader()
            .read_to_end(&mut data)?;

        cache
            .put(
                format!("make-fetch-happen:request-cache:{resolved}"),
                resolved,
                &data,
                package
                    .integrity
                    .map(|i| Ok::<String, anyhow::Error>(get_ideal_hash(&i)?.to_string()))
                    .transpose()?,
            )
            .map_err(|e| anyhow!("couldn't insert cache entry for {dep}: {e:?}"))?;

        Ok::<_, anyhow::Error>(())
    })?;

    fs::write(out.join("package-lock.json"), lock_content)?;

    if print_hash {
        Command::new("nix")
            .args(["--experimental-features", "nix-command", "hash", "path"])
            .arg(out.as_os_str())
            .status()?;
    }

    Ok(())
}
