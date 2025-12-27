/// cli entrypoint for the vendor file structure transformer
/// this just acts as a wrapper around the `deno_cache_di` rust crate from deno upstream
/// see readme.md -> "Vendor Directory"
/// see readme.md -> "Architecture"
use std::{
    collections::HashMap,
    fs::{self, File},
    path::{Path, PathBuf},
    rc::Rc,
};

use anyhow::{Context, Result};
use clap::Parser;
use deno_cache_dir::{GlobalHttpCache, GlobalToLocalCopy, HttpCache, LocalHttpCache};
use serde::Deserialize;
use sys_traits::impls::RealSys;
use url::Url;

#[derive(Debug, Deserialize)]
#[serde(rename_all(deserialize = "camelCase"))]
struct CommonLockFormatOut {
    url: String,
    out_path: PathBuf,
    headers: Option<HashMap<String, String>>,
    //hash: String,
    //hashAlgo: String,
    //meta: Option<Value>,
}

#[derive(Parser, Debug)]
#[command(version, about)]
struct Args {
    #[arg(short, long)]
    common_lock_jsr_path: PathBuf,
    #[arg(short, long)]
    common_lock_https_path: PathBuf,
    #[arg(short, long)]
    deno_dir_path: PathBuf,
    #[arg(short, long)]
    vendor_dir_path: PathBuf,
    #[arg(short, long, default_value_t=String::from("https://jsr.io/"))]
    jsr_registry_url: String,
}

fn add_common_lock_to_cache(
    common_lock: Vec<CommonLockFormatOut>,
    base_path: &Path,
    cache: &LocalHttpCache<RealSys>,
) -> Result<(), anyhow::Error> {
    for package_file in common_lock {
        let content = fs::read(base_path.join(&package_file.out_path))
            .with_context(|| format!("failed to read file {}", package_file.out_path.display()))?;
        let url = Url::parse(&package_file.url)
            .with_context(|| format!("failed to parse URL {}", package_file.url))?;

        cache
            .set(&url, package_file.headers.unwrap_or_default(), &content)
            .with_context(|| format!("failed to set URL {} in local cache", package_file.url))?;
    }
    Ok(())
}

fn read_common_lock(common_lock_path: &PathBuf) -> Result<Vec<CommonLockFormatOut>, anyhow::Error> {
    let mut common_lock_jsr_file =
        File::open(common_lock_path).context("failed to open URL file map")?;
    let common_lock: Vec<CommonLockFormatOut> =
        serde_json::from_reader(&mut common_lock_jsr_file).context("failed to parse URL map")?;
    Ok(common_lock)
}

fn main() -> Result<()> {
    let args = Args::parse();

    let sys = RealSys;
    let global_cache = Rc::new(GlobalHttpCache::new(sys, args.deno_dir_path));
    let jsr_registry_url = &args.jsr_registry_url;
    let cache = LocalHttpCache::new(
        args.vendor_dir_path,
        global_cache.clone(),
        GlobalToLocalCopy::Allow,
        Url::parse(jsr_registry_url).unwrap(),
    );

    let common_lock_jsr: Vec<CommonLockFormatOut> = read_common_lock(&args.common_lock_jsr_path)?;
    let base_path = args
        .common_lock_jsr_path
        .parent()
        .context("failed to get base path for common_lock_jsr_path")
        .unwrap();
    add_common_lock_to_cache(common_lock_jsr, base_path, &cache)?;

    let common_lock_https: Vec<CommonLockFormatOut> =
        read_common_lock(&args.common_lock_https_path)?;
    let base_path = args
        .common_lock_https_path
        .parent()
        .context("failed to get base path for common_lock_https_path")
        .unwrap();
    add_common_lock_to_cache(common_lock_https, base_path, &cache)?;

    Ok(())
}
