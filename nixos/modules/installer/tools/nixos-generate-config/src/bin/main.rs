use nixos_generate_config::run_app;
use std::env;
use std::process::exit;

pub fn main() {
    let args: Vec<_> = env::args().collect();
    exit(run_app(&args))
}
