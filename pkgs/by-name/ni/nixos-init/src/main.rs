use std::{env, io::Write, process::ExitCode};

use log::{Level, LevelFilter};

use nixos_init::{chroot_realpath, find_etc, initrd_init};

fn main() -> ExitCode {
    let arg0 = env::args()
        .next()
        .and_then(|c| c.split('/').next_back().map(std::borrow::ToOwned::to_owned))
        .expect("Failed to retrieve name of binary");

    setup_logger();
    let entrypoint = match arg0.as_str() {
        "find-etc" => find_etc,
        "chroot-realpath" => chroot_realpath,
        "initrd-init" => initrd_init,
        _ => {
            log::error!("Command {arg0} unknown");
            return ExitCode::FAILURE;
        }
    };

    match entrypoint() {
        Ok(()) => ExitCode::SUCCESS,
        Err(err) => {
            log::error!("{err:#}.");
            ExitCode::FAILURE
        }
    }
}

// Setup the logger to use the kernel's `printk()` scheme.
//
// This way, systemd can interpret the levels correctly.
fn setup_logger() {
    env_logger::builder()
        .format(|buf, record| {
            writeln!(
                buf,
                "<{}>{}",
                match record.level() {
                    Level::Error => 3,
                    Level::Warn => 4,
                    Level::Info => 6,
                    Level::Debug | Level::Trace => 7,
                },
                record.args()
            )
        })
        .filter(None, LevelFilter::Info)
        .init();
}
