#![warn(clippy::pedantic)]

use crate::cacache::{Cache, Key, ReqHeaders};
use anyhow::{anyhow, bail};
use log::info;
use rayon::prelude::*;
use serde_json::{Map, Value};
use std::{
    collections::{HashMap, HashSet},
    env, fs,
    path::{Path, PathBuf},
    process,
};
use tempfile::tempdir;
use url::Url;
use walkdir::WalkDir;

mod cacache;
mod parse;
mod util;

fn cache_map_path() -> Option<PathBuf> {
    env::var_os("CACHE_MAP_PATH").map(PathBuf::from)
}

/// Get the packument URL for a package name
fn get_packument_url(registry: &str, package_name: &str) -> anyhow::Result<Url> {
    // URL-encode the package name for scoped packages
    let encoded_name = package_name.replace('/', "%2f");
    Url::parse(&format!("{registry}/{encoded_name}"))
        .map_err(|e| anyhow!("failed to construct packument URL: {e}"))
}

/// Normalize packument data to ensure determinism.
///
/// Filters to whitelisted fields and requested versions only.
/// Allowed top-level fields in normalized packuments.
///
/// For lockfile-based installs, versions are exact (e.g., "4.17.21") so npm-pick-manifest
/// just does a direct `versions[ver]` lookup. Tarballs are fetched via the resolved URL.
const ALLOWED_TOP_LEVEL_FIELDS: &[&str] = &["name", "versions"];

/// Allowed fields in version objects.
///
/// Based on analysis of pacote, npm-pick-manifest, npm-install-checks, and arborist.
/// Only fields actually read during `npm install` are included.
const ALLOWED_VERSION_FIELDS: &[&str] = &[
    "name",
    "version",
    // Dependencies
    "dependencies",
    "devDependencies",
    "peerDependencies",
    "peerDependenciesMeta",
    "optionalDependencies",
    "bundleDependencies",
    "bundledDependencies",
    // Distribution (tarball URL and integrity)
    "dist",
    // Executables
    "bin",
    // Platform constraints (npm-install-checks)
    "engines",
    "os",
    "cpu",
    // Lifecycle scripts
    "scripts",
];

fn normalize_packument(
    package_name: &str,
    data: &[u8],
    requested_versions: &HashSet<String>,
) -> anyhow::Result<Vec<u8>> {
    let mut json: Value = serde_json::from_slice(data)
        .map_err(|e| anyhow!("failed to parse packument JSON for {package_name}: {e}"))?;

    let obj = json
        .as_object_mut()
        .ok_or_else(|| anyhow!("packument for {package_name} is not a JSON object"))?;

    // Keep only whitelisted top-level fields to ensure determinism
    obj.retain(|key, _| ALLOWED_TOP_LEVEL_FIELDS.contains(&key.as_str()));

    // Filter and normalize versions
    if let Some(Value::Object(versions)) = obj.get_mut("versions") {
        // Only keep versions that are in the lockfile
        versions.retain(|version, _| requested_versions.contains(version));

        // Normalize each version object to only include necessary fields
        for version_val in versions.values_mut() {
            if let Some(version_obj) = version_val.as_object_mut() {
                version_obj.retain(|key, _| ALLOWED_VERSION_FIELDS.contains(&key.as_str()));
            }
        }
    }

    serde_json::to_vec(&json)
        .map_err(|e| anyhow!("failed to re-serialize packument for {package_name}: {e}"))
}

