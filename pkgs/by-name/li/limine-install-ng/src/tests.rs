//! Installs into a temporary directory, covering what the NixOS tests do not reach: Xen,
//! initrd secrets, extra initrds, extra profiles and removing stale files.

use std::ffi::CString;
use std::fs;
use std::os::unix::ffi::OsStrExt;
use std::os::unix::fs::{PermissionsExt, symlink};
use std::path::{Path, PathBuf};

use serde_json::{Value, json};

use crate::config::Config;
use crate::install::{self, blake2b};
use crate::profiles;

const GENERATION_1_TIME: i64 = 1_577_934_245;
const GENERATION_2_TIME: i64 = 1_600_000_000;
const EXTRA_PROFILE_TIME: i64 = 1_700_000_000;

// A single test, as installing changes the umask of the whole process while it runs the initrd
// secrets script, which would race with other tests creating files.
#[test]
fn installs_and_reinstalls() {
    let base = std::env::temp_dir().join(format!("limine-install-test-{}", std::process::id()));
    let _ = fs::remove_dir_all(&base);
    fs::create_dir_all(&base).unwrap();
    let base = fs::canonicalize(base).unwrap();
    let store = base.join("store");
    let profiles = base.join("profiles");
    let boot = base.join("boot");
    let path = |relative: &str| base.join(relative);

    write(&path("store/aaa-linux/bzImage"), "kernel a");
    write(&path("store/aaa-initrd/initrd"), "initrd a");
    write(&path("store/bbb-linux/bzImage"), "kernel b");
    write(&path("store/www-wallpaper/wall.png"), "wallpaper");
    write(
        &path("store/lim-limine/share/limine/BOOTX64.EFI"),
        "limine efi",
    );
    write(&path("store/mem-memtest/memtest.efi"), "memtest");
    write(&path("store/xxx-xen/xen.efi"), "xen efi");
    write(&path("store/xxx-xen/xen.gz"), "xen multiboot");
    let secrets_script = path("store/sec-secrets/append");
    write(&secrets_script, "#!/bin/sh\necho secret > \"$1\"\n");
    fs::set_permissions(&secrets_script, fs::Permissions::from_mode(0o755)).unwrap();

    let store_path = |relative: &str| store.join(relative).display().to_string();
    let other = boot_json(
        &store_path("sys1-other"),
        "other-label",
        &store_path("aaa-linux/bzImage"),
        None,
    );
    let mut sys1 = boot_json(
        &store_path("sys1"),
        "sys1-label",
        &store_path("aaa-linux/bzImage"),
        Some(&store_path("aaa-initrd/initrd")),
    );
    sys1["org.nixos.specialisation.v1"] = json!({ "other": other });
    let mut sys2 = boot_json(
        &store_path("sys2"),
        "sys2-label",
        &store_path("bbb-linux/bzImage"),
        Some(&store_path("aaa-initrd/initrd")),
    );
    let spec = &mut sys2["org.nixos.bootspec.v1"];
    spec["kernelParams"] = json!(["quiet"]);
    spec["initrdSecrets"] = json!(secrets_script);
    sys2["org.nixos.extra-initrd.v1"] = json!({ "paths": ["extra/initrd"] });
    sys2["org.xenproject.bootspec.v2"] = json!({
        "efiPath": store_path("xxx-xen/xen.efi"),
        "multibootPath": store_path("xxx-xen/xen.gz"),
        "params": ["dom0_mem=1G"],
        "version": "4.19",
    });
    write(&path("store/sys1/boot.json"), &sys1.to_string());
    write(&path("store/sys2/boot.json"), &sys2.to_string());

    link(
        &store.join("sys1"),
        &profiles.join("system-1-link"),
        GENERATION_1_TIME,
    );
    link(
        &store.join("sys2"),
        &profiles.join("system-2-link"),
        GENERATION_2_TIME,
    );
    let extra = profiles.join("system-profiles");
    link(
        &store.join("sys1"),
        &extra.join("extra-1-link"),
        EXTRA_PROFILE_TIME,
    );
    link(
        &extra.join("extra-1-link"),
        &extra.join("extra"),
        EXTRA_PROFILE_TIME,
    );

    // Left over from earlier installations.
    write(&boot.join("limine/kernels/stale-linux-bzImage"), "stale");
    write(&boot.join("limine/xen/1/stale-xen.efi"), "stale");

    let config = |overrides: Value| {
        let mut config = base_config(&base);
        merge(&mut config, overrides);
        serde_json::from_value::<Config>(config).unwrap()
    };
    let install = |config: &Config| {
        install::install(config, &profiles, &store.join("sys2")).unwrap();
        fs::read_to_string(boot.join("limine/limine.conf")).unwrap()
    };

    let conf = install(&config(json!({})));
    let store = store.display();
    let [t1, t2, t3] = [GENERATION_1_TIME, GENERATION_2_TIME, EXTRA_PROFILE_TIME]
        .map(|time| profiles::local_time(time).unwrap());
    let sys1 = format!(
        "\
protocol: linux
kernel_path: boot():/limine/kernels/aaa-linux-bzImage
cmdline: init={store}/sys1/init
module_path: boot():/limine/kernels/aaa-initrd-initrd"
    );
    let other = format!(
        "\
protocol: linux
kernel_path: boot():/limine/kernels/aaa-linux-bzImage
cmdline: init={store}/sys1-other/init"
    );
    let sys2 = format!(
        "\
protocol: linux
kernel_path: boot():/limine/kernels/bbb-linux-bzImage
cmdline: init={store}/sys2/init quiet
module_path: boot():/limine/kernels/aaa-initrd-initrd
module_path: boot():/extra/initrd
module_path: boot():/limine/kernels/sys2-secrets"
    );
    assert_eq!(
        conf,
        format!(
            "\
serial: yes

timeout: 5
editor_enabled: no
hash_mismatch_panic: no
graphics: yes
default_entry: 1
wallpaper_style: stretched
interface_help_hidden: no
term_margin: 4
wallpaper: boot():/limine/wallpapers/www-wallpaper-wall.png

# NixOS boot entries start here
/NixOS
comment: Generation 2, sys2-label, built on {t2}
{sys2}
/+NixOS generations
//Generation 2 with Xen 4.19 EFI
comment: Xen 4.19 sys2-label, built on {t2}
protocol: efi
path: boot():/limine/xen/2/xxx-xen-xen.efi
//Generation 2 with Xen 4.19
comment: Xen 4.19 sys2-label, built on {t2}
protocol: multiboot
path: boot():/limine/xen/2/xxx-xen-xen.gz
cmdline: -- dom0_mem=1G
module_path: boot():/limine/kernels/bbb-linux-bzImage
module_string: -- init={store}/sys2/init quiet
module_path: boot():/limine/kernels/aaa-initrd-initrd
module_path: boot():/extra/initrd
//Generation 2
comment: sys2-label, built on {t2}
{sys2}
//Generation 1
///Default
comment: sys1-label, built on {t1}
{sys1}
///other
comment: other-label, built on {t1}
{other}
/+NixOS profile 'extra'
//+Generation 1
///Default
comment: sys1-label, built on {t3}
{sys1}
///other
comment: other-label, built on {t3}
{other}

# NixOS boot entries end here

/memtest
  protocol: efi"
        )
    );

    let files = files(&boot);
    assert_eq!(
        files,
        [
            "efi/boot/BOOTX64.EFI",
            "efi/memtest/memtest.efi",
            "limine/kernels/aaa-initrd-initrd",
            "limine/kernels/aaa-linux-bzImage",
            "limine/kernels/bbb-linux-bzImage",
            "limine/kernels/sys2-secrets",
            "limine/limine.conf",
            "limine/wallpapers/www-wallpaper-wall.png",
            "limine/xen/2/aaa-initrd-initrd",
            "limine/xen/2/bbb-linux-bzImage",
            "limine/xen/2/xxx-xen-xen.cfg",
            "limine/xen/2/xxx-xen-xen.efi",
            "limine/xen/2/xxx-xen-xen.gz",
        ]
    );
    let read = |relative: &str| fs::read_to_string(boot.join(relative)).unwrap();
    assert_eq!(
        read("limine/xen/2/xxx-xen-xen.cfg"),
        format!(
            "default=nixos2\n\n[nixos2]\noptions=dom0_mem=1G\n\
             kernel=bbb-linux-bzImage init={store}/sys2/init quiet\n\
             ramdisk=aaa-initrd-initrd\n"
        )
    );
    assert_eq!(read("limine/kernels/sys2-secrets"), "secret\n");
    let secrets_mode = fs::metadata(boot.join("limine/kernels/sys2-secrets"))
        .unwrap()
        .permissions()
        .mode();
    assert_eq!(
        secrets_mode & 0o137,
        0,
        "secrets are readable by others: {secrets_mode:o}"
    );

    // Installing again changes nothing.
    assert_eq!(install(&config(json!({}))), conf);
    assert_eq!(self::files(&boot), files);

    // Every installed file is checksummed by its source.
    let conf = install(&config(json!({ "validateChecksums": true })));
    let kernel = blake2b(&b"kernel b"[..]).unwrap();
    assert!(
        conf.contains(&format!("kernels/bbb-linux-bzImage#{kernel}\n")),
        "{conf}"
    );
    let secrets = blake2b(&b"secret\n"[..]).unwrap();
    assert!(
        conf.contains(&format!("kernels/sys2-secrets#{secrets}\n")),
        "{conf}"
    );
    let references = conf.lines().filter(|line| line.contains("boot():/limine/"));
    assert!(references.clone().all(|line| line.contains('#')), "{conf}");

    // Only the newest generation of each profile is kept.
    let conf = install(&config(json!({ "maxGenerations": 1 })));
    assert!(!conf.contains(&t1), "{conf}");
    assert!(conf.contains("\n//+Generation 1\n"), "{conf}");

    fs::remove_dir_all(&base).unwrap();
}

