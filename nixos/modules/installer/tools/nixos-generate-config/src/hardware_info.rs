use serde::Deserialize;
use serde::Serialize;


#[derive(Debug, Deserialize, Serialize)]
pub struct Filesystem {
    // TODO: make those fields private?
    pub dev: String,
    pub fs_type: String,
    // TODO should be vector
    pub options: String,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct LuksDevices {
    pub dm_name: String,
    pub dev: String,
}


/// The resolved hardware info and the input for rendering the hardware-configuration.nix.tera template.
#[derive(Debug, Deserialize, Serialize)]
pub struct HardwareInfo {
    // TODO: make those fields private?
    pub imports: Vec<String>,
    pub initrd_available_kernel_modules: Vec<String>,
    pub initrd_kernel_modules: Vec<String>,
    pub kernel_modules: Vec<String>,
    pub module_packages: Vec<String>,
    pub filesystems: Vec<Filesystem>,
    pub luks_devices: Vec<LuksDevices>,
    pub swap_devices: Vec<String>,
    // TODO: maybe those should become subtemplates or hash maps?
    pub attrs: Vec<String>
}
