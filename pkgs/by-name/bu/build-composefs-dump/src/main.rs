//! Build a composefs dump from a Json config
//! See the man page of composefs-dump for details about the format:
//! https://github.com/containers/composefs/blob/main/man/composefs-dump.md

use std::collections::BTreeMap;
use std::env;
use std::fs;
use std::os::linux::fs::MetadataExt as _;
use std::os::unix::ffi::OsStrExt;
use std::path;
use std::path::Path;
use std::path::PathBuf;

use anyhow::Context;

const INLINE_CONTENT_MAX: u64 = 4096;

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
        content: Option<String>,
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
            mode: mode.to_string(),
            uid: attrs.uid.to_string(),
            gid: attrs.gid.to_string(),
            payload: payload.to_string(),
            rdev: String::from("0"),
            nlink: 1,
            mtime: String::from("1.0"),
            content: content.unwrap_or("-".to_string()),
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

fn dump_short_escapes(b: u8) -> Option<&'static str> {
    match b {
        b'\\' => Some("\\\\"),
        b'\n' => Some("\\n"),
        b'\r' => Some("\\r"),
        b'\t' => Some("\\t"),
        _ => None,
    }
}

fn escape_dump_field(data: &[u8]) -> String {
    if data.is_empty() {
        panic!("cannot escape empty content; emit '-' instead");
    }
    if data == b"-" {
        return String::from("\u{2d}");
    }
    let mut out = String::new();
    for b in data {
        if let Some(bs) = dump_short_escapes(*b) {
            out.push_str(bs);
        } else if *b == b' ' || *b == b'=' || !(0x20 <= *b && *b <= 0x7E) {
            out.push_str(&format!("\\x{b:02x}"));
        } else {
            out.push(char::from(*b));
        }
    }

    out
}

fn normalize_path(path: &Path) -> std::io::Result<PathBuf> {
    path::absolute(Path::new("/").join(path))
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
    paths: &mut BTreeMap<PathBuf, ComposefsPath>,
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
            None,
        );
        paths.insert(component, composefs_path);
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

    let mut paths: BTreeMap<PathBuf, ComposefsPath> = BTreeMap::new();

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
                    None,
                );
                paths.insert(glob_target.clone(), composefs_path);
                add_leading_directories(&glob_target, attrs, &mut paths);
            }
        } else {
            let composefs_path = if matches!(mode.as_str(), "symlink" | "direct-symlink") {
                ComposefsPath::new(attrs, 100, FileType::Symlink, "0777", source, None, None)
            } else if Path::new(source).is_dir() {
                ComposefsPath::new(attrs, 4096, FileType::Directory, mode, source, None, None)
            } else {
                let mut size = Path::new(source).metadata().unwrap().st_size();
                if size <= INLINE_CONTENT_MAX {
                    let content = if size > 0 {
                        let raw = fs::read(Path::new(source)).unwrap();
                        size = raw.len() as u64;
                        escape_dump_field(&raw)
                    } else {
                        String::from("-")
                    };
                    ComposefsPath::new(attrs, size, FileType::File, mode, "-", None, Some(content))
                } else {
                    ComposefsPath::new(
                        attrs,
                        size,
                        FileType::File,
                        mode,
                        // payload needs to be relative path in this case
                        target.to_str().unwrap().strip_prefix("/").unwrap(),
                        None,
                        None,
                    )
                }
            };

            paths.insert(target.clone(), composefs_path);
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
