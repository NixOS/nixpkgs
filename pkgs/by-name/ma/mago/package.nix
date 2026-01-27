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
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "carthage-software";
    repo = "mago";
    tag = finalAttrs.version;
    hash = "sha256-me36u5dfMMOBcighoOUdJ9KZMzhdqBhwCCxJuwVN0Qg=";
    forceFetchGit = true; # Does not download all files otherwise
  };

  cargoHash = "sha256-7/KqVOtT3CJngzz9d0EDqyHCy7kahClbDjdWBf98T2w=";

  env = {
    # Get openssl-sys to use pkg-config
    OPENSSL_NO_VENDOR = 1;
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    changelog = "https://github.com/carthage-software/mago/releases/tag/${finalAttrs.version}";
    description = "Toolchain for PHP that aims to provide a set of tools to help developers write better code";
    homepage = "https://github.com/carthage-software/mago";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hythera ];
    mainProgram = "mago";
  };
})
