use std::{borrow::Cow, collections::HashMap, path::Path};

use eyre::{Context, Result};
use serde::{Deserialize, Deserializer, de};

#[derive(Deserialize)]
#[serde(rename_all = "camelCase")]
pub struct Config<'a> {
	#[serde(flatten)]
	pub target: Target<'a>,

	pub extra_config: &'a str,
	pub extra_prepare_config: &'a str,
	pub extra_per_entry_config: &'a str,
	pub extra_entries: &'a str,
	#[serde(rename = "extraEntriesBeforeNixOS")]
	pub extra_entries_before_nixos: bool,

	#[serde(deserialize_with = "empty_is_none")]
	pub splash_image: Option<&'a Path>,
	pub splash_mode: SplashMode,
	pub background_color: &'a str,

	pub entry_options: &'a str,
	pub sub_entry_options: &'a str,

	pub configuration_limit: usize,
	pub copy_kernels: bool,

	pub timeout: Timeout,
	pub timeout_style: TimeoutStyle,

	#[serde(rename = "default")]
	pub default_entry: &'a str,
	pub fs_identifier: FsIdentifier,

	pub boot_path: &'a Path,
	pub store_path: &'a Path,
	pub store_dir: &'a Path,

	#[serde(rename = "gfxmodeEfi")]
	pub gfx_mode_efi: &'a str,
	#[serde(rename = "gfxmodeBios")]
	pub gfx_mode_bios: &'a str,
	#[serde(rename = "gfxpayloadEfi")]
	pub gfx_payload_efi: &'a str,
	#[serde(rename = "gfxpayloadBios")]
	pub gfx_payload_bios: &'a str,

	pub font: &'a Path,
	#[serde(deserialize_with = "empty_is_none")]
	pub theme: Option<&'a Path>,
	pub shell: &'a Path,
	pub path: &'a str,

	pub users: Users<'a>,

	#[serde(rename = "useOSProber")]
	pub use_os_prober: bool,

	pub can_touch_efi_variables: bool,
	pub efi_install_as_removable: bool,
	pub efi_sys_mount_point: &'a Path,

	pub bootloader_id: &'a str,
	pub force_install: bool,

	pub devices: Vec<&'a Path>,
	pub extra_grub_install_args: Vec<&'a str>,
	pub full_name: &'a str,
	pub full_version: &'a str,
}

#[derive(Clone, Debug, Deserialize)]
pub struct Users<'a>(#[serde(borrow)] pub HashMap<&'a str, Password<'a>>);

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Password<'a> {
	pub content: Cow<'a, str>,
	pub is_hashed: bool,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "camelCase")]
pub enum FsIdentifier {
	Uuid,
	Label,
	Provided,
}

#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Timeout(pub Option<u64>);

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "camelCase")]
pub enum TimeoutStyle {
	Menu,
	Countdown,
	Hidden,
}

#[derive(Clone, Copy, Debug, Deserialize, PartialEq, Eq)]
#[serde(rename_all = "camelCase")]
pub enum SplashMode {
	Normal,
	Stretch,
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct Target<'a> {
	pub bios: Option<BiosTarget<'a>>,
	pub efi: Option<EfiTarget<'a>>,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct BiosTarget<'a> {
	pub package: &'a Path,
	pub target: Option<&'a Path>,
}
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct EfiTarget<'a> {
	pub package: &'a Path,
	pub target: &'a Path,
}

impl Config<'_> {
	pub fn save_default(&self) -> bool {
		self.default_entry == "saved"
	}
}

fn empty_is_none<'de, D>(deserializer: D) -> Result<Option<&'de Path>, D::Error>
where
	D: Deserializer<'de>,
{
	<&Path as Deserialize>::deserialize(deserializer).map(|r| {
		if r.as_os_str().is_empty() {
			None
		} else {
			Some(r)
		}
	})
}

impl<'a, 'de: 'a> Deserialize<'de> for Password<'a> {
	fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
	where
		D: serde::Deserializer<'de>,
	{
		// TODO: This sucks. It should've just been an attrTag in the nix code, but it
		// predates that...

		#[derive(Deserialize)]
		#[serde(rename_all = "camelCase")]
		struct PasswordInner<'a> {
			password: Option<&'a str>,
			password_file: Option<&'a Path>,
			hashed_password: Option<&'a str>,
			hashed_password_file: Option<&'a Path>,
		}
		let password = PasswordInner::deserialize(deserializer)?;

		let password = if let Some(file) = password.hashed_password_file {
			Self {
				content: std::fs::read_to_string(file)
					.context("While reading hashed password file")
					.map_err(de::Error::custom)?
					.into(),
				is_hashed: true,
			}
		} else if let Some(text) = password.hashed_password {
			Self {
				content: text.into(),
				is_hashed: true,
			}
		} else if let Some(file) = password.password_file {
			Self {
				content: std::fs::read_to_string(file)
					.context("While reading hashed password file")
					.map_err(de::Error::custom)?
					.into(),
				is_hashed: false,
			}
		} else if let Some(text) = password.password {
			Self {
				content: text.into(),
				is_hashed: false,
			}
		} else {
			return Err(de::Error::custom("No password found"));
		};

		if password.is_hashed && !password.content.starts_with("grub.pbkdf2") {
			return Err(de::Error::custom(format!(
				"Invalid hashed password ('{}'): hashes should always start with `grub.pbkdf2`!",
				password.content
			)));
		}

		Ok(password)
	}
}

