{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mago";
  version = "0.26.1";

  src = fetchFromGitHub {
    owner = "carthage-software";
    repo = "mago";
    hash = "sha256-9WrSHjs1EdDqTXuB0HbIzQCQWp4okkdy3jTVl4J2wUg=";
    tag = finalAttrs.version;
  };

  cargoHash = "sha256-7/kbuWcy1IwAL7m87WPgyhwPidLL9K65u6ybpj0Ryl0=";

  env = {
    # Get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    changelog = "https://github.com/carthage-software/mago/releases/tag/${finalAttrs.version}";
    description = "Toolchain for PHP that aims to provide a set of tools to help developers write better code";
    homepage = "https://github.com/carthage-software/mago";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelreyrol ];
    mainProgram = "mago";
  };
})
