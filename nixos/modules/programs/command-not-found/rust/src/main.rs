use rusqlite::{params, Connection, Result};
use std::env;
use std::process::exit;

const NIX_SYSTEM: &str = env!("NIX_SYSTEM");
const DB_PATH: &str = env!("DB_PATH");

fn query_packages(system: &str, program: &str) -> Result<Vec<String>> {
    Connection::open(DB_PATH)?
        .prepare("select package from Programs where system = ? and name = ?;")?
        .query_map(params![system, program], |row| row.get("package"))?
        .collect::<Result<Vec<String>>>()
}

fn run_app() -> i32 {
    let args: Vec<_> = env::args().collect();
    if args.len() < 2 {
        eprintln!("USAGE: {} PROGRAMNAME", args[0]);
        return 1;
    }
    let program = &args[1];
    let system = env::var("NIX_SYSTEM").unwrap_or_else(|_| NIX_SYSTEM.to_string());
    let packages = match query_packages(&system, program) {
        Ok(packages) => packages,
        Err(err) => {
            eprintln!("Failed to query package database: {}", err);
            return 1;
        }
    };
    if packages.is_empty() {
        eprintln!("{}: command not found", program);
    } else {
        let advice = if packages.len() > 1 {
            "It is provided by several packages. You can install it by typing one of the following commands:"
        } else {
            "You can install it by typing:"
        };
        eprintln!(
            "The program '{}' is currently not installed. {}",
            program, advice
        );
        for pkg in packages {
            eprintln!("  nix-env -iA nixos.{}", pkg);
        }
    }

    127
}

fn main() {
    exit(run_app());
}
