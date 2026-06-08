use std::{
    env, fs,
    os::{
        fd::{AsFd, AsRawFd, BorrowedFd, OwnedFd},
        unix::fs::{FileTypeExt, MetadataExt, PermissionsExt, chown},
    },
    path::{Path, PathBuf},
};

use anyhow::{Context, Result, bail};
use rustix::{
    fs::{CWD, Mode, OFlags, RenameFlags, mkdirat, openat, renameat_with},
    io::Errno,
    mount::{
        FsMountFlags, FsOpenFlags, MountAttrFlags, MoveMountFlags, OpenTreeFlags, UnmountFlags,
        fsconfig_create, fsconfig_set_fd, fsconfig_set_flag, fsconfig_set_string, fsmount, fsopen,
        move_mount, open_tree, unmount,
    },
};

use crate::{
    SYSROOT_PATH, config::Config, find_init_in_prefix, proc_mounts::Mounts, resolve_in_prefix,
    verify_init_is_nixos,
};

const OVERLAY_XATTR_PREFIX: &str = "trusted.overlay.";
const METADATA_MOUNT_PREFIX: &str = "/run/nixos-etc-metadata";

/// All paths needed to (re)mount the `/etc` overlay.
pub struct EtcLayout {
    /// Where to mount the overlay (`/etc` or `/sysroot/etc`).
    pub etc: String,
    /// erofs metadata image (composefs-style metadata-only lowerdir).
    pub metadata_image: String,
    /// Data lowerdir holding mode-copied file contents.
    pub basedir: String,
    /// Mutable overlay state (`None` for `mutable = false`).
    pub rw: Option<RwLayout>,
}

/// Mutable overlay state directory containing `upper/` and `work/`.
#[derive(Clone)]
pub struct RwLayout {
    pub base: PathBuf,
}

impl RwLayout {
    fn upper(&self) -> PathBuf {
        self.base.join("upper")
    }

    fn work(&self) -> PathBuf {
        self.base.join("work")
    }

    /// Sibling `.next` state dir used while the canonical one is still in
    /// use by the live `/etc` overlay.
    fn next(&self) -> RwLayout {
        let mut base = self.base.clone().into_os_string();
        base.push(".next");
        RwLayout { base: base.into() }
    }

    fn remove(&self) -> std::io::Result<()> {
        fs::remove_dir_all(&self.base)
    }
}

/// Entrypoint for `mount-etc-overlay`, called from the activation script.
///
/// The layout is passed on the command line because the activation
/// script cannot reference its own toplevel.
pub fn mount_etc_overlay() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    let layout = match args.len() {
        3 => EtcLayout {
            etc: "/etc".to_string(),
            metadata_image: args[1].clone(),
            basedir: args[2].clone(),
            rw: None,
        },
        4 => EtcLayout {
            etc: "/etc".to_string(),
            metadata_image: args[1].clone(),
            basedir: args[2].clone(),
            rw: Some(RwLayout {
                base: PathBuf::from(&args[3]),
            }),
        },
        _ => bail!("Usage: {} <metadata-image> <basedir> [<rw-state>]", args[0]),
    };

    setup_etc(&layout)
}

/// Entrypoint for `initrd-etc-overlay`, mounts `/sysroot/etc` from initrd.
///
/// The layout is discovered via the `init=` kernel parameter and bootspec
/// so the initrd does not need to be rebuilt per generation.
pub fn initrd_etc_overlay() -> Result<()> {
    let init_in_sysroot =
        find_init_in_prefix(SYSROOT_PATH).context("Failed to find init in sysroot")?;

    // A non-NixOS init= (e.g. init=/bin/sh) has no etc metadata image. Skip
    // mounting the overlay so initrd-init can switch root to the init directly.
    let Ok(toplevel) = verify_init_is_nixos(SYSROOT_PATH, &init_in_sysroot) else {
        log::info!(
            "{} is not a NixOS system - not setting up the etc overlay.",
            init_in_sysroot.display()
        );
        return Ok(());
    };

    let config = Config::from_toplevel(&toplevel, SYSROOT_PATH)?;

    let metadata_image = in_sysroot(
        config
            .etc_metadata_image
            .as_deref()
            .context("etc_metadata_image missing from bootspec")?,
    )?;
    let basedir = in_sysroot(
        config
            .etc_basedir
            .as_deref()
            .context("etc_basedir missing from bootspec")?,
    )?;

    setup_etc(&EtcLayout {
        etc: format!("{SYSROOT_PATH}/etc"),
        metadata_image,
        basedir,
        rw: config.etc_overlay_mutable.then(|| RwLayout {
            base: Path::new(SYSROOT_PATH).join(".rw-etc"),
        }),
    })
}

