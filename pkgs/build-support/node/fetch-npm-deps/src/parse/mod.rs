use anyhow::{anyhow, bail, Context};
use lock::UrlOrString;
use rayon::prelude::*;
use std::{
    fs, io,
    process::{Command, Stdio},
};
use tempfile::{tempdir, TempDir};
use url::Url;

mod lock;

pub fn lockfile(lockfile: &str) -> anyhow::Result<Vec<Package>> {
    let packages = lock::packages(lockfile).context("failed to extract packages from lockfile")?;

    packages
        .into_par_iter()
        .map(|p| {
            let n = p.name.clone().unwrap();

            Package::from_lock(p).with_context(|| format!("failed to parse data for {n}"))
        })
        .collect()
}

#[derive(Debug)]
pub struct Package {
    pub name: String,
    pub url: Url,
    specifics: Specifics,
}

#[derive(Debug)]
enum Specifics {
    Registry { integrity: String },
    Git { workdir: TempDir },
}

impl Package {
    fn from_lock(pkg: lock::Package) -> anyhow::Result<Package> {
        let mut resolved = match pkg
            .resolved
            .expect("at this point, packages should have URLs")
        {
            UrlOrString::Url(u) => u,
            UrlOrString::String(_) => panic!("at this point, all packages should have URLs"),
        };

        let specifics = match get_hosted_git_url(&resolved) {
            Some(hosted) => {
                let mut body = ureq::get(hosted.as_str()).call()?.into_reader();

                let workdir = tempdir()?;

                let tar_path = workdir.path().join("package");

                fs::create_dir(&tar_path)?;

                let mut cmd = Command::new("tar")
                    .args(["--extract", "--gzip", "--strip-components=1", "-C"])
                    .arg(&tar_path)
                    .stdin(Stdio::piped())
                    .spawn()?;

                io::copy(&mut body, &mut cmd.stdin.take().unwrap())?;

                let exit = cmd.wait()?;

                if !exit.success() {
                    bail!(
                        "failed to extract tarball for {}: tar exited with status code {}",
                        pkg.name.unwrap(),
                        exit.code().unwrap()
                    );
                }

                resolved = hosted;

                Specifics::Git { workdir }
            }
            None => Specifics::Registry {
                integrity: get_ideal_hash(
                    &pkg.integrity
                        .expect("non-git dependencies should have assosciated integrity"),
                )?
                .to_string(),
            },
        };

        Ok(Package {
            name: pkg.name.unwrap(),
            url: resolved,
            specifics,
        })
    }

    pub fn tarball(&self) -> anyhow::Result<Vec<u8>> {
        match &self.specifics {
            Specifics::Registry { .. } => {
                let mut body = Vec::new();

                ureq::get(self.url.as_str())
                    .call()?
                    .into_reader()
                    .read_to_end(&mut body)?;

                Ok(body)
            }
            Specifics::Git { workdir } => Ok(Command::new("tar")
                .args([
                    "--sort=name",
                    "--mtime=@0",
                    "--owner=0",
                    "--group=0",
                    "--numeric-owner",
                    "--format=gnu",
                    "-I",
                    "gzip -n -9",
                    "--create",
                    "-C",
                ])
                .arg(workdir.path())
                .arg("package")
                .output()?
                .stdout),
        }
    }

    pub fn integrity(&self) -> Option<String> {
        match &self.specifics {
            Specifics::Registry { integrity } => Some(integrity.clone()),
            Specifics::Git { .. } => None,
        }
    }
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

#[cfg(test)]
mod tests {
    use super::{get_hosted_git_url, get_ideal_hash};
    use url::Url;

    #[test]
    fn hosted_git_urls() {
        for (input, expected) in [
            (
                "git+ssh://git@github.com/castlabs/electron-releases.git#fc5f78d046e8d7cdeb66345a2633c383ab41f525",
                Some("https://codeload.github.com/castlabs/electron-releases/tar.gz/fc5f78d046e8d7cdeb66345a2633c383ab41f525"),
            ),
            (
                "https://user@github.com/foo/bar#fix/bug",
                Some("https://codeload.github.com/foo/bar/tar.gz/fix/bug")
            ),
            (
                "https://github.com/eligrey/classList.js/archive/1.2.20180112.tar.gz",
                None
            ),
            (
                "git+ssh://bitbucket.org/foo/bar#branch",
                Some("https://bitbucket.org/foo/bar/get/branch.tar.gz")
            ),
            (
                "ssh://git@gitlab.com/foo/bar.git#fix/bug",
                Some("https://gitlab.com/foo/bar/repository/archive.tar.gz?ref=fix/bug")
            ),
            (
                "git+ssh://git.sr.ht/~foo/bar#branch",
                Some("https://git.sr.ht/~foo/bar/archive/branch.tar.gz")
            ),
        ] {
            assert_eq!(
                get_hosted_git_url(&Url::parse(input).unwrap()),
                expected.map(|u| Url::parse(u).unwrap())
            );
        }
    }

    #[test]
    fn ideal_hashes() {
        for (input, expected) in [
            ("sha512-foo sha1-bar", Some("sha512-foo")),
            ("sha1-bar md5-foo", Some("sha1-bar")),
            ("sha1-bar", Some("sha1-bar")),
            ("sha512-foo", Some("sha512-foo")),
            ("foo-bar sha1-bar", Some("sha1-bar")),
            ("foo-bar baz-foo", None),
        ] {
            assert_eq!(get_ideal_hash(input).ok(), expected);
        }
    }
}
