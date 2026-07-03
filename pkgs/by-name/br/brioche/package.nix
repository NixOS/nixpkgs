{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  rusty-v8_146,
  openssl,
  tzdata,
  versionCheckHook,
}:

let
  librusty_v8 = rusty-v8_146;
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "brioche";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "brioche-dev";
    repo = "brioche";
    tag = "v${finalAttrs.version}";
    hash = "sha256-j0Hi75olubvlHEOzVbW0cMAslZFWCzHiwXaBqmkXzmE=";
  };

  cargoHash = "sha256-3UvggE45Gvus5ghd64ZK+Nh/VB3NJBmZNrbStl/xJu0=";

  env = {
    OPENSSL_NO_VENDOR = true;
    RUSTY_V8_ARCHIVE = librusty_v8;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Tests require network access and CA certificates, which are unavailable in the nix sandbox
  doCheck = false;

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = ./update.sh;
    inherit librusty_v8;
  };

  meta = {
    description = "Package manager for building and running complex software projects";
    homepage = "https://brioche.dev/";
    downloadPage = "https://github.com/brioche-dev/brioche";
    changelog = "https://github.com/brioche-dev/brioche/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "brioche";
  };
})
