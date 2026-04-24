use std::{
    collections::{BTreeMap, BTreeSet},
    io::Write,
    path::PathBuf,
};

use clap::{ArgAction, arg, value_parser};
use walkdir::{DirEntry, WalkDir};

fn cli() -> clap::Command {
    clap::Command::new("patch-electron")
        .version(env!("CARGO_PKG_VERSION"))
        .about("Patch Electron packages in Nixpkgs. Does not follow symlinks, and does not canonicalize paths")
        .arg(
            arg!([PATHS] "Paths to operate upon")
                .value_parser(value_parser!(PathBuf))
                .trailing_var_arg(true)
                .allow_hyphen_values(true)
                .num_args(1..)
                .required(true)
                .action(ArgAction::Append),
        )
        .arg(
            arg!(--ignore "Paths to ignore for substitution")
                .value_parser(value_parser!(PathBuf))
                .num_args(1..)
                .action(ArgAction::Append),
        )
        .arg(
            arg!(--symlink "Symlink duplicated files rather than delete them").action(ArgAction::SetTrue)
        )
        .arg(
            arg!(--electron "Path to the Electron path to substitute from")
                .value_parser(value_parser!(PathBuf))
                .action(ArgAction::Set)
        )
}

fn main() {
    let mut stdout = std::io::stdout().lock();

    let matches = cli().get_matches();

    let cwd = std::env::current_dir().expect("Unable to get $CWD");
    let _ = writeln!(stdout, "CWD: {}", cwd.display());

    // Collect all the paths to search and rm/symlink.
    // There must be at least one.
    //
    // If it is relative, make it relative to the CWD
    let to_search = matches
        .get_many::<PathBuf>("PATHS")
        .expect("At least one path to substitute is required")
        // If a relative path, do relative to CWD
        .map(|path| cwd.join(path))
        .collect::<Vec<_>>();
    let _ = writeln!(stdout, "Searching: {:#?}", to_search);


    // Collect all the paths to remove from searching.
    // There can be zero.
    //
    // If it is relative, make it relative to the CWD
    let to_ignore = matches
        .get_many::<PathBuf>("ignore")
        .iter_mut()
        .flatten()
        // If a relative path, do relative to CWD
        .map(|path| cwd.join(path))
        .collect::<Vec<_>>();
    let _ = writeln!(stdout, "Ignoring: {:#?}", to_ignore);

    // Collect a set of all the search paths by recursively
    // walking all the paths.
    let search_paths = BTreeSet::from_iter(
        to_search
            .into_iter()
            .map(WalkDir::new)
            .flatten()
            .map(|v| v.expect("Error while walking search path"))
            .map(DirEntry::into_path),
    );

    // Collect all the ignore paths
    let ignore_paths = BTreeSet::from_iter(
        to_ignore
            .into_iter()
            .map(WalkDir::new)
            .flatten()
            .map(|v| v.expect("Error while walking ignore paths"))
            .map(DirEntry::into_path),
    );

    // The total paths are the search paths minus the ignore paths
    let total_paths = search_paths.difference(&ignore_paths);

    // Collect all the files from the electron pacakge
    // We don't symlink directories, so only look at the leaf
    // files.
    let _ = writeln!(stdout, "Electron: {:#?}", matches.get_one::<PathBuf>("electron").unwrap());
    let electron_paths = BTreeMap::from_iter(
        WalkDir::new(
            matches
                .get_one::<PathBuf>("electron")
                .expect("Must supply a path of an electron pacakge to search"),
        )
        .follow_links(true)
        .into_iter()
        .map(|path| path.expect("Error while walking Electron package directory"))
        .filter(|path| path.file_type().is_file())
        .map(|path| (path.file_name().to_os_string(), path.into_path())),
    );

    // Lazily report errors so that we can report all possible errors at once
    let mut failures = Vec::new();

    // Look at each path
    for path in total_paths {
        if !path.is_file() || path.is_symlink() {
            // Ignore directories and symlinks
            continue;
        }

        // If the name matches a name in the electron package, handle it.
        if let Some(elec_path) = electron_paths.get(path.file_name().unwrap()) {
            let _ = writeln!(stdout, "Removing: {:#?}", path);
            // Always just remove the path first, though if we fail at rming, don't try to symlink
            if let Err(err) = std::fs::remove_file(path) {
                failures.push(format!(
                    "Failed to remove file `{}` because of:\n{:#?}",
                    path.display(),
                    err
                ));
                continue;
            }

            if matches.get_flag("symlink") {
                if let Err(err) = std::os::unix::fs::symlink(elec_path, path) {
                    failures.push(format!(
                        "Failed to symlink file `{}` because of:\n{:#?}",
                        path.display(),
                        err
                    ))
                }
            }
        }
    }

    if failures.len() > 0 {

        let _ = writeln!(stdout, "Failed to remove and/or symlink files");
        for error in failures.iter().map(|string| string.lines()).flatten() {
            // Give the errors a slight amount of indentation for nicer formatting
            let _ = writeln!(stdout, "  {error}");
        }

        std::process::exit(2);
    }
}
