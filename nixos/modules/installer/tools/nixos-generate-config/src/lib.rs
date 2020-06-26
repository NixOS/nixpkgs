use std::io;
use std::io::Write;
use std::process::Command;
use std::path::PathBuf;
use crate::config_info::ConfigInfo;
use crate::hardware_info::HardwareInfo;
use crate::error::Result;

pub mod render;
mod config_info;
mod hardware_info;
mod error;

use simple_error::{bail, try_with};

const MAN_EXECUTABLE: &str = env!("MAN_EXECUTABLE");
const NIXOS_MANPAGES: &str = env!("NIXOS_MANPAGES");


/// Options set by command line flags
struct Options {
    out_dir: PathBuf,
    root_dir: PathBuf,
    force: bool,
    no_filesystems: bool,
    show_hardware_config: bool,
    show_help: bool,
}

fn parse_options(args: &[String]) -> Result<Options> {
    let mut i: usize = 0;
    let mut opts = Options {
        out_dir: PathBuf::from("/etc/nixos"),
        root_dir: PathBuf::from("/"),
        force: false,
        no_filesystems: false,
        show_hardware_config: false,
        show_help: false,
    };

    loop {
        if i >= args.len() {
            return Ok(opts);
        }

        match args[i].as_ref() {
            "-h" | "--help" => {
                opts.show_help = true;

                return Ok(opts);
            }
            "--dir" => {
                i += 1;

                if i >= args.len() {
                    bail!("'--dir' requires an argument");
                }

                opts.out_dir = PathBuf::from(args[i].clone());
            }
            "--root" => {
                i += 1;

                if i >= args.len() {
                    bail!("'--root' requires an argument");
                }

                opts.root_dir = PathBuf::from(args[i].clone());
            }
            "--force" => {
                opts.force = true;
            }
            "--no-filesystems" => {
                opts.no_filesystems = true;
            }
            "--show-hardware-config" => {
                opts.show_hardware_config = true;
            }
            _ => {
                bail!("unrecognized argument '{}'", args[i]);
            }
        }

        i += 1;
    }
}

fn show_help() -> Result<()> {
    let status = try_with!(
        Command::new(MAN_EXECUTABLE)
            .arg("nixos-generate-config")
            .env("MANPATH", NIXOS_MANPAGES)
            .status(),
        "failed to open man page"
    );

    match status.code() {
        Some(0) => Ok(()),
        Some(code) => bail!("man exited with {}", code),
        None => bail!("man was killed by signal"),
    }
}

// FIXME also have a unit test for this
fn generate_config(opts: &Options) -> Result<()> {
    let mut target_dir = opts.root_dir.clone();
    let relative_dir = opts.out_dir.strip_prefix("/").unwrap_or(&opts.out_dir);
    target_dir.push(relative_dir);

    let config_info = ConfigInfo{
        bootloader_config: String::from(""),
        networking_dhcp_config: String::from(""),
        nixos_release: String::from("")
    };
    let hardware_info = HardwareInfo{
        imports: vec![],
        initrd_available_kernel_modules: vec![],
        initrd_kernel_modules: vec![],
        kernel_modules: vec![],
        module_packages: vec![],
        filesystems: vec![],
        luks_devices: vec![],
        swap_devices: vec![],
        // TODO: maybe those should become subtemplates or hash maps?
        attrs: vec![]
    };

    render::CONFIGURATION_NIX.write_to_file(target_dir.join("configuration.nix"), &config_info)?;
    render::HARDWARE_CONFIGURATION_NIX.write_to_file(target_dir.join("hardware-configuration.nix"), &hardware_info)?;
    Ok(())
}

pub fn run_app(args: &[String]) -> i32 {
    let default_name = String::from("nixos-generate-config");
    let app_name = args.get(0).unwrap_or(&default_name);
    let opts = match parse_options(&args[1..]) {
        Ok(opts) => opts,
        Err(err) => {
            writeln!(io::stderr(), "{}: {}", app_name, err)
                .expect("Failed to write error to stderr");

            return 1;
        }
    };

    if opts.show_help {
        if let Err(err) = show_help() {
            writeln!(io::stderr(), "{}: {}", app_name, err)
                .expect("Failed to write error to stderr");

            return 1;
        }
    }

    if let Err(err) = generate_config(&opts) {
        writeln!(io::stderr(), "{}: {}", app_name, err)
            .expect("Failed to write error to stderr");
    };

    0
}
