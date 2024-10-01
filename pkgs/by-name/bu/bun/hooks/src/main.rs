// FIX 1: Removed `io::Bytes` from the import list
use std::{env, fs, path::Path, process};

#[derive(Debug)]
enum LockContent {
    Text(String),
    Binary(Vec<u8>),
}

fn main() -> anyhow::Result<()>{
    env_logger::init();

    let args = env::args().collect::<Vec<_>>();

    if args.len() < 2 {
        println!("usage: {} <path/to/bun.lock*>", args[0]);
        println!();
        println!("Prefetches bun dependencies for usage by bun.fetchDeps.");

        process::exit(1);
    }

    if let Ok(jobs) = env::var("NIX_BUILD_CORES")
        && !jobs.is_empty()
    {
        rayon::ThreadPoolBuilder::new()
            .num_threads(
                jobs.parse()
                    .expect("NIX_BUILD_CORES must be a whole number"),
            )
            .build_global()
            .unwrap();
    }

    let path = Path::new(&args[1]);
    let is_binary = path
        .extension()
        .map(|ext| ext == "lockb")
        .unwrap_or(false);

    let bytes = fs::read(path)?;
    let lock_content: LockContent = if is_binary {
        LockContent::Binary(bytes)
    } else {
        LockContent::Text(String::from_utf8_lossy(&bytes).into_owned())
    };

    println!("{lock_content:?}");

    Ok(())
}
