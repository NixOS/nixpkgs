{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  aws-lc,
  sqlite,
  xz,
  zstd,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "celler";
  version = "0-unstable-2026-11-09";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "celler-cache";
    repo = "celler";
    rev = "590c6bca864a5614dd8b94a0b8862eeefb9d3a77";
    hash = "sha256-G2L8usGIrwlTnVhZZ51hADsHtfjyYsEGgjP7FdV8Z0E=";
  };

  cargoHash = "sha256-qSuxxNxytV1yTMrwN40VbEvtrFt49dwE0WbKbQefkFU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    aws-lc
    sqlite
    xz
    zstd
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  checkFlags = [
    # Failed to connect to the Nix store: StoreConnectError { reason: "No such file or directory (os error 2)" }
    "--skip=nix_store::tests::"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Multi-tenant Nix Binary Cache";
    homepage = "https://github.com/celler-cache/celler";
    changelog = "https://github.com/celler-cache/celler/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ blitz ];
    mainProgram = "celler";
  };
})
