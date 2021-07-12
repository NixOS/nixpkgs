//! "Render" files using tera templates.

use std::fs::File;
use std::io::Write;
use std::path::Path;

use lazy_static::lazy_static;
use serde::Serialize;
use crate::error::Result;
use std::{fmt::Debug, marker::PhantomData};
use tera::{Context, Tera};
use simple_error::SimpleError;
use crate::config_info::ConfigInfo;
use crate::hardware_info::HardwareInfo;

macro_rules! template {
    ($x:expr) => {
        Template {
            template: $x,
            #[cfg(not(debug_assertions))]
            content: include_str!(concat!("../templates/", $x)),
            context: PhantomData,
        }
    };
}


/// The template for generating /etc/nixos/configuration.nix
pub const CONFIGURATION_NIX: Template<ConfigInfo> = template!("configuration.nix.tera");
/// The template for generating /etc/nixos/hardware-configuration.nix
pub const HARDWARE_CONFIGURATION_NIX: Template<HardwareInfo> = template!("hardware-configuration.nix.tera");

/// A predefined template.
#[derive(Debug)]
pub struct Template<C: Serialize + Debug> {
    /// Relative path in the templates directory and template name.
    template: &'static str,
    /// The whole content of the template file in release builds.
    #[cfg(not(debug_assertions))]
    content: &'static str,
    context: PhantomData<C>,
}

impl<C: Serialize + Debug> Template<C> {
    /// Returns the rendered template as a string.
    pub fn render(&self, context: &C) -> Result<String> {
        let res = TERA.render(self.template, &Context::from_serialize(context)?);
        Ok(res.map_err(|e| {
            SimpleError::new(format!("while rendering {}: {:#?}\nContext: {:#?}", self.template, e, context))
        })?)
    }

    /// Writes the rendered template to the given file path.
    pub fn write_to_file(&self, path: impl AsRef<Path>, context: &C) -> Result<()> {
        let mut output_file = File::create(&path)?;
        output_file.write_all(self.render(context)?.as_bytes())?;
        println!(
            "Written {}.",
            path.as_ref().to_string_lossy()
        );
        Ok(())
    }
}

trait AbstractTemplate {
    fn template(&self) -> &'static str;
    #[cfg(not(debug_assertions))]
    fn template_content(&self) -> &'static str;
}

impl<C: Serialize + Debug> AbstractTemplate for Template<C> {
    fn template(&self) -> &'static str {
        self.template
    }

    #[cfg(not(debug_assertions))]
    fn template_content(&self) -> &'static str {
        self.content
    }
}

const TEMPLATES: &[&'static dyn AbstractTemplate] = &[&CONFIGURATION_NIX,
                                                      &HARDWARE_CONFIGURATION_NIX];

fn create_tera() -> Tera {
    let mut tera = Tera::default();

    // For debug builds, we load the templates from the files during runtime.
    #[cfg(debug_assertions)]
    let template_dir = std::env::var("TEMPLATES_DIR")
        .expect("TEMPLATES_DIR environment variable when running in debug mode");
    #[cfg(debug_assertions)]
    for template in TEMPLATES.iter() {
        let path = Path::new(&template_dir).join(template.template());
        tera.add_template_file(path, Some(template.template()))
            .expect("adding template to succeed");
    }

    // For release builds, we compile the template definitions into the binary.
    #[cfg(not(debug_assertions))]
    tera.add_raw_templates(
        TEMPLATES
            .iter()
            .map(|template| (template.template(), template.template_content()))
            .collect::<Vec<_>>(),
    )
    .expect("adding templats to succeed");

    tera.autoescape_on(vec![".nix.tera"]);
    tera.set_escape_fn(escape_nix_string);
    tera
}

lazy_static! {
    static ref TERA: Tera = create_tera();
}

/// Escapes a string as a nix string.
///
/// ```
/// use nixos_generate_config::render::escape_nix_string;
/// assert_eq!("\"abc\"", escape_nix_string("abc"));
/// assert_eq!("\"a\\\"bc\"", escape_nix_string("a\"bc"));
/// assert_eq!("\"a$bc\"", escape_nix_string("a$bc"));
/// assert_eq!("\"a$\"", escape_nix_string("a$"));
/// assert_eq!("\"a\\${bc\"", escape_nix_string("a${bc"));
/// ```
pub fn escape_nix_string(raw_string: &str) -> String {
    let mut ret = String::with_capacity(raw_string.len() + 2);
    ret.push('"');
    let mut peekable_chars = raw_string.chars().peekable();
    while let Some(c) = peekable_chars.next() {
        if c == '\\' || c == '"' || (c == '$' && peekable_chars.peek() == Some(&'{')) {
            ret.push('\\');
        }
        ret.push(c);
    }
    ret.push('"');
    ret
}
