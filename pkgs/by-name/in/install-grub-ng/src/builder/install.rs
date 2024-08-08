use std::{
	collections::HashSet,
	fs,
	io::{BufRead, BufReader, BufWriter, Write},
	os::unix::fs::symlink,
	path::{Path, PathBuf},
	process::Command,
};

use eyre::{bail, Context, Result};

use super::Builder;
use crate::config::Config;

impl Builder<'_> {
	pub fn install(&mut self) -> Result<&mut Self> {
		let efi_target = EfiTarget::deduce(&self.config)?;
		let conf = self.config.boot_path.join("grub/grub.cfg");
		let temp = self.config.boot_path.join("grub/grub.cfg.tmp");

		if self.dry_run {
			println!("{}", self.inner);
			return Ok(self);
		}

		fs::write(&temp, &self.inner)?;

		self.append_prepare_config()?;
		self.run_os_prober(&efi_target, &temp)?;

		// Atomically switch to the new config
		fs::rename(&temp, &conf)
			.with_context(|| format!("Cannot rename {} to {}", temp.display(), conf.display()))?;

		self.remove_old_kernels()?;

		let mut grub_state = GrubState::load(&self.config);

		if grub_state.update(&self.config, &efi_target) {
			if std::env::var("NIXOS_INSTALL_GRUB").as_deref() == Ok("1") {
				eprintln!("NIXOS_INSTALL_GRUB env var deprecated, use NIXOS_INSTALL_BOOTLOADER");
				std::env::set_var("NIXOS_INSTALL_BOOTLOADER", "1");
			}

			self.install_bios(&efi_target)?;
			self.install_efi(&efi_target)?;

			grub_state.save()?;
		};

		Ok(self)
	}

	fn append_prepare_config(&self) -> Result<()> {
		let extra_prepare_config = self
			.config
			.extra_prepare_config
			.replace("@bootPath@", &self.config.boot_path.to_string_lossy());

		if !extra_prepare_config.is_empty() {
			Command::new(self.config.shell)
				.arg("-c")
				.arg(extra_prepare_config)
				.status()?;
		}

		Ok(())
	}

	fn run_os_prober(&self, efi_target: &EfiTarget, temp: &Path) -> Result<()> {
		if self.config.use_os_prober {
			return Ok(());
		}

		let target_package = match efi_target {
			EfiTarget::Both { efi, .. } | EfiTarget::EfiOnly { efi, .. } => efi,
			EfiTarget::BiosOnly { bios } => bios,
			EfiTarget::Neither => todo!("This is unhandled in the Perl version!!"),
		};

		let mut cmd = Command::new(self.config.shell);
		cmd.arg("-c").arg(format!(
			"pkgdatadir={target}/share/grub {target}/etc/grub.d/30_os-prober >> {temp}",
			target = target_package.display(),
			temp = temp.display()
		));

		if self.config.save_default() {
			cmd.env("GRUB_SAVEDEFAULT", "true");
		}

		cmd.status()?;

		Ok(())
	}

	fn remove_old_kernels(&self) -> Result<()> {
		// Remove obsolete files from $bootPath/kernels
		let Ok(kernels) = fs::read_dir(self.config.boot_path.join("kernels")) else {
			return Ok(());
		};

		for file in kernels {
			let file = file?;
			let path = file.path();

			// Ignore files we have copied over ourselves
			if self.copied.contains(&path) {
				continue;
			}
			eprintln!("removing obsolete file {}", path.display());
			fs::remove_file(path)?;
		}

		Ok(())
	}

	fn install_bios(&self, efi_target: &EfiTarget) -> Result<()> {
		let Some((bios, bios_target)) = efi_target.bios() else {
			return Ok(());
		};

		// install a symlink so that grub can detect the boot drive
		let tmp_dir = tempfile::tempdir().context("Failed to create temporary space")?;
		symlink(self.config.boot_path, tmp_dir.path().join("boot"))
			.with_context(|| format!("Failed to symlink {}/boot", tmp_dir.path().display()))?;

		for dev in &self.config.devices {
			if *dev == Path::new("nodev") {
				continue;
			}

			eprintln!("installing the GRUB 2 boot loader on {}...", dev.display());

			let install = bios.join("sbin/grub-install");
			let mut cmd = Command::new(&install);
			cmd.arg("--recheck")
				.arg(format!("--root-directory={}", tmp_dir.path().display()))
				.arg(dev.canonicalize()?)
				.args(&self.config.extra_grub_install_args);

			if self.config.force_install {
				cmd.arg("--force");
			}
			if let Some(target) = bios_target {
				cmd.arg(format!("--target={}", target.display()));
			}
			let status = cmd.status()?;

			if !status.success() {
				bail!(
					"{}: installation of GRUB on {} failed: ({status})",
					install.display(),
					dev.display()
				);
			}
		}

		Ok(())
	}

	fn install_efi(&self, efi_target: &EfiTarget) -> Result<()> {
		let Some((efi, efi_target)) = efi_target.efi() else {
			return Ok(());
		};

		eprintln!(
			"installing the GRUB 2 boot loader into {}...",
			self.config.efi_sys_mount_point.display()
		);

		let install = efi.join("sbin/grub-install");
		let mut cmd = Command::new(&install);
		cmd.arg("--recheck")
			.arg(format!("--target={}", efi_target.display()))
			.arg(format!(
				"--boot-directory={}",
				self.config.boot_path.display()
			))
			.arg(format!(
				"--efi-directory={}",
				self.config.efi_sys_mount_point.display()
			))
			.args(&self.config.extra_grub_install_args);

		if self.config.force_install {
			cmd.arg("--force");
		}
		cmd.arg(format!("--bootloader-id={}", self.config.bootloader_id));

		if !self.config.can_touch_efi_variables {
			cmd.arg("--no-nvram");
			if self.config.efi_install_as_removable {
				cmd.arg("--removable");
			}
		}

		let status = cmd.status()?;

		if !status.success() {
			bail!(
				"{}: installation of GRUB EFI into {} failed: ({status})",
				install.display(),
				self.config.efi_sys_mount_point.display()
			);
		}

		Ok(())
	}
}

