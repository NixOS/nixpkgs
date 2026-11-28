//! UEFI specifics: the firmware boot entry and Secure Boot signability.

use std::ffi::OsString;
use std::fs::{self, File};
use std::io::{self, Read, Seek, SeekFrom};
use std::os::unix::ffi::OsStringExt;
use std::path::{Path, PathBuf};
use std::process::Command;

use anyhow::{Context, Result};

use crate::command;

const BOOT_ENTRY_LABEL: &str = "Limine";

/// Creates the `Limine` firmware boot entry, replacing an existing one in place.
pub fn install_boot_entry(efibootmgr: &Path, esp: &Path, boot_file: &str) -> Result<()> {
    let partition = Partition::mounted_at(esp)?;
    let entries = command::output(&mut Command::new(efibootmgr))?;

    let mut create = vec!["-c".to_owned()];
    if let Some(entry) = limine_boot_entry(&entries) {
        // Keep the entry's position in the boot order; leave it out if the user removed it.
        create = match boot_order(&entries).position(|e| e.eq_ignore_ascii_case(entry)) {
            Some(index) => vec!["-c".to_owned(), "--index".to_owned(), index.to_string()],
            None => vec!["-C".to_owned()],
        };
        create.extend(["-b".to_owned(), entry.to_owned()]);
        command::output(Command::new(efibootmgr).args(["-b", entry, "-B"]))?;
    }

    command::output(
        Command::new(efibootmgr)
            .args(create)
            .arg("-d")
            .arg(&partition.disk)
            .args(["-p", &partition.number])
            .args(["-l", &format!("\\efi\\limine\\{boot_file}")])
            .args(["-L", BOOT_ENTRY_LABEL]),
    )?;
    Ok(())
}

/// The number of the first `BootXXXX` entry labelled `Limine` in `efibootmgr` output.
fn limine_boot_entry(entries: &str) -> Option<&str> {
    entries.lines().find_map(|line| {
        let rest = line.strip_prefix("Boot")?;
        let number = rest.get(..4)?;
        if !number.bytes().all(|b| b.is_ascii_hexdigit()) {
            return None;
        }
        let rest = &rest[4..];
        let rest = rest.strip_prefix('*').unwrap_or(rest);
        rest.strip_prefix(' ')?
            .starts_with(BOOT_ENTRY_LABEL)
            .then_some(number)
    })
}

fn boot_order(entries: &str) -> impl Iterator<Item = &str> {
    entries
        .lines()
        .find_map(|line| line.strip_prefix("BootOrder: "))
        .into_iter()
        .flat_map(|order| order.trim().split(','))
        .filter(|entry| !entry.is_empty())
}

struct Partition {
    disk: PathBuf,
    number: String,
}

impl Partition {
    fn mounted_at(mount_point: &Path) -> Result<Self> {
        let mount_point = fs::canonicalize(mount_point)
            .with_context(|| format!("resolving {}", mount_point.display()))?;
        let mountinfo = fs::read_to_string("/proc/self/mountinfo")?;
        let device = mounted_device(&mountinfo, &mount_point)
            .with_context(|| format!("no mount found for {}", mount_point.display()))?;

        let sysfs = Path::new("/sys/dev/block").join(device);
        let sysfs = fs::canonicalize(&sysfs)
            .with_context(|| format!("{} is not on a block device", mount_point.display()))?;
        let number = fs::read_to_string(sysfs.join("partition"))
            .with_context(|| format!("{} is not on a partition", mount_point.display()))?;
        let disk = sysfs
            .parent()
            .and_then(Path::file_name)
            .with_context(|| format!("no disk found for {}", sysfs.display()))?;

        Ok(Partition {
            disk: Path::new("/dev").join(disk),
            number: number.trim().to_owned(),
        })
    }
}

/// The `major:minor` device of the innermost mount containing `path`.
fn mounted_device<'a>(mountinfo: &'a str, path: &Path) -> Option<&'a str> {
    mountinfo
        .lines()
        .filter_map(|line| {
            let mut fields = line.split(' ');
            let device = fields.nth(2)?;
            let mount_point = unescape_mount_field(fields.nth(1)?);
            path.starts_with(&mount_point)
                .then(|| (mount_point.as_os_str().len(), device))
        })
        // Later mounts on the same point shadow earlier ones, and `max_by_key` keeps the last.
        .max_by_key(|&(depth, _)| depth)
        .map(|(_, device)| device)
}