/// Fetch and cache packuments (package metadata) for all packages.
///
/// This is needed because npm may query package metadata for optional peer dependencies
/// and for workspace packages.
///
/// npm's cache policy checks that the Accept header matches between the cached
/// request and the new request. npm can request packuments with two different headers:
/// 1. "corgiDoc" (abbreviated metadata) - used initially
/// 2. "fullDoc" (full metadata) - used when npm needs full package info (e.g., workspaces)
///
/// We cache both versions to ensure cache hits regardless of which header npm uses.
/// See: pacote/lib/registry.js and @npmcli/arborist/lib/arborist/build-ideal-tree.js
fn fetch_packuments(
    cache: &Cache,
    package_versions: HashMap<String, HashSet<String>>,
) -> anyhow::Result<()> {
    const CORGI_DOC: &str =
        "application/vnd.npm.install-v1+json; q=1.0, application/json; q=0.8, */*";
    const FULL_DOC: &str = "application/json";

    info!("Fetching {} packuments", package_versions.len());

    package_versions
        .into_par_iter()
        .try_for_each(|(package_name, requested_versions)| {
            let packument_url = get_packument_url("https://registry.npmjs.org", &package_name)?;

            match util::get_url_body_with_retry(&packument_url) {
                Ok(packument_data) => {
                    let normalized_data =
                        normalize_packument(&package_name, &packument_data, &requested_versions)?;

                    // npm's make-fetch-happen uses the URL-encoded form for cache keys
                    // e.g., "https://registry.npmjs.org/@types%2freact-dom" not "@types/react-dom"
                    // We must use the encoded form in both the cache key string AND the metadata URL

                    // Cache with corgiDoc header (for initial requests)
                    cache
                        .put(
                            format!("make-fetch-happen:request-cache:{packument_url}"),
                            packument_url.clone(),
                            &normalized_data,
                            None, // Packuments don't have integrity hashes
                            Some(ReqHeaders {
                                accept: String::from(CORGI_DOC),
                            }),
                        )
                        .map_err(|e| {
                            anyhow!("couldn't insert packument cache entry (corgi) for {package_name}: {e:?}")
                        })?;

                    // Cache with fullDoc header (for workspace/full metadata requests)
                    cache
                        .put(
                            format!("make-fetch-happen:request-cache:{packument_url}"),
                            packument_url.clone(),
                            &normalized_data,
                            None,
                            Some(ReqHeaders {
                                accept: String::from(FULL_DOC),
                            }),
                        )
                        .map_err(|e| {
                            anyhow!("couldn't insert packument cache entry (full) for {package_name}: {e:?}")
                        })?;
                }
                Err(e) => {
                    // Log but don't fail - some packages might not need packuments
                    info!("Warning: couldn't fetch packument for {package_name}: {e}");
                }
            }

            Ok::<_, anyhow::Error>(())
        })
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
    mut lock: Map<String, Value>,
    cache: Option<&HashMap<String, String>>,
) -> anyhow::Result<Option<Map<String, Value>>> {
    let mut fixed = false;

    match lock
        .get("lockfileVersion")
        .ok_or_else(|| anyhow!("couldn't get lockfile version"))?
        .as_i64()
        .ok_or_else(|| anyhow!("lockfile version isn't an int"))?
    {
        1 => fixup_v1_deps(
            lock.get_mut("dependencies")
                .unwrap()
                .as_object_mut()
                .unwrap(),
            cache,
            &mut fixed,
        ),
        2 | 3 => {
            for package in lock
                .get_mut("packages")
                .ok_or_else(|| anyhow!("couldn't get packages"))?
                .as_object_mut()
                .ok_or_else(|| anyhow!("packages isn't a map"))?
                .values_mut()
            {
                if let Some(Value::String(resolved)) = package.get("resolved")
                    && let Some(Value::String(integrity)) = package.get("integrity")
                {
                    if resolved.starts_with("git+") {
                        fixed = true;

                        package
                            .as_object_mut()
                            .ok_or_else(|| anyhow!("package isn't a map"))?
                            .remove("integrity");
                    } else if let Some(cache_hashes) = cache {
                        let cache_hash = cache_hashes
                            .get(resolved)
                            .expect("dependency should have a hash");

                        if integrity != cache_hash {
                            fixed = true;

                            *package
                                .as_object_mut()
                                .ok_or_else(|| anyhow!("package isn't a map"))?
                                .get_mut("integrity")
                                .unwrap() = Value::String(cache_hash.clone());
                        }
                    }
                }
            }

            if fixed {
                lock.remove("dependencies");
            }
        }
        v => bail!("unsupported lockfile version {v}"),
    }

    if fixed { Ok(Some(lock)) } else { Ok(None) }
}

// Recursive helper to fixup v1 lockfile deps
fn fixup_v1_deps(
    dependencies: &mut Map<String, Value>,
    cache: Option<&HashMap<String, String>>,
    fixed: &mut bool,
) {
    for dep in dependencies.values_mut() {
        if let Some(Value::String(resolved)) = dep
            .as_object()
            .expect("v1 dep must be object")
            .get("resolved")
            && let Some(Value::String(integrity)) = dep
                .as_object()
                .expect("v1 dep must be object")
                .get("integrity")
        {
            if resolved.starts_with("git+ssh://") {
                *fixed = true;

                dep.as_object_mut()
                    .expect("v1 dep must be object")
                    .remove("integrity");
            } else if let Some(cache_hashes) = cache {
                let cache_hash = cache_hashes
                    .get(resolved)
                    .expect("dependency should have a hash");

                if integrity != cache_hash {
                    *fixed = true;

                    *dep.as_object_mut()
                        .expect("v1 dep must be object")
                        .get_mut("integrity")
                        .unwrap() = Value::String(cache_hash.clone());
                }
            }
        }

        if let Some(Value::Object(more_deps)) = dep.as_object_mut().unwrap().get_mut("dependencies")
        {
            fixup_v1_deps(more_deps, cache, fixed);
        }
    }
}

