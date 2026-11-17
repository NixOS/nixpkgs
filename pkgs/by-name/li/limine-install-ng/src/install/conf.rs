use std::collections::HashMap;
use std::env;
use std::ffi::OsString;
use std::fmt::Write as _;
use std::fs;
use std::io;
use std::os::unix::ffi::OsStringExt;
use std::path::{Path, PathBuf};
use std::process::Command;

use anyhow::{Context, Result};

use super::files::{BootFiles, file_name};
use crate::bootspec::{BootJson, Xen, join_params};
use crate::config::InstallConfig;
use crate::profiles::{self, Profile};

pub(super) fn render(
    config: &InstallConfig,
    files: &mut BootFiles,
    profiles_dir: &Path,
    current_system: &Path,
) -> Result<String> {
    Renderer {
        config,
        files,
        payloads: HashMap::new(),
    }
    .limine_conf(profiles_dir, current_system)
}

struct Renderer<'a> {
    config: &'a InstallConfig,
    files: &'a mut BootFiles,
    /// Boot entry bodies by toplevel, so each initrd secrets script runs once.
    payloads: HashMap<String, String>,
}

impl Renderer<'_> {
    fn limine_conf(&mut self, profiles_dir: &Path, current_system: &Path) -> Result<String> {
        let config = self.config;
        let distro = &config.distro_name;
        let current = BootJson::load(current_system)?;

        let mut header = config.global_config.clone();
        for wallpaper in &config.wallpapers {
            let uri = self.files.copied_path_uri(wallpaper, "wallpapers")?;
            writeln!(header, "wallpaper: {uri}")?;
        }
        writeln!(header, "\n# {distro} boot entries start here")?;

        let mut generations = String::new();
        let mut current_matches = Vec::new();
        for profile in Profile::all(profiles_dir)? {
            match profile.name() {
                None => writeln!(generations, "/+{distro} generations")?,
                Some(name) => writeln!(generations, "/+{distro} profile '{name}'")?,
            }
            let mut numbers = profile.generations(config.max_generations)?;
            numbers.reverse();
            for (i, number) in numbers.into_iter().enumerate() {
                generations += &self.generation_entries(
                    &profile,
                    number,
                    i == 0,
                    &current.spec.toplevel,
                    &mut current_matches,
                )?;
            }
        }

        // Only describe the installed system when exactly one generation provides it.
        let (generation, time) = match current_matches.as_slice() {
            [(generation, time)] => (Some(generation.as_str()), Some(time.as_str())),
            _ => (None, None),
        };
        header += &self.entry(1, &current, distro, time, generation)?;

        let conf = format!(
            "{header}{generations}\n# {distro} boot entries end here\n\n{}",
            config.extra_entries
        );
        Ok(conf.trim().to_owned())
    }

    /// The menu entries of one generation, recording which of them boot `current_toplevel`.
    fn generation_entries(
        &mut self,
        profile: &Profile,
        number: u64,
        is_newest: bool,
        current_toplevel: &str,
        current_matches: &mut Vec<(String, String)>,
    ) -> Result<String> {
        let path = profile.generation_path(number);
        let time = profiles::link_time(&path)?;
        let boot = BootJson::load(&path)?;

        let mut generation = format!("Generation {number}");
        if let Some(name) = profile.name() {
            write!(generation, " (profile '{name}')")?;
        }
        if boot.spec.toplevel == current_toplevel {
            current_matches.push((generation.clone(), time.clone()));
        }

        let mut out = String::new();
        // Xen, if configured, is listed first for each generation.
        if let Some(xen) = &boot.xen
            && let Some(version) = &xen.version
        {
            if self.config.efi_support {
                out += &self.xen_entry(&boot, xen, version, number, &time, true)?;
            }
            out += &self.xen_entry(&boot, xen, version, number, &time, false)?;
        }

        let depth = if boot.specialisations.is_empty() {
            out += &self.entry(2, &boot, &format!("Generation {number}"), Some(&time), None)?;
            2
        } else {
            let expanded = if is_newest { "+" } else { "" };
            writeln!(out, "//{expanded}Generation {number}")?;
            out += &self.entry(3, &boot, "Default", Some(&time), None)?;
            3
        };

        for (name, specialisation) in &boot.specialisations {
            out += &self.entry(depth, specialisation, name, Some(&time), None)?;
            if specialisation.spec.toplevel == current_toplevel {
                current_matches.push((
                    format!("{generation} (specialisation '{name}')"),
                    time.clone(),
                ));
            }
        }
        Ok(out)
    }

    fn entry(
        &mut self,
        depth: usize,
        boot: &BootJson,
        title: &str,
        time: Option<&str>,
        generation: Option<&str>,
    ) -> Result<String> {
        let mut out = format!("{}{title}\ncomment: ", "/".repeat(depth));
        if let Some(generation) = generation {
            write!(out, "{generation}, ")?;
        }
        out += &boot.spec.label;
        if let Some(time) = time {
            write!(out, ", built on {time}")?;
        }
        out += "\n";
        out += &self.linux_payload(boot, title)?;
        Ok(out)
    }

    fn linux_payload(&mut self, boot: &BootJson, title: &str) -> Result<String> {
        let spec = &boot.spec;
        if let Some(payload) = self.payloads.get(&spec.toplevel) {
            return Ok(payload.clone());
        }

        let mut out = String::from("protocol: linux\n");
        writeln!(
            out,
            "kernel_path: {}",
            self.files
                .copied_path_uri(spec.kernel.as_ref(), "kernels")?
        )?;
        writeln!(out, "cmdline: {}", spec.cmdline())?;
        if let Some(resolution) = &self.config.resolution {
            writeln!(out, "resolution: {resolution}")?;
        }
        self.write_initrds(&mut out, boot)?;
        if let Some(script) = &spec.initrd_secrets
            && let Some(uri) = self.initrd_secrets(script, &spec.toplevel, title)?
        {
            writeln!(out, "module_path: {uri}")?;
        }

        self.payloads.insert(spec.toplevel.clone(), out.clone());
        Ok(out)
    }

    fn write_initrds(&mut self, out: &mut String, boot: &BootJson) -> Result<()> {
        if let Some(initrd) = &boot.spec.initrd {
            writeln!(
                out,
                "module_path: {}",
                self.files.copied_path_uri(initrd.as_ref(), "kernels")?
            )?;
        }
        for path in boot.extra_initrd_paths() {
            writeln!(out, "module_path: boot():/{path}")?;
        }
        Ok(())
    }

    /// Runs the initrd secrets script of `toplevel` and installs the archive it creates.
    fn initrd_secrets(
        &mut self,
        script: &str,
        toplevel: &str,
        title: &str,
    ) -> Result<Option<String>> {
        let name = format!("{}-secrets", file_name(Path::new(toplevel)));
        let relative = Path::new("kernels").join(&name);
        let kernels_dir = self.files.install_dir().join("kernels");
        let dest = self.files.install_dir().join(&relative);
        // Created before the umask below, which would leave it unsearchable.
        fs::create_dir_all(kernels_dir)?;
        let temp_dir = TempDir::new()?;
        let archive = temp_dir.0.join(&name);

        let _umask = Umask::set(0o137);
        let status = Command::new(script)
            .arg(&archive)
            .status()
            .with_context(|| format!("failed to run {script}"))?;
        if !status.success() {
            eprintln!("warning: failed to create initrd secrets for \"{title}\"");
            eprintln!("note: if this is an older generation there is nothing to worry about");
        }
        if !archive.exists() {
            return Ok(None);
        }
        self.files.copy_file(&archive, &dest)?;
        self.files.path_uri(&dest, &relative).map(Some)
    }

    fn xen_entry(
        &mut self,
        boot: &BootJson,
        xen: &Xen,
        version: &str,
        generation: u64,
        time: &str,
        efi: bool,
    ) -> Result<String> {
        let spec = &boot.spec;
        let suffix = if efi { " EFI" } else { "" };
        let mut out = format!("//Generation {generation} with Xen {version}{suffix}\n");
        writeln!(
            out,
            "comment: Xen {version} {}, built on {time}",
            spec.label
        )?;

        let multiboot = Path::new(&xen.multiboot_path);
        if xen.multiboot_path.is_empty() || !multiboot.exists() {
            return Ok(out);
        }
        let target = format!("xen/{generation}");

        if efi {
            // Limine cannot boot Xen through multiboot2 (limine#482), and multiboot1 does not
            // work under EFI, so chainload Xen's EFI binary with a generated xen.cfg instead.
            out += "protocol: efi\n";
            writeln!(
                out,
                "path: {}",
                self.xen_efi_files(boot, xen, &target, generation)?
            )?;
            return Ok(out);
        }

        // multiboot2 does not work for Xen under Limine (limine#483).
        out += "protocol: multiboot\n";
        writeln!(
            out,
            "path: {}",
            self.files.copied_path_uri(multiboot, &target)?
        )?;
        // Xen skips the first word of multiboot command lines, which normally names the image.
        if !xen.params.is_empty() {
            writeln!(out, "cmdline: -- {}", join_params(&xen.params))?;
        }
        writeln!(
            out,
            "module_path: {}",
            self.files
                .copied_path_uri(spec.kernel.as_ref(), "kernels")?
        )?;
        writeln!(out, "module_string: -- {}", spec.cmdline())?;
        self.write_initrds(&mut out, boot)?;
        Ok(out)
    }

    /// Installs Xen's EFI binary next to the dom0 kernel, initrd and the xen.cfg it reads.
    fn xen_efi_files(
        &mut self,
        boot: &BootJson,
        xen: &Xen,
        target: &str,
        generation: u64,
    ) -> Result<String> {
        let spec = &boot.spec;
        let efi_path = Path::new(&xen.efi_path);
        let uri = self.files.copied_path_uri(efi_path, target)?;

        let mut cfg = format!("default=nixos{generation}\n\n[nixos{generation}]\n");
        if !xen.params.is_empty() {
            writeln!(cfg, "options={}", join_params(&xen.params))?;
        }
        let kernel = self.files.dest_path(spec.kernel.as_ref(), target);
        self.files.copy_file(spec.kernel.as_ref(), &kernel)?;
        writeln!(cfg, "kernel={} {}", file_name(&kernel), spec.cmdline())?;
        if let Some(initrd) = &spec.initrd {
            let dest = self.files.dest_path(initrd.as_ref(), target);
            self.files.copy_file(initrd.as_ref(), &dest)?;
            writeln!(cfg, "ramdisk={}", file_name(&dest))?;
        }

        // Xen's EFI binary reads the configuration named after itself.
        let cfg_path = self.files.dest_path(efi_path, target).with_extension("cfg");
        self.files.write_file(&cfg_path, cfg)?;
        Ok(uri)
    }
}

/// A private directory for the initrd secrets archive, removed on drop.
struct TempDir(PathBuf);

impl TempDir {
    fn new() -> Result<Self> {
        let mut template = env::temp_dir()
            .join("limine-install.XXXXXX")
            .into_os_string()
            .into_vec();
        template.push(0);
        // SAFETY: `template` is a writable NUL-terminated buffer that mkdtemp fills in place.
        if unsafe { libc::mkdtemp(template.as_mut_ptr().cast()) }.is_null() {
            return Err(io::Error::last_os_error()).context("creating a temporary directory");
        }
        template.pop();
        Ok(TempDir(PathBuf::from(OsString::from_vec(template))))
    }
}

impl Drop for TempDir {
    fn drop(&mut self) {
        let _ = fs::remove_dir_all(&self.0);
    }
}

/// Restores the previous umask on drop.
struct Umask(libc::mode_t);

impl Umask {
    fn set(mask: libc::mode_t) -> Self {
        // SAFETY: umask cannot fail.
        Umask(unsafe { libc::umask(mask) })
    }
}

impl Drop for Umask {
    fn drop(&mut self) {
        // SAFETY: umask cannot fail.
        unsafe { libc::umask(self.0) };
    }
}
