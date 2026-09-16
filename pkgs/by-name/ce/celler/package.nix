{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  xz,
  zstd,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "celler";
  version = "0-unstable-2026-09-14";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "celler-cache";
    repo = "celler";
    rev = "8d1ea58d5b10b681b055065f984bd5aac7201857";
    hash = "sha256-WgP1kXnFKycUtSNeZ7hPZ12T4Gn8TNE6/nbz4m0jXUY=";
  };

  cargoHash = "sha256-kMjMNuUT8PtHFMRncm94iphMDOnGfMKKUNi6NCqNOMQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
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
    maintainers = with lib.maintainers; [
      blitz
      drupol
    ];
    mainProgram = "celler";
  };
})
