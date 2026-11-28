use std::process::Command;

use anyhow::{Context, Result, bail};

/// Runs `command` with inherited stdio and fails unless it exits successfully.
pub fn run(command: &mut Command) -> Result<()> {
    let status = command
        .status()
        .with_context(|| format!("failed to run {command:?}"))?;
    if !status.success() {
        bail!("{command:?} failed with {status}");
    }
    Ok(())
}

/// Runs `command` and returns its stdout, failing with its output unless it exits successfully.
pub fn output(command: &mut Command) -> Result<String> {
    let output = command
        .output()
        .with_context(|| format!("failed to run {command:?}"))?;
    if !output.status.success() {
        bail!(
            "{command:?} failed with {}:\n{}{}",
            output.status,
            String::from_utf8_lossy(&output.stdout),
            String::from_utf8_lossy(&output.stderr)
        );
    }
    Ok(String::from_utf8_lossy(&output.stdout).into_owned())
}
