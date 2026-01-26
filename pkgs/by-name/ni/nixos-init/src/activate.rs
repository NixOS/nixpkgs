use std::{fs, path::Path};

use anyhow::{Context, Result};

use crate::{config::Config, fs::atomic_symlink};

/// Activate the system.
///
/// This runs both during boot and during re-activation initiated by switch-to-configuration.
pub fn activate(prefix: &str, toplevel: impl AsRef<Path>, config: &Config) -> Result<()> {
    log::info!("Setting up /run/current-system...");
    atomic_symlink(&toplevel, format!("{prefix}/run/current-system"))?;

    log::info!("Setting up modprobe...");
    setup_modprobe(&config.modprobe_binary)?;

    log::info!("Setting up firmware search paths...");
    setup_firmware_search_path(&config.firmware)?;

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

    Ok(())
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
    const USRBINENV_PATH: &str = "/usr/bin/env";

    fs::create_dir_all(format!("{prefix}/usr/bin")).context("Failed to create /usr/bin")?;
    atomic_symlink(&env_binary, format!("{prefix}{USRBINENV_PATH}"))
}

/// Setup /bin/sh.
///
/// `/bin/sh` is an essential part of a Linux system as this path is hardcoded in the `system()` call
/// from libc. See `man systemd(3)`.
fn setup_binsh(prefix: &str, sh_binary: impl AsRef<Path>) -> Result<()> {
    const BINSH_PATH: &str = "/bin/sh";
    atomic_symlink(&sh_binary, format!("{prefix}{BINSH_PATH}"))
}
