use std::{
	collections::HashSet,
	fs,
	io::{BufRead, BufReader, BufWriter, Write},
	os::unix::fs::symlink,
	path::{Path, PathBuf},
	process::Command,
};

use eyre::{Context, Result, bail, eyre};

use super::{Builder, unless_dry_run};
use crate::config::{BiosTarget, Config, EfiTarget, Target};

impl Builder<'_> {
	pub fn install(&mut self) -> Result<&mut Self> {
		println!("{}", self.inner);

		unless_dry_run(|| {
			let conf = self.config.boot_path.join("grub/grub.cfg");
			let temp = self.config.boot_path.join("grub/grub.cfg.tmp");

			eprintln!("{}", conf.display());

			let mut tempfile = fs::File::options()
				.create(true)
				.append(true)
				.open(&temp)
				.context("Failed to create temporary config file")?;

			tempfile
				.write(self.inner.as_ref())
				.context("Failed to write config to temporary config file")?;

			self.append_prepare_config()
				.context("While writing prepare config")?;
			self.run_os_prober(tempfile)
				.context("While running os-prober")?;

			// Atomically switch to the new config
			fs::rename(&temp, &conf).with_context(|| {
				format!(
					"Cannot move temporary config file {} to {}",
					temp.display(),
					conf.display()
				)
			})?;

			self.remove_old_kernels()
				.context("While removing old kernel images")?;

			let mut grub_state = GrubState::load(&self.config);

			if grub_state.update(&self.config, &self.config.target) {
				if std::env::var("NIXOS_INSTALL_GRUB").as_deref() == Ok("1") {
					eprintln!(
						"NIXOS_INSTALL_GRUB env var deprecated, use NIXOS_INSTALL_BOOTLOADER"
					);
					std::env::set_var("NIXOS_INSTALL_BOOTLOADER", "1");
				}

				if let Some(bios) = &self.config.target.bios {
					self.install_bios(bios)
						.context("While installing GRUB to BIOS")?;
				}
				if let Some(efi) = &self.config.target.efi {
					self.install_efi(efi)
						.context("While installing EFI to BIOS")?;
				}

				grub_state.save()?;
			} else {
				eprintln!("GRUB state has not been modified - skipping installation")
			};

			Ok(())
		})?;

		Ok(self)
	}

	fn append_prepare_config(&self) -> Result<()> {
		let Some(boot_path) = self.config.boot_path.to_str() else {
			bail!("Boot path is not UTF-8");
		};

		let extra_prepare_config = self
			.config
			.extra_prepare_config
			.replace("@bootPath@", boot_path);

		if !extra_prepare_config.is_empty() {
			Command::new(self.config.shell)
				.arg("-c")
				.arg(extra_prepare_config)
				.status()?;
		}

		Ok(())
	}

	fn run_os_prober(&self, temp: fs::File) -> Result<()> {
		if !self.config.use_os_prober {
			return Ok(());
		}

		let target_package = if let Some(efi) = &self.config.target.efi {
			efi.package
		} else if let Some(bios) = &self.config.target.bios {
			bios.package
		} else {
			bail!("GRUB has to be installed to either EFI or BIOS to run os-prober");
		};

		// Using the shell is stinky.
		let os_prober = target_package.join("etc/grub.d/30_os-prober");
		let pkg_data_dir = target_package.join("share/grub");

		let mut cmd = Command::new(&os_prober);
		cmd.stdout(temp).env("pkgdatadir", &pkg_data_dir);

		if self.config.save_default() {
			cmd.env("GRUB_SAVEDEFAULT", "true");
		}

		let status = cmd.status().context("Failed to spawn os-prober")?;

		if !status.success() {
			bail!("os-prober failed with error: {status}");
		}

		Ok(())
	}

	fn remove_old_kernels(&self) -> Result<()> {
		// Remove obsolete files from $bootPath/kernels
		if let Ok(kernels) = fs::read_dir(self.config.boot_path.join("kernels")) {
			for file in kernels {
				let file = file?;
				let path = file.path();

				// Ignore files we have copied over ourselves
				if self.copied.contains(&path) {
					continue;
				}
				eprintln!("removing obsolete file {}", path.display());
				fs::remove_file(path).context("Failed to remove kernel file")?;
			}
		}

		Ok(())
	}

	fn install_bios(&self, bios: &BiosTarget) -> Result<()> {
		// install a symlink so that grub can detect the boot drive
		let tmp_dir = tempfile::tempdir().context("Failed to create temporary space")?;
		symlink(self.config.boot_path, tmp_dir.path().join("boot"))
			.with_context(|| format!("Failed to symlink {}/boot", tmp_dir.path().display()))?;

		for dev in &self.config.devices {
			if *dev == Path::new("nodev") {
				continue;
			}

			eprintln!("installing the GRUB 2 boot loader on {}...", dev.display());

			let install = bios.package.join("sbin/grub-install");
			let mut cmd = Command::new(&install);
			let dev = dev
				.canonicalize()
				.with_context(|| format!("Failed to canonicalize device path {}", dev.display()))?;

			cmd.arg("--recheck")
				.arg(format!("--root-directory={}", tmp_dir.path().display()))
				.arg(&dev)
				.args(&self.config.extra_grub_install_args);

			if self.config.force_install {
				cmd.arg("--force");
			}
			if let Some(target) = bios.target {
				cmd.arg(format!("--target={}", target.display()));
			}
			let status = cmd
				.status()
				.context("Failed to start grub-install command")?;

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

	fn install_efi(&self, efi: &EfiTarget) -> Result<()> {
		eprintln!(
			"installing the GRUB 2 boot loader into {}...",
			self.config.efi_sys_mount_point.display()
		);

		let install = efi.package.join("sbin/grub-install");
		let mut cmd = Command::new(&install);
		cmd.arg("--recheck")
			.arg(format!("--target={}", efi.target.display()))
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

		let status = cmd
			.status()
			.context("Failed to start grub-install command")?;

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
					.map(|s| s.to_str().ok_or(eyre!("Device path is not UTF-8")))
					.collect::<Result<Vec<_>>>()?
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

	fn update(&mut self, config: &Config, efi_target: &Target) -> bool {
		let mut dirty = false;

		let device_targets = config.devices.iter().copied().collect::<HashSet<_>>();
		let prev_device_targets = self
			.devices
			.iter()
			.map(|p| p.as_ref())
			.collect::<HashSet<_>>();

		// Devices differ
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

		// Install args differ
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
