use std::{
    env, fs,
    os::unix::fs::PermissionsExt,
    path::{Path, PathBuf},
};

use anyhow::{Context, Result, bail};

use rustix::mount::{mount, mount_remount};

use crate::{
    config::{Config, SpecialMount},
    fs::{atomic_symlink, split_mount_opts},
    proc_mounts::Mounts,
};

/// Entrypoint for the `activate` binary.
///
/// Activate a `NixOS` system configuration on the running system.
pub fn activate_main() -> Result<()> {
    let args: Vec<String> = env::args().collect();

    if args.len() != 2 {
        bail!("Usage: {} <toplevel>", args[0]);
    }

    // Canonicalize so /run/current-system points at the resolved store path.
    let toplevel = fs::canonicalize(&args[1])
        .with_context(|| format!("Failed to canonicalize toplevel path {}", args[1]))?;

    let config =
        Config::from_toplevel(&toplevel, "/").context("Failed to load nixos-init config")?;

    log::info!("Setting up special filesystems...");
    setup_special_filesystems(&config.special_filesystems)?;

    activate("/", &toplevel, &config)
}

/// Mount or remount each entry in `boot.specialFileSystems`.
fn setup_special_filesystems(mounts: &[SpecialMount]) -> Result<()> {
    let existing = Mounts::parse_from_proc_mounts()?;
    for m in mounts {
        let (flags, data) = split_mount_opts(&m.options);
        if existing.find_mountpoint(&m.mountpoint).is_some() {
            mount_remount(m.mountpoint.as_str(), flags, data.as_c_str())
                .with_context(|| format!("Failed to remount {}", m.mountpoint))?;
        } else {
            fs::create_dir_all(&m.mountpoint)
                .with_context(|| format!("Failed to create {}", m.mountpoint))?;
            let mut perms = fs::metadata(&m.mountpoint)?.permissions();
            perms.set_mode(0o755);
            fs::set_permissions(&m.mountpoint, perms)?;
            mount(
                m.device.as_str(),
                m.mountpoint.as_str(),
                m.fstype.as_str(),
                flags,
                data.as_c_str(),
            )
            .with_context(|| format!("Failed to mount {}", m.mountpoint))?;
        }
    }
    Ok(())
}

/// Activate the system.
///
/// This runs both during boot and during re-activation initiated by switch-to-configuration.
pub fn activate(prefix: &str, toplevel: impl AsRef<Path>, config: &Config) -> Result<()> {
    log::info!("Setting up /run/current-system...");
    let system_path = PathBuf::from(prefix).join("run/current-system");
    atomic_symlink(&toplevel, system_path)?;

    if let Some(modprobe_binary) = &config.modprobe_binary {
        log::info!("Setting up modprobe...");
        setup_modprobe(modprobe_binary)?;
    } else {
        log::info!("No modprobe binary provided. Not setting up modprobe.");
    }

    if let Some(firmware) = &config.firmware {
        log::info!("Setting up firmware search paths...");
        setup_firmware_search_path(firmware)?;
    } else {
        log::info!("No firmware path provided. Not setting up firmware search paths.");
    }

    match config.env_binary.as_deref() {
        None => log::info!("/usr/bin/env not managed by nixos-init."),
        Some("") => {
            log::info!("Removing /usr/bin/env...");
            remove_usrbinenv(prefix)?;
        }
        Some(path) => {
            log::info!("Setting up /usr/bin/env...");
            setup_usrbinenv(prefix, path)?;
        }
    }

    match config.sh_binary.as_deref() {
        None => log::info!("/bin/sh not managed by nixos-init."),
        Some("") => {
            log::info!("Removing /bin/sh...");
            remove_binsh(prefix)?;
        }
        Some(path) => {
            log::info!("Setting up /bin/sh...");
            setup_binsh(prefix, path)?;
        }
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
    let usrbin_path = PathBuf::from(prefix).join("usr/bin");
    fs::create_dir_all(&usrbin_path).context("Failed to create /usr/bin")?;
    atomic_symlink(&env_binary, usrbin_path.join("env"))
}

/// Remove `/usr/bin/env`.
///
/// `/usr/bin` is kept (and created if missing) so that `/usr` is never empty,
/// which systemd treats as a fatal boot error.
fn remove_usrbinenv(prefix: &str) -> Result<()> {
    let usrbin = PathBuf::from(prefix).join("usr/bin");
    fs::create_dir_all(&usrbin).context("Failed to create /usr/bin")?;
    remove_if_exists(&usrbin.join("env"))
}

/// Setup /bin/sh.
///
/// `/bin/sh` is an essential part of a Linux system as this path is hardcoded in the `system()` call
/// from libc. See `man systemd(3)`.
fn setup_binsh(prefix: &str, sh_binary: impl AsRef<Path>) -> Result<()> {
    let binsh_path = PathBuf::from(prefix).join("bin/sh");
    atomic_symlink(&sh_binary, binsh_path)
}

/// Remove `/bin/sh`. `/bin` is kept (and created if missing).
fn remove_binsh(prefix: &str) -> Result<()> {
    let bin = PathBuf::from(prefix).join("bin");
    fs::create_dir_all(&bin).context("Failed to create /bin")?;
    remove_if_exists(&bin.join("sh"))
}

fn remove_if_exists(path: &Path) -> Result<()> {
    match fs::remove_file(path) {
        Ok(()) => Ok(()),
        Err(e) if e.kind() == std::io::ErrorKind::NotFound => Ok(()),
        Err(e) => Err(e).with_context(|| format!("Failed to remove {}", path.display())),
    }
}
