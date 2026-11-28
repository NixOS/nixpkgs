//! Installs Limine and generates its configuration for a NixOS system.
//!
//! Usage: `limine-install <config.json> <toplevel>`

mod bootspec;
mod command;
mod config;
mod efi;
mod install;
mod profiles;
#[cfg(test)]
mod tests;

use std::ffi::OsString;
use std::fs::File;
use std::io;
use std::os::fd::AsRawFd;
use std::path::Path;
use std::process::ExitCode;

use config::InstallConfig;

fn main() -> ExitCode {
    let args: Vec<OsString> = std::env::args_os().skip(1).collect();
    let [config, toplevel] = args.as_slice() else {
        eprintln!("usage: limine-install <config.json> <toplevel>");
        return ExitCode::from(2);
    };

    match run(Path::new(config), Path::new(toplevel)) {
        Ok(()) => ExitCode::SUCCESS,
        Err(err) => {
            eprintln!("error: {err:#}");
            ExitCode::FAILURE
        }
    }
}

fn run(config: &Path, toplevel: &Path) -> anyhow::Result<()> {
    let config = InstallConfig::load(config)?;
    let result = install::install(&config, Path::new(profiles::PROFILES_DIR), toplevel);
    // FAT offers little recovery after a crash, so flush the boot partition before an outage
    // shortly after an update can leave the system unbootable.
    if let Err(err) = sync_filesystem(&config.efi_mount_point) {
        eprintln!("could not sync {}: {err}", config.efi_mount_point.display());
    }
    result
}

fn sync_filesystem(path: &Path) -> io::Result<()> {
    let file = File::open(path)?;
    // SAFETY: the descriptor stays open for the duration of the call.
    if unsafe { libc::syncfs(file.as_raw_fd()) } != 0 {
        return Err(io::Error::last_os_error());
    }
    Ok(())
}
