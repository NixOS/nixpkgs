use std::env;

use anyhow::{Context, Result};

pub struct Config {
    pub firmware: String,
    pub modprobe_binary: String,
    pub nix_store_mount_opts: Vec<String>,
    pub env_binary: Option<String>,
    pub sh_binary: Option<String>,
}

impl Config {
    /// Read the config from the environment.
    ///
    /// These options are provided by wrapping the binary when assembling the toplevel.
    pub fn from_env() -> Result<Self> {
        let nix_store_mount_opts = required("NIX_STORE_MOUNT_OPTS")?
            .split(',')
            .map(std::borrow::ToOwned::to_owned)
            .collect();

        Ok(Self {
            firmware: required("FIRMWARE")?,
            modprobe_binary: required("MODPROBE_BINARY")?,
            nix_store_mount_opts,
            env_binary: optional("ENV_BINARY"),
            sh_binary: optional("SH_BINARY"),
        })
    }
}

/// Read a required environment variable
///
/// Fail with useful context if the variable is not set in the environment.
fn required(key: &str) -> Result<String> {
    env::var(key).with_context(|| format!("Failed to read {key} from environment"))
}

/// Read an optional environment variable
fn optional(key: &str) -> Option<String> {
    env::var(key).ok()
}
