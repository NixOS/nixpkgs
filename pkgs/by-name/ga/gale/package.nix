{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  fetchNpmDeps,
  npmHooks,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,

  openssl,
  libsoup_3,
  webkitgtk_4_1,
}:

let
  cargo-tauri_2 =
    let
      pname = "cargo-tauri";
      version = "2.0.0-rc.3";
      src = fetchFromGitHub {
        owner = "tauri-apps";
        repo = "tauri";
        rev = "tauri-v${version}";
        hash = "sha256-PV8m/MzYgbY4Hv71dZrqVbrxmxrwFfOAraLJIaQk6FQ=";
      };
    in
    cargo-tauri.overrideAttrs {
      inherit src version;
      cargoDeps = rustPlatform.fetchCargoTarball {
        inherit pname version src;
        sourceRoot = "${src.name}/tooling/cli";
        hash = "sha256-JPlMaoPw6a7D20KQH7iuhHKfGT5oUKf55tMaMYEM/Z4=";
      };
    };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gale";
  version = "0.8.11";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-PXK64WD3vb3uVxBFNU+LiGOipUjIAKW9RLWr1o4RigU=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-W0ryt3WH/3SireaOHa9i1vKpuokzIsDlD8R9Fnd0s4k=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.cargoRoot}";
    hash = "sha256-zXZkjSYN6/qNwBh+xUgJPWQvduIUSMVSt/XGbocKTwg=";
  };

  cargoRoot = "src-tauri";

  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
    rustPlatform.cargoSetupHook
    (cargo-tauri.hook.override { cargo-tauri = cargo-tauri_2; })
    rustPlatform.cargoCheckHook
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    libsoup_3
    webkitgtk_4_1
    openssl
  ];

  meta = {
    description = "Lightweight Thunderstore client";
    homepage = "https://github.com/Kesomannen/gale";
    license = lib.licenses.gpl3Only;
    mainProgram = "gale";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
