use std::error;
use std::io;
use std::io::Write;
use std::process::Command;

use simple_error::{bail, try_with};

const MAN_EXECUTABLE: &str = env!("MAN_EXECUTABLE");
const NIXOS_MANPAGES: &str = env!("NIXOS_MANPAGES");

type Result<T> = std::result::Result<T, Box<dyn error::Error>>;

struct Options {
    out_dir: String,
    root_dir: String,
    force: bool,
    no_filesystems: bool,
    show_hardware_config: bool,
    show_help: bool,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Error {
    err: String,
}

fn parse_options(args: &[String]) -> Result<Options> {
    let mut i: usize = 0;
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

    0
}
