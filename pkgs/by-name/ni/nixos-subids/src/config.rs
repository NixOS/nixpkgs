use std::{fs, path::Path};

use anyhow::{Context, Result};
use serde::Deserialize;

#[derive(Deserialize, Debug, Clone, Default)]
#[serde(rename_all = "camelCase")]
pub struct Range {
    pub start: u64,
    pub count: u64,
}

#[derive(Deserialize, Debug, Clone, Default)]
#[serde(default, rename_all = "camelCase")]
pub struct User {
    pub name: String,
    /// Allocate a single auto_count-wide range starting at the lowest
    /// auto_count-aligned offset >= auto_base that does not overlap any
    /// other range.
    pub auto: bool,
    pub sub_uid_ranges: Vec<Range>,
    pub sub_gid_ranges: Vec<Range>,
}

fn default_auto_base() -> u64 {
    100_000
}

fn default_auto_count() -> u64 {
    65_536
}

#[derive(Deserialize, Debug, Clone)]
#[serde(rename_all = "camelCase")]
pub struct Config {
    #[serde(default)]
    pub users: Vec<User>,
    #[serde(default = "default_auto_base")]
    pub auto_base: u64,
    #[serde(default = "default_auto_count")]
    pub auto_count: u64,
}

impl Config {
    pub fn from_file(path: impl AsRef<Path>) -> Result<Self> {
        let contents = fs::read(&path)
            .with_context(|| format!("Failed to read {}", path.as_ref().display()))?;
        serde_json::from_slice(&contents).context("Failed to parse config")
    }
}