fn base_config(base: &Path) -> Value {
    let path = |relative: &str| base.join(relative);
    json!({
        "distroName": "NixOS",
        "globalConfig": "\
serial: yes

timeout: 5
editor_enabled: no
hash_mismatch_panic: no
graphics: yes
default_entry: 1
wallpaper_style: stretched
interface_help_hidden: no
term_margin: 4
",
        "wallpapers": [path("store/www-wallpaper/wall.png")],
        "liminePath": path("store/lim-limine"),
        "efiBootMgrPath": null,
        "efiMountPoint": path("boot"),
        "fileSystems": {},
        "luksDevices": [],
        "canTouchEfiVariables": false,
        "efiSupport": true,
        "efiRemovable": true,
        "efiBootFile": "BOOTX64.EFI",
        "secureBoot": {
            "enable": false,
            "autoGenerateKeys": false,
            "autoEnrollKeys": { "enable": false, "extraArgs": [] },
            "signAdditionalFiles": { "enable": false, "skip": [] },
            "sbctl": null,
        },
        "biosSupport": false,
        "biosDevice": "nodev",
        "partitionIndex": null,
        "force": false,
        "enrollConfig": false,
        "resolution": null,
        "maxGenerations": 0,
        "extraEntries": "/memtest\n  protocol: efi\n",
        "additionalFiles": { "efi/memtest/memtest.efi": path("store/mem-memtest/memtest.efi") },
        "validateChecksums": false,
    })
}

