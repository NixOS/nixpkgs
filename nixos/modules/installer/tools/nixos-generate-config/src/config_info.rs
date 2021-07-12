use serde::Deserialize;
use serde::Serialize;


/// The resolved configuration info and the input for rendering the configuration.nix.tera template.
#[derive(Debug, Deserialize, Serialize)]
pub struct ConfigInfo {
    // TODO: make those fields private?
    pub bootloader_config: String,
    pub networking_dhcp_config: String,
    pub nixos_release: String,
}
