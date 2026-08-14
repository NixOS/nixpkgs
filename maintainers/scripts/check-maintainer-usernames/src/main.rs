use std::{env, error::Error, io::{self, Write}};

use tokio::fs;

#[tokio::main]
async fn main() {
    real_main().await.unwrap();
}

async fn real_main() -> Result<(), Box<dyn Error>> {
    let gh = octocrab::OctocrabBuilder::default()
        .personal_token(env::var("GITHUB_PAT").expect("no GITHUB_PAT configured"))
        .build()?;

    // first run: nix-instantiate -A lib.maintainers --eval --strict --json > maintainers.json
    let data: serde_json::Value = serde_json::from_str(&fs::read_to_string("maintainers.json").await?)?;

    let data = data.as_object().unwrap();
    let total = data.len();
    for (i, (maintainer_name, v)) in data.iter().enumerate() {
        print!("\r{i}/{total}");
        io::stdout().flush()?;
        let Some(github_id) = v.get("githubId") else {
            println!("\rWARN: no id for {maintainer_name}");
            continue;
        };
        let Some(github) = v.get("github") else {
            println!("\rWARN: no username for {maintainer_name}");
            continue;
        };
        let Ok(name) = gh.users_by_id(github_id.as_u64().unwrap()).profile().await else {
            println!("\rWARN: error fetching {maintainer_name}");
            continue;
        };
        let name = name.login;
        if name.to_ascii_lowercase() != github.as_str().unwrap().to_ascii_lowercase() {
            println!("\rERR: {maintainer_name} has github = {github}, but username really is '{name}'");
        }
    }

    Ok(())
}
