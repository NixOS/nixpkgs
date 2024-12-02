use std::env;
use std::io::{stdout, Error, ErrorKind, Write};
use std::os::unix::ffi::OsStrExt;
use std::os::unix::fs;

fn main() -> std::io::Result<()> {
    let args: Vec<String> = env::args().collect();

    if args.len() != 3 {
        return Err(Error::new(
            ErrorKind::InvalidInput,
            format!("Usage: {} <chroot> <path>", args[0]),
        ));
    }

    fs::chroot(&args[1])?;
    std::env::set_current_dir("/")?;

    let path = std::fs::canonicalize(&args[2])?;

    stdout().write_all(path.into_os_string().as_bytes())?;

    Ok(())
}
