use std::{fs, path::Path};

use anyhow::{Context, Result, anyhow};

/// Atomically symlink a file.
///
/// This will first symlink the original to a temporary path with a `.tmp` suffix and then move the
/// symlink to its actual path.
/// The temporary and actual paths are located in the same directory, which is created if it does
/// not exist.
pub fn atomic_symlink(original: impl AsRef<Path>, link: impl AsRef<Path>) -> Result<()> {
    let mut i = 0;

    let tmp_path = loop {
        let parent = link
            .as_ref()
            .parent()
            .ok_or(anyhow!("Failed to determine parent of {:?}", link.as_ref()))?;
        if !parent.exists() {
            std::fs::create_dir(parent)?;
        }

        let mut tmp_path = link.as_ref().as_os_str().to_os_string();
        tmp_path.push(format!(".tmp{i}"));

        let res = std::os::unix::fs::symlink(&original, &tmp_path);
        match res {
            Ok(()) => break tmp_path,
            Err(err) => {
                if err.kind() != std::io::ErrorKind::AlreadyExists {
                    return Err(err).context(format!(
                        "Failed to symlink to temporary file {}",
                        tmp_path.display()
                    ));
                }
            }
        }
        i += 1;
    };

    fs::rename(&tmp_path, &link).with_context(|| {
        format!(
            "Failed to rename {} to {}",
            tmp_path.display(),
            link.as_ref().display()
        )
    })?;

    Ok(())
}
