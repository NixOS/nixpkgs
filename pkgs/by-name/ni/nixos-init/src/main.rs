use std::{env, io::Write, os::fd::AsFd, process::ExitCode};

use log::Level;

use nixos_init::{
    activate_main, clear_etc_opaque, env_generator, find_etc, initrd_init, resolve_in_root,
};

fn main() -> ExitCode {
    let arg0 = env::args()
        .next()
        .and_then(|c| c.split('/').next_back().map(std::borrow::ToOwned::to_owned))
        .expect("Failed to retrieve name of binary");

    setup_logger();
    let entrypoint = match arg0.as_str() {
        "activate" => activate_main,
        "clear-etc-opaque" => clear_etc_opaque,
        "find-etc" => find_etc,
        "resolve-in-root" => resolve_in_root,
        "initrd-init" => initrd_init,
        "env-generator" => env_generator,
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

// Setup the logger.
//
// When stderr is connected to the journal, use the kernel `printk()` scheme
// so systemd can interpret the levels. Otherwise (interactive switch, plain
// terminal) use a plain format without the `<N>` prefix.
fn setup_logger() {
    let env = env_logger::Env::default().filter_or("LOG_LEVEL", "info");
    let to_journal = stderr_is_journal();

    env_logger::Builder::from_env(env)
        .format(move |buf, record| {
            if to_journal {
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
            } else {
                writeln!(buf, "{}", record.args())
            }
        })
        .init();
}

// Check whether stderr is connected to the systemd journal.
//
// Per systemd.exec(5), $JOURNAL_STREAM holds the dev:ino of the journal
// stream and must be compared against stderr's actual dev:ino, since the
// variable is inherited across exec.
fn stderr_is_journal() -> bool {
    let Ok(var) = env::var("JOURNAL_STREAM") else {
        return false;
    };
    let Some((dev, ino)) = var.split_once(':') else {
        return false;
    };
    let (Ok(dev), Ok(ino)) = (dev.parse::<u64>(), ino.parse::<u64>()) else {
        return false;
    };
    rustix::fs::fstat(std::io::stderr().as_fd()).is_ok_and(|s| s.st_dev == dev && s.st_ino == ino)
}
