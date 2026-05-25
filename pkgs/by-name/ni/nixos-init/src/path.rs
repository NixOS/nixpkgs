use std::{
    env,
    io::{Write, stdout},
    os::{
        fd::{AsFd, AsRawFd},
        unix::ffi::OsStrExt,
    },
    path::{Path, PathBuf},
};

use anyhow::{Context, Result, bail};
use pathrs::{
    Root,
    procfs::{ProcfsBase, ProcfsHandle},
};

/// Resolve a path inside a prefix.
///
/// This resolves the path by following all symlinks until the end.
///
/// Uses `openat(2)` with the `RESOLVE_IN_ROOT` flag.
pub fn resolve_in_prefix(prefix: &str, path: impl AsRef<Path>) -> Result<PathBuf> {
    let root = Root::open(prefix).with_context(|| format!("Failed to open prefix {prefix}"))?;
    let handle = root.resolve(&path).with_context(|| {
        format!(
            "Failed to resolve path {} in prefix {prefix}",
            path.as_ref().display()
        )
    })?;

    let fd = handle.as_fd().as_raw_fd();
    if fd.is_negative() {
        bail!("File descriptor of resolved path is negative")
    }
    let proc = ProcfsHandle::new().context("Failed to open /proc")?;
    let resolved_path = proc
        .readlink(ProcfsBase::ProcSelf, format!("fd/{fd}"))
        .context("Failed to read path from procfs fd")?;

    // Reading the path of the resolved FD will add the prefix to the path. Nonetheless this path
    // has been correctly resolved and we can simply strip the prefix again.
    Ok(Path::new("/").join(
        resolved_path
            .strip_prefix(prefix)
            .context("Failed to strip prefix from path")?,
    ))
}

/// Entrypoint for the `resolve-in-root` binary.
pub fn resolve_in_root() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        bail!("Usage: {} <root> <path>", args[0]);
    }

    let path = resolve_in_prefix(&args[1], &args[2])?;

    stdout()
        .write_all(path.into_os_string().as_bytes())
        .context("Failed to write output")?;

    Ok(())
}