fn in_sysroot(path: &str) -> Result<String> {
    let resolved = resolve_in_prefix(SYSROOT_PATH, path)?;
    Ok(Path::new(SYSROOT_PATH)
        .join(resolved.strip_prefix("/")?)
        .to_str()
        .context("path is not UTF-8")?
        .to_owned())
}

/// Mount or atomically remount the `/etc` overlay for the given layout.
pub fn setup_etc(layout: &EtcLayout) -> Result<()> {
    log::info!("Setting up {} overlay...", layout.etc);

    let mounts = Mounts::parse_from_proc_mounts()?;
    // /etc already mounted: live switch, must not touch its upperdir.
    let live = mounts.find_mountpoint(&layout.etc).is_some();

    if let Some(rw) = &layout.rw {
        for d in [rw.upper(), rw.work()] {
            fs::create_dir_all(&d).with_context(|| format!("Failed to create {}", d.display()))?;
        }
        // Stale .next from a previous crashed switch; normally absent.
        let next = rw.next();
        if let Err(e) = next.remove()
            && e.kind() != std::io::ErrorKind::NotFound
        {
            log::warn!("Failed to remove stale {}: {e}.", next.base.display());
        }
    }

    let meta = build_metadata(&layout.metadata_image)?;
    let meta_path = PathBuf::from(format!("/proc/self/fd/{}", meta.as_raw_fd()));

    let mount_rw = match &layout.rw {
        // Live switch: reconcile and mount against a snapshot, promoted
        // with RENAME_EXCHANGE after the new overlay is revealed.
        Some(rw) if live => {
            let next = snapshot_upperdir(rw)?;
            reconcile_upperdir(&meta_path, &next.upper())?;
            Some(next)
        }
        // initrd / nixos-enter: the upperdir may persist from a previous
        // boot but no overlay has it open, so reconcile in place.
        Some(rw) => {
            reconcile_upperdir(&meta_path, &rw.upper())?;
            Some(rw.clone())
        }
        None => None,
    };

    let ovl = build_overlay(meta.as_fd(), layout, mount_rw.as_ref())?;
    drop(meta);

    if live {
        transfer_submounts(&mounts, &layout.etc, ovl.as_fd(), layout.rw.is_some())?;

        let etc_fd = open_tree(CWD, layout.etc.as_str(), OpenTreeFlags::empty())
            .with_context(|| format!("Failed to open {}", layout.etc))?;
        move_mount(
            ovl.as_fd(),
            "",
            etc_fd.as_fd(),
            "",
            MoveMountFlags::MOVE_MOUNT_F_EMPTY_PATH
                | MoveMountFlags::MOVE_MOUNT_T_EMPTY_PATH
                | MoveMountFlags::MOVE_MOUNT_BENEATH,
        )
        .with_context(|| format!("Failed to move new overlay beneath {}", layout.etc))?;

        // Reveal the new mount.
        unmount(layout.etc.as_str(), UnmountFlags::DETACH)
            .with_context(|| format!("Failed to detach old {}", layout.etc))?;

        if let Some(rw) = &layout.rw {
            commit_upperdir(rw)?;
        }
    } else {
        // /etc not mounted yet (initrd, nixos-enter): attach directly.
        fs::create_dir_all(&layout.etc)
            .with_context(|| format!("Failed to create {}", layout.etc))?;
        move_mount(
            ovl.as_fd(),
            "",
            CWD,
            layout.etc.as_str(),
            MoveMountFlags::MOVE_MOUNT_F_EMPTY_PATH,
        )
        .with_context(|| format!("Failed to attach overlay at {}", layout.etc))?;
    }

    // Drop /run/nixos-etc-metadata* left by older generations or the
    // legacy-lowerdir fallback.
    cleanup_legacy_metadata_mounts(&mounts);

    Ok(())
}

