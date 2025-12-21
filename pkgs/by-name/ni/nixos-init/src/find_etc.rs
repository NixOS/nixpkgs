use std::{os::unix, path::Path};

use anyhow::{Context, Result};

use crate::config::Config;
use crate::{SYSROOT_PATH, canonicalize_in_chroot, find_toplevel_in_prefix};

/// Entrypoint for the `find-etc` binary.
///
/// Find the etc related paths in /sysroot.
///
/// This avoids needing a reference to the toplevel embedded in the initrd and thus reduces the
/// need to re-build it.
pub fn find_etc() -> Result<()> {
    let toplevel = find_toplevel_in_prefix(SYSROOT_PATH)?;
    let config = Config::from_toplevel(&toplevel, SYSROOT_PATH)?;

    if let (Some(basedir), Some(metadata_image)) = (config.etc_basedir, config.etc_metadata_image) {
        let etc_metadata_image = Path::new(SYSROOT_PATH).join(
            canonicalize_in_chroot(SYSROOT_PATH, &Path::new(&metadata_image))?.strip_prefix("/")?,
        );

        let etc_basedir = Path::new(SYSROOT_PATH)
            .join(canonicalize_in_chroot(SYSROOT_PATH, Path::new(&basedir))?.strip_prefix("/")?);

        unix::fs::symlink(etc_metadata_image, "/etc-metadata-image")
            .context("Failed to link /etc-metadata-image")?;

        unix::fs::symlink(etc_basedir, "/etc-basedir").context("Failed to link /etc-basedir")?;
    } else {
        log::debug!(
            "nixos-init: find-etc: failed to read the etc_basedir and/or etc_metadata_image from the metadata file, ignoring..."
        )
    }

    Ok(())
}
