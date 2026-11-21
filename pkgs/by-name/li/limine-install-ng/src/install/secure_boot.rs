use std::path::Path;
use std::process::Command;

use anyhow::{Context, Result, bail};

use crate::command;
use crate::config::Config;
use crate::efi;

const SBCTL_DIR: &str = "/var/lib/sbctl";
const SBCTL_KEYS_DIR: &str = "/var/lib/sbctl/keys";

pub(super) fn ensure_keys_present(config: &Config) -> Result<()> {
    if config.secure_boot.enable
        && !config.secure_boot.auto_generate_keys
        && !Path::new(SBCTL_DIR).exists()
    {
        bail!("There are no sbctl secure boot keys present. Please generate some.");
    }
    Ok(())
}

pub(super) fn sign(config: &Config, limine_efi: &Path) -> Result<()> {
    let secure_boot = &config.secure_boot;
    let sbctl = secure_boot
        .sbctl
        .as_ref()
        .context("secureBoot.sbctl is required when secureBoot is enabled")?
        .join("bin/sbctl");

    if secure_boot.auto_generate_keys && !Path::new(SBCTL_KEYS_DIR).exists() {
        println!("auto generating keys");
        command::run(Command::new(&sbctl).arg("create-keys")).context("failed to create keys")?;
        if secure_boot.auto_enroll_keys.enable {
            command::run(
                Command::new(&sbctl)
                    .arg("enroll-keys")
                    .args(&secure_boot.auto_enroll_keys.extra_args),
            )
            .context("failed to enroll keys")?;
        }
    }

    println!("signing limine...");
    command::run(Command::new(&sbctl).arg("sign").arg(limine_efi))
        .context("failed to sign limine")?;

    if !secure_boot.sign_additional_files.enable {
        return Ok(());
    }
    for file in config.additional_files.keys() {
        if secure_boot.sign_additional_files.skip.contains(file) {
            println!("skipping signing of {file}");
            continue;
        }
        let path = config.efi_mount_point.join(file);
        // Additional files need not be bootable, and only PE/COFF images can be signed.
        if !efi::is_pe_coff_image(&path) {
            println!("skipping signing of {file}: not a PE/COFF image");
            continue;
        }
        println!("signing {file}...");
        command::run(Command::new(&sbctl).arg("sign").arg(&path))
            .with_context(|| format!("failed to sign {file}"))?;
    }
    Ok(())
}