/// Create `base.next/` with a hardlink-copy of `upper/` and a fresh `work/`.
fn snapshot_upperdir(rw: &RwLayout) -> Result<RwLayout> {
    let next = rw.next();
    fs::create_dir(&next.base)
        .with_context(|| format!("Failed to create {}", next.base.display()))?;
    link_tree(&rw.upper(), &next.upper())
        .with_context(|| format!("Failed to snapshot {}", rw.upper().display()))?;
    fs::create_dir(next.work())
        .with_context(|| format!("Failed to create {}", next.work().display()))?;
    Ok(next)
}

/// Recreate the directory structure of `src` at `dst`, hardlinking all
/// non-directory entries. xattrs (`trusted.overlay.opaque` etc.) are
/// copied per directory; file inodes are shared so theirs come for free.
fn link_tree(src: &Path, dst: &Path) -> Result<()> {
    let meta = fs::symlink_metadata(src)?;
    fs::create_dir(dst)?;
    fs::set_permissions(dst, fs::Permissions::from_mode(meta.mode() & 0o7777))?;
    chown(dst, Some(meta.uid()), Some(meta.gid()))?;
    for name in xattr::list(src)? {
        if let Some(val) = xattr::get(src, &name)? {
            xattr::set(dst, &name, &val)?;
        }
    }

    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let d = dst.join(entry.file_name());
        if entry.file_type()?.is_dir() {
            link_tree(&entry.path(), &d)?;
        } else {
            fs::hard_link(entry.path(), &d)?;
        }
    }
    Ok(())
}

/// Atomically swap the rw state dir with its `.next` sibling.
///
/// Both overlays hold their upper/work dirs by dentry, so renaming an
/// ancestor is transparent to them.
fn commit_upperdir(rw: &RwLayout) -> Result<()> {
    let next = rw.next();
    renameat_with(CWD, &rw.base, CWD, &next.base, RenameFlags::EXCHANGE).with_context(|| {
        format!(
            "Failed to exchange {} and {}",
            rw.base.display(),
            next.base.display()
        )
    })?;
    if let Err(e) = next.remove() {
        log::warn!(
            "Failed to remove old state dir which was moved to {}: {e}.",
            next.base.display()
        );
    }
    Ok(())
}

/// Build the erofs metadata image as a detached mount fd.
///
/// Tries file-backed erofs first, falling back to a loop device.
fn build_metadata(image: &str) -> Result<OwnedFd> {
    let attrs = MountAttrFlags::MOUNT_ATTR_RDONLY
        | MountAttrFlags::MOUNT_ATTR_NODEV
        | MountAttrFlags::MOUNT_ATTR_NOSUID;

    match build_erofs(image, attrs) {
        Ok(mnt) => Ok(mnt),
        Err(Errno::NOTBLK) => {
            log::info!("File-backed erofs not available, falling back to a loop device.");
            let (loopdev, _guard) = attach_loop_device(image)?;
            build_erofs(&loopdev, attrs)
                .with_context(|| format!("Failed to mount erofs {image} via {loopdev}"))
        }
        Err(e) => Err(e).with_context(|| format!("Failed to mount erofs {image}")),
    }
}

fn build_erofs(source: &str, attrs: MountAttrFlags) -> rustix::io::Result<OwnedFd> {
    let fs = fsopen("erofs", FsOpenFlags::FSOPEN_CLOEXEC)?;
    fsconfig_set_string(fs.as_fd(), "source", source)?;
    // Set SB_RDONLY before get_tree so the block-device path opens RO.
    fsconfig_set_flag(fs.as_fd(), "ro")?;
    fsconfig_create(fs.as_fd())?;
    fsmount(fs.as_fd(), FsMountFlags::FSMOUNT_CLOEXEC, attrs)
}

