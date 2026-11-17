mod conf;
mod files;
mod secure_boot;

use std::fs;
use std::path::{Path, PathBuf};
use std::process::Command;

use anyhow::{Context, Result, bail};

use crate::command;
use crate::config::{Config, FileSystem};
use crate::efi;
use files::BootFiles;
pub use files::blake2b;

pub fn install(config: &Config, profiles_dir: &Path, current_system: &Path) -> Result<()> {
    let install_dir = install_dir(config)?;
    secure_boot::ensure_keys_present(config)?;

    let mut files = BootFiles::new(install_dir, config.validate_checksums)?;
    let limine_conf = conf::render(config, &mut files, profiles_dir, current_system)?;
    files.write_limine_conf(&limine_conf)?;

    for (dest, source) in &config.additional_files {
        files.copy_file(source, &config.efi_mount_point.join(dest))?;
    }
    if config.efi_support {
        install_efi(config, &mut files, &limine_conf)?;
    }
    if config.bios_support {
        install_bios(config, &mut files)?;
    }
    files.remove_unused_files()
}

/// `limine` on the partition Limine boots from, which it refers to as `boot():/limine`.
fn install_dir(config: &Config) -> Result<PathBuf> {
    if config.efi_support {
        return Ok(config.efi_mount_point.join("limine"));
    }

    let cause = match config.file_systems.get("/boot") {
        None => "not present".to_owned(),
        Some(boot) => {
            let is_fat = boot.fs_type.starts_with("vfat");
            let is_encrypted = is_encrypted(&config.luks_devices, boot);
            if is_fat && !is_encrypted {
                return Ok(PathBuf::from("/boot/limine"));
            }
            format!("FAT: {is_fat}, encrypted: {is_encrypted}")
        }
    };
    bail!(
        "Could not find a valid place for Limine configuration files!\n\
         Possible candidates that were ruled out:\n  \
         - /limine on the boot partition ({cause})\n\
         Limine cannot be installed on a system without an unencrypted\n\
         partition formatted as FAT."
    );
}

fn is_encrypted(luks_devices: &[String], boot: &FileSystem) -> bool {
    let Some(device) = boot.device.as_ref().and_then(|d| fs::canonicalize(d).ok()) else {
        return false;
    };
    luks_devices.iter().any(|name| {
        fs::canonicalize(Path::new("/dev/mapper").join(name)).is_ok_and(|mapped| mapped == device)
    })
}

fn install_efi(config: &Config, files: &mut BootFiles, limine_conf: &str) -> Result<()> {
    let boot_file = config
        .efi_boot_file
        .as_deref()
        .context("efiBootFile is required for EFI support")?;
    let source = config.limine_path.join("share/limine").join(boot_file);
    let dir = if config.efi_removable {
        "boot"
    } else {
        "limine"
    };
    let dest = config.efi_mount_point.join("efi").join(dir).join(boot_file);
    files.copy_file(&source, &dest)?;

    if config.enroll_config {
        command::run(
            Command::new(limine_bin(config))
                .arg("enroll-config")
                .arg(&dest)
                .arg(blake2b(limine_conf.as_bytes())?),
        )
        .context("failed to enroll limine config")?;
    }

    if config.secure_boot.enable {
        secure_boot::sign(config, &dest)?;
    }

    match (config.can_touch_efi_variables, config.efi_removable) {
        (false, false) => eprintln!(
            "warning: boot.loader.efi.canTouchEfiVariables and \
             boot.loader.limine.efiInstallAsRemovable are both false.\n  \
             This may render the system unbootable."
        ),
        (true, true) => println!(
            "note: boot.loader.limine.efiInstallAsRemovable is true, no need to add EFI entry."
        ),
        (true, false) => {
            let efibootmgr = config
                .efi_boot_mgr_path
                .as_ref()
                .context("efiBootMgrPath is required for EFI support")?
                .join("bin/efibootmgr");
            efi::install_boot_entry(&efibootmgr, &config.efi_mount_point, boot_file)
                .context("failed to create the EFI boot entry")?;
        }
        (false, true) => {}
    }
    Ok(())
}

fn install_bios(config: &Config, files: &mut BootFiles) -> Result<()> {
    let stage2 = config.limine_path.join("share/limine/limine-bios.sys");
    files.copy_file(&stage2, &files.install_dir().join("limine-bios.sys"))?;

    if config.bios_device == "nodev" {
        eprintln!(
            "note: boot.loader.limine.biosSupport is set, but device is set to nodev, \
             only the stage 2 bootloader will be installed."
        );
        return Ok(());
    }

    let mut install = Command::new(limine_bin(config));
    install.args(["bios-install", &config.bios_device]);
    if let Some(index) = config.partition_index {
        install.arg(index.to_string());
    }
    if config.force {
        install.arg("--force");
    }
    command::run(&mut install).context(
        "Failed to deploy BIOS stage 1 Limine bootloader!\n\
         You might want to try enabling the `boot.loader.limine.force` option.",
    )
}

fn limine_bin(config: &Config) -> PathBuf {
    config.limine_path.join("bin/limine")
}
