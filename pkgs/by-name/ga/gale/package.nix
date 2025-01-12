{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  jq,
  moreutils,
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

stdenv.mkDerivation (finalAttrs: {
  pname = "gale";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    tag = finalAttrs.version;
    hash = "sha256-bpeRbsbC1x1AXSyEPs1pUqwMouHQqJ/OtXXlNOVYcEA=";
  };

  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-xKg/ABUdtylFpT3EisXVvyv38++KjucrZ+s3/fFjzmM=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-xaqNps2AimGWKSwtnfkP3RkLgTNlkaAUtOgDWpB2yEg=";
  };

  cargoRoot = "src-tauri";

  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    jq
    moreutils
    npmHooks.npmConfigHook
    nodejs
    rustPlatform.cargoSetupHook
    cargo-tauri.hook
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
