{
  lib,
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

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gale";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    tag = finalAttrs.version;
    hash = "sha256-OaUpyG+XdP7AIA55enPf6/viBGBBQVuNi2QxgD5EVNc=";
  };

  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  npmDeps = fetchNpmDeps {
    name = "gale-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-yaPUNtlb2vMwK42u+3/rViGx6YzhYxRDJylPu++tbNs=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-v0/A4jUq5t61KB7NLwvsl6wR7N0UUbdVCk7nFZVTOi8=";

  nativeBuildInputs = [
    jq
    moreutils
    npmHooks.npmConfigHook
    nodejs
    cargo-tauri.hook
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
