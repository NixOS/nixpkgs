use serde::Deserialize;
use serde_json;
use std::fs;
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};

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
        let metadata_path = toplevel.as_ref().join("nixos-metadata.json");
        let metadata = PathBuf::from(prefix).join(metadata_path.strip_prefix("/")?);

        if !metadata
            .try_exists()
            .context("Failed to determine if metadata file exists, permissions issue?")?
        {
            anyhow::bail!("The metadata file '{}' does not exist", metadata.display());
        }

        let config: Config =
            serde_json::from_slice(&fs::read(metadata).context("Failed to read metadata file")?)
                .context("Failed to Deserialize JSON")?;

        return Ok(config);
    }
}
