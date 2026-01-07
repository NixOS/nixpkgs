use anyhow::{anyhow, bail, Context};
use lock::UrlOrString;
use log::debug;
use rayon::prelude::*;
use std::{
    fs,
    io::Write,
    process::{Command, Stdio},
};
use tempfile::{tempdir, TempDir};
use url::Url;

use crate::util;

pub mod lock;

pub fn lockfile(content: &str, force_empty_cache: bool) -> anyhow::Result<Vec<Package>> {
    debug!("parsing lockfile with contents:\n{content}");

    let packages = lock::packages(content)
        .context("failed to extract packages from lockfile")?
        .into_par_iter()
        .map(|p| {
            let n = p.name.clone().unwrap();

            Package::from_lock(p).with_context(|| format!("failed to parse data for {n}"))
        })
        .collect::<anyhow::Result<Vec<_>>>()?;

    if packages.is_empty() && !force_empty_cache {
        bail!("No cacheable dependencies were found. Please inspect the upstream `package-lock.json` file and ensure that remote dependencies have `resolved` URLs and `integrity` hashes. If the lockfile is missing this data, attempt to get upstream to fix it via a tool like <https://github.com/jeslie0/npm-lockfile-fix>. If generating an empty cache is intentional and you would like to do it anyways, set `forceEmptyCache = true`.");
    }

    Ok(packages)
}

#[derive(Debug)]
pub struct Package {
    pub name: String,
    pub url: Url,
    pub tarball_filename: String,
    specifics: Specifics,
}

#[derive(Debug)]
enum Specifics {
    Registry { integrity: lock::Hash },
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
        let mut filename: String = "".to_string();

        let specifics = match get_hosted_git_url(&resolved)? {
            Some(hosted) => {
                let body = util::get_url_body_with_retry(&hosted)?;

                let workdir = tempdir()?;

                let tar_path = workdir.path().join("package");

                fs::create_dir(&tar_path)?;

                let mut cmd = Command::new("tar")
                    .args(["--extract", "--gzip", "--strip-components=1", "-C"])
                    .arg(&tar_path)
                    .stdin(Stdio::piped())
                    .spawn()?;

                cmd.stdin.take().unwrap().write_all(&body)?;

                let exit = cmd.wait()?;

                if !exit.success() {
                    bail!(
                        "failed to extract tarball for {}: tar exited with status code {}",
                        pkg.name.unwrap(),
                        exit.code().unwrap()
                    );
                }

                filename = match resolved.scheme() {
                    "git+https" => resolved
                        .path_segments()
                        .unwrap()
                        .into_iter()
                        .rev()
                        .take(1)
                        .collect::<String>(),
                    _ => resolved.fragment().unwrap().to_string(),
                };

                resolved = hosted;

                Specifics::Git { workdir }
            }
            None => {
                filename = {
                    fn sanitize(s: &String) -> String {
                        s.split('/')
                            .map(|seg| seg.replace(&['@', '%', '-', ':'], "_"))
                            .collect::<Vec<_>>()
                            .join("_")
                    }
                    match resolved.host_str().unwrap() {
                        "codeload.github.com" if resolved.path().contains("/tar.gz/") => resolved
                            .path_segments()
                            .unwrap()
                            .into_iter()
                            .rev()
                            .take(1)
                            .collect::<String>(),
                        "registry.yarnpkg.com" | "github.com" | "codeload.github.com" => {
                            sanitize(&resolved.path().strip_prefix('/').unwrap().to_string())
                        }
                        _ => {
                            let mut s = resolved.clone();
                            s.set_fragment(None);
                            sanitize(&s.to_string())
                        }
                    }
                };

                Specifics::Registry {
                    integrity: pkg
                        .integrity
                        .expect("non-git dependencies should have associated integrity")
                        .into_best()
                        .expect("non-git dependencies should have non-empty associated integrity"),
                }
            }
        };

        Ok(Package {
            name: pkg.name.unwrap(),
            url: resolved,
            tarball_filename: filename,
            specifics,
        })
    }

    pub fn tarball(&self) -> anyhow::Result<Vec<u8>> {
        match &self.specifics {
            Specifics::Registry { .. } => Ok(util::get_url_body_with_retry(&self.url)?),
            Specifics::Git { workdir } => Ok(Command::new("tar")
                .args([
                    "--sort=name",
                    "--mtime=@1",
                    "--owner=0",
                    "--group=0",
                    "--numeric-owner",
                    "--format=gnu",
                    "--mode=u+w",
                    "--create",
                    "-C",
                ])
                .arg(workdir.path().join("package"))
                .args([
                    "-c",
                    ".",
                ])
                .output()?
                .stdout),
        }
    }

    pub fn integrity(&self) -> Option<&lock::Hash> {
        match &self.specifics {
            Specifics::Registry { integrity } => Some(integrity),
            Specifics::Git { .. } => None,
        }
    }
}

#[allow(clippy::case_sensitive_file_extension_comparisons)]
fn get_hosted_git_url(url: &Url) -> anyhow::Result<Option<Url>> {
    if ["git", "git+ssh", "git+https", "ssh"].contains(&url.scheme()) {
        let mut s = url
            .path_segments()
            .ok_or_else(|| anyhow!("bad URL: {url}"))?;

        let mut get_url = || match url.host_str()? {
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
                /* let path = &url.path()[1..];

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
                ) */

                // lmao: https://github.com/npm/hosted-git-info/pull/109
                None
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
        };

        match get_url() {
            Some(u) => Ok(Some(u)),
            None => Err(anyhow!("This lockfile either contains a Git dependency with an unsupported host, or a malformed URL in the lockfile: {url}"))
        }
    } else {
        Ok(None)
    }
}

#[cfg(test)]
mod tests {
    use super::get_hosted_git_url;
    use url::Url;

    #[test]
    fn hosted_git_urls() {
        for (input, expected) in [
            (
                "git+ssh://git@github.com/castlabs/electron-releases.git#fc5f78d046e8d7cdeb66345a2633c383ab41f525",
                Some("https://codeload.github.com/castlabs/electron-releases/tar.gz/fc5f78d046e8d7cdeb66345a2633c383ab41f525"),
            ),
            (
                "git+ssh://bitbucket.org/foo/bar#branch",
                Some("https://bitbucket.org/foo/bar/get/branch.tar.gz")
            ),
            (
                "git+ssh://git.sr.ht/~foo/bar#branch",
                Some("https://git.sr.ht/~foo/bar/archive/branch.tar.gz")
            ),
        ] {
            assert_eq!(
                get_hosted_git_url(&Url::parse(input).unwrap()).unwrap(),
                expected.map(|u| Url::parse(u).unwrap())
            );
        }

        assert!(
            get_hosted_git_url(&Url::parse("ssh://git@gitlab.com/foo/bar.git#fix/bug").unwrap())
                .is_err(),
            "GitLab URLs should be marked as invalid (lol)"
        );
    }
}
