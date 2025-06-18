{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  zstd,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ferron";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ferronweb";
    repo = "ferron";
    tag = finalAttrs.version;
    hash = "sha256-DD9mv2tMGLtnBU1YAb/CDTt+OcDVRzEfW3kUmePT+y4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-ezH8Oraog7XmD4zcrT5eiqS4zQ54m0SXNWlBRx0mJgo=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast, memory-safe web server written in Rust";
    homepage = "https://github.com/ferronweb/ferron";
    changelog = "https://github.com/ferronweb/ferron/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
    mainProgram = "ferron";
  };
})
