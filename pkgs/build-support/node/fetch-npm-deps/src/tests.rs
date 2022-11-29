use super::{
    fixup_lockfile, get_hosted_git_url, get_ideal_hash, get_initial_url, to_new_packages,
    OldPackage, Package, UrlOrString,
};
use serde_json::json;
use std::collections::HashMap;
use url::Url;

#[test]
fn hosted_git_urls() {
    for (input, expected) in [
        (
            "git+ssh://git@github.com/castlabs/electron-releases.git#fc5f78d046e8d7cdeb66345a2633c383ab41f525",
            Some("https://codeload.github.com/castlabs/electron-releases/tar.gz/fc5f78d046e8d7cdeb66345a2633c383ab41f525"),
        ),
        (
            "https://user@github.com/foo/bar#fix/bug",
            Some("https://codeload.github.com/foo/bar/tar.gz/fix/bug")
        ),
        (
            "https://github.com/eligrey/classList.js/archive/1.2.20180112.tar.gz",
            None
        ),
        (
            "git+ssh://bitbucket.org/foo/bar#branch",
            Some("https://bitbucket.org/foo/bar/get/branch.tar.gz")
        ),
        (
            "ssh://git@gitlab.com/foo/bar.git#fix/bug",
            Some("https://gitlab.com/foo/bar/repository/archive.tar.gz?ref=fix/bug")
        ),
        (
            "git+ssh://git.sr.ht/~foo/bar#branch",
            Some("https://git.sr.ht/~foo/bar/archive/branch.tar.gz")
        ),
    ] {
        assert_eq!(
            get_hosted_git_url(&Url::parse(input).unwrap()),
            expected.map(|u| Url::parse(u).unwrap())
        );
    }
}

#[test]
fn ideal_hashes() {
    for (input, expected) in [
        ("sha512-foo sha1-bar", Some("sha512-foo")),
        ("sha1-bar md5-foo", Some("sha1-bar")),
        ("sha1-bar", Some("sha1-bar")),
        ("sha512-foo", Some("sha512-foo")),
        ("foo-bar sha1-bar", Some("sha1-bar")),
        ("foo-bar baz-foo", None),
    ] {
        assert_eq!(get_ideal_hash(input).ok(), expected);
    }
}

#[test]
fn git_shorthand_v1() -> anyhow::Result<()> {
    let old = {
        let mut o = HashMap::new();
        o.insert(
            String::from("sqlite3"),
            OldPackage {
                version: UrlOrString::Url(
                    Url::parse(
                        "github:mapbox/node-sqlite3#593c9d498be2510d286349134537e3bf89401c4a",
                    )
                    .unwrap(),
                ),
                bundled: false,
                resolved: None,
                integrity: None,
                dependencies: None,
            },
        );
        o
    };

    let initial_url = get_initial_url()?;

    let new = to_new_packages(old, &initial_url)?;

    assert_eq!(new.len(), 1, "new packages map should contain 1 value");
    assert_eq!(new.into_values().next().unwrap(), Package {
        resolved: Some(UrlOrString::Url(Url::parse("git+ssh://git@github.com/mapbox/node-sqlite3.git#593c9d498be2510d286349134537e3bf89401c4a").unwrap())),
        integrity: None
    });

    Ok(())
}

#[test]
fn lockfile_fixup() -> anyhow::Result<()> {
    let input = json!({
        "lockfileVersion": 2,
        "name": "foo",
        "packages": {
            "": {

            },
            "foo": {
                "resolved": "https://github.com/NixOS/nixpkgs",
                "integrity": "aaa"
            },
            "bar": {
                "resolved": "git+ssh://git@github.com/NixOS/nixpkgs.git",
                "integrity": "bbb"
            }
        }
    });

    let expected = json!({
        "lockfileVersion": 2,
        "name": "foo",
        "packages": {
            "": {

            },
            "foo": {
                "resolved": "https://github.com/NixOS/nixpkgs",
                "integrity": "aaa"
            },
            "bar": {
                "resolved": "git+ssh://git@github.com/NixOS/nixpkgs.git",
            }
        }
    });

    assert_eq!(
        fixup_lockfile(input.as_object().unwrap().clone())?,
        Some(expected.as_object().unwrap().clone())
    );

    assert_eq!(
        fixup_lockfile(json!({"lockfileVersion": 1}).as_object().unwrap().clone())?,
        None
    );

    Ok(())
}
