use std::{os::unix, path::Path};

use anyhow::{Context, Result};

use crate::{SYSROOT_PATH, canonicalize_in_chroot, find_toplevel_in_prefix};

/// Entrypoint for the `find-etc` binary.
///
/// Find the etc related paths in /sysroot.
///
/// This avoids needing a reference to the toplevel embedded in the initrd and thus reduces the
/// need to re-build it.
pub fn find_etc() -> Result<()> {
    let toplevel = find_toplevel_in_prefix(SYSROOT_PATH)?;

    let etc_metadata_image = Path::new(SYSROOT_PATH).join(
        canonicalize_in_chroot(SYSROOT_PATH, &toplevel.join("etc-metadata-image"))?
            .strip_prefix("/")?,
    );

    let etc_basedir = Path::new(SYSROOT_PATH).join(
        canonicalize_in_chroot(SYSROOT_PATH, &toplevel.join("etc-basedir"))?.strip_prefix("/")?,
    );

    unix::fs::symlink(etc_metadata_image, "/etc-metadata-image")
        .context("Failed to link /etc-metadata-image")?;

    unix::fs::symlink(etc_basedir, "/etc-basedir").context("Failed to link /etc-basedir")?;

    Ok(())
}