enum EfiTarget<'a> {
	Both {
		bios: &'a Path,
		bios_target: &'a Path,
		efi: &'a Path,
		efi_target: &'a Path,
	},
	BiosOnly {
		bios: &'a Path,
	},
	EfiOnly {
		efi: &'a Path,
		efi_target: &'a Path,
	},
	Neither,
}
impl<'a> EfiTarget<'a> {
	fn deduce(config: &Config<'a>) -> Result<Self> {
		let Config {
			grub,
			grub_efi,
			grub_target,
			grub_target_efi,
			..
		} = config;

		match (grub, grub_efi, grub_target, grub_target_efi) {
			(Some(bios), Some(efi), Some(bios_target), Some(efi_target)) => Ok(Self::Both {
				bios,
				bios_target,
				efi,
				efi_target,
			}),
			(Some(_), Some(_), _, _) => bail!(
				"EFI can only be installed when target is set; a target is also required then for \
				 non-EFI grub"
			),
			// TODO:
			// It would be safer to disallow non-EFI grub installation if no target is
			// given. If no target is given, then grub auto-detects the target which can
			// lead to errors. E.g. it seems as if grub would auto-detect a EFI target based
			// on the availability of a EFI partition.
			// However, it seems as auto-detection is currently relied on for non-x86_64 and
			// non-i386 architectures in NixOS. That would have to be fixed in the nixos
			// modules first.
			(Some(bios), None, _, _) => Ok(Self::BiosOnly { bios }),
			(None, Some(efi), _, Some(efi_target)) => Ok(Self::EfiOnly { efi, efi_target }),
			(None, Some(_), _, _) => bail!("EFI can only be installed when target is set"),
			(None, None, _, _) => Ok(Self::Neither),
		}
	}

	fn efi(&self) -> Option<(&Path, &Path)> {
		match self {
			Self::Both {
				efi, efi_target, ..
			}
			| Self::EfiOnly { efi, efi_target } => Some((efi, efi_target)),
			_ => None,
		}
	}

	fn bios(&self) -> Option<(&Path, Option<&Path>)> {
		match self {
			Self::Both {
				bios, bios_target, ..
			} => Some((bios, Some(bios_target))),
			Self::BiosOnly { bios } => Some((bios, None)),
			_ => None,
		}
	}

	fn to_str(&self) -> &'static str {
		match self {
			Self::Both { .. } => "both",
			Self::BiosOnly { .. } => "no",
			Self::EfiOnly { .. } => "only",
			Self::Neither => "neither",
		}
	}
}

#[derive(Clone, Debug, Default)]
struct GrubState {
	path: PathBuf,

