use std::{os::unix, path::Path};

use anyhow::{Context, Result};

use crate::config::Config;
use crate::{SYSROOT_PATH, find_toplevel_in_prefix, resolve_in_prefix};

/// Entrypoint for the `find-etc` binary.
///
/// Find the etc related paths in /sysroot.
///
/// This avoids needing a reference to the toplevel embedded in the initrd and thus reduces the
/// need to re-build it.
pub fn find_etc() -> Result<()> {
    let toplevel = find_toplevel_in_prefix(SYSROOT_PATH)?;
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