fn map_cache(content_path_from_arg: &Option<&String>) -> anyhow::Result<HashMap<Url, String>> {
    let mut hashes = HashMap::new();

    // Lazily evaluate npmDeps, which may not be present
    let content_path_string = content_path_from_arg.map_or_else(
        || env::var_os("npmDeps")
            .unwrap()
            .into_string()
            .expect("env variable npmDeps should be set if it is not provided as an argument (but this is not recommended)"),
        |a| a.clone());

    for entry in WalkDir::new(Path::new(&content_path_string).join("_cacache/index-v5")) {
        let entry = entry?;

        if entry.file_type().is_file() {
            let content = fs::read_to_string(entry.path())?;
            // cacache index format: each line is <sha1_hash>\t<json>
            // Multiple entries can exist in the same file (e.g., same URL with different headers)
            for line in content.lines() {
                if line.is_empty() {
                    continue;
                }
                // Split on tab, not whitespace, because JSON values may contain spaces
                let json_part = line
                    .split_once('\t')
                    .map(|(_, json)| json)
                    .ok_or_else(|| anyhow!("invalid cache index entry: missing tab separator"))?;
                let key: Key = serde_json::from_str(json_part)?;

                hashes.insert(key.metadata.url, key.integrity);
            }
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

    if let Ok(jobs) = env::var("NIX_BUILD_CORES")
        && !jobs.is_empty()
    {
        rayon::ThreadPoolBuilder::new()
            .num_threads(
                jobs.parse()
                    .expect("NIX_BUILD_CORES must be a whole number"),
            )
            .build_global()
            .unwrap();
    }

    if args[1] == "--fixup-lockfile" {
        let lock = serde_json::from_str(&fs::read_to_string(&args[2])?)?;

        let cache = cache_map_path()
            .map(|map_path| {
                Ok::<_, anyhow::Error>(serde_json::from_slice::<HashMap<String, String>>(
                    &fs::read(map_path)?,
                )?)
            })
            .transpose()?;

        if let Some(fixed) = fixup_lockfile(lock, cache.as_ref())? {
            println!("Fixing lockfile");

            fs::write(&args[2], serde_json::to_string(&fixed)?)?;
        }

        return Ok(());
    } else if args[1] == "--map-cache" {
        let map = map_cache(&args.get(2))?;

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

    // Collect package names and their versions from the lockfile for packument filtering.
    // For non-aliased packages: extract from lockfile keys like "node_modules/@scope/name" -> "@scope/name"
    // For aliased packages: the name is already the real package name (e.g., "string-width" not "string-width-cjs")
    // We only care about packages that have a version string (registry packages).
    let mut package_versions: HashMap<String, HashSet<String>> = HashMap::new();
    for p in &packages {
        if let Some(version) = &p.version {
            let pkg_name = p
                .name
                .rsplit_once("node_modules/")
                .map(|(_, name)| name.to_string())
                .unwrap_or_else(|| p.name.clone());
            package_versions
                .entry(pkg_name)
                .or_default()
                .insert(version.to_string());
        }
    }

    // Fetch and cache tarballs
    packages.into_par_iter().try_for_each(|package| {
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
                None, // tarballs don't need special request headers
            )
            .map_err(|e| anyhow!("couldn't insert cache entry for {}: {e:?}", package.name))?;

        Ok::<_, anyhow::Error>(())
    })?;

    // Fetch and cache packuments (package metadata) - only for fetcher version 2+
    let fetcher_version: u32 = env::var("NPM_FETCHER_VERSION")
        .ok()
        .and_then(|v| v.parse().ok())
        .unwrap_or(1);

    if fetcher_version >= 2 {
        fetch_packuments(&cache, package_versions)?;
        fs::write(out.join(".fetcher-version"), format!("{fetcher_version}"))?;
    }

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
    use serde_json::json;

    #[test]
    fn lockfile_fixup() -> anyhow::Result<()> {
        let input = json!({
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
        });

        let expected = json!({
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
        });

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

        assert_eq!(
            fixup_lockfile(input.as_object().unwrap().clone(), Some(hashes).as_ref())?,
            Some(expected.as_object().unwrap().clone())
        );

        Ok(())
    }

    #[test]
    fn lockfile_v1_fixup() -> anyhow::Result<()> {
        let input = json!({
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
        });

        let expected = json!({
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
        });

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

        assert_eq!(
            fixup_lockfile(input.as_object().unwrap().clone(), Some(hashes).as_ref())?,
            Some(expected.as_object().unwrap().clone())
        );

        Ok(())
    }

}
