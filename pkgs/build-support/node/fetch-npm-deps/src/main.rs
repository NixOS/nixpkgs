#![warn(clippy::pedantic)]

use crate::cacache::Cache;
use anyhow::anyhow;
use rayon::prelude::*;
use serde_json::{Map, Value};
use std::{
    env, fs,
    path::Path,
    process::{self, Command},
};
use tempfile::tempdir;

mod cacache;
mod parse;

/// `fixup_lockfile` removes the `integrity` field from Git dependencies.
///
/// Git dependencies from specific providers can be retrieved from those providers' automatic tarball features.
/// When these dependencies are specified with a commit identifier, npm generates a tarball, and inserts the integrity hash of that
/// tarball into the lockfile.
///
/// Thus, we remove this hash, to replace it with our own determinstic copies of dependencies from hosted Git providers.
fn fixup_lockfile(mut lock: Map<String, Value>) -> anyhow::Result<Option<Map<String, Value>>> {
    if lock
        .get("lockfileVersion")
        .ok_or_else(|| anyhow!("couldn't get lockfile version"))?
        .as_i64()
        .ok_or_else(|| anyhow!("lockfile version isn't an int"))?
        < 2
    {
        return Ok(None);
    }

    let mut fixed = false;

    for package in lock
        .get_mut("packages")
        .ok_or_else(|| anyhow!("couldn't get packages"))?
        .as_object_mut()
        .ok_or_else(|| anyhow!("packages isn't a map"))?
        .values_mut()
    {
        if let Some(Value::String(resolved)) = package.get("resolved") {
            if resolved.starts_with("git+ssh://") && package.get("integrity").is_some() {
                fixed = true;

                package
                    .as_object_mut()
                    .ok_or_else(|| anyhow!("package isn't a map"))?
                    .remove("integrity");
            }
        }
    }

    if fixed {
        lock.remove("dependencies");

        Ok(Some(lock))
    } else {
        Ok(None)
    }
}

fn main() -> anyhow::Result<()> {
    let args = env::args().collect::<Vec<_>>();

    if args.len() < 2 {
        println!("usage: {} <path/to/package-lock.json>", args[0]);
        println!();
        println!("Prefetches npm dependencies for usage by fetchNpmDeps.");

        process::exit(1);
    }

    if args[1] == "--fixup-lockfile" {
        let lock = serde_json::from_str(&fs::read_to_string(&args[2])?)?;

        if let Some(fixed) = fixup_lockfile(lock)? {
            println!("Fixing lockfile");

            fs::write(&args[2], serde_json::to_string(&fixed)?)?;
        }

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

    let packages = parse::lockfile(&lock_content, env::var("FORCE_GIT_DEPS").is_ok())?;

    let cache = Cache::new(out.join("_cacache"));

    packages.into_par_iter().try_for_each(|package| {
        eprintln!("{}", package.name);

        let tarball = package.tarball()?;
        let integrity = package.integrity();

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
        Command::new("nix")
            .args(["--experimental-features", "nix-command", "hash", "path"])
            .arg(out.as_os_str())
            .status()?;
    }

    Ok(())
}

#[cfg(test)]
mod tests {
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
                    "integrity": "aaa"
                },
                "bar": {
                    "resolved": "git+ssh://git@github.com/NixOS/nixpkgs.git",
                    "integrity": "bbb"
                }
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
                    "integrity": "aaa"
                },
                "bar": {
                    "resolved": "git+ssh://git@github.com/NixOS/nixpkgs.git",
                }
            }
        });

        assert_eq!(
            fixup_lockfile(input.as_object().unwrap().clone())?,
            Some(expected.as_object().unwrap().clone())
        );

        assert_eq!(
            fixup_lockfile(json!({"lockfileVersion": 1}).as_object().unwrap().clone())?,
            None
        );

        Ok(())
    }
}
