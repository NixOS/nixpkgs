use std::{borrow::Cow, collections::HashMap, iter::Iterator, path::Path};

use eyre::{bail, eyre, Context, Result};
use roxmltree::{Document, Node};

use crate::grub::FsIdentifier;

config! {
  'a;
  grub: Option<&'a Path> => grub,
  grub_target: Option<&'a Path> => grubTarget,
  grub_efi: Option<&'a Path> => grubEfi,
  grub_target_efi: Option<&'a Path> => grubTargetEfi,

  extra_config: &'a str => extraConfig,
  extra_prepare_config: &'a str => extraPrepareConfig,
  extra_per_entry_config: Option<&'a str> => extraPerEntryConfig,
  extra_entries: &'a str => extraEntries,
  extra_entries_before_nixos: bool => extraEntriesBeforeNixOS,

  splash_image: Option<&'a Path> => splashImage,
  splash_mode: Option<&'a str> => splashMode,
  background_color: Option<&'a str> => backgroundColor,

  entry_options: &'a str => entryOptions,
  sub_entry_options: &'a str => subEntryOptions,

  configuration_limit: usize => configurationLimit,
  copy_kernels: bool => copyKernels,

  timeout: i32 => timeout,
  timeout_style: &'a str => timeoutStyle,

  default_entry: &'a str => default,
  fs_identifier: FsIdentifier => fsIdentifier,

  boot_path: &'a Path => bootPath,
  store_path: &'a Path => storePath,

  gfx_mode_efi: &'a str => gfxmodeEfi,
  gfx_mode_bios: &'a str => gfxmodeBios,
  gfx_payload_efi: &'a str => gfxpayloadEfi,
  gfx_payload_bios: &'a str => gfxpayloadBios,

  font: &'a Path => font,
  theme: Option<&'a Path> => theme,
  shell: &'a Path => shell,
  path: &'a str => path,

  users: Users<'a> => users,

  use_os_prober: bool => useOSProber,

  can_touch_efi_variables: bool => canTouchEfiVariables,
  efi_install_as_removable: bool => efiInstallAsRemovable,
  efi_sys_mount_point: &'a Path => efiSysMountPoint,

  bootloader_id: &'a str => bootloaderId,
  force_install: bool => forceInstall,

  devices: Vec<&'a Path> => devices,
  extra_grub_install_args: Vec<&'a str> => extraGrubInstallArgs,
  full_name: &'a str => fullName,
  full_version: &'a str => fullVersion,
}

impl Config<'_> {
	pub fn save_default(&self) -> bool {
		self.default_entry == "saved"
	}
}

pub trait NodeExt<'a, 'input: 'a> {
	fn to<T: FromNode<'a, 'input>>(self) -> Result<T>;
}
pub trait FromNode<'a, 'input: 'a>: Sized {
	fn from_node(node: Node<'a, 'input>) -> Result<Self>;
}

#[derive(Clone, Debug)]
pub struct Users<'a>(pub HashMap<&'a str, Password<'a>>);

#[derive(Clone, Debug, PartialEq, Eq)]
pub enum Password<'a> {
	Plain(Cow<'a, str>),
	Hashed(Cow<'a, str>),
}

//= Implementation =//

macro_rules! config {
  ($lifetime:lifetime; $($field:ident : $ty:ty => $key:ident),*$(,)?) => {
    #[derive(Debug, Clone)]
    pub struct Config<$lifetime> {
      $(
        pub $field: $ty
      ),*
    }

    impl<'a> Config<'a> {
	    pub fn new<'input: 'a>(doc: &'a Document<'input>) -> Result<Self> {
	    	let root_elem = doc.root_element();
	    	if root_elem.tag_name().name() != "expr" {
		        bail!("Root node of config is not <expr>");
	    	}

	    	let Some(root_attrs) = root_elem.first_element_child() else {
                bail!("Root <expr> is empty");
	    	};

	    	let root_attrs = root_attrs.to::<AttrsNode>()?;

		    Ok(Self {$(
          $field: root_attrs.attr_to::<$ty>(stringify!($key))?
        ),*})
	    }
    }
  }
}
use config;

impl<'a, 'input: 'a> NodeExt<'a, 'input> for Node<'a, 'input> {
	fn to<T: FromNode<'a, 'input>>(self) -> Result<T> {
		T::from_node(self)
	}
}

struct AttrsNode<'a, 'input> {
	node: Node<'a, 'input>,
}
impl<'a, 'input> AttrsNode<'a, 'input> {
	fn attr(&self, key: &'input str) -> Result<Node<'a, 'input>> {
		self.node
			.children()
			.find(|c| c.tag_name().name() == "attr" && c.attribute("name") == Some(key))
			.and_then(|c| c.first_element_child())
			.ok_or_else(|| eyre!("Key `{key}` not found in attrs"))
	}

