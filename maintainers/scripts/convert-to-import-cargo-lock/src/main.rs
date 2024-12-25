#![warn(clippy::pedantic)]
#![allow(clippy::too_many_lines)]

use anyhow::anyhow;
use serde::Deserialize;
use std::{collections::HashMap, env, fs, path::PathBuf, process::Command};

#[derive(Deserialize)]
struct CargoLock<'a> {
    #[serde(rename = "package", borrow)]
    packages: Vec<Package<'a>>,
    metadata: Option<HashMap<&'a str, &'a str>>,
}

#[derive(Deserialize)]
struct Package<'a> {
    name: &'a str,
    version: &'a str,
    source: Option<&'a str>,
    checksum: Option<&'a str>,
}

#[derive(Deserialize)]
struct PrefetchOutput {
    sha256: String,
}

fn main() -> anyhow::Result<()> {
    let mut hashes = HashMap::new();

    let attr_count = env::args().len() - 1;

    for (i, attr) in env::args().skip(1).enumerate() {
        println!("converting {attr} ({}/{attr_count})", i + 1);

        convert(&attr, &mut hashes)?;
    }

    Ok(())
}

fn convert(attr: &str, hashes: &mut HashMap<String, String>) -> anyhow::Result<()> {
    let package_path = nix_eval(format!("{attr}.meta.position"))?
        .and_then(|p| p.split_once(':').map(|(f, _)| PathBuf::from(f)));

    if package_path.is_none() {
        eprintln!("can't automatically convert {attr}: doesn't exist");
        return Ok(());
    }

    let package_path = package_path.unwrap();

    if package_path.with_file_name("Cargo.lock").exists() {
        eprintln!("skipping {attr}: already has a vendored Cargo.lock");
        return Ok(());
    }

    let mut src = PathBuf::from(
        String::from_utf8(
            Command::new("nix-build")
                .arg("-A")
                .arg(format!("{attr}.src"))
                .output()?
                .stdout,
        )?
        .trim(),
    );

    if !src.exists() {
        eprintln!("can't automatically convert {attr}: src doesn't exist (bad attr?)");
        return Ok(());
    } else if !src.metadata()?.is_dir() {
        eprintln!("can't automatically convert {attr}: src isn't a directory");
        return Ok(());
    }

    if let Some(mut source_root) = nix_eval(format!("{attr}.sourceRoot"))?.map(PathBuf::from) {
        source_root = source_root.components().skip(1).collect();
        src.push(source_root);
    }

    let cargo_lock_path = src.join("Cargo.lock");

    if !cargo_lock_path.exists() {
        eprintln!("can't automatically convert {attr}: src doesn't contain Cargo.lock");
        return Ok(());
    }

    let cargo_lock_content = fs::read_to_string(cargo_lock_path)?;

    let cargo_lock: CargoLock = basic_toml::from_str(&cargo_lock_content)?;

    let mut git_dependencies = Vec::new();

    for package in cargo_lock.packages.iter().filter(|p| {
        p.source.is_some()
            && p.checksum
                .or_else(|| {
                    cargo_lock
                        .metadata
                        .as_ref()?
                        .get(
                            format!("checksum {} {} ({})", p.name, p.version, p.source.unwrap())
                                .as_str(),
                        )
                        .copied()
                })
                .is_none()
    }) {
        let (typ, original_url) = package
            .source
            .unwrap()
            .split_once('+')
            .expect("dependency should have well-formed source url");

        if let Some(hash) = hashes.get(original_url) {
            continue;
        }

        assert_eq!(
            typ, "git",
            "packages without checksums should be git dependencies"
        );

        let (mut url, rev) = original_url
            .split_once('#')
            .expect("git dependency should have commit");

        // TODO: improve
        if let Some((u, _)) = url.split_once('?') {
            url = u;
        }

        let prefetch_output: PrefetchOutput = serde_json::from_slice(
            &Command::new("nix-prefetch-git")
                .args(["--url", url, "--rev", rev, "--quiet", "--fetch-submodules"])
                .output()?
                .stdout,
        )?;

        let output_hash = String::from_utf8(
            Command::new("nix")
                .args([
                    "--extra-experimental-features",
                    "nix-command",
                    "hash",
                    "to-sri",
                    "--type",
                    "sha256",
                    &prefetch_output.sha256,
                ])
                .output()?
                .stdout,
        )?;

        let hash = output_hash.trim().to_string();

        git_dependencies.push((
            format!("{}-{}", package.name, package.version),
            output_hash.trim().to_string().clone(),
        ));

        hashes.insert(original_url.to_string(), hash);
    }

    fs::write(
        package_path.with_file_name("Cargo.lock"),
        cargo_lock_content,
    )?;

    let mut package_lines: Vec<_> = fs::read_to_string(&package_path)?
        .lines()
        .map(String::from)
        .collect();

    let (cargo_deps_line_index, cargo_deps_line) = package_lines
        .iter_mut()
        .enumerate()
        .find(|(_, l)| {
            l.trim_start().starts_with("cargoHash") || l.trim_start().starts_with("cargoSha256")
        })
        .expect("package should contain cargoHash/cargoSha256");

    let spaces = " ".repeat(cargo_deps_line.len() - cargo_deps_line.trim_start().len());

    if git_dependencies.is_empty() {
        *cargo_deps_line = format!("{spaces}cargoLock.lockFile = ./Cargo.lock;");
    } else {
        *cargo_deps_line = format!("{spaces}cargoLock = {{");

        let mut index_iter = cargo_deps_line_index + 1..;

        package_lines.insert(
            index_iter.next().unwrap(),
            format!("{spaces}  lockFile = ./Cargo.lock;"),
        );

        package_lines.insert(
            index_iter.next().unwrap(),
            format!("{spaces}  outputHashes = {{"),
        );

        for ((dep, hash), index) in git_dependencies.drain(..).zip(&mut index_iter) {
            package_lines.insert(index, format!("{spaces}    {dep:?} = {hash:?};"));
        }

        package_lines.insert(index_iter.next().unwrap(), format!("{spaces}  }};"));
        package_lines.insert(index_iter.next().unwrap(), format!("{spaces}}};"));
    }

    if package_lines.last().map(String::as_str) != Some("") {
        package_lines.push(String::new());
    }

    fs::write(package_path, package_lines.join("\n"))?;

    Ok(())
}

fn nix_eval(attr: impl AsRef<str>) -> anyhow::Result<Option<String>> {
    let output = String::from_utf8(
        Command::new("nix-instantiate")
            .args(["--eval", "-A", attr.as_ref()])
            .output()?
            .stdout,
    )?;

    let trimmed = output.trim();

    if trimmed.is_empty() || trimmed == "null" {
        Ok(None)
    } else {
        Ok(Some(
            trimmed
                .strip_prefix('"')
                .and_then(|p| p.strip_suffix('"'))
                .ok_or_else(|| anyhow!("couldn't parse nix-instantiate output: {output:?}"))?
                .to_string(),
        ))
    }
}
