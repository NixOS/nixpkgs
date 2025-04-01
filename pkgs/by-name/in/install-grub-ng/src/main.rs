mod builder;
mod config;
mod grub;

use std::path::Path;

use eyre::{Context, Result, bail};

use crate::{builder::Builder, config::Config};

fn main() -> Result<()> {
	let mut args = std::env::args().skip(1);
	let Some(config_file) = args.next() else {
		bail!("Missing first argument: should be path to config file")
	};
	let Some(default_config) = args.next() else {
		bail!("Missing second argument: should be path to default config")
	};

	let config_file = std::fs::read_to_string(config_file).context("While reading config file")?;
	let config: Config = serde_json::from_str(&config_file).context("While parsing config file")?;

	eprintln!("updating GRUB 2 menu...");

	// TODO: move to wrapper
	std::env::set_var("PATH", config.path);

	Builder::new(config, Path::new(&default_config))
		.context("While initializing builder")?
		.users()
		.context("While writing user configs")?
		.default_entry()
		.context("While writing default entries")?
		.appearance()
		.context("While writing appearance settings")?
		.entries()
		.context("While writing entries")?
		.install()
		.context("While installing GRUB")?;

	Ok(())
}
