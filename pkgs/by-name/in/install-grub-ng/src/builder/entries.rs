use std::{
	cmp::Reverse,
	fmt::Write as _,
	fs,
	os::unix::fs::PermissionsExt,
	path::{Path, PathBuf},
	process::Command,
};

use eyre::{bail, eyre, Context, Result};
use nix::sys::stat::{umask, Mode};
use tempfile::TempDir;

use super::Builder;

impl Builder<'_> {
	pub fn entries(&mut self) -> Result<&mut Self> {
		self.append_default_entries()?;
		self.append_profiles()?;

		Ok(self)
	}

	fn append_default_entries(&mut self) -> Result<()> {
		// extraEntries could refer to @bootRoot@, which we have to substitute
		let extra_entries = self
			.config
			.extra_entries
			.replace("@bootRoot@", &self.grub_boot.path.to_string_lossy());

		if self.config.extra_entries_before_nixos {
			writeln!(&mut self.inner, "{extra_entries}")?;
		}

		self.add_generation(
			env!("DISTRO_NAME"),
			"",
			self.default_config,
			self.config.entry_options,
			true,
		)?;

		if !self.config.extra_entries_before_nixos {
			writeln!(&mut self.inner, "{extra_entries}")?;
		}

		Ok(())
	}

	fn append_profiles(&mut self) -> Result<()> {
		let distro_name = env!("DISTRO_NAME");
		self.add_profile(
			Path::new("/nix/var/nix/profiles/system"),
			&format!("{distro_name} - All configurations"),
		)?;

		if let Ok(system_profiles) = fs::read_dir("/nix/var/nix/profiles/system-profiles") {
			for profile in system_profiles {
				let profile = profile?;
				let file_name = profile.file_name();
				let Some(name) = file_name.to_str() else {
					continue;
				};

				if name.chars().all(|c| c.is_ascii_alphanumeric() || c == '_') {
					self.add_profile(
						&profile.path(),
						&format!("{distro_name} - Profile '{name}'"),
					)?;
				}
			}
		};

		Ok(())
	}

	// Helpers
	fn add_profile(&mut self, profile: &Path, description: &str) -> Result<()> {
		writeln!(
			&mut self.inner,
			r#"submenu "{description}" --class submenu {{"#
		)?;

		let Some(parent) = profile.parent() else {
			bail!("Profile directory should not be root!")
		};
		let Some(name) = profile.file_name() else {
			bail!(
				"Profile `{}` somehow does not have a file name!",
				profile.display()
			)
		};

		let mut links = fs::read_dir(parent)?
			.filter_map(|m| {
				let m = m.ok()?;
				let filename = m.file_name();
				let file = filename.to_string_lossy();

				// Extract the generation from the file name
				// The file name would look something like "system-263-link",
				// here `system` is the profile name.
				let Some((gen, "link")) = file.rsplit_once('-') else {
					return None;
				};
				let (profile, gen) = gen.rsplit_once('-')?;

				if profile == name {
					Some((m.path(), gen.parse::<u32>().ok()?))
				} else {
					None
				}
			})
			.collect::<Vec<_>>();

		links.sort_by_key(|&(_, gen)| Reverse(gen));

		for (link, gen) in links.into_iter().take(self.config.configuration_limit) {
			let Ok(version) = std::fs::read_to_string(link.join("nixos-version")) else {
				eprintln!("skipping corrupt system profile entry '{}'", link.display());
				continue;
			};
			let date = Self::generation_date_from_link(&link)?;

			self.add_generation(
				&format!("{} - Configuration {gen}", env!("DISTRO_NAME")),
				&format!(" ({date} - {version})"),
				&link,
				self.config.sub_entry_options,
				false,
			)?;
		}

		writeln!(&mut self.inner, "}}")?;
		Ok(())
	}

	fn add_generation(
		&mut self,
		name: &str,
		name_suffix: &str,
		path: &Path,
		options: &str,
		current: bool,
	) -> Result<()> {
		// Do not search for grandchildren
		let mut links = if let Ok(links) = fs::read_dir(path.join("specialisation")) {
			links
				.map(|d| d.map(|p| p.path()))
				.collect::<Result<Vec<_>, _>>()?
		} else {
			vec![]
		};

		links.sort();

		if !current && !links.is_empty() {
			writeln!(
				&mut self.inner,
				r#"submenu "> {name}{name_suffix}" --class submenu {{"#
			)?;
		}

		self.add_entry(
			&format!(
				"{name}{}{name_suffix}",
				if !links.is_empty() { " - Default" } else { "" }
			),
			path,
			options,
			current,
		)?;

		// Find all the children of the current default configuration
		// Do not search for grand children
		for link in &links {
			// FIXME:
			// This currently returns 1970-01-01 no matter what.
			// These links seem to be have the correct creation date set, but not their
			// modified date...?
			let date = Self::generation_date_from_link(link)?;

			let version = if let Ok(version) = fs::read_to_string(link.join("nixos-version")) {
				version
			} else {
				let modules = link
					.join("kernel")
					.canonicalize()?
					.parent()
					.ok_or_else(|| {
						eyre!("Somehow {}/kernel doesn't have a parent..?", link.display())
					})?
					.join("lib/modules");

				let Some(version) = fs::read_dir(&modules)?.find_map(|m| {
					m.ok()
						.and_then(|p| Some(p.path().file_name()?.to_string_lossy().into_owned()))
				}) else {
					bail!("Could not deduce the current NixOS version")
				};

				version
			};

			let entry_name =
				fs::read_to_string(link.join("configuration-name")).unwrap_or_else(|_| {
					format!(
						"({} - {date} - {version})",
						link.file_name().unwrap_or_default().to_string_lossy()
					)
				});

			self.add_entry(&format!("{name} - {entry_name}"), link, "", true)?;
		}

		if !current && !links.is_empty() {
			writeln!(&mut self.inner, "}}")?;
		}

		Ok(())
	}

	fn generation_date_from_link(link: &Path) -> Result<time::Date> {
		let sys_time = link.symlink_metadata()?.modified()?;

		Ok(time::OffsetDateTime::from(sys_time).date())
	}

	fn add_entry(&mut self, name: &str, path: &Path, options: &str, current: bool) -> Result<()> {
		let kernel_dir = path.join("kernel");
		let initrd_dir = path.join("initrd");

		if !(kernel_dir.exists() && initrd_dir.exists()) {
			return Ok(());
		}

		let kernel_dir = self.copy_to_kernels_dir(&kernel_dir)?;
		let initrd_dir = self.copy_to_kernels_dir(&initrd_dir)?;

		// Include second initrd with secrets
		let secrets_dir = self
			.append_initrd_secrets(name, path, current)?
			.unwrap_or_default();

		// FIXME: $confName

		let kernel_params = format!(
			"init={} {}",
			path.join("init").canonicalize()?.display(),
			fs::read_to_string(path.join("kernel-params"))?
		);

		let xen = path.join("xen.gz");
		let xen = if xen.exists() {
			Some((
				self.copy_to_kernels_dir(&xen)?,
				fs::read_to_string(path.join("xen-params")).unwrap_or_default(),
			))
		} else {
			None
		};

		writeln!(&mut self.inner, r#"menuentry "{name}" {options} {{"#)?;
		if self.config.save_default() {
			writeln!(&mut self.inner, "  savedefault")?;
		}
		writeln!(&mut self.inner, "{}", self.grub_boot.search)?;
		if let Some(store) = &self.grub_store {
			writeln!(&mut self.inner, "  {}", store.search)?;
		}
		if let Some(conf) = &self.config.extra_per_entry_config {
			writeln!(&mut self.inner, "  {conf}")?;
		}
		if let Some((xen, xen_params)) = xen {
			writeln!(
				&mut self.inner,
				"
  multiboot {xen} {xen_params}
  module {kernel} {kernel_params}
  module {initrd} {secrets}",
				xen = xen.display(),
				kernel = kernel_dir.display(),
				initrd = initrd_dir.display(),
				secrets = secrets_dir.display(),
			)?;
		} else {
			writeln!(
				&mut self.inner,
				"
  linux {kernel} {kernel_params}
  initrd {initrd} {secrets}",
				kernel = kernel_dir.display(),
				initrd = initrd_dir.display(),
				secrets = secrets_dir.display(),
			)?;
		}
		writeln!(&mut self.inner, "}}\n")?;

		Ok(())
	}

	fn append_initrd_secrets(
		&mut self,
		name: &str,
		path: &Path,
		current: bool,
	) -> Result<Option<PathBuf>> {
		let append_initrd_secrets = path.join("append-initrd-secrets");
		let Ok(metadata) = fs::metadata(&append_initrd_secrets) else {
			return Ok(None);
		};

		// Check if it's an executable file
		if !(metadata.is_file() && metadata.permissions().mode() & 0b111 != 0) {
			return Ok(None);
		}

		let canonicalized = path.canonicalize()?;
		let Some(system_name) = canonicalized.file_name().and_then(|s| s.to_str()) else {
			bail!(
				"Entry path {} somehow doesn't have a file name?",
				path.display()
			)
		};

		let kernels = self.config.boot_path.join("kernels");
		let secrets_name = format!("{system_name}-secrets");
		let initrd_secrets_path = kernels.join(&secrets_name);

		let secrets_added = self.dry_run || {
			fs::create_dir_all(&kernels)?;
			fs::set_permissions(&kernels, PermissionsExt::from_mode(0o755))?;

			// Make sure initrd is not world readable (won't work if /boot is FAT)
			let old_umask = umask(Mode::from_bits_truncate(0o137));

			let initrd_secrets_path_temp = TempDir::with_prefix(&secrets_name)?;

			let status = Command::new(&append_initrd_secrets)
				.arg(initrd_secrets_path_temp.path())
				.status()?;

			if !status.success() {
				if current {
					bail!("Failed to create initrd secrets ({status})");
				} else {
					eprintln!(
						"warning: failed to create initrd secrets for \"{name}\", an older \
						 generation"
					);
					eprintln!(
						" note: this is normal after having removed or renamed a file in \
						 `boot.initrd.secrets`"
					);
				}
			}

			// Restore umask
			// Temp dir is automatically cleaned up.
			umask(old_umask);

			// Check whether any secrets were actually added
			if fs::read_dir(&initrd_secrets_path_temp).map_or(0, |i| i.count()) > 0 {
				fs::rename(&initrd_secrets_path_temp, &initrd_secrets_path)
					.context("Failed to move initrd secrets into place")?;

				self.copied.insert(initrd_secrets_path);

				true
			} else {
				false
			}
		};

		Ok(if secrets_added {
			let mut secrets_dir = self.grub_boot.path.join("kernels");
			secrets_dir.push(&secrets_name);
			Some(secrets_dir)
		} else {
			None
		})
	}

	fn copy_to_kernels_dir(&mut self, path: &Path) -> Result<PathBuf> {
		let path = path.canonicalize()?;

		let Ok(path) = path.strip_prefix("/nix/store") else {
			bail!("Path {} is not in /nix/store!", path.display())
		};

		// GRUB store exists, which means the kernels and initrds are on the same
		// filesystem as / and /nix/store. No need to copy!
		if let Some(store) = &self.grub_store {
			return Ok(store.path.join(path));
		}

		let name = path.to_string_lossy().replace('/', "-");
		let mut dst = self.config.boot_path.join("kernels");
		dst.push(&name);

		// Don't copy the file if $dst already exists.  This means that we
		// have to create $dst atomically to prevent partially copied
		// kernels or initrd if this script is ever interrupted.
		if !self.dry_run && !dst.exists() {
			let Some(mut name) = dst.file_name().map(|s| s.to_os_string()) else {
				bail!(
					"Somehow path {} does not have a file name...? This shouldn't be possible!",
					dst.display()
				)
			};
			name.push(".tmp");
			let tmp = dst.with_file_name(name);

			fs::copy(path, &tmp)
				.with_context(|| format!("Cannot copy {} to {}", path.display(), tmp.display()))?;
			fs::rename(&tmp, &dst).with_context(|| {
				format!("Cannot rename {} to {}", path.display(), tmp.display())
			})?;
		}

		self.copied.insert(dst);
		Ok(self.grub_boot.path.join("kernels/name"))
	}
}
