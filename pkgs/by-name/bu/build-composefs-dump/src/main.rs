//! Build a composefs dump from a Json config
//! See the man page of composefs-dump for details about the format:
//! https://github.com/containers/composefs/blob/main/man/composefs-dump.md

use std::collections::BTreeMap;
use std::env;
use std::fs;
use std::os::unix::{ffi::OsStrExt, fs::MetadataExt};
use std::path::{Path, PathBuf};
use std::ffi::OsString;

use anyhow::Context;

#[derive(serde::Deserialize)]
struct Attrs {
    target: PathBuf,
    source: String,
    mode: String,
    uid: u64,
    gid: u64,
}

/// The filetype as defined by the `st_mode` stat field in octal
///
/// You can check the st_mode stat field of a path in Python with
/// `oct(os.stat("/path/").st_mode)`
enum FileType {
    Directory,
    File,
    Symlink,
}

impl std::fmt::Display for FileType {
    fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
        match self {
            Self::Directory => "4",
            Self::File => "10",
            Self::Symlink => "12",
        }
        .fmt(f)
    }
}

struct ComposefsPath {
    path: PathBuf,
    size: u64,
    filetype: FileType,
    mode: String,
    uid: String,
    gid: String,
    payload: String,
    rdev: String,
    nlink: usize,
    mtime: String,
    content: String,
    digest: String,
}

impl ComposefsPath {
    fn new(
        attrs: &Attrs,
        size: u64,
        filetype: FileType,
        mode: &str,
        payload: &str,
        path: Option<PathBuf>,
    ) -> Self {
        assert!(
            matches!(mode.len(), 3 | 4) && u32::from_str_radix(mode, 8).is_ok(),
            "mode should be 3 or 4 octal digits, got: {}",
            mode
        );

        Self {
            path: path.unwrap_or_else(|| attrs.target.clone()),
            size,
            filetype,
            mode: mode.to_owned(),
            uid: attrs.uid.to_string(),
            gid: attrs.gid.to_string(),
            payload: payload.to_owned(),
            rdev: String::from("0"),
            nlink: 1,
            mtime: String::from("1.0"),
            content: String::from("-"),
            digest: String::from("-"),
        }
    }
    fn write_line(&self) -> String {
        [
            self.path.to_str().unwrap(),
            &self.size.to_string(),
            &format!("{}{:0>4}", self.filetype, self.mode),
            &self.nlink.to_string(),
            &self.uid,
            &self.gid,
            &self.rdev,
            &self.mtime,
            &self.payload,
            &self.content,
            &self.digest,
        ]
        .join(" ")
    }
}

fn normalize_path(path: &Path) -> std::io::Result<PathBuf> {
    std::path::absolute(Path::new("/").join(path))
}

/// Return the leading directories of `path`
fn leading_directories(path: &Path) -> Vec<PathBuf> {
    let mut parents: Vec<_> = path
        .ancestors()
        // remove the implicit `.` from the start of a relative path or `/` from an
        // absolute path
        .skip(1)
        .filter(|p| !matches!(p.as_os_str().as_bytes(), b"" | b"/"))
        .map(|p: &Path| p.to_owned())
        .collect();

    parents.reverse();
    parents
}

#[test]
fn test_leading_directories() {
    let leading = leading_directories(Path::new("alsa/conf.d/50-pipewire.conf"));
    assert_eq!(
        leading,
        vec![PathBuf::from("alsa"), PathBuf::from("alsa/conf.d")]
    );
}

/// Add the leading directories of a target path to the composefs paths
///
/// mkcomposefs expects that all leading directories are explicitly listed in
/// the dump file. Given the path "alsa/conf.d/50-pipewire.conf", for example,
/// this function adds "alsa" and "alsa/conf.d" to the composefs paths.
fn add_leading_directories(
    target: &Path,
    attrs: &Attrs,
    paths: &mut BTreeMap<OsString, ComposefsPath>,
) {
    let path_components = leading_directories(target);
    for component in path_components {
        let composefs_path = ComposefsPath::new(
            attrs,
            4096,
            FileType::Directory,
            "0755",
            "-",
            Some(component.clone()),
        );
        paths.insert(component.into(), composefs_path);
    }
}

fn main() -> anyhow::Result<()> {
    let config_path = env::args()
        .nth(1)
        .context("No config file supplied as argument")?;
    let config_bytes = fs::read(&config_path).context("Config isn't accessible")?;
    let mut config: Vec<Attrs> =
        serde_json::from_slice(&config_bytes).with_context(|| format!("Config for etc {config_path:?} isn't parsable"))?;

    eprintln!("Building composefs dump...");

    let mut paths: BTreeMap<OsString, ComposefsPath> = BTreeMap::new();

    for attrs in &mut config {
        attrs.target = normalize_path(&attrs.target)?;

        let target = &attrs.target;
        let source = &attrs.source;
        let mode = &attrs.mode;

        if source.as_bytes().contains(&b'*') {
            let glob_sources = glob::glob(source)?;
            for glob_source in glob_sources {
                let glob_source = glob_source?;
                let basename = glob_source.file_name().unwrap();
                let glob_target = target.join(basename);

                let composefs_path = ComposefsPath::new(
                    attrs,
                    100, // a high approximation for the size of a symlink
                    FileType::Symlink,
                    "0777",
                    glob_source.to_str().unwrap(),
                    Some(glob_target.clone()),
                );
                paths.insert(glob_target.as_os_str().to_owned(), composefs_path);
                add_leading_directories(&glob_target, attrs, &mut paths);
            }
        } else {
            let composefs_path = if matches!(mode.as_str(), "symlink" | "direct-symlink") {
                ComposefsPath::new(attrs, 100, FileType::Symlink, "0777", source, None)
            } else if Path::new(source).is_dir() {
                ComposefsPath::new(attrs, 4096, FileType::Directory, mode, source, None)
            } else {
                ComposefsPath::new(
                    attrs,
                    fs::metadata(Path::new(source))?.size(),
                    FileType::File,
                    mode,
                    target.to_str().unwrap().strip_prefix("/").unwrap(),
                    None,
                )
            };

            paths.insert(target.as_os_str().to_owned(), composefs_path);
            add_leading_directories(target, attrs, &mut paths);
        }
    }

    let mut composefs_dump = String::from("/ 4096 40755 1 0 0 0 0.0 - - -"); // Root directory
    for (_, composefs_path) in paths {
        composefs_dump.push('\n');
        eprintln!("{}", composefs_path.path.display());
        composefs_dump.push_str(&composefs_path.write_line())
    }

    println!("{composefs_dump}");
    Ok(())
}
