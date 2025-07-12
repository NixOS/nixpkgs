use std::{
    collections::HashMap,
    fs::{self, File},
    path::PathBuf,
    rc::Rc,
};

use anyhow::{Context, Result};
use clap::Parser;
use deno_cache_dir::{GlobalHttpCache, GlobalToLocalCopy, HttpCache, LocalHttpCache};
use serde::Deserialize;
use sys_traits::impls::RealSys;
use url::Url;

#[derive(Debug, Deserialize)]
struct UrlFile {
    url: String,
    out_path: PathBuf,
    headers: Option<HashMap<String, String>>,
}

#[derive(Parser, Debug)]
#[command(version, about)]
struct Args {
    #[arg(short, long)]
    url_file_map: PathBuf,
    #[arg(short, long)]
    cache_path: PathBuf,
    #[arg(short, long)]
    vendor_path: PathBuf,
}

fn main() -> Result<()> {
    let args = Args::parse();

    let mut url_file = File::open(args.url_file_map).context("failed to open URL file map")?;
    let files: Vec<UrlFile> =
        serde_json::from_reader(&mut url_file).context("failed to parse URL map")?;

    let sys = RealSys;
    let global_cache = Rc::new(GlobalHttpCache::new(sys, args.cache_path));
    let cache = LocalHttpCache::new(
        args.vendor_path,
        global_cache.clone(),
        GlobalToLocalCopy::Allow,
        Url::parse("https://jsr.io/").unwrap(),
    );

    for file in files {
        let content = fs::read(&file.out_path)
            .with_context(|| format!("failed to read file {}", file.out_path.display()))?;
        let url =
            Url::parse(&file.url).with_context(|| format!("failed to parse URL {}", file.url))?;

        cache
            .set(&url, file.headers.unwrap_or_default(), &content)
            .with_context(|| format!("failed to set URL {} in local cache", file.url))?;
    }

    Ok(())
}
