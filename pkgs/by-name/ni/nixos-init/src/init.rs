use std::{fs, os::unix::fs::PermissionsExt, path::Path, process::Command};

use anyhow::{Context, Result};

use crate::{activate::activate, config::Config, fs::atomic_symlink, proc_mounts::Mounts};

const NIX_STORE_PATH: &str = "/nix/store";

fn prefixed_store_path(prefix: &str) -> String {
    format!("{prefix}{NIX_STORE_PATH}")
}

/// Initialize the system in a prefix.
///
/// This is done only once during the boot of the system.
///
/// It is not designed to be re-executed during the lifetime of a system boot cycle.
pub fn init(prefix: &str, toplevel: impl AsRef<Path>, config: &Config) -> Result<()> {
    log::info!("Setting up /nix/store permissions...");
    setup_nix_store_permissions(prefix);

    log::info!("Remounting /nix/store with the correct options...");
    remount_nix_store(prefix, &config.nix_store_mount_opts)?;

    log::info!("Setting up /run/booted-system...");
    atomic_symlink(&toplevel, format!("{prefix}/run/booted-system"))?;

    log::info!("Activating the system...");
    activate(prefix, toplevel, config)?;

    Ok(())
}

/// Set up the correct permissions for the Nix Store.
///
/// Gracefully fail if they cannot be changed to accommodate read-only filesystems.
fn setup_nix_store_permissions(prefix: &str) {
    const ROOT_UID: u32 = 0;
    const NIXBUILD_GID: u32 = 0;
    const NIX_STORE_MODE: u32 = 0o1775;

    let nix_store_path = prefixed_store_path(prefix);

    std::os::unix::fs::chown(&nix_store_path, Some(ROOT_UID), Some(NIXBUILD_GID)).ok();
    fs::metadata(&nix_store_path)
        .map(|metadata| {
            let mut permissions = metadata.permissions();
            permissions.set_mode(NIX_STORE_MODE);
        })
        .ok();
}

/// Remount the Nix Store in a prefix with the provided options.
fn remount_nix_store(prefix: &str, nix_store_mount_opts: &[String]) -> Result<()> {
    let nix_store_path = prefixed_store_path(prefix);

    let mut missing_opts = Vec::new();
    let mounts = Mounts::parse_from_proc_mounts()?;

    if let Some(last_nix_store_mount) = mounts.find_mountpoint(&nix_store_path) {
        for opt in nix_store_mount_opts {
            if !last_nix_store_mount.mntopts.contains(opt) {
                missing_opts.push(opt.to_string());
            }
        }
        if !missing_opts.is_empty() {
            log::info!(
                "/nix/store is missing mount options: {}.",
                missing_opts.join(",")
            );
        }
    } else {
        log::info!("/nix/store is not a mountpoint.");
        missing_opts.extend_from_slice(nix_store_mount_opts);
    }

    if !missing_opts.is_empty() {
        log::info!("Remounting /nix/store with {}...", missing_opts.join(","));

        mount(&["--bind", &nix_store_path, &nix_store_path])?;
        mount(&[
            "-o",
            &format!("remount,bind,{}", missing_opts.join(",")),
            &nix_store_path,
        ])?;
    }

    Ok(())
}

/// Call `mount` with the provided `args`.
fn mount(args: &[&str]) -> Result<()> {
    let output = Command::new("mount")
        .args(args)
        .output()
        .context("Failed to run mount. Most likely, the binary is not on PATH")?;

    if !output.status.success() {
        return Err(anyhow::anyhow!(
            "mount executed unsuccessfully: {}",
            String::from_utf8_lossy(&output.stdout)
        ));
    }

    Ok(())
}
