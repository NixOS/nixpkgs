use serde::Deserialize;
use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use bootspec::BootJson;

#[derive(Deserialize)]
pub struct Config {
    pub firmware: String,
    pub modprobe_binary: String,
    pub nix_store_mount_opts: Vec<String>,
    pub env_binary: Option<String>,
    pub sh_binary: Option<String>,
    pub etc_basedir: Option<String>,
    pub etc_metadata_image: Option<String>,
}

impl Config {
    /// Read the config from the metadata file in the toplevel directory.
    pub fn from_toplevel(toplevel: impl AsRef<Path>, prefix: &str) -> Result<Self> {
        let bootspec_path =
            PathBuf::from(prefix).join(toplevel.as_ref().join("boot.json").strip_prefix("/")?);

        let boot_json: BootJson = fs::read(bootspec_path)
            .context("Failed to read bootspec file")
            .and_then(|raw| serde_json::from_slice(&raw).context("Failed to read bootspec JSON"))?;

        let config = boot_json
            .extensions
            .get("org.nixos.nixos-init.v1")
            .context("Failed to extract nixos-init bootspec extension")
            .and_then(|v| {
                serde_json::from_value(v.clone()).context("Failed to deserialise config")
            })?;

        Ok(config)
    }
}
