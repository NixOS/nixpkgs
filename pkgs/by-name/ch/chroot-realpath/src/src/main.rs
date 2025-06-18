use std::env;
use std::io::{stdout, Write};
use std::os::unix::ffi::OsStrExt;
use std::os::unix::fs;

use anyhow::{bail, Context, Result};

fn main() -> Result<()> {
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
