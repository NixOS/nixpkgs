//! System profiles and their generations, normally under `/nix/var/nix/profiles`.

use std::fs;
use std::io;
use std::os::unix::fs::MetadataExt;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result, bail};

pub const PROFILES_DIR: &str = "/nix/var/nix/profiles";

pub struct Profile {
    /// `None` for the default `system` profile.
    name: Option<String>,
    /// The directory holding the profile's `<link_name>-<number>-link` generations.
    dir: PathBuf,
    link_name: String,
}

impl Profile {
    /// The default profile followed by the extra profiles in `system-profiles`, sorted by name.
    pub fn all(profiles_dir: &Path) -> Result<Vec<Self>> {
        let system_profiles_dir = profiles_dir.join("system-profiles");
        let mut names = Vec::new();
        match fs::read_dir(&system_profiles_dir) {
            Ok(entries) => {
                for entry in entries {
                    let name = entry?.file_name();
                    let Some(name) = name.to_str() else { continue };
                    if !name.ends_with("-link") {
                        names.push(name.to_owned());
                    }
                }
            }
            Err(err) if err.kind() == io::ErrorKind::NotFound => {}
            Err(err) => {
                return Err(err)
                    .with_context(|| format!("reading {}", system_profiles_dir.display()));
            }
        }
        names.sort();

        let mut profiles = vec![Profile {
            name: None,
            dir: profiles_dir.to_owned(),
            link_name: "system".to_owned(),
        }];
        profiles.extend(names.into_iter().map(|name| Profile {
            dir: system_profiles_dir.clone(),
            link_name: name.clone(),
            name: Some(name),
        }));
        Ok(profiles)
    }

    pub fn name(&self) -> Option<&str> {
        self.name.as_deref()
    }

    pub fn generation_path(&self, generation: u64) -> PathBuf {
        self.dir
            .join(format!("{}-{generation}-link", self.link_name))
    }

    /// The newest `max` generation numbers in ascending order, or all of them if `max` is 0.
    ///
    /// Matches the `<profile>-<number>-link` naming that `nix-env --list-generations` reads.
    pub fn generations(&self, max: usize) -> Result<Vec<u64>> {
        let prefix = format!("{}-", self.link_name);
        let mut generations = Vec::new();
        let entries =
            fs::read_dir(&self.dir).with_context(|| format!("reading {}", self.dir.display()))?;
        for entry in entries {
            let file_name = entry?.file_name();
            let Some(number) = file_name
                .to_str()
                .and_then(|n| n.strip_prefix(&prefix))
                .and_then(|n| n.strip_suffix("-link"))
            else {
                continue;
            };
            if !number.is_empty() && number.bytes().all(|b| b.is_ascii_digit()) {
                generations.push(number.parse()?);
            }
        }
        generations.sort_unstable();
        if max > 0 && generations.len() > max {
            generations.drain(..generations.len() - max);
        }
        Ok(generations)
    }
}

/// The modification time of the link itself, as `YYYY-MM-DD HH:MM:SS` local time.
pub fn link_time(path: &Path) -> Result<String> {
    let mtime = fs::symlink_metadata(path)
        .with_context(|| format!("reading {}", path.display()))?
        .mtime();
    local_time(mtime)
}

/// Formats seconds since the epoch as `YYYY-MM-DD HH:MM:SS` local time.
pub fn local_time(seconds: i64) -> Result<String> {
    let time = libc::time_t::try_from(seconds)?;
    // SAFETY: `tm` is plain data that `localtime_r` fully initialises on success.
    let mut tm: libc::tm = unsafe { std::mem::zeroed() };
    if unsafe { libc::localtime_r(&time, &mut tm) }.is_null() {
        bail!("cannot convert {seconds} to local time");
    }
    Ok(format!(
        "{:04}-{:02}-{:02} {:02}:{:02}:{:02}",
        tm.tm_year + 1900,
        tm.tm_mon + 1,
        tm.tm_mday,
        tm.tm_hour,
        tm.tm_min,
        tm.tm_sec
    ))
}
