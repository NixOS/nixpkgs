use serde::Deserialize;
use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result, bail};
use bootspec::BootJson;

const EXTENSION_KEY: &str = "org.nixos.nixos-init.v1";

#[derive(Deserialize)]
pub struct Config {
    pub firmware: Option<String>,
    pub modprobe_binary: Option<String>,
    pub nix_store_mount_opts: Vec<String>,
    pub env_binary: Option<String>,
    pub sh_binary: Option<String>,
    pub etc_basedir: Option<String>,
    pub etc_metadata_image: Option<String>,
    #[serde(default)]
    pub special_filesystems: Vec<SpecialMount>,
}

#[derive(Deserialize)]
pub struct SpecialMount {
    pub mountpoint: String,
    pub device: String,
    pub fstype: String,
    pub options: Vec<String>,
}

impl Config {
    /// Read the config from the toplevel directory.
    ///
    /// Tries the bootspec extension in `boot.json` first, falling back to
    /// `nixos-init.json` for systems where `boot.json` is not written
    /// (containers).
    pub fn from_toplevel(toplevel: impl AsRef<Path>, prefix: &str) -> Result<Self> {
        let toplevel_in_prefix =
            PathBuf::from(prefix).join(toplevel.as_ref().strip_prefix("/").with_context(|| {
                format!("toplevel {} is not absolute", toplevel.as_ref().display())
            })?);

        let bootspec_path = toplevel_in_prefix.join("boot.json");
        if bootspec_path.exists() {
            let boot_json: BootJson = fs::read(&bootspec_path)
                .with_context(|| format!("Failed to read {}", bootspec_path.display()))
                .and_then(|b| serde_json::from_slice(&b).context("Failed to parse boot.json"))?;
            let extension = boot_json
                .extensions
                .get(EXTENSION_KEY)
                .with_context(|| format!("boot.json has no {EXTENSION_KEY} extension"))?;
            return serde_json::from_value(extension.clone())
                .with_context(|| format!("Failed to deserialize {EXTENSION_KEY} extension"));
        }

        let fallback_path = toplevel_in_prefix.join("nixos-init.json");
        if fallback_path.exists() {
            return fs::read(&fallback_path)
                .with_context(|| format!("Failed to read {}", fallback_path.display()))
                .and_then(|b| {
                    serde_json::from_slice(&b).context("Failed to parse nixos-init.json")
                });
        }

        bail!(
            "Neither {} nor {} found in toplevel",
            bootspec_path.display(),
            fallback_path.display()
        )
    }
}
