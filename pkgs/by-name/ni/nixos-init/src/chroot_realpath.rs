use std::{
    env,
    io::{Write, stdout},
    os::unix::ffi::OsStrExt,
    os::unix::fs,
    path::{Path, PathBuf},
    process::Command,
};

use anyhow::{Context, Result, bail};

/// Canonicalize `path` in a chroot at the specified `root`.
pub fn canonicalize_in_chroot(root: &str, path: &Path) -> Result<PathBuf> {
    let output = Command::new("chroot-realpath")
        .arg(root)
        .arg(path.as_os_str())
        .output()
        .context("Failed to run chroot-realpath. Most likely, the binary is not on PATH")?;

    if !output.status.success() {
        bail!(
            "chroot-realpath exited unsuccessfully: {}",
            String::from_utf8_lossy(&output.stderr)
        );
    }

    let output =
        String::from_utf8(output.stdout).context("Failed to decode stdout of chroot-realpath")?;

    Ok(PathBuf::from(&output))
}

/// Entrypoint for the `chroot-realpath` binary.
pub fn chroot_realpath() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        bail!("Usage: {} <chroot> <path>", args[0]);
    }

    fs::chroot(&args[1]).context("Failed to chroot")?;
    std::env::set_current_dir("/").context("Failed to change directory")?;

    let path = std::fs::canonicalize(&args[2])
        .with_context(|| format!("Failed to canonicalize {}", args[2]))?;

    stdout()
        .write_all(path.into_os_string().as_bytes())
        .context("Failed to write output")?;

    Ok(())
}