fn merge(base: &mut Value, overrides: Value) {
    match (base, overrides) {
        (Value::Object(base), Value::Object(overrides)) => {
            for (key, value) in overrides {
                merge(base.entry(key).or_insert(Value::Null), value);
            }
        }
        (base, overrides) => *base = overrides,
    }
}

fn boot_json(toplevel: &str, label: &str, kernel: &str, initrd: Option<&str>) -> Value {
    json!({
        "org.nixos.bootspec.v1": {
            "init": format!("{toplevel}/init"),
            "kernel": kernel,
            "kernelParams": [],
            "label": label,
            "toplevel": toplevel,
            "initrd": initrd,
        },
        "org.nixos.specialisation.v1": {},
    })
}

fn write(path: &Path, content: &str) {
    fs::create_dir_all(path.parent().unwrap()).unwrap();
    fs::write(path, content).unwrap();
}

/// Creates the symlink `link` with the modification time `mtime`.
fn link(target: &Path, link: &Path, mtime: i64) {
    fs::create_dir_all(link.parent().unwrap()).unwrap();
    symlink(target, link).unwrap();
    let path = CString::new(link.as_os_str().as_bytes()).unwrap();
    #[allow(
        clippy::useless_conversion,
        reason = "time_t is narrower on 32-bit targets"
    )]
    let time = libc::timespec {
        tv_sec: mtime.try_into().unwrap(),
        tv_nsec: 0,
    };
    let times = [time, time];
    // SAFETY: `path` is NUL-terminated and `times` holds the access and modification time.
    let result = unsafe {
        libc::utimensat(
            libc::AT_FDCWD,
            path.as_ptr(),
            times.as_ptr(),
            libc::AT_SYMLINK_NOFOLLOW,
        )
    };
    assert_eq!(result, 0, "setting the time of {}", link.display());
}

/// The files below `dir`, relative to it and sorted.
fn files(dir: &Path) -> Vec<String> {
    fn visit(dir: &Path, base: &Path, files: &mut Vec<String>) {
        for entry in fs::read_dir(dir).unwrap() {
            let path: PathBuf = entry.unwrap().path();
            if path.is_dir() {
                visit(&path, base, files);
            } else {
                files.push(path.strip_prefix(base).unwrap().display().to_string());
            }
        }
    }
    let mut files = Vec::new();
    visit(dir, dir, &mut files);
    files.sort();
    files
}