/// Build the `/etc` overlay as a detached mount fd.
///
/// Passes the metadata layer by fd on modern kernels. On older kernels
/// we attach it under `/run` and use the legacy `lowerdir` string.
fn build_overlay(
    meta: BorrowedFd<'_>,
    layout: &EtcLayout,
    rw: Option<&RwLayout>,
) -> Result<OwnedFd> {
    let fs = fsopen("overlay", FsOpenFlags::FSOPEN_CLOEXEC).context("fsopen overlay")?;

    match fsconfig_set_fd(fs.as_fd(), "lowerdir+", meta) {
        Ok(()) => {
            fsconfig_set_string(fs.as_fd(), "datadir+", &layout.basedir)
                .context("fsconfig datadir+")?;
        }
        Err(Errno::INVAL) => {
            log::info!("fd-based overlay layers not available, attaching metadata under /run.");
            let p = make_temp_dir(&format!("{METADATA_MOUNT_PREFIX}."))?;
            move_mount(meta, "", CWD, &p, MoveMountFlags::MOVE_MOUNT_F_EMPTY_PATH)
                .context("Failed to attach metadata under /run")?;
            fsconfig_set_string(
                fs.as_fd(),
                "lowerdir",
                format!("{}::{}", p.display(), layout.basedir),
            )
            .context("fsconfig lowerdir")?;
        }
        Err(e) => return Err(e).context("fsconfig lowerdir+"),
    }

    fsconfig_set_string(fs.as_fd(), "redirect_dir", "on").context("fsconfig redirect_dir")?;
    fsconfig_set_string(fs.as_fd(), "metacopy", "on").context("fsconfig metacopy")?;
    if let Some(rw) = rw {
        fsconfig_set_string(fs.as_fd(), "upperdir", rw.upper()).context("fsconfig upperdir")?;
        fsconfig_set_string(fs.as_fd(), "workdir", rw.work()).context("fsconfig workdir")?;
    }
    fsconfig_create(fs.as_fd()).context("fsconfig create overlay")?;

    let mut attrs = MountAttrFlags::MOUNT_ATTR_NODEV
        | MountAttrFlags::MOUNT_ATTR_NOSUID
        | MountAttrFlags::MOUNT_ATTR_RELATIME;
    if rw.is_none() {
        attrs |= MountAttrFlags::MOUNT_ATTR_RDONLY;
    }
    fsmount(fs.as_fd(), FsMountFlags::FSMOUNT_CLOEXEC, attrs).context("fsmount overlay")
}

/// Bind each submount of `etc` onto the corresponding path inside the
/// detached overlay so it survives the slide-under.
fn transfer_submounts(
    mounts: &Mounts,
    etc: &str,
    ovl: BorrowedFd<'_>,
    mutable: bool,
) -> Result<()> {
    let prefix = format!("{etc}/");
    for m in mounts.iter() {
        let Some(rel) = m.file.strip_prefix(prefix.as_str()) else {
            continue;
        };
        let Some(target) = resolve_mountpoint(ovl, rel, &m.file, mutable)? else {
            log::warn!(
                "Dropping submount {}: mountpoint to mount on does not exist in the new read-only /etc image.",
                m.file
            );
            continue;
        };
        // Non-recursive: nested submounts are iterated separately.
        let src = open_tree(CWD, m.file.as_str(), OpenTreeFlags::OPEN_TREE_CLONE)
            .with_context(|| format!("Failed to clone submount {}", m.file))?;
        move_mount(
            src.as_fd(),
            "",
            target.as_fd(),
            "",
            MoveMountFlags::MOVE_MOUNT_F_EMPTY_PATH | MoveMountFlags::MOVE_MOUNT_T_EMPTY_PATH,
        )
        .with_context(|| format!("Failed to attach submount {rel} into new /etc"))?;
    }
    Ok(())
}

/// Walk `rel` inside the detached overlay and return an fd to the final
/// component. With `create`, missing intermediates and the leaf are made
/// in the upperdir, otherwise a missing component returns `None` so the
/// caller can skip that submount on a read-only overlay.
///
/// Uses `openat` rather than `openat2`, which systemd's `RestrictSUIDSGID=` blocks.
fn resolve_mountpoint(
    ovl: BorrowedFd<'_>,
    rel: &str,
    src: &str,
    create: bool,
) -> Result<Option<OwnedFd>> {
    let is_dir = fs::symlink_metadata(src).map_or(true, |m| m.is_dir());
    let mut cur = openat(ovl, c".", OFlags::PATH | OFlags::DIRECTORY, Mode::empty())
        .context("Failed to reopen overlay root")?;
    let mut it = rel.split('/').filter(|c| !c.is_empty()).peekable();

    while let Some(comp) = it.next() {
        // We need a directory if either there are more components
        // following, or the current component is a dir. Otherwise we
        // need a file.
        let want_dir = it.peek().is_some() || is_dir;
        if create {
            if want_dir {
                let _ = mkdirat(cur.as_fd(), comp, Mode::from_raw_mode(0o755));
            } else {
                // Create a file to mount on if it doesn't exist yet.
                // O_EXCL because O_WRONLY otherwise causes an existing file
                // to be copied into the upperdir.
                let _ = openat(
                    cur.as_fd(),
                    comp,
                    OFlags::CREATE | OFlags::EXCL | OFlags::WRONLY | OFlags::NOFOLLOW,
                    Mode::from_raw_mode(0o644),
                );
            }
        }
        let mut flags = OFlags::PATH | OFlags::NOFOLLOW;
        if want_dir {
            flags |= OFlags::DIRECTORY;
        }
        cur = match openat(cur.as_fd(), comp, flags, Mode::empty()) {
            Ok(fd) => fd,
            Err(Errno::NOENT) if !create => return Ok(None),
            Err(e) => {
                return Err(e).with_context(|| format!("Failed to open {comp} in new /etc"));
            }
        };
    }
    Ok(Some(cur))
}

