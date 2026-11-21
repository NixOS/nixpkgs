use std::{
    fs,
    os::unix::fs::PermissionsExt,
    path::{Path, PathBuf},
};

use anyhow::{Context, Result};
use pathrs::{Root, flags::RenameFlags};

use crate::{config::Config, fs::atomic_symlink};

/// Activate the system.
///
/// This runs both during boot and during re-activation initiated by switch-to-configuration.
pub fn activate(prefix: &str, toplevel: impl AsRef<Path>, config: &Config) -> Result<()> {
    log::info!("Setting up /run/current-system...");
    let system_path = PathBuf::from(prefix).join("run/current-system");
    atomic_symlink(&toplevel, system_path)?;

    log::info!("Setting up modprobe...");
    setup_modprobe(&config.modprobe_binary)?;

    log::info!("Setting up firmware search paths...");
    setup_firmware_search_path(&config.firmware)?;

    log::info!("Setting up /usr/bin...");
    setup_usrbin(prefix)?;

    if let Some(env_path) = &config.env_binary {
        log::info!("Setting up /usr/bin/env...");
        setup_usrbinenv(prefix, env_path)?;
    } else {
        log::info!("No env binary provided. Not setting up /usr/bin/env.");
    }

    if let Some(sh_path) = &config.sh_binary {
        log::info!("Setting up /bin/sh...");
        setup_binsh(prefix, sh_path)?;
    } else {
        log::info!("No sh binary provided. Not setting up /bin/sh.");
    }

    log::info!("Setting up /bin...");
    setup_bin_symlink(prefix)
}

/// Create `/usr/bin` if it doesn't exist.
///
/// The mode is only set on a newly created directory, so an existing directory or mount (e.g.
/// envfs) is left alone.
fn setup_usrbin(prefix: &str) -> Result<()> {
    let usrbin_path = PathBuf::from(prefix).join("usr/bin");
    if usrbin_path.exists() {
        return Ok(());
    }
    fs::create_dir_all(&usrbin_path).context("Failed to create /usr/bin")?;
    fs::set_permissions(&usrbin_path, fs::Permissions::from_mode(0o755))
        .context("Failed to set permissions on /usr/bin")
}

/// Setup modprobe so that the kernel can find the wrapped binary.
///
/// See <https://docs.kernel.org/admin-guide/sysctl/kernel.html#modprobe>
fn setup_modprobe(modprobe_binary: impl AsRef<Path>) -> Result<()> {
    // This uses the procfs setup in the initrd, which is fine because it points to the same kernel
    // a procfs in a chroot would.
    const MODPROBE_PATH: &str = "/proc/sys/kernel/modprobe";

    if Path::new(MODPROBE_PATH).exists() {
        fs::write(
            MODPROBE_PATH,
            modprobe_binary.as_ref().as_os_str().as_encoded_bytes(),
        )
        .with_context(|| {
            format!(
                "Failed to populate modprobe path with {}",
                modprobe_binary.as_ref().display()
            )
        })?;
    } else {
        log::info!("{MODPROBE_PATH} doesn't exist. Not populating it...");
    }

    Ok(())
}

/// Setup the firmware search path so that the kernel can find the firmware.
///
/// See <https://www.kernel.org/doc/html/latest/driver-api/firmware/fw_search_path.html>
fn setup_firmware_search_path(firmware: impl AsRef<Path>) -> Result<()> {
    // This uses the sysfs setup in the initrd, which is fine because it points to the same kernel
    // a procfs in a chroot would.
    const FIRMWARE_SERCH_PATH: &str = "/sys/module/firmware_class/parameters/path";

    if Path::new(FIRMWARE_SERCH_PATH).exists() {
        fs::write(
            FIRMWARE_SERCH_PATH,
            firmware.as_ref().as_os_str().as_encoded_bytes(),
        )
        .with_context(|| {
            format!(
                "Failed to populate firmware search path with {}",
                firmware.as_ref().display()
            )
        })?;
    } else {
        log::info!("{FIRMWARE_SERCH_PATH} doesn't exist. Not populating it...");
    }

    Ok(())
}

