{
  lib,
  fetchFromGitHub,
  nix-update-script,
  openssl,
  pkg-config,
  rustPlatform,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "introspectme";
  version = "0.0.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bountyyfi";
    repo = "IntrospectMe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-PQSfIbcY3vgJhi2OcG6wqFH6xiWcBylJhr1kWdlr0go=";
  };

  cargoHash = "sha256-UAcIwBrHuU7AbLXoSCwpT7cetioVNboG2rpDMPbnvR8=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
    zstd
  ];

  env = {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for introspecting and analyzing GraphQL field suggestion errors";
    homepage = "https://github.com/bountyyfi/IntrospectMe";
    changelog = "https://github.com/bountyyfi/IntrospectMe/releases/tag/${finalAttrs.src.tag}";
    # SOURCE-AVAILABLE LICENSE, Version 0.0.1 - Effective February 15, 2026
    # https://github.com/bountyyfi/IntrospectMe/blob/main/LICENSE
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "introspectme";
  };
})
