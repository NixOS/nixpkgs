use std::{os::unix, path::Path};

use anyhow::{Context, Result};

use crate::config::Config;
use crate::{SYSROOT_PATH, find_init_in_prefix, resolve_in_prefix, verify_init_is_nixos};

/// Entrypoint for the `find-etc` binary.
///
/// Find the etc related paths in /sysroot.
///
/// This avoids needing a reference to the toplevel embedded in the initrd and thus reduces the
/// need to re-build it.
pub fn find_etc() -> Result<()> {
    let init_in_sysroot =
        find_init_in_prefix(SYSROOT_PATH).context("Failed to find init in sysroot")?;

    // A non-NixOS init= (e.g. init=/bin/sh) has no etc metadata image. Skip
    // without creating the symlinks: the etc-overlay mounts are gated on them
    // and so skip too, and initrd-init switches root to the init directly.
    let Ok(toplevel) = verify_init_is_nixos(SYSROOT_PATH, &init_in_sysroot) else {
        log::info!(
            "{} is not a NixOS system - not setting up the etc overlay.",
            init_in_sysroot.display()
        );
        return Ok(());
    };

    let config = Config::from_toplevel(&toplevel, SYSROOT_PATH)?;

    let basedir = config
        .etc_basedir
        .context("Failed to read etc_basedir from bootspec")?;
    let etc_basedir =
        Path::new(SYSROOT_PATH).join(resolve_in_prefix(SYSROOT_PATH, &basedir)?.strip_prefix("/")?);

    let metadata_image = config
        .etc_metadata_image
        .context("Failed to read etc_metadata_image from bootspec")?;
    let etc_metadata_image = Path::new(SYSROOT_PATH)
        .join(resolve_in_prefix(SYSROOT_PATH, &metadata_image)?.strip_prefix("/")?);

    unix::fs::symlink(etc_basedir, "/etc-basedir").context("Failed to link /etc-basedir")?;
    unix::fs::symlink(etc_metadata_image, "/etc-metadata-image")
        .context("Failed to link /etc-metadata-image")?;

    Ok(())
}
