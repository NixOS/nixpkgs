//! The subset of the NixOS bootspec (`boot.json`) the installer uses.

use std::collections::BTreeMap;
use std::path::Path;

use anyhow::{Context, Result};
use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct BootJson {
    #[serde(rename = "org.nixos.bootspec.v1")]
    pub spec: BootSpec,
    /// Ordered by name, as written by the bootspec module.
    #[serde(rename = "org.nixos.specialisation.v1", default)]
    pub specialisations: BTreeMap<String, BootJson>,
    #[serde(rename = "org.xenproject.bootspec.v2")]
    pub xen: Option<Xen>,
    #[serde(rename = "org.nixos.extra-initrd.v1")]
    pub extra_initrd: Option<ExtraInitrd>,
}

#[derive(Debug, Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct BootSpec {
    pub init: String,
    pub kernel: String,
    pub kernel_params: Vec<String>,
    pub label: String,
    pub toplevel: String,
    pub initrd: Option<String>,
    pub initrd_secrets: Option<String>,
}

#[derive(Debug, Default, Deserialize)]
#[serde(rename_all = "camelCase", default)]
pub struct Xen {
    pub efi_path: String,
    pub multiboot_path: String,
    pub params: Vec<String>,
    pub version: Option<String>,
}

#[derive(Debug, Deserialize)]
pub struct ExtraInitrd {
    #[serde(default)]
    pub paths: Vec<String>,
}

impl BootJson {
    pub fn load(system: &Path) -> Result<Self> {
        let path = system.join("boot.json");
        let json = std::fs::read(&path).with_context(|| format!("reading {}", path.display()))?;
        serde_json::from_slice(&json).with_context(|| format!("parsing {}", path.display()))
    }

    pub fn extra_initrd_paths(&self) -> &[String] {
        self.extra_initrd.as_ref().map_or(&[], |e| &e.paths)
    }
}

impl BootSpec {
    /// The kernel command line: `init=` followed by the kernel parameters.
    pub fn cmdline(&self) -> String {
        let mut params = vec![format!("init={}", self.init)];
        params.extend_from_slice(&self.kernel_params);
        join_params(&params)
    }
}

pub fn join_params(params: &[String]) -> String {
    params.join(" ").trim().to_owned()
}
