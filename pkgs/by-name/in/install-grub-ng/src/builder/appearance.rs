use std::{collections::HashSet, fmt::Write as _, fs, path::PathBuf};

use eyre::{Result, WrapErr, bail};
use walkdir::WalkDir;

use super::{Builder, unless_dry_run};
use crate::config::Config;

impl Builder<'_> {
	pub fn appearance(&mut self) -> Result<&mut Self> {
		self.append_font().context("Writing font settings")?;
		self.append_splash().context("Writing splash settings")?;
		self.append_theme().context("Writing theme settings")?;
		self.append_extra_config().context("Writing extra config")?;

		Ok(self)
	}

	pub fn append_font(&mut self) -> Result<()> {
		let Config {
			font,
			boot_path,
			gfx_mode_efi,
			gfx_payload_efi,
			gfx_mode_bios,
			gfx_payload_bios,
			..
		} = &self.config;

		let new_font = "converted-font.pf2";
		let font_path = boot_path.join(new_font);

		unless_dry_run(|| {
			fs::copy(font, font_path).with_context(|| {
				format!("Cannot copy {} to {}", font.display(), boot_path.display())
			})?;
			Ok(())
		})?;

		writeln!(
			&mut self.inner,
			r#"insmod font
if loadfont {font}; then
  insmod gfxterm
  if [ "${{grub_platform}}" = "efi" ]; then
    set gfxmode={gfx_mode_efi}
    set gfxpayload={gfx_payload_efi}
  else
    set gfxmode={gfx_mode_bios}
    set gfxpayload={gfx_payload_bios}
  fi
  terminal_output gfxterm
fi
"#,
			font = self.grub_boot.path.join(new_font).display(),
		)?;

		Ok(())
	}

	pub fn append_splash(&mut self) -> Result<()> {
		let Config {
			splash_image,
			background_color,
			boot_path,
			splash_mode,
			..
		} = &self.config;

		let Some(splash_image) = splash_image else {
			return Ok(());
		};

		let Some(ext) = splash_image.extension() else {
			bail!("Splash image has no extension - could not decide which module to load!")
		};
		let Some(ext) = ext.to_str() else {
			bail!("Extension is not UTF-8");
		};

		let mut target = PathBuf::from("background");
		target.set_extension(match ext {
			"jpg" => "jpeg",
			other => other,
		});

		if !background_color.is_empty() {
			writeln!(&mut self.inner, "background_color '{background_color}'")?;
		}

		unless_dry_run(|| {
			fs::copy(splash_image, boot_path.join(&target)).with_context(|| {
				format!(
					"Cannot copy {} to {}",
					splash_image.display(),
					boot_path.display()
				)
			})?;
			Ok(())
		})?;

		writeln!(
			&mut self.inner,
			r#"insmod {ext}
if background_image --mode '{splash_mode}' {target}; then
  set color_normal=white/black
  set color_highlight=black/white
else
  set menu_color_normal=cyan/blue
  set menu_color_highlight=white/blue
fi
"#,
			target = self.grub_boot.path.join(target).display(),
		)?;

		Ok(())
	}

	pub fn append_theme(&mut self) -> Result<()> {
		let Config {
			boot_path, theme, ..
		} = &self.config;
		let theme_dir = boot_path.join("theme");

		if theme_dir.exists() {
			unless_dry_run(|| {
				fs::remove_dir_all(&theme_dir).with_context(|| {
					format!("Cannot clean up theme folder in {}", boot_path.display())
				})
			})?;
		}

		let Some(theme) = theme else {
			return Ok(());
		};

		let mut modules_to_load = HashSet::new();
		let mut fonts = vec![];

		// TODO: Could be parallelized
		for entry in WalkDir::new(theme) {
			let entry = entry?;
			let relative = entry.path().strip_prefix(theme)?;

			if let Some(ext) = entry.path().extension().and_then(|e| e.to_str()) {
				match ext {
					"png" => _ = modules_to_load.insert("png"),
					"jpeg" | "jpg" => _ = modules_to_load.insert("jpeg"),
					"pf2" => fonts.push(relative.to_owned()),
					_ => {}
				}
			}

			unless_dry_run(|| {
				fs::copy(entry.path(), theme_dir.join(relative))?;
				Ok(())
			})?;
		}

		for module in modules_to_load {
			writeln!(&mut self.inner, "insmod {module}")?;
		}

		let mut boot_font_path = self.grub_boot.path.join("theme");

		writeln!(
			&mut self.inner,
			r#"# Sets theme.
set theme={}
export theme
# Load theme fonts, if any
"#,
			boot_font_path.join("theme.txt").display(),
		)?;

		for font in fonts {
			boot_font_path.push(font);
			write!(&mut self.inner, "loadfont {}", boot_font_path.display())?;
			boot_font_path.pop();
		}

		Ok(())
	}

	pub fn append_extra_config(&mut self) -> Result<()> {
		writeln!(&mut self.inner, "{}\n", self.config.extra_config)?;
		Ok(())
	}
}