	name: String,
	version: String,
	efi: String,
	devices: Vec<PathBuf>,
	efi_mount_point: PathBuf,
	extra_grub_install_args: Vec<String>,
}
impl GrubState {
	fn load(config: &Config) -> Self {
		let path = config.boot_path.join("grub/state");
		let state = Self::parse(&path).unwrap_or_default();

		Self { path, ..state }
	}

	fn parse(path: &Path) -> Option<Self> {
		let file = fs::File::open(path).ok()?;
		let mut lines = BufReader::new(file).lines();

		let name = lines.next()?.ok()?;
		let version = lines.next()?.ok()?;
		let efi = lines.next()?.ok()?;
		let devices = lines
			.next()?
			.ok()?
			.split(',')
			.map(PathBuf::from)
			.collect::<Vec<_>>();
		let efi_mount_point = PathBuf::from(lines.next()?.ok()?);

		// Historically, arguments in the state file were one per each line, but that
		// gets really messy when newlines are involved, structured arguments
		// like lists are needed (they have to have a separator encoding), or even
		// worse, when we need to remove a setting in the future. Thus, the 6th line is
		// a JSON object that can store structured data, with named keys, and all new
		// state should go in there.
		let json_state = lines.next().and_then(|l| l.ok());
		let json_state = match json_state.as_deref() {
			Some("") | None => "{}", // empty JSON object
			Some(s) => s,
		};

		let GrubJsonState {
			extra_grub_install_args,
		} = serde_json::from_str(json_state).ok()?;

		Some(Self {
			name,
			version,
			efi,
			devices,
			efi_mount_point,
			extra_grub_install_args,
			..Default::default()
		})
	}

	fn save(&self) -> Result<()> {
		let temp = self.path.with_extension("tmp");
		{
			let mut temp = BufWriter::new(fs::File::create(&temp)?);

			writeln!(&mut temp, "{}", self.name)?;
			writeln!(&mut temp, "{}", self.version)?;
			writeln!(&mut temp, "{}", self.efi)?;
			writeln!(
				&mut temp,
				"{}",
				self.devices
					.iter()
					.map(|s| s.to_string_lossy())
					.collect::<Vec<_>>()
					.join(",")
			)?;
			writeln!(&mut temp, "{}", self.efi_mount_point.display())?;

			serde_json::to_writer(&mut temp, &GrubJsonState {
				extra_grub_install_args: self.extra_grub_install_args.clone(),
			})?;
			writeln!(&mut temp)?;
		}

		fs::rename(&temp, &self.path).with_context(|| {
			format!(
				"Cannot rename {} to {}",
				temp.display(),
				self.path.display()
			)
		})?;

		Ok(())
	}

	fn update(&mut self, config: &Config, efi_target: &EfiTarget) -> bool {
		let mut dirty = false;

		let device_targets = config.devices.iter().copied().collect::<HashSet<_>>();
		let prev_device_targets = self
			.devices
			.iter()
			.map(|p| p.as_ref())
			.collect::<HashSet<_>>();

		if !device_targets.is_disjoint(&prev_device_targets) {
			dirty = true;
			self.devices = config.devices.iter().map(|&p| p.to_owned()).collect();
		}

		let extra_grub_install_args = config
			.extra_grub_install_args
			.iter()
			.copied()
			.collect::<HashSet<_>>();
		let prev_extra_grub_install_args = self
			.extra_grub_install_args
			.iter()
			.map(|p| p.as_ref())
			.collect::<HashSet<_>>();
		if !extra_grub_install_args.is_disjoint(&prev_extra_grub_install_args) {
			dirty = true;
			self.extra_grub_install_args = config
				.extra_grub_install_args
				.iter()
				.map(|&p| p.to_owned())
				.collect();
		}

		if config.full_name != self.name {
			dirty = true;
			config.full_name.clone_into(&mut self.name);
		}
		if config.full_version != self.version {
			dirty = true;
			config.full_version.clone_into(&mut self.version);
		}
		if efi_target.to_str() != self.efi {
			dirty = true;
			efi_target.to_str().clone_into(&mut self.efi);
		}
		if config.efi_sys_mount_point != self.efi_mount_point {
			dirty = true;
			config
				.efi_sys_mount_point
				.clone_into(&mut self.efi_mount_point);
		}

		dirty
	}
}

#[derive(Clone, Debug, serde::Deserialize, serde::Serialize)]
#[serde(rename_all = "camelCase")]
struct GrubJsonState {
	#[serde(default)]
	extra_grub_install_args: Vec<String>,
}
