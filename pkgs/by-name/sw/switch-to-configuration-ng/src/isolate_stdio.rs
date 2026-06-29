// Wrap writing to stdout and stderr so that write failures
// do not cause Rust panic. A switch may temporarily break
// the connection over which it was initiated, and in that
// case we want the switch to continue, not abort.
// Such a scenario is tested in
// nixosTests.nixos-rebuild-target-host-interrupted

use nix::unistd;
use std::fs::File;
use std::io::{self, Error, PipeReader, Read, Write};
use std::os::fd::AsRawFd;
use std::thread::{self, JoinHandle};

fn pipe(mut reader: PipeReader, mut dest: File) -> JoinHandle<Result<(), Error>> {
    thread::spawn(move || -> io::Result<()> {
        let mut buf = [0u8; 8192];
        loop {
            let n = reader.read(&mut buf)?;
            if n == 0 {
                break;
            }
            if dest.write_all(&buf[..n]).is_err() {
                // Drain and discard the rest
                io::copy(&mut reader, &mut io::sink())?;
                break;
            }
        }
        Ok(())
    })
}

pub fn init() -> Result<(JoinHandle<Result<(), Error>>, JoinHandle<Result<(), Error>>), Error> {
    let (out_reader, out_writer) = io::pipe()?;
    let (err_reader, err_writer) = io::pipe()?;
    let old_stdout = File::from(unistd::dup(io::stdout())?);
    let old_stderr = File::from(unistd::dup(io::stderr())?);
    let out_thread = pipe(out_reader, old_stdout);
    let err_thread = pipe(err_reader, old_stderr);
    unistd::dup2_stdout(out_writer)?;
    unistd::dup2_stderr(err_writer)?;
    Ok((out_thread, err_thread))
}

pub fn close(threads: (JoinHandle<Result<(), std::io::Error>>, JoinHandle<Result<(), Error>>)) {
    let _ = unistd::close(io::stdout().as_raw_fd());
    let _ = unistd::close(io::stderr().as_raw_fd());
    let _ = threads.0.join();
    let _ = threads.1.join();
}
