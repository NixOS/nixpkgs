use log::{Log, Metadata, Record, Level, LevelFilter, SetLoggerError};

use std::backtrace::Backtrace;
use std::ffi::OsStr;
use std::io::{self, BufRead, BufReader, Read, Write};
use std::os::unix::process::CommandExt;
use std::panic;
use std::process::{Command, ExitStatus, Stdio};
use std::thread::{self, JoinHandle};

use syslog::{BasicLogger, Facility, Formatter3164};

struct ResilientLogger {
    syslog: BasicLogger,
}

impl Log for ResilientLogger {
    fn enabled(&self, _: &Metadata) -> bool {
        true
    }
    fn log(&self, record: &Record) {
        self.syslog.log(record);
        if record.level() <= Level::Warn {
            let _ = writeln!(io::stderr(), "{}", record.args());
        } else {
            let _ = writeln!(io::stdout(), "{}", record.args());
        }
    }
    fn flush(&self) {
        // Intentionally ignore errors here
        let _ = io::stdout().flush();
        let _ = io::stderr().flush();
    }
}

pub fn init(log_level: LevelFilter) -> Result<(), SetLoggerError> {
    log::set_max_level(log_level);
    let formatter = Formatter3164 {
        facility: Facility::LOG_USER,
        hostname: None,
        process: "nixos".into(),
        pid: 0,
    };
    let syslog_logger = syslog::unix(formatter).expect("nope");
    let resilient_logger = ResilientLogger {
      syslog: BasicLogger::new(syslog_logger)
    };
    log::set_boxed_logger(Box::new(resilient_logger))?;

    panic::set_hook(Box::new(|panic_info| {
        let backtrace = Backtrace::force_capture();
        log::error!("panic occurred: {panic_info}\n{backtrace}");
    }));

    Ok(())
}

pub struct LoggedCommand(Command);

impl LoggedCommand {
    pub fn new<S: AsRef<OsStr>>(program: S) -> Self {
        let mut cmd = Command::new(program);
        cmd.stdout(Stdio::piped())
           .stderr(Stdio::piped());
        Self(cmd)
    }

    pub fn arg<S: AsRef<OsStr>>(mut self, arg: S) -> Self {
        self.0.arg(arg);
        self
    }

    pub fn args<I, S>(mut self, args: I) -> Self
    where
        I: IntoIterator<Item = S>,
        S: AsRef<OsStr>,
    {
        self.0.args(args);
        self
    }

    pub fn uid(mut self, id: u32) -> Self {
        self.0.uid(id);
        self
    }

    pub fn gid(mut self, id: u32) -> Self {
        self.0.gid(id);
        self
    }

    pub fn env_clear(mut self) -> Self {
        self.0.env_clear();
        self
    }

    pub fn env<K, V>(mut self, key: K, val: V) -> Self
    where
        K: AsRef<OsStr>,
        V: AsRef<OsStr>,
    {
        self.0.env(key, val);
        self
    }

    fn pipe_to(fd: impl Read + Send + 'static, level: Level) -> JoinHandle<()> {
        let reader = BufReader::new(fd);
        thread::spawn(move || {
            // Intentionally ignore errors here
            for line in reader.lines().map_while(Result::ok) {
                log::log!(level, "{}", line)
            }
        })
    }

    pub fn spawn_and_wait(mut self) -> std::io::Result<ExitStatus> {
        let mut child = self.0.spawn()?;
        let out = Self::pipe_to(child.stdout.take().unwrap(), Level::Info);
        let err = Self::pipe_to(child.stderr.take().unwrap(), Level::Warn);

        // Intentionally ignore errors here
        let _ = out.join();
        let _ = err.join();

        child.wait()
    }
}
