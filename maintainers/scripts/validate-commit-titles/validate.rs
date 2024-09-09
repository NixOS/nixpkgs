#!/usr/bin/env nix-shell
//! ```cargo
//! [dependencies]
//! regex = "1"
//! ```

use std::{fs::read_to_string, process::{Command, Stdio, ExitCode}};
use regex::Regex;
/*
#!nix-shell -i rust-script -p rustc -p rust-script -p cargo -p gh -p jq --
*/

fn validate(titles: Vec<&str>) -> bool {
    let re = Regex::new(r"^[^{]+:.+$").unwrap();
    let mut invalid_titles_found = false;
    for title in titles {
        if !re.is_match(title) {
            invalid_titles_found = true;
            eprintln!("title '{}' is not valid", title);
        }
    }
    return invalid_titles_found
}

fn main() -> ExitCode {

    let commits = Command::new("gh")
        .args(["pr", "view", "--json", "commits" ])
        .stdout(Stdio::piped())
        .spawn()
        .unwrap();

    let stdout = Command::new("jq")
        .args([ ".[] | .[].messageHeadline", "--raw-output" ])
        .stdin(Stdio::from(commits.stdout.unwrap()))
        .output()
        .unwrap()
        .stdout;

    let binding = String::from_utf8(stdout).unwrap();
    let titles = binding.split_terminator("\n").collect();

    let invalid_titles_found = validate(titles);

    if invalid_titles_found {
        return ExitCode::FAILURE;
    }

    return ExitCode::SUCCESS;

}

#[test]
fn check_validate() {
    let valid_file = read_to_string("./titles-valid.txt").expect("couldn't read titles-valid.txt");
    let invalid_file = read_to_string("./titles-invalid.txt").expect("couldn't read titles-invalid.txt");

    let mut combined: String = valid_file.to_owned();
    combined.push_str(&invalid_file);

    validate(combined.split_terminator("\n").collect())

}
// vim: ft=rust
