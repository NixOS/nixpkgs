#![warn(clippy::pedantic)]

use anyhow::anyhow;
use rayon::prelude::*;
use std::{env, fs, path::Path, process};
use tempfile::tempdir;

mod parse;
mod util;

fn main() -> anyhow::Result<()> {
    env_logger::init();

    let args = env::args().collect::<Vec<_>>();

    if args.len() < 2 {
        println!("usage: {} <path/to/yarn.lock>", args[0]);
        println!();
        println!("Prefetches yarn dependencies for usage by fetchYarnDeps.");

        process::exit(1);
    }

    if let Ok(jobs) = env::var("NIX_BUILD_CORES") {
        if !jobs.is_empty() {
            rayon::ThreadPoolBuilder::new()
                .num_threads(
                    jobs.parse()
                        .expect("NIX_BUILD_CORES must be a whole number"),
                )
                .build_global()
                .unwrap();
        }
    }

    let lock_content = fs::read_to_string(&args[1])?;

    let out_tempdir;

    let (out, print_hash) = if let Some(path) = args.get(2) {
        let dir = Path::new(path);
        fs::create_dir_all(dir)?;

        (dir, false)
    } else {
        out_tempdir = tempdir()?;

        (out_tempdir.path(), true)
    };

    let packages = parse::lockfile(&lock_content, env::var("FORCE_EMPTY_CACHE").is_ok())?;

    packages.into_par_iter().try_for_each(|package| {
        let filename = &package.tarball_filename;
        let tarball = package
            .tarball()
            .map_err(|e| anyhow!("couldn't fetch {} at {}: {e:?}", package.name, package.url))?;

        fs::write(out.join(filename), &tarball)?;

        Ok::<_, anyhow::Error>(())
    })?;

    fs::write(out.join("yarn.lock"), lock_content)?;

    if print_hash {
        println!("{}", util::make_sri_hash(out)?);
    }

    Ok(())
}