fn cleanup_legacy_metadata_mounts(mounts: &Mounts) {
    for m in mounts.iter() {
        if !m.file.starts_with(METADATA_MOUNT_PREFIX) {
            continue;
        }
        if let Err(e) = unmount(m.file.as_str(), UnmountFlags::DETACH) {
            log::warn!("Failed to unmount stale {}: {e}.", m.file);
            continue;
        }
        let _ = fs::remove_dir(&m.file);
    }
}

fn make_temp_dir(prefix: &str) -> Result<PathBuf> {
    let (dir, name) = prefix
        .rsplit_once('/')
        .context("temp dir prefix must contain a directory")?;
    Ok(tempfile::Builder::new()
        .prefix(name)
        .tempdir_in(dir)
        .with_context(|| format!("Failed to create temp dir under {dir}"))?
        .keep())
}

/// Attach `image` to a free autoclearing loop device.
fn attach_loop_device(image: &str) -> Result<(String, fs::File)> {
    let out = std::process::Command::new("losetup")
        .args(["--find", "--show", "--read-only", image])
        .output()
        .context("Failed to run losetup")?;
    if !out.status.success() {
        bail!(
            "losetup failed: {}",
            String::from_utf8_lossy(&out.stderr).trim()
        );
    }
    let path = String::from_utf8(out.stdout)?.trim().to_string();

    // `losetup --detach` on a busy device sets LO_FLAGS_AUTOCLEAR to clean up
    // the loop device once it's no longer used. We return a guard that should
    // be kept alive until the erofs mount holds the device open.
    // The loop device will then automatically get cleaned up once the erofs
    // gets unmounted again.
    let guard =
        fs::File::open(&path).with_context(|| format!("Failed to open loop device {path}"))?;
    let _ = std::process::Command::new("losetup")
        .args(["--detach", &path])
        .status();

    Ok((path, guard))
}

/// Remove upperdir entries that shadow managed lowerdir entries.
///
/// Overlayfs assumes the lowerdir is immutable for the lifetime of the
/// upperdir, but we swap the lowerdir on every generation switch. Walk the
/// metadata layer and, for each entry that has an upperdir counterpart:
/// dir/dir strips `trusted.overlay.*` xattrs and recurses, anything else
/// removes the upperdir entry (whiteout, copy-up, type mismatch).
/// Upperdir-only entries are left untouched.
///
/// See <https://github.com/NixOS/nixpkgs/issues/505475>.
fn reconcile_upperdir(metadata_root: &Path, upperdir: &Path) -> Result<()> {
    reconcile_dir(metadata_root, upperdir)
}

fn reconcile_dir(metadata_dir: &Path, upper_dir: &Path) -> Result<()> {
    let entries = fs::read_dir(metadata_dir)
        .with_context(|| format!("Failed to read directory {}", metadata_dir.display()))?;

    for entry in entries {
        let entry =
            entry.with_context(|| format!("Failed to read entry in {}", metadata_dir.display()))?;
        let target = upper_dir.join(entry.file_name());

        let meta_is_dir = entry
            .file_type()
            .with_context(|| format!("Failed to stat {}", entry.path().display()))?
            .is_dir();
        let Ok(upper_meta) = fs::symlink_metadata(&target) else {
            continue;
        };

        if meta_is_dir && upper_meta.is_dir() {
            clear_overlay_xattrs(&target);
            reconcile_dir(&entry.path(), &target)?;
        } else {
            remove_upper_entry(&target, &upper_meta);
        }
    }

    Ok(())
}

