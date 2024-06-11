#![warn(clippy::pedantic)]

use crate::cacache::{Cache, Key};
use anyhow::anyhow;
use lockfile::{NpmDependency, NpmLockfile, NpmPackage};
use rayon::prelude::*;
use std::{
    collections::HashMap,
    env, fs,
    path::{Path, PathBuf},
    process,
};
use tempfile::tempdir;
use url::Url;
use walkdir::WalkDir;

mod cacache;
mod lockfile;
mod parse;
mod util;

fn cache_map_path() -> Option<PathBuf> {
    env::var_os("CACHE_MAP_PATH").map(PathBuf::from)
}

/// `fixup_lockfile` rewrites `integrity` hashes to match cache and removes the `integrity` field from Git dependencies.
///
/// Sometimes npm has multiple instances of a given `resolved` URL that have different types of `integrity` hashes (e.g. SHA-1
/// and SHA-512) in the lockfile. Given we only cache one version of these, the `integrity` field must be normalized to the hash
/// we cache as (which is the strongest available one).
///
/// Git dependencies from specific providers can be retrieved from those providers' automatic tarball features.
/// When these dependencies are specified with a commit identifier, npm generates a tarball, and inserts the integrity hash of that
/// tarball into the lockfile.
///
/// Thus, we remove this hash, to replace it with our own determinstic copies of dependencies from hosted Git providers.
///
/// If no fixups were performed, `None` is returned and the lockfile structure should be left as-is. If fixups were performed, the
/// `dependencies` key in v2 lockfiles designed for backwards compatibility with v1 parsers is removed because of inconsistent data.
fn fixup_lockfile(
    mut lock: NpmLockfile,
    cache: Option<&HashMap<String, String>>,
) -> anyhow::Result<Option<NpmLockfile>> {
    let mut fixed = false;

    match &mut lock {
        NpmLockfile::V1(lock) => fixup_v1_deps(&mut lock.dependencies, cache, &mut fixed),
        NpmLockfile::V2(lock) => {
            fixup_v2_deps(&mut lock.packages, cache, &mut fixed);
            if fixed {
                lock.dependencies.clear();
            }
        }
        NpmLockfile::V3(lock) => {
            // v3 just uses v2 format, without backwards compatibility to v1
            fixup_v2_deps(&mut lock.packages, cache, &mut fixed);
        }
    };

    if fixed {
        Ok(Some(lock))
    } else {
        Ok(None)
    }
}

// Recursive helper to fixup v1 lockfile deps
fn fixup_v1_deps(
    dependencies: &mut HashMap<String, NpmDependency>,
    cache: Option<&HashMap<String, String>>,
    fixed: &mut bool,
) {
    for (_, dependency) in dependencies.iter_mut() {
        if let NpmDependency {
            resolved: Some(resolved),
            integrity: Some(integrity),
            ..
        } = dependency
        {
            if resolved.starts_with("git+ssh://") {
                *fixed = true;
                dependency.integrity = None;
            } else if let Some(cache_hashes) = cache {
                let cache_hash = cache_hashes
                    .get(&resolved.to_string())
                    .expect("dependency should have a hash");
                if integrity != cache_hash {
                    *fixed = true;
                    dependency.integrity = Some(cache_hash.clone());
                }
            }
        }
        if !dependency.dependencies.is_empty() {
            fixup_v1_deps(&mut dependency.dependencies, cache, fixed);
        }
    }
}

fn fixup_v2_deps(
    packages: &mut HashMap<String, NpmPackage>,
    cache: Option<&HashMap<String, String>>,
    fixed: &mut bool,
) {
    for (_, package) in packages {
        if let NpmPackage {
            resolved: Some(resolved),
            integrity: Some(integrity),
            ..
        } = package
        {
            if resolved.starts_with("git+ssh://") {
                *fixed = true;
                package.integrity = None;
            } else if let Some(cache_hashes) = cache {
                let cache_hash = cache_hashes
                    .get(&resolved.to_string())
                    .expect("dependency should have a hash");

                if integrity != cache_hash {
                    *fixed = true;

                    package.integrity = Some(cache_hash.clone());
                }
            }
        }
    }
}

fn map_cache() -> anyhow::Result<HashMap<Url, String>> {
    let mut hashes = HashMap::new();

    let content_path = Path::new(&env::var_os("npmDeps").unwrap()).join("_cacache/index-v5");

    for entry in WalkDir::new(content_path) {
        let entry = entry?;

        if entry.file_type().is_file() {
            let content = fs::read_to_string(entry.path())?;
            let key: Key = serde_json::from_str(content.split_ascii_whitespace().nth(1).unwrap())?;

            hashes.insert(key.metadata.url, key.integrity);
        }
    }

    Ok(hashes)
}