	fn attr_to<T: FromNode<'a, 'input>>(&self, key: &'input str) -> Result<T> {
		let attr = self.attr(key)?;
		let attr =
			T::from_node(attr).with_context(|| format!("While trying to read attr `{key}`"))?;
		Ok(attr)
	}

	fn attrs(&self) -> impl Iterator<Item = (&'a str, Node<'a, 'input>)> {
		self.node
			.children()
			.filter(|c| c.tag_name().name() == "attr")
			.filter_map(|c| c.attribute("name").zip(c.first_element_child()))
	}
}

impl<'a, 'input: 'a> FromNode<'a, 'input> for Users<'a> {
	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		node.to::<AttrsNode>()?
			.attrs()
			.map(|(user, node)| {
				let fields = node.to::<AttrsNode>()?;

				let hashed_password_file = fields.attr_to::<&Path>("hashedPasswordFile");
				let hashed_password = fields.attr_to::<&str>("hashedPassword");
				let password_file = fields.attr_to::<&Path>("passwordFile");
				let password = fields.attr_to::<&str>("password");

				let password = if let Ok(f) = hashed_password_file {
					let f = std::fs::read_to_string(f).with_context(|| {
						format!("While trying to read hashed password file for user {user}")
					})?;
					Password::Hashed(f.into())
				} else if let Ok(f) = hashed_password {
					Password::Hashed(f.into())
				} else if let Ok(f) = password_file {
					let f = std::fs::read_to_string(f).with_context(|| {
						format!("While trying to read plain password file for user {user}")
					})?;
					Password::Plain(f.into())
				} else if let Ok(f) = password {
					Password::Plain(f.into())
				} else {
					bail!("Password not found for user {user}!")
				};

				match password {
					Password::Hashed(hash) if !hash.starts_with("grub.pbkdf2") => Err(eyre!(
						"Invalid hashed password for user {user}: {hash} - hashes should always \
						 start with `grub.pbkdf2!`"
					)),

					p => Ok((user, p)),
				}
			})
			.collect::<Result<HashMap<_, _>, _>>()
			.map(Users)
	}
}

impl<'a, 'input: 'a> FromNode<'a, 'input> for FsIdentifier {
	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		match node.to::<&str>()? {
			"uuid" => Ok(Self::Uuid),
			"label" => Ok(Self::Label),
			"provided" => Ok(Self::Provided),
			s => Err(eyre!("Invalid file system identifier: {s}")),
		}
	}
}

impl<'a, 'input: 'a> FromNode<'a, 'input> for &'a str {
	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		check_tag_name(node, "string", value)
	}
}
impl<'a, 'input: 'a> FromNode<'a, 'input> for Option<&'a str> {
	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		let s = node.to::<&str>()?;
		Ok(if s.is_empty() { None } else { Some(s) })
	}
}
impl<'a, 'input: 'a> FromNode<'a, 'input> for &'a Path {
	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		node.to::<&str>().map(Path::new)
	}
}
impl<'a, 'input: 'a> FromNode<'a, 'input> for Option<&'a Path> {
	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		let s = node.to::<&str>()?;
		Ok(if s.is_empty() {
			None
		} else {
			Some(Path::new(s))
		})
	}
}
impl<'a, 'input: 'a> FromNode<'a, 'input> for bool {
	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		check_tag_name(node, "bool", |node| Ok(value(node)? == "true"))
	}
}
impl<'a, 'input: 'a, T: FromNode<'a, 'input>> FromNode<'a, 'input> for Vec<T> {
	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		check_tag_name(node, "list", |node| {
			node.children()
				.filter(|n| n.is_element())
				.map(T::from_node)
				.collect()
		})
	}
}
impl<'a, 'input: 'a> FromNode<'a, 'input> for AttrsNode<'a, 'input> {
	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		check_tag_name(node, "attrs", |node| Ok(AttrsNode { node }))
	}
}

macro_rules! int_impl {
  ($($ty:ty)*) => {
    $(
      impl<'a, 'input: 'a> FromNode<'a, 'input> for $ty {
      	fn from_node(node: Node<'a, 'input>) -> Result<Self> {
		      check_tag_name(node, "int", |node| {
		      	value(node)?.parse::<$ty>().map_err(|e| eyre!("Invalid int: {e}"))
		      })
      	}
      }
    )*
  }
}
int_impl!(u8 u16 u32 u64 u128 usize i8 i16 i32 i64 i128 isize);

fn check_tag_name<'a, 'input, F, R>(
	node: Node<'a, 'input>,
	expected: &'static str,
	f: F,
) -> Result<R>
where
	'input: 'a,
	F: FnOnce(Node<'a, 'input>) -> Result<R>,
{
	let found = node.tag_name().name();
	if found == expected {
		f(node)
	} else {
		bail!("Found unexpected tag {found}, expecting {expected}");
	}
}

fn value<'a, 'input: 'a>(node: Node<'a, 'input>) -> Result<&'a str> {
	node.attribute("value")
		.ok_or(eyre!("`value` attribute not found"))
}
