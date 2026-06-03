use std::{fs::{self, File, OpenOptions}, io::{BufRead, BufReader, ErrorKind}, os::unix::process::CommandExt, path::{Path, PathBuf}, process::Command};

use anyhow::{Context, Result};
use clap::Parser;
use nix::{mount::{MsFlags, mount}};

#[derive(Parser, Debug)]
#[command(author, version, about, long_about = None)]
struct Args {
    #[arg(
        short,
        long,
        value_name = "PATH",
        help = "Closure to be mounted from the specified file, one path per line",
    )]
    closure_file: String,

    #[arg(
        short,
        long,
        value_name = "PATH",
        help = "Where to mount the substore",
    )]
    mount_path: PathBuf,

    #[arg(
        short,
        long,
        action = clap::ArgAction::Count,
        help = "Verbose output",
    )]
    verbose: u8,

    #[arg(
        trailing_var_arg = true,
        default_values = ["bash"],
        help = "Command to execute once the substore is mounted",
    )]
    exec_cmd: Vec<String>,
}

fn main() -> Result<()> {
    // TODO: check that we are in a mount namespace or warn/exit (in that case provide a flag to
    // bypass).
    // TODO: allow for non /nix/store nix-stores.
    let args = Args::parse();
    let log_level = match args.verbose {
        0 => log::LevelFilter::Info,
        1 => log::LevelFilter::Debug,
        _ => log::LevelFilter::Trace,
    };

    env_logger::builder()
        .filter_level(log_level)
        .init();

    log::debug!("mouting tmpfs over the substore {:?}", args.mount_path);
    match fs::create_dir(&args.mount_path) {
        Err(e) if e.kind() == ErrorKind::AlreadyExists => Ok(()),
        v => v,
    }.context(format!("failed to create substore dir {:?}", args.mount_path))?;
    mount(Some("tmpfs"), &args.mount_path, Some("tmpfs"), MsFlags::MS_NOSUID | MsFlags::MS_NODEV, None::<&str>)
        .context(format!("failed to mount tmpfs over the substore {:?}", args.mount_path))?;
    log::debug!("tmpfs mounted over the substore");

    log::debug!(
        "parsing closure {:?} and mouting substore at {:?}",
        args.closure_file,
        args.mount_path);

    let file = File::open(&args.closure_file)
        .context(format!("failed to open closure file {:?}", args.closure_file))?;

    let reader = BufReader::new(file);

    for line in reader.lines() {
        let path = PathBuf::from(line.context("failed to read line")?);
        log::trace!("got path {:?} in closure", path);

        path.parent()
            .filter(|&p| p.eq("/nix/store"))
            .context(format!("path {:?} is invalid (not in the /nix/store)", path))?;

        let file_name = path.file_name()
            .context(format!("path {:?} is invalid (failed to get file_name)", path))?;
        let mount_to = args.mount_path.join(file_name);

        log::trace!("mounting {:?} into {:?}", path, mount_to);

        if path.is_dir() {
            fs::create_dir(&mount_to)
                .context(format!("failed to create dir mountpoint {:?}", mount_to))?;
        } else {
            OpenOptions::new()
                .write(true)
                .create(true)
                .open(&mount_to)
                .context(format!("failed to create regular file mountpoint {:?}", mount_to))?;
        }

        mount(Some(&path), &mount_to, None::<&Path>, MsFlags::MS_BIND | MsFlags::MS_RDONLY, None::<&str>)
            .context(format!("failed to mount {:?} into {:?}", path, mount_to))?;
    }
    log::debug!("closure parsed and substore mounted");

    log::debug!("spawning command {:?}", args.exec_cmd);
    let (cmd, cmd_args) = args.exec_cmd.split_at(1);
    let exec_err = Command::new(&cmd[0])
        .args(cmd_args)
        .exec();

    Err(exec_err).context(format!("failed to exec command {:?}", args.exec_cmd))
}
