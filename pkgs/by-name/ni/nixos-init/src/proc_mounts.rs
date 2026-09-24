use std::fs;

use anyhow::{Context, Result};

pub struct Mounts {
    inner: Vec<Mount>,
}

#[derive(Debug)]
pub struct Mount {
    _spec: String,
    file: String,
    _vfstype: String,
    pub mntopts: MntOpts,
}

#[derive(Debug)]
pub struct MntOpts {
    inner: Vec<String>,
}

impl Mounts {
    pub fn parse_from_proc_mounts() -> Result<Self> {
        let proc_mounts =
            fs::read_to_string("/proc/mounts").context("Failed to read /proc/mounts")?;
        Self::parse(&proc_mounts)
    }

    fn parse(s: &str) -> Result<Self> {
        let mut inner = Vec::new();
        for line in s.lines() {
            let mut split = line.split_whitespace();
            let mount = Mount {
                _spec: split.next().context("Failed to parse spec")?.to_string(),
                file: split.next().context("Failed to parse file")?.to_string(),
                _vfstype: split.next().context("Failed to parse vfstype")?.to_string(),
                mntopts: MntOpts::parse(split.next().context("Failed to parse mntopts")?),
            };
            inner.push(mount);
        }
        Ok(Self { inner })
    }

    pub fn find_mountpoint(&self, mountpoint: &str) -> Option<&Mount> {
        self.inner.iter().rev().find(|m| m.file == mountpoint)
    }
}

impl MntOpts {
    fn parse(s: &str) -> Self {
        let mut vec = Vec::new();
        for sp in s.split(',') {
            vec.push(sp.to_string());
        }

        Self { inner: vec }
    }

    pub fn contains(&self, s: &str) -> bool {
        self.inner.contains(&s.to_string())
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    use indoc::indoc;

    #[test]
    fn test_proc_mounts_parsing() -> Result<()> {
        let s = indoc! {r"
            /dev/mapper/root / btrfs rw,noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvolid=5,subvol=/ 0 0
            tmpfs /run tmpfs rw,nosuid,nodev,size=15350916k,nr_inodes=819200,mode=755 0 0
            devtmpfs /dev devtmpfs rw,nosuid,size=3070184k,nr_inodes=7671201,mode=755 0 0
            devpts /dev/pts devpts rw,nosuid,noexec,relatime,gid=3,mode=620,ptmxmode=666 0 0
            tmpfs /dev/shm tmpfs rw,nosuid,nodev 0 0
            proc /proc proc rw,nosuid,nodev,noexec,relatime 0 0
            ramfs /run/keys ramfs rw,nosuid,nodev,relatime,mode=750 0 0
            sysfs /sys sysfs rw,nosuid,nodev,noexec,relatime 0 0
            /dev/mapper/root /nix/store btrfs ro,nosuid,nodev,noatime,compress=zstd:3,ssd,discard=async,space_cache=v2,subvolid=5,subvol=/ 0 0
            securityfs /sys/kernel/security securityfs rw,nosuid,nodev,noexec,relatime 0 0
            cgroup2 /sys/fs/cgroup cgroup2 rw,nosuid,nodev,noexec,relatime,nsdelegate,memory_recursiveprot 0 0
            none /sys/fs/pstore pstore rw,nosuid,nodev,noexec,relatime 0 0
            efivarfs /sys/firmware/efi/efivars efivarfs rw,nosuid,nodev,noexec,relatime 0 0
            bpf /sys/fs/bpf bpf rw,nosuid,nodev,noexec,relatime,mode=700 0 0
            hugetlbfs /dev/hugepages hugetlbfs rw,nosuid,nodev,relatime,pagesize=2M 0 0
            mqueue /dev/mqueue mqueue rw,nosuid,nodev,noexec,relatime 0 0
            debugfs /sys/kernel/debug debugfs rw,nosuid,nodev,noexec,relatime 0 0
            tracefs /sys/kernel/tracing tracefs rw,nosuid,nodev,noexec,relatime 0 0
        "};

        let mounts = Mounts::parse(s)?;
        if let Some(nix_store_mount) = mounts.find_mountpoint("/nix/store") {
            println!("{nix_store_mount:?}");
            println!("{:?}", nix_store_mount.mntopts);
            assert!(nix_store_mount.mntopts.contains("ro"));
            assert!(!nix_store_mount.mntopts.contains("no"));
        }

        Ok(())
    }
}