/// Setup `/usr/bin/env`.
///
/// We have to setup `/usr` for `NixOS` to work.
///
/// We do this here accidentally. `/usr/bin/env` is currently load-bearing for `NixOS`.
fn setup_usrbinenv(prefix: &str, env_binary: impl AsRef<Path>) -> Result<()> {
    let usrbin_path = PathBuf::from(prefix).join("usr/bin");
    atomic_symlink(&env_binary, usrbin_path.join("env"))
}

/// Setup /bin/sh.
///
/// `/bin/sh` is an essential part of a Linux system as this path is hardcoded in the `system()` call
/// from libc. See `man systemd(3)`.
///
/// The actual symlink lives in `/usr/bin` and `/bin` is a symlink to `usr/bin`. Otherwise systemd
/// taints the system with `unmerged-usr`.
fn setup_binsh(prefix: &str, sh_binary: impl AsRef<Path>) -> Result<()> {
    let usrbin_path = PathBuf::from(prefix).join("usr/bin");
    atomic_symlink(&sh_binary, usrbin_path.join("sh"))
}

/// Make `/bin` a symlink to `usr/bin`.
///
/// Older generations created `/bin` as a directory that only contains `sh`. Atomically exchange it
/// with the symlink so that `/bin/sh` never disappears.
fn setup_bin_symlink(prefix: &str) -> Result<()> {
    let bin_path = PathBuf::from(prefix).join("bin");

    if bin_path.is_symlink() || !bin_path.is_dir() {
        return atomic_symlink("usr/bin", bin_path);
    }

    let tmp_path = PathBuf::from(prefix).join(".bin.tmp");
    std::os::unix::fs::symlink("usr/bin", &tmp_path)
        .with_context(|| format!("Failed to create {}", tmp_path.display()))?;
    Root::open(prefix)
        .with_context(|| format!("Failed to open prefix {prefix}"))?
        .rename(".bin.tmp", "bin", RenameFlags::RENAME_EXCHANGE)
        .context("Failed to exchange /bin with a symlink")?;
    // /bin is already migrated at this point, so failing to clean up must not fail the boot.
    if let Err(err) = fs::remove_file(tmp_path.join("sh")).and_then(|()| fs::remove_dir(&tmp_path))
    {
        log::warn!("Failed to remove old /bin at {}: {err}", tmp_path.display());
    }
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;

    use tempfile::tempdir;

    const SH: &str = "/nix/store/xxx-bash/bin/sh";

    #[test]
    fn binsh_migrates_bin_dir() -> Result<()> {
        let prefix = tempdir()?;
        fs::create_dir(prefix.path().join("bin"))?;
        std::os::unix::fs::symlink(SH, prefix.path().join("bin/sh"))?;

        let prefix_str = prefix.path().to_str().unwrap();
        setup_usrbin(prefix_str)?;
        setup_binsh(prefix_str, SH)?;
        setup_bin_symlink(prefix_str)?;

        assert_eq!(
            fs::read_link(prefix.path().join("bin"))?,
            Path::new("usr/bin")
        );
        assert_eq!(
            fs::read_link(prefix.path().join("usr/bin/sh"))?,
            Path::new(SH)
        );
        assert!(!prefix.path().join(".bin.tmp").exists());
        Ok(())
    }

    #[test]
    fn usrbin_keeps_existing_mode() -> Result<()> {
        let prefix = tempdir()?;
        let usrbin = prefix.path().join("usr/bin");
        fs::create_dir_all(&usrbin)?;
        fs::set_permissions(&usrbin, fs::Permissions::from_mode(0o700))?;

        setup_usrbin(prefix.path().to_str().unwrap())?;

        assert_eq!(fs::metadata(&usrbin)?.permissions().mode() & 0o777, 0o700);
        Ok(())
    }

    #[test]
    fn usrbin_created_with_mode() -> Result<()> {
        let prefix = tempdir()?;

        setup_usrbin(prefix.path().to_str().unwrap())?;

        let usrbin = prefix.path().join("usr/bin");
        assert_eq!(fs::metadata(&usrbin)?.permissions().mode() & 0o777, 0o755);
        Ok(())
    }
}
