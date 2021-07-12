use nixos_generate_config::run_app;

pub fn main() {
    let args: Vec<String> = std::env::args().collect();

    std::process::exit(run_app(&args))
}