impl<'de> Deserialize<'de> for Timeout {
	fn deserialize<D>(deserializer: D) -> Result<Timeout, D::Error>
	where
		D: Deserializer<'de>,
	{
		struct Visitor;
		impl<'de> de::Visitor<'de> for Visitor {
			type Value = Timeout;

			fn expecting(&self, formatter: &mut std::fmt::Formatter) -> std::fmt::Result {
				write!(formatter, "either -1 or an unsigned 64-bit integer")
			}

			fn visit_i64<E>(self, v: i64) -> Result<Self::Value, E>
			where
				E: de::Error,
			{
				if v == -1 {
					Ok(Timeout(None))
				} else {
					Err(de::Error::invalid_value(de::Unexpected::Signed(v), &self))
				}
			}

			fn visit_u64<E>(self, v: u64) -> Result<Self::Value, E>
			where
				E: de::Error,
			{
				Ok(Timeout(Some(v)))
			}
		}

		deserializer.deserialize_any(Visitor)
	}
}

impl std::fmt::Display for Timeout {
	fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
		match self.0 {
			Some(t) => write!(f, "{t}"),
			None => write!(f, "-1"),
		}
	}
}

impl std::fmt::Display for TimeoutStyle {
	fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
		f.write_str(match self {
			Self::Menu => "menu",
			Self::Countdown => "countdown",
			Self::Hidden => "hidden",
		})
	}
}

impl std::fmt::Display for SplashMode {
	fn fmt(&self, f: &mut std::fmt::Formatter) -> std::fmt::Result {
		f.write_str(match self {
			Self::Normal => "normal",
			Self::Stretch => "stretch",
		})
	}
}

impl<'a> Target<'a> {
	pub(crate) fn to_str(&self) -> &'static str {
		match (&self.bios, &self.efi) {
			(Some(_), Some(_)) => "both",
			(Some(_), None) => "no",
			(None, Some(_)) => "only",
			(None, None) => "neither",
		}
	}
}

impl<'a, 'de: 'a> Deserialize<'de> for Target<'a> {
	fn deserialize<D>(deserializer: D) -> Result<Self, D::Error>
	where
		D: Deserializer<'de>,
	{
		#[derive(Deserialize)]
		#[serde(rename_all = "camelCase")]
		struct TargetInner<'a> {
			#[serde(deserialize_with = "empty_is_none", borrow)]
			pub grub: Option<&'a Path>,
			#[serde(deserialize_with = "empty_is_none", borrow)]
			pub grub_target: Option<&'a Path>,
			#[serde(deserialize_with = "empty_is_none", borrow)]
			pub grub_efi: Option<&'a Path>,
			#[serde(deserialize_with = "empty_is_none", borrow)]
			pub grub_target_efi: Option<&'a Path>,
		}

		let inner = TargetInner::deserialize(deserializer)?;

		match inner {
			TargetInner {
				grub: Some(bios),
				grub_efi: Some(efi),
				grub_target,
				grub_target_efi,
			} => match (grub_target, grub_target_efi) {
				(Some(bios_target), Some(efi_target)) => Ok(Self {
					bios: Some(BiosTarget {
						package: bios,
						target: Some(bios_target),
					}),
					efi: Some(EfiTarget {
						package: efi,
						target: efi_target,
					}),
				}),
				_ => Err(de::Error::custom(
					"EFI can only be installed when target is set; a target is also required then \
					 for non-EFI grub",
				)),
			},
			// TODO:
			// It would be safer to disallow non-EFI grub installation if no target is
			// given. If no target is given, then grub auto-detects the target which can
			// lead to errors. E.g. it seems as if grub would auto-detect a EFI target based
			// on the availability of a EFI partition.
			// However, it seems as auto-detection is currently relied on for non-x86_64 and
			// non-i386 architectures in NixOS. That would have to be fixed in the nixos
			// modules first.
			TargetInner {
				grub: Some(bios),
				grub_efi: None,
				..
			} => Ok(Self {
				bios: Some(BiosTarget {
					package: bios,
					target: None,
				}),
				efi: None,
			}),
			TargetInner {
				grub: None,
				grub_efi: Some(efi),
				grub_target_efi,
				..
			} => match grub_target_efi {
				Some(efi_target) => Ok(Self {
					bios: None,
					efi: Some(EfiTarget {
						package: efi,
						target: efi_target,
					}),
				}),
				None => Err(de::Error::custom(
					"EFI can only be installed when target is set",
				)),
			},
			TargetInner {
				grub: None,
				grub_efi: None,
				..
			} => Ok(Self {
				bios: None,
				efi: None,
			}),
		}
	}
}
