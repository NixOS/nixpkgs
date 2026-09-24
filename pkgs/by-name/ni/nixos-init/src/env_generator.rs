use std::{
    collections::HashMap,
    fs,
    io::{self, Write},
};

use anyhow::{Context, Result};
use serde::Deserialize;

const CONFIG_PATH: &str = "/etc/systemd/generator-environment.json";
const KMSG_PATH: &str = "/dev/kmsg";

#[derive(Deserialize)]
struct Config(HashMap<String, String>);

/// Implementation for the entrypoint of the `env-generator` binary.
///
/// Reads the JSON config for the systemd generator environment and prints it in KEY=VALUE format
/// to stdout. This makes the configured environment variables available for all systemd
/// generators.
///
/// In case of the PATH variable, it extends the PATH read from the environment with the one from
/// the config.
fn env_generator_impl() -> Result<()> {
    let content = fs::read(CONFIG_PATH).with_context(|| format!("Failed to read {CONFIG_PATH}"))?;
    let config: Config = serde_json::from_slice(&content).context("Failed to parse config")?;

    let mut buffer = Vec::new();
    for (key, mut value) in config.0 {
        // If the config contains the PATH env variable, read the current PATH and extend it with
        // the one from the config.
        if key == "PATH"
            && let Some(current_path) = std::env::var("PATH").ok()
        {
            value.push(':');
            value.push_str(&current_path);
        }
        writeln!(&mut buffer, "{key}=\"{value}\"").context("Failed to write to buffer")?;
    }

    let stdout = io::stdout();
    let mut locked = stdout.lock();
    locked
        .write_all(&buffer)
        .context("Failed to write to stdout")?;

    Ok(())
}

/// Entrypoint for the `env-generator` binary.
///
/// Generators cannot use normal logging but have to write to /dev/kmsg.
///
/// The return value is just here so that we can use the `main.rs` entrypoint for this binary.
/// Errors returned from this function will not be logged and thus are meaningless.
pub fn env_generator() -> Result<()> {
    if let Err(err) = env_generator_impl() {
        // Sometimes we do not have /dev/kmsg, e.g. inside a container
        if let Ok(mut kmsg) = fs::OpenOptions::new().write(true).open(KMSG_PATH) {
            let _ = write!(kmsg, "<3>env-generator: {err:#}");
        }
    }
    Ok(())
}
