{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchYarnDeps,
  rustPlatform,
  yarnConfigHook,
  nodejs,
  cargo-tauri_1,
  pkg-config,
  wrapGAppsHook3,
  libsoup,
  webkitgtk_4_0,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pointless";
  # typescript is not resolved in yarn.lock in 1.11.0
  version = "1.11.0-unstable-2024-03-23";

  src = fetchFromGitHub {
    owner = "kkoomen";
    repo = "pointless";
    rev = "66e7f479cef4b9a6bea8ea64f6fca8b9725af8f4";
    hash = "sha256-DIwVOhEWjLbcdCIv33yXHG3s6joeLZ7aCAUWGeso9i8=";
  };

  yarnOfflineCache = fetchYarnDeps {
    inherit (finalAttrs) src;
    hash = "sha256-9h6JBkTC9VG4LF1JjNi62S18RCSb3sPHCrxdfuTTUrk=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.cargoRoot}";
    hash = "sha256-Ezv21J5GIB331Zuxls7O12xOFWC5a/YSXyEABK6ftcQ=";
  };

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
    rustPlatform.cargoSetupHook
    cargo-tauri_1.hook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libsoup
    webkitgtk_4_0
  ];

  meta = {
    description = "Endless drawing canvas desktop app made with Tauri (Rust) and React";
    homepage = "https://github.com/kkoomen/pointless";
    license = lib.licenses.gpl3Only;
    mainProgram = "pointless";
    maintainers = with lib.maintainers; [ aleksana ];
    platforms = lib.platforms.unix;
  };
})
