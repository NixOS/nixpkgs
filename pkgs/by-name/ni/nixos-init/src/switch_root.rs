use std::{io::Write, path::PathBuf, process::Command};

use anyhow::{Context, Result, bail};

use crate::SYSROOT_PATH;

/// Switch root from initrd.
///
/// If the provided init is `None`, systemd is used as the next init.
pub fn switch_root(init: Option<PathBuf>) -> Result<()> {
    log::info!("Switching root to {SYSROOT_PATH}...");

    let mut cmd = Command::new("systemctl");
    cmd.arg("--no-block").arg("switch-root").arg(SYSROOT_PATH);

    if let Some(init) = init {
        log::info!("Using init {}.", init.display());
        cmd.arg(init);
    } else {
        log::info!("Using built-in systemd as init.");
        cmd.arg("");
    }

    let output = cmd
        .output()
        .context("Failed to run systemctl switch-root. Most likely the binary is not on PATH")?;

    let _ = std::io::stderr().write_all(&output.stderr);

    if !output.status.success() {
        bail!("systemctl switch-root exited unsuccessfully");
    }

    Ok(())
}
