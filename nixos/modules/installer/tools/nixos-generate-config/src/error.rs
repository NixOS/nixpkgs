use std::error as base_error;

/// Standard result type used nixos-generate-config
pub type Result<T> = std::result::Result<T, Box<dyn base_error::Error>>;

/// Standard Error type used nixos-generate-config
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Error {
    err: String,
}
