mod builder;
mod config;
mod grub;

use std::path::Path;

use eyre::{bail, Result};
use roxmltree::Document;

use crate::{builder::Builder, config::Config};

fn main() -> Result<()> {
	let mut args = std::env::args();
	let Some(config_file) = args.nth(1) else {
		bail!("Config file not given: expected it to be the first argument")
	};
	let Some(default_config) = args.next() else {
		bail!("Default config not given: expected it to be the second argument")
	};

	let document_file = std::fs::read_to_string(config_file)?;
	let document = Document::parse(&document_file)?;

	let config = Config::new(&document)?;

	eprintln!("updating GRUB 2 menu...");

	std::env::set_var("PATH", config.path);

	Builder::new(config, Path::new(&default_config))?
		.users()?
		.default_entry()?
		.appearance()?
		.entries()?
		.install()?;

	Ok(())
}
