use anyhow::{Context, Result};

use crate::{
    SYSROOT_PATH, config::Config, find_init_in_prefix, init, switch_root, verify_init_is_nixos,
};

/// Entrypoint for the `initrd-bin` binary.
///
/// Initialize `NixOS` from a systemd initrd.
pub fn initrd_init() -> Result<()> {
    let config = Config::from_env().context("Failed to get configuration")?;
    let init_in_sysroot =
        find_init_in_prefix(SYSROOT_PATH).context("Failed to find init in sysroot")?;

    let init_path = if let Ok(toplevel) = verify_init_is_nixos(SYSROOT_PATH, &init_in_sysroot) {
        log::info!("Initializing NixOS...");
        init(SYSROOT_PATH, toplevel, &config)?;
        None
    } else {
        log::info!("Not initializing NixOS. Switching to new root immediately...");
        Some(init_in_sysroot)
    };

    switch_root(init_path)?;
    Ok(())
}
