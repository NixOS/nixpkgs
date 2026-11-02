{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fast-nix-gc";
  version = "0-unstable-2026-10-08";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mic92";
    repo = "fast-nix-gc";
    rev = "b4471ec56911541f72f7a7b9b8fee7f42183f21b";
    hash = "sha256-CNSHu5tKx//E9+ayDlfhk9C/3JVDFxiB0PKYQA37CC4=";
  };

  cargoHash = "sha256-bHMR29uAAy0lUkqRIxv0GFqCe2ljA/UEsmzVillidkU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  env = {
    LIBSQLITE3_SYS_USE_PKG_CONFIG = true;
  };

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A faster nix-collect-garbage";
    homepage = "https://github.com/Mic92/fast-nix-gc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mic92 ];
    mainProgram = "fast-nix-gc";
  };
})
