use std::collections::{HashMap, HashSet};
use std::fs::{self, File};
use std::io::{self, Write};
use std::path::{Path, PathBuf};

use anyhow::{Context, Result};
use blake2::{Blake2b512, Digest};

pub(super) struct BootFiles {
    install_dir: PathBuf,
    validate_checksums: bool,
    /// Existing files below `install_dir` that have not been reused or written in this run.
    unused_files: HashSet<PathBuf>,
    /// BLAKE2b checksums by source, as generations mostly share their kernels and initrds.
    checksums: HashMap<PathBuf, String>,
}

impl BootFiles {
    pub(super) fn new(install_dir: PathBuf, validate_checksums: bool) -> Result<Self> {
        let mut unused_files = HashSet::new();
        if install_dir.exists() {
            collect_files(&install_dir, &mut unused_files)?;
        } else {
            fs::create_dir_all(&install_dir)
                .with_context(|| format!("creating {}", install_dir.display()))?;
        }

        // Xen files are named after generations rather than their content, so regenerate them all.
        let xen_dir = install_dir.join("xen");
        if xen_dir.exists() {
            println!("cleaning {}", xen_dir.display());
            fs::remove_dir_all(&xen_dir)
                .with_context(|| format!("removing {}", xen_dir.display()))?;
        }
        fs::create_dir_all(&xen_dir).with_context(|| format!("creating {}", xen_dir.display()))?;

        Ok(BootFiles {
            install_dir,
            validate_checksums,
            unused_files,
            checksums: HashMap::new(),
        })
    }

    pub(super) fn install_dir(&self) -> &Path {
        &self.install_dir
    }

    /// Where `source` is installed below `target`, named uniquely after its store path.
    pub(super) fn dest_path(&self, source: &Path, target: &str) -> PathBuf {
        self.install_dir.join(target).join(dest_file_name(source))
    }

    /// Installs `source` below `target` unless present, and returns its `boot():` URI.
    pub(super) fn copied_path_uri(&mut self, source: &Path, target: &str) -> Result<String> {
        let dest = self.dest_path(source, target);
        if dest.exists() {
            self.unused_files.remove(&dest);
        } else {
            self.copy_file(source, &dest)?;
        }
        self.path_uri(source, &Path::new(target).join(dest_file_name(source)))
    }

    /// The `boot():` URI of `relative` in the install directory, checksummed by `source`.
    pub(super) fn path_uri(&mut self, source: &Path, relative: &Path) -> Result<String> {
        let mut uri = format!("boot():{}", Path::new("/limine").join(relative).display());
        if self.validate_checksums {
            if !self.checksums.contains_key(source) {
                let file =
                    File::open(source).with_context(|| format!("reading {}", source.display()))?;
                self.checksums.insert(source.to_owned(), blake2b(file)?);
            }
            uri += "#";
            uri += &self.checksums[source];
        }
        Ok(uri)
    }

    pub(super) fn copy_file(&mut self, from: &Path, to: &Path) -> Result<()> {
        let context = || format!("copying {} to {}", from.display(), to.display());
        if let Some(dir) = to.parent() {
            fs::create_dir_all(dir).with_context(context)?;
        }
        let temp = temp_path(to);
        io::copy(
            &mut File::open(from).with_context(context)?,
            &mut File::create(&temp).with_context(context)?,
        )
        .with_context(context)?;
        fs::rename(&temp, to).with_context(context)?;
        self.unused_files.remove(to);
        Ok(())
    }

    pub(super) fn write_file(&mut self, path: &Path, contents: impl AsRef<[u8]>) -> Result<()> {
        fs::write(path, contents).with_context(|| format!("writing {}", path.display()))?;
        self.unused_files.remove(path);
        Ok(())
    }

    pub(super) fn write_limine_conf(&mut self, conf: &str) -> Result<()> {
        let path = self.install_dir.join("limine.conf");
        let temp = temp_path(&path);
        let context = || format!("writing {}", path.display());
        let mut file = File::create(&temp).with_context(context)?;
        file.write_all(conf.as_bytes()).with_context(context)?;
        file.sync_all().with_context(context)?;
        fs::rename(&temp, &path).with_context(context)?;
        self.unused_files.remove(&path);
        Ok(())
    }

    pub(super) fn remove_unused_files(&self) -> Result<()> {
        println!("removing unused boot files...");
        for path in &self.unused_files {
            match fs::remove_file(path) {
                Err(err) if err.kind() != io::ErrorKind::NotFound => {
                    return Err(err).with_context(|| format!("removing {}", path.display()));
                }
                _ => {}
            }
        }
        Ok(())
    }
}

fn collect_files(dir: &Path, files: &mut HashSet<PathBuf>) -> Result<()> {
    for entry in fs::read_dir(dir).with_context(|| format!("reading {}", dir.display()))? {
        let entry = entry?;
        if entry.file_type()?.is_dir() {
            collect_files(&entry.path(), files)?;
        } else {
            files.insert(entry.path());
        }
    }
    Ok(())
}

/// `<package>-<file>`, e.g. `…-linux-6.12/bzImage` becomes `…-linux-6.12-bzImage`.
fn dest_file_name(source: &Path) -> String {
    let package = source.parent().map(file_name).unwrap_or_default();
    format!("{package}-{}", file_name(source))
}

pub(super) fn file_name(path: &Path) -> String {
    path.file_name()
        .unwrap_or_default()
        .to_string_lossy()
        .into_owned()
}

fn temp_path(path: &Path) -> PathBuf {
    let mut temp = path.as_os_str().to_owned();
    temp.push(".tmp");
    PathBuf::from(temp)
}

pub fn blake2b(mut data: impl io::Read) -> Result<String> {
    let mut hasher = Blake2b512::new();
    let mut buffer = vec![0; 1 << 16];
    loop {
        match data.read(&mut buffer) {
            Ok(0) => break,
            Ok(n) => hasher.update(&buffer[..n]),
            Err(err) if err.kind() == io::ErrorKind::Interrupted => {}
            Err(err) => return Err(err.into()),
        }
    }
    Ok(hasher
        .finalize()
        .iter()
        .map(|b| format!("{b:02x}"))
        .collect())
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn names_files_after_their_package() {
        assert_eq!(
            dest_file_name(Path::new("/nix/store/abc-linux-6.12/bzImage")),
            "abc-linux-6.12-bzImage"
        );
    }

    #[test]
    fn hashes_with_blake2b() {
        assert_eq!(
            blake2b(&b"abc"[..]).unwrap(),
            "ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d1\
             7d87c5392aab792dc252d5de4533cc9518d38aa8dbf1925ab92386edd4009923"
        );
    }
}
