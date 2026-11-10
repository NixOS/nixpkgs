use std::{
    env, fs,
    path::{Path, PathBuf},
};

use anyhow::{Context, Result, bail};

const OVERLAY_OPAQUE_XATTR: &str = "trusted.overlay.opaque";

/// Entrypoint for the `clear-etc-opaque` binary.
///
/// When a directory is created in the mutable `/etc` overlay that does not yet
/// exist in the lowerdir, overlayfs marks it opaque in the upperdir. This is
/// correct at creation time, but becomes stale when a later generation adds
/// entries under that same directory to the metadata layer: the opaque marker
/// hides them.
///
/// This walks the (newly mounted) metadata layer and removes
/// `trusted.overlay.opaque` from any upperdir directory that now has a
/// directory counterpart in the lowerdir, turning it back into a merged view.
/// Files the user placed in the upperdir remain visible (upperdir wins
/// per-entry) and individual whiteouts are preserved; only the blanket hiding
/// of lowerdir content is undone.
///
/// See <https://github.com/NixOS/nixpkgs/issues/505475>.
///
/// Usage: `clear-etc-opaque <metadata-mount> <upperdir>`
pub fn clear_etc_opaque() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        bail!("Usage: {} <metadata-mount> <upperdir>", args[0]);
    }

    let metadata_mount = PathBuf::from(&args[1]);
    let upperdir = PathBuf::from(&args[2]);

    if !upperdir.is_dir() {
        // Nothing to clear (e.g. first boot before the upperdir is created).
        log::info!(
            "Upperdir {} does not exist, nothing to clear.",
            upperdir.display()
        );
        return Ok(());
    }

    clear_opaque_markers(&metadata_mount, &metadata_mount, &upperdir)
}

/// Recursively walk `current` (a subtree of `metadata_root`) and clear the
/// opaque xattr from the corresponding directory in `upperdir`.
fn clear_opaque_markers(metadata_root: &Path, current: &Path, upperdir: &Path) -> Result<()> {
    let entries = fs::read_dir(current)
        .with_context(|| format!("Failed to read directory {}", current.display()))?;

    for entry in entries {
        let entry =
            entry.with_context(|| format!("Failed to read entry in {}", current.display()))?;

        // Use the entry's own type info (no symlink following) so we only
        // recurse into real directories of the metadata image.
        if !entry
            .file_type()
            .with_context(|| format!("Failed to stat {}", entry.path().display()))?
            .is_dir()
        {
            continue;
        }

        let path = entry.path();
        let rel = path
            .strip_prefix(metadata_root)
            .context("Failed to strip metadata root prefix")?;
        let target = upperdir.join(rel);

        // Only act on real directories in the upperdir; an opaque marker on a
        // non-directory would be meaningless and we must not follow symlinks
        // out of the upperdir.
        match fs::symlink_metadata(&target) {
            Ok(meta) if meta.is_dir() => {
                remove_opaque_xattr(&target);
                // Only recurse when the upperdir also has this directory:
                // deeper lowerdir directories without an upperdir counterpart
                // cannot carry stale markers.
                clear_opaque_markers(metadata_root, &path, upperdir)?;
            }
            // Missing or not a directory: nothing to do for this subtree.
            _ => {}
        }
    }

    Ok(())
}

/// Remove the `trusted.overlay.opaque` xattr from `path` if present.
fn remove_opaque_xattr(path: &Path) {
    // Check first instead of removing unconditionally: lremovexattr(2) reports
    // a missing attribute as ENODATA, which std does not map to a stable
    // io::ErrorKind, so distinguishing it from real errors is awkward.
    match xattr::get(path, OVERLAY_OPAQUE_XATTR) {
        Ok(None) => return,
        Ok(Some(_)) => {}
        Err(err) => {
            log::warn!(
                "Failed to read {OVERLAY_OPAQUE_XATTR} on {}: {err}.",
                path.display()
            );
            return;
        }
    }

    match xattr::remove(path, OVERLAY_OPAQUE_XATTR) {
        Ok(()) => {
            log::info!("Cleared stale opaque marker from {}.", path.display());
        }
        Err(err) => {
            // Don't abort the boot over this; the worst case is that some
            // declaratively-managed /etc entries stay hidden, which is what
            // would happen anyway without this fixup.
            log::warn!(
                "Failed to remove {OVERLAY_OPAQUE_XATTR} from {}: {err}.",
                path.display()
            );
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    use tempfile::tempdir;

    #[test]
    fn clears_opaque_only_for_matching_dirs() -> Result<()> {
        if !xattr::SUPPORTED_PLATFORM {
            return Ok(());
        }

        let metadata = tempdir()?;
        let upper = tempdir()?;

        // lowerdir gained nixos/sub in the new generation.
        fs::create_dir_all(metadata.path().join("nixos/sub"))?;
        // upperdir has an opaque nixos/ from before.
        fs::create_dir_all(upper.path().join("nixos"))?;
        // upperdir directory without a lowerdir counterpart: we only clear
        // markers where the lowerdir has a matching directory, so this one
        // must stay opaque.
        fs::create_dir_all(upper.path().join("only-upper"))?;

        // The build sandbox usually lacks CAP_SYS_ADMIN, so trusted.* xattrs
        // cannot be set. Skip in that case rather than fail the build.
        if xattr::set(upper.path().join("nixos"), OVERLAY_OPAQUE_XATTR, b"y").is_err() {
            eprintln!("skipping: cannot set trusted.* xattrs in this environment");
            return Ok(());
        }
        xattr::set(upper.path().join("only-upper"), OVERLAY_OPAQUE_XATTR, b"y")?;

        clear_opaque_markers(metadata.path(), metadata.path(), upper.path())?;

        assert!(xattr::get(upper.path().join("nixos"), OVERLAY_OPAQUE_XATTR)?.is_none());
        assert_eq!(
            xattr::get(upper.path().join("only-upper"), OVERLAY_OPAQUE_XATTR)?.as_deref(),
            Some(b"y".as_slice())
        );

        Ok(())
    }
}
