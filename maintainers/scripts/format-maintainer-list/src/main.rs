#![warn(clippy::pedantic)]

use serde::Deserialize;
use std::{
    collections::HashMap,
    env,
    fmt::Debug,
    process::{Command, ExitCode},
};

#[derive(Debug, Deserialize)]
struct Maintainer {
    name: String,
    email: String,
    matrix: Option<String>,
    github: Option<String>,
    #[serde(rename = "githubId")]
    github_id: Option<u64>,
    keys: Option<Vec<Key>>,
}

#[derive(Debug, Deserialize)]
struct Key {
    fingerprint: String,
}

fn print_key_value(key: &str, value: impl Debug) {
    println!("    {key} = {value:?};");
}

fn print_optional_key_value(key: &str, value: Option<impl Debug>) {
    if let Some(v) = value {
        print_key_value(key, v);
    }
}

const PRELUDE: &str = r#"/* List of NixOS maintainers.
    ```nix
    handle = {
      # Required
      name = "Your name";
      email = "address@example.org";

      # Optional
      matrix = "@user:example.org";
      github = "GithubUsername";
      githubId = your-github-id;
      keys = [{
        fingerprint = "AAAA BBBB CCCC DDDD EEEE  FFFF 0000 1111 2222 3333";
      }];
    };
    ```

    where

    - `handle` is the handle you are going to use in nixpkgs expressions,
    - `name` is your, preferably real, name,
    - `email` is your maintainer email address,
    - `matrix` is your Matrix user ID,
    - `github` is your GitHub handle (as it appears in the URL of your profile page, `https://github.com/<userhandle>`),
    - `githubId` is your GitHub user ID, which can be found at `https://api.github.com/users/<userhandle>`,
    - `keys` is a list of your PGP/GPG key fingerprints.

    `handle == github` is strongly preferred whenever `github` is an acceptable attribute name and is short and convenient.

    If `github` begins with a numeral, `handle` should be prefixed with an underscore.
    ```nix
    _1example = {
      github = "1example";
    };
    ```

    Add PGP/GPG keys only if you actually use them to sign commits and/or mail.

    To get the required PGP/GPG values for a key run
    ```shell
    gpg --fingerprint <email> | head -n 2
    ```

    !!! Note that PGP/GPG values stored here are for informational purposes only, don't use this file as a source of truth.

    More fields may be added in the future, however, in order to comply with GDPR this file should stay as minimal as possible.

    When editing this file:
     * keep the list alphabetically sorted
     * test the validity of the format with:
         nix-build lib/tests/maintainers.nix

    See `./scripts/check-maintainer-github-handles.sh` for an example on how to work with this data.
*/"#;

fn main() -> ExitCode {
    let mut list: Vec<_> = serde_json::from_slice::<HashMap<String, Maintainer>>(
        &Command::new("nix")
            .args(["eval", "--json", "-f"])
            .arg(env::args().nth(1).unwrap())
            .output()
            .unwrap()
            .stdout,
    )
    .unwrap()
    .into_iter()
    .collect();

    list.sort_by_cached_key(|m| m.0.to_lowercase());

    println!("{PRELUDE}");

    println!("{{");

    for (name, info) in list {
        if info.github.is_some() ^ info.github_id.is_some() {
            eprintln!("ERROR: {name} only has one of github and githubId, when both are required.");
            return ExitCode::FAILURE;
        }

        println!("  {name} = {{");

        print_key_value("name", info.name);
        print_key_value("email", info.email);

        println!();

        print_optional_key_value("matrix", info.matrix);
        print_optional_key_value("github", info.github);
        print_optional_key_value("githubId", info.github_id);

        if let Some(keys) = info.keys {
            print!("    keys = [");

            // We could probably just run this through nixpkgs-fmt instead?
            if keys.len() == 1 {
                println!("{{");
                println!("      fingerprint = {:?};", keys[0].fingerprint);
                println!("    }}];");
            } else {
                for key in keys {
                    println!("\n      {{");
                    println!("        fingerprint = {:?};", key.fingerprint);
                    println!("      }}");
                }

                println!("    ];");
            }
        }

        println!("  }};");
    }

    println!("}}");

    ExitCode::SUCCESS
}