fn main() -> anyhow::Result<()> {
    env_logger::init();

    let args = env::args().collect::<Vec<_>>();

    if args.len() < 2 {
        println!("usage: {} <path/to/package-lock.json>", args[0]);
        println!();
        println!("Prefetches npm dependencies for usage by fetchNpmDeps.");

        process::exit(1);
    }

    if let Ok(jobs) = env::var("NIX_BUILD_CORES") {
        if !jobs.is_empty() {
            rayon::ThreadPoolBuilder::new()
                .num_threads(
                    jobs.parse()
                        .expect("NIX_BUILD_CORES must be a whole number"),
                )
                .build_global()
                .unwrap();
        }
    }

    if args[1] == "--fixup-lockfile" {
        let lock: NpmLockfile = serde_json::from_str(&fs::read_to_string(&args[2])?)?;

        let cache = cache_map_path()
            .map(|map_path| Ok::<_, anyhow::Error>(serde_json::from_slice(&fs::read(map_path)?)?))
            .transpose()?;

        if let Some(fixed) = fixup_lockfile(lock, cache.as_ref())? {
            println!("Fixing lockfile");

            fs::write(&args[2], serde_json::to_string(&fixed)?)?;
        }

        return Ok(());
    } else if args[1] == "--map-cache" {
        let map = map_cache()?;

        fs::write(
            cache_map_path().expect("CACHE_MAP_PATH environment variable must be set"),
            serde_json::to_string(&map)?,
        )?;

        return Ok(());
    }

    let lock_content = fs::read_to_string(&args[1])?;

    let out_tempdir;

    let (out, print_hash) = if let Some(path) = args.get(2) {
        (Path::new(path), false)
    } else {
        out_tempdir = tempdir()?;

        (out_tempdir.path(), true)
    };

    let packages = parse::lockfile(
        &lock_content,
        env::var("FORCE_GIT_DEPS").is_ok(),
        env::var("FORCE_EMPTY_CACHE").is_ok(),
    )?;

    let cache = Cache::new(out.join("_cacache"));
    cache.init()?;

    packages.into_par_iter().try_for_each(|package| {
        eprintln!("{}", package.name);

        let tarball = package
            .tarball()
            .map_err(|e| anyhow!("couldn't fetch {} at {}: {e:?}", package.name, package.url))?;
        let integrity = package.integrity().map(ToString::to_string);

        cache
            .put(
                format!("make-fetch-happen:request-cache:{}", package.url),
                package.url,
                &tarball,
                integrity,
            )
            .map_err(|e| anyhow!("couldn't insert cache entry for {}: {e:?}", package.name))?;

        Ok::<_, anyhow::Error>(())
    })?;

    fs::write(out.join("package-lock.json"), lock_content)?;

    if print_hash {
        println!("{}", util::make_sri_hash(out)?);
    }

    Ok(())
}

#[cfg(test)]
mod tests {
    use std::collections::HashMap;

    use super::fixup_lockfile;
    use super::lockfile::NpmLockfile;
    use serde_json::json;

    #[test]
    fn lockfile_fixup() -> anyhow::Result<()> {
        let input: NpmLockfile = serde_json::from_value(json!({
            "lockfileVersion": 2,
            "name": "foo",
            "packages": {
                "": {

                },
                "foo": {
                    "resolved": "https://github.com/NixOS/nixpkgs",
                    "integrity": "sha1-aaa"
                },
                "bar": {
                    "resolved": "git+ssh://git@github.com/NixOS/nixpkgs.git",
                    "integrity": "sha512-aaa"
                },
                "foo-bad": {
                    "resolved": "foo",
                    "integrity": "sha1-foo"
                },
                "foo-good": {
                    "resolved": "foo",
                    "integrity": "sha512-foo"
                },
            }
        }))?;

        let expected: NpmLockfile = serde_json::from_value(json!({
            "lockfileVersion": 2,
            "name": "foo",
            "packages": {
                "": {

                },
                "foo": {
                    "resolved": "https://github.com/NixOS/nixpkgs",
                    "integrity": ""
                },
                "bar": {
                    "resolved": "git+ssh://git@github.com/NixOS/nixpkgs.git",
                },
                "foo-bad": {
                    "resolved": "foo",
                    "integrity": "sha512-foo"
                },
                "foo-good": {
                    "resolved": "foo",
                    "integrity": "sha512-foo"
                },
            }
        }))?;

        let mut hashes = HashMap::new();

        hashes.insert(
            String::from("https://github.com/NixOS/nixpkgs"),
            String::new(),
        );

        hashes.insert(
            String::from("git+ssh://git@github.com/NixOS/nixpkgs.git"),
            String::new(),
        );

        hashes.insert(String::from("foo"), String::from("sha512-foo"));

        assert_eq!(fixup_lockfile(input, Some(&hashes))?, Some(expected));

        Ok(())
    }

    #[test]
    fn lockfile_v1_fixup() -> anyhow::Result<()> {
        let input: NpmLockfile = serde_json::from_value(json!({
            "lockfileVersion": 1,
            "name": "foo",
            "dependencies": {
                "foo": {
                    "resolved": "https://github.com/NixOS/nixpkgs",
                    "integrity": "sha512-aaa"
                },
                "foo-good": {
                    "resolved": "foo",
                    "integrity": "sha512-foo"
                },
                "bar": {
                    "resolved": "git+ssh://git@github.com/NixOS/nixpkgs.git",
                    "integrity": "sha512-bbb",
                    "dependencies": {
                        "foo-bad": {
                            "resolved": "foo",
                            "integrity": "sha1-foo"
                        },
                    },
                },
            }
        }))?;

        let expected: NpmLockfile = serde_json::from_value(json!({
            "lockfileVersion": 1,
            "name": "foo",
            "dependencies": {
                "foo": {
                    "resolved": "https://github.com/NixOS/nixpkgs",
                    "integrity": ""
                },
                "foo-good": {
                    "resolved": "foo",
                    "integrity": "sha512-foo"
                },
                "bar": {
                    "resolved": "git+ssh://git@github.com/NixOS/nixpkgs.git",
                    "dependencies": {
                        "foo-bad": {
                            "resolved": "foo",
                            "integrity": "sha512-foo"
                        },
                    },
                },
            }
        }))?;

        let mut hashes = HashMap::new();

        hashes.insert(
            String::from("https://github.com/NixOS/nixpkgs"),
            String::new(),
        );

        hashes.insert(
            String::from("git+ssh://git@github.com/NixOS/nixpkgs.git"),
            String::new(),
        );

        hashes.insert(String::from("foo"), String::from("sha512-foo"));

        assert_eq!(fixup_lockfile(input, Some(&hashes))?, Some(expected));

        Ok(())
    }
}
