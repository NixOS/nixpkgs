mod activate;
mod chroot_realpath;
mod config;
mod find_etc;
mod fs;
mod init;
mod initrd_init;
mod proc_mounts;
mod switch_root;

use std::path::{Path, PathBuf};

use anyhow::{Context, Result, bail};

pub use crate::{
    activate::activate,
    chroot_realpath::{canonicalize_in_chroot, chroot_realpath},
    find_etc::find_etc,
    init::init,
    initrd_init::initrd_init,
    switch_root::switch_root,
};

pub const SYSROOT_PATH: &str = "/sysroot";

/// Find the path to the toplevel closure of the system in a prefix.
///
/// Uses the `init=` parameter on the kernel command-line.
///
/// Returns the relative path of the init to the prefix, e.g. without the `/sysroot` prefix.
pub fn find_toplevel_in_prefix(prefix: &str) -> Result<PathBuf> {
    let init_in_sysroot = find_init_in_prefix(prefix)?;
    verify_init_is_nixos(prefix, init_in_sysroot)
}

/// Verify that an init path is inside a `NixOS` toplevel directory.
///
/// If the path is verified, returns the path to the toplevel.
///
/// Check for the file `nixos-version` inside the toplevel to verify.
///
/// # Errors
///
/// If the init is not inside a `NixOS` toplevel return an error.
pub fn verify_init_is_nixos(prefix: &str, path: impl AsRef<Path>) -> Result<PathBuf> {
    let toplevel = path
        .as_ref()
        .parent()
        .map(Path::to_path_buf)
        .context("Provided init= is not in a directory")?;

    let stripped_toplevel = toplevel
        .strip_prefix("/")
        .with_context(|| format!("Failed to strip / from {}", toplevel.display()))?;

    let nixos_version_in_prefix = Path::new(prefix)
        .join(stripped_toplevel)
        .join("nixos-version");

    if !nixos_version_in_prefix
        .try_exists()
        .context("Failed to check whether nixos-version exists in toplevel")?
    {
        bail!(
            "Failed to verify init {} is inside a NixOS toplevel",
            path.as_ref().display()
        )
    }
    Ok(toplevel)
}

/// Find the canonical path of the init in a prefix.
///
/// Uses the `init=` parameter on the kernel command-line.
///
/// Returns the relative path of the init to the prefix, e.g. without the `/sysroot` prefix.
pub fn find_init_in_prefix(prefix: &str) -> Result<PathBuf> {
    let cmdline = std::fs::read_to_string("/proc/cmdline")?;
    let init = extract_init(&cmdline)?;
    let canonicalized_init = canonicalize_in_chroot(prefix, &init)?;
    log::info!("Found init: {}.", canonicalized_init.display());
    Ok(canonicalized_init)
}

/// Extract the value of the `init` parameter from the given kernel `cmdline`.
fn extract_init(cmdline: &str) -> Result<PathBuf> {
    let init_params: Vec<&str> = cmdline
        .split_ascii_whitespace()
        .filter(|p| p.starts_with("init="))
        .collect();

    if init_params.len() != 1 {
        bail!("Expected exactly one init param on kernel cmdline: {cmdline}")
    }

    let init = init_params
        .first()
        .and_then(|s| s.split('=').next_back())
        .context("Failed to extract init path from kernel cmdline: {cmdline}")?;

    Ok(PathBuf::from(init))
}

#[cfg(test)]
mod tests {
    use super::*;

    use std::fs;

    use tempfile::tempdir;

    #[test]
    fn test_verify_init_is_nixos() -> Result<()> {
        let prefix = tempdir()?;
        let toplevel = prefix.path().join("toplevel");
        fs::create_dir(&toplevel)?;

        let init = &toplevel.join("init");
        fs::write(init, "init")?;

        let nixos_version = toplevel.join("nixos-version");
        fs::write(&nixos_version, "25.11")?;

        verify_init_is_nixos(prefix.path().to_str().unwrap(), "/toplevel/init")?;

        Ok(())
    }
}
