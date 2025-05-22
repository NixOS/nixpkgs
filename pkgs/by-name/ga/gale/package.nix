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

  glib-networking,
  libsoup_3,
  openssl,
  webkitgtk_4_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gale";
  version = "1.5.12";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    tag = finalAttrs.version;
    hash = "sha256-5iJ04/q/emPwG0ILurFx2gNlXkZrfP2D6xv25AIlhfc=";
  };

  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-yaPUNtlb2vMwK42u+3/rViGx6YzhYxRDJylPu++tbNs=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-GGH5kQlnYIlKbTAKbF275mH4J9BcbcBHSdzP7RgfDwk=";
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
    glib-networking # needed to load icons
    libsoup_3
    openssl
    webkitgtk_4_1
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
