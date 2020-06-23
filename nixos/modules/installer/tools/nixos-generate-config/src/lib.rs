#[macro_use]
extern crate simple_error;

use std::error;
use std::result;
use std::string::String;
use std::process::Command;

const MAN_EXECUTABLE: &str = env!("MAN_EXECUTABLE");
const NIXOS_MANPAGES: &str = env!("NIXOS_MANPAGES");

type Result<T> = result::Result<T,Box<dyn error::Error>>;

struct Options {
    out_dir: String,
    root_dir: String,
    force: bool,
    no_filesystems: bool,
    show_hardware_config: bool,
    show_help: bool
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Error {
    err: String,
}

fn parse_options(args: &[String]) -> Result<Options> {
    let mut i : usize = 0;
    let mut opts = Options {
        out_dir: String::from("/etc/nixos"),
        root_dir: String::from("/"),
        force: false,
        no_filesystems: false,
        show_hardware_config: false,
        show_help: false,
    };
    loop {
        if i >= args.len() {
            return Ok(opts)
        }
        match args[i].as_ref() {
            "-h"|"--help" => {
                opts.show_help = true;
                return Ok(opts)
            }
            "--dir" => {
                i += 1;
                if i >= args.len() {
                    bail!("'--dir' requires an argument");
                }
                opts.out_dir = args[i].clone();
            }
            "--root" => {
                i += 1;
                if i >= args.len() {
                    bail!("'--root' requires an argument");
                }
                opts.root_dir = args[i].clone();
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

fn show_help(app_name: &str) -> Result<()> {
    let status = try_with!(Command::new(MAN_EXECUTABLE)
        .arg("nixos-generate-config")
        .env("MANPATH", NIXOS_MANPAGES)
        .status(), "{}: failed to open man page", app_name);
    match status.code() {
        Some(0) => {},
        Some(code) => {
            bail!("{}: man exited with {}", app_name, code);
        },
        None => {
            bail!("{}: man was killed by signal", app_name);
        }
    };
    Ok(())
}


pub fn run_app(args: &[String]) -> i32 {
    let default_name: String = String::from("nixos-generate-config");
    let app_name = args.get(0).unwrap_or(&default_name);
    let opts = match parse_options(&args[1..]) {
        Ok(opts) => opts,
        Err(err) => {
            eprintln!("{}: {}", app_name, err);
            return 1;
        }
    };
    if opts.show_help {
        if let Err(err) = show_help(app_name) {
            eprintln!("{}: {}", app_name, err);
            return 1;
        }
        return 0;
    }
    return 0;
}