fn remove_upper_entry(path: &Path, meta: &fs::Metadata) {
    let ft = meta.file_type();
    let kind = if ft.is_char_device() {
        "whiteout"
    } else if ft.is_symlink() {
        "symlink"
    } else if ft.is_dir() {
        "directory"
    } else {
        "file"
    };

    let res = if ft.is_dir() {
        fs::remove_dir_all(path)
    } else {
        fs::remove_file(path)
    };

    match res {
        Ok(()) => {
            log::info!(
                "Removed upperdir {kind} {} shadowing managed /etc entry.",
                path.display()
            );
        }
        Err(err) => {
            // Don't abort boot over this; worst case the entry stays hidden.
            log::warn!(
                "Failed to remove upperdir {kind} {}: {err}.",
                path.display()
            );
        }
    }
}

/// Strip `trusted.overlay.*` xattrs from a kept upperdir directory.
/// opaque/redirect/origin all reference the old lowerdir.
fn clear_overlay_xattrs(path: &Path) {
    let names = match xattr::list(path) {
        Ok(names) => names,
        Err(err) => {
            log::warn!("Failed to list xattrs on {}: {err}.", path.display());
            return;
        }
    };
    for name in names {
        if !name
            .as_encoded_bytes()
            .starts_with(OVERLAY_XATTR_PREFIX.as_bytes())
        {
            continue;
        }
        match xattr::remove(path, &name) {
            Ok(()) => log::info!(
                "Cleared stale {} from {}.",
                name.to_string_lossy(),
                path.display()
            ),
            Err(err) => log::warn!(
                "Failed to remove {} from {}: {err}.",
                name.to_string_lossy(),
                path.display()
            ),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    use std::os::unix::fs::symlink;

    use tempfile::tempdir;

    #[test]
    fn removes_shadows_and_preserves_unmanaged() -> Result<()> {
        let metadata = tempdir()?;
        let upper = tempdir()?;

        fs::create_dir_all(metadata.path().join("sub"))?;
        symlink("/nix/store/x", metadata.path().join("sub/managed"))?;
        symlink("/nix/store/y", metadata.path().join("sub/replaced"))?;

        // Whiteouts need mknod, so that case is covered by the VM test.
        fs::create_dir_all(upper.path().join("sub"))?;
        fs::write(upper.path().join("sub/replaced"), b"mine")?;
        fs::write(upper.path().join("sub/user-file"), b"keep")?;
        fs::write(upper.path().join("only-upper"), b"keep")?;

        reconcile_upperdir(metadata.path(), upper.path())?;

        assert!(!upper.path().join("sub/replaced").exists());
        assert_eq!(fs::read(upper.path().join("sub/user-file"))?, b"keep");
        assert_eq!(fs::read(upper.path().join("only-upper"))?, b"keep");

        Ok(())
    }

    #[test]
    fn clears_overlay_xattrs_only_for_matching_dirs() -> Result<()> {
        if !xattr::SUPPORTED_PLATFORM {
            return Ok(());
        }

        let metadata = tempdir()?;
        let upper = tempdir()?;

        fs::create_dir_all(metadata.path().join("nixos/sub"))?;
        fs::create_dir_all(upper.path().join("nixos"))?;
        fs::create_dir_all(upper.path().join("only-upper"))?;

        let opaque = "trusted.overlay.opaque";
        let redirect = "trusted.overlay.redirect";
        // trusted.* xattrs need CAP_SYS_ADMIN; skip in the build sandbox.
        if xattr::set(upper.path().join("nixos"), opaque, b"y").is_err() {
            eprintln!("skipping: cannot set trusted.* xattrs in this environment");
            return Ok(());
        }
        xattr::set(upper.path().join("nixos"), redirect, b"/elsewhere")?;
        xattr::set(upper.path().join("only-upper"), opaque, b"y")?;

        reconcile_upperdir(metadata.path(), upper.path())?;

        assert!(xattr::get(upper.path().join("nixos"), opaque)?.is_none());
        assert!(xattr::get(upper.path().join("nixos"), redirect)?.is_none());
        assert_eq!(
            xattr::get(upper.path().join("only-upper"), opaque)?.as_deref(),
            Some(b"y".as_slice())
        );

        Ok(())
    }
}