/// Decodes the `\ooo` octal escapes the kernel uses in `/proc/self/mountinfo`.
fn unescape_mount_field(field: &str) -> PathBuf {
    let bytes = field.as_bytes();
    let mut decoded = Vec::with_capacity(bytes.len());
    let mut i = 0;
    while i < bytes.len() {
        if bytes[i] == b'\\'
            && let Some(digits) = bytes.get(i + 1..i + 4)
            && digits.iter().all(|d| (b'0'..=b'7').contains(d))
        {
            decoded.push(
                digits
                    .iter()
                    .fold(0, |byte: u8, d| byte.wrapping_mul(8) + (d - b'0')),
            );
            i += 4;
        } else {
            decoded.push(bytes[i]);
            i += 1;
        }
    }
    PathBuf::from(OsString::from_vec(decoded))
}

/// Whether `path` is a PE/COFF image, which is what sbctl can sign.
///
/// sbctl ignores the file name, so this mirrors the checks of Go's debug/pe: the DOS `MZ`
/// magic, the `PE\0\0` signature at the offset stored at 0x3c, and a PE32 or PE32+ optional
/// header magic after the 20 byte COFF header.
pub fn is_pe_coff_image(path: &Path) -> bool {
    fn check(path: &Path) -> io::Result<bool> {
        let mut file = File::open(path)?;
        let mut read = |offset: u64, buf: &mut [u8]| {
            file.seek(SeekFrom::Start(offset))?;
            file.read_exact(buf)
        };

        let mut dos_magic = [0; 2];
        read(0, &mut dos_magic)?;
        if dos_magic != *b"MZ" {
            return Ok(false);
        }
        let mut pe_offset = [0; 4];
        read(0x3c, &mut pe_offset)?;
        let pe_offset = u64::from(u32::from_le_bytes(pe_offset));
        let mut signature = [0; 4];
        read(pe_offset, &mut signature)?;
        if signature != *b"PE\0\0" {
            return Ok(false);
        }
        let mut optional_magic = [0; 2];
        read(pe_offset + 4 + 20, &mut optional_magic)?;
        Ok(matches!(optional_magic, [0x0b, 0x01 | 0x02]))
    }
    check(path).unwrap_or(false)
}

#[cfg(test)]
mod tests {
    use super::*;

    const EFIBOOTMGR: &str = "\
BootCurrent: 0001
Timeout: 0 seconds
BootOrder: 0003,000a,0001
Boot0001* UEFI QEMU HARDDISK\tPciRoot(0x0)/Pci(0x1,0x1)/Ata(0,0,0)
Boot000A* Limine\tHD(1,GPT,00000000-0000-0000-0000-000000000000,0x800,0x100000)/\\efi\\limine\\BOOTX64.EFI
Boot0003  Limine\tHD(1,GPT,00000000-0000-0000-0000-000000000000,0x800,0x100000)
";

    #[test]
    fn finds_the_first_limine_entry() {
        assert_eq!(limine_boot_entry(EFIBOOTMGR), Some("000A"));
        assert_eq!(limine_boot_entry("Boot0001* UEFI Shell\n"), None);
    }

    #[test]
    fn reads_the_boot_order() {
        assert_eq!(
            boot_order(EFIBOOTMGR).collect::<Vec<_>>(),
            ["0003", "000a", "0001"]
        );
        assert_eq!(boot_order("BootCurrent: 0001\n").count(), 0);
    }

    #[test]
    fn picks_the_innermost_mount() {
        let mountinfo = "\
22 1 254:1 / / rw,relatime shared:1 - ext4 /dev/vda1 rw
25 22 254:2 / /boot rw,relatime shared:2 - vfat /dev/vda2 rw
26 22 254:3 / /boot\\040efi rw,relatime shared:3 - vfat /dev/vda3 rw
27 25 254:4 / /boot rw,relatime shared:4 - vfat /dev/vdb1 rw
";
        let device = |path: &str| mounted_device(mountinfo, Path::new(path));
        assert_eq!(device("/boot"), Some("254:4"));
        assert_eq!(device("/boot/limine"), Some("254:4"));
        assert_eq!(device("/boot efi"), Some("254:3"));
        assert_eq!(device("/bootx"), Some("254:1"));
    }

    #[test]
    fn unescapes_mount_points() {
        assert_eq!(
            unescape_mount_field("/a\\040b\\134c\\"),
            Path::new("/a b\\c\\")
        );
    }
}
