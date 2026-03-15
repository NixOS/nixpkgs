{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,

  jq,
  moreutils,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  cargo-tauri,
  pkg-config,
  wrapGAppsHook3,

  glib-networking,
  libsoup_3,
  openssl,
  webkitgtk_4_1,

  nix-update-script,
}:

let
  inlangModules = [
    (fetchurl {
      name = "plugin-message-format-index.js";
      url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-message-format@4/dist/index.js";
      hash = "sha256-IOyECYVo8YqD2jYePrrfWGImn6M1FQzJvVDXmaSP31c=";
    })
    (fetchurl {
      name = "plugin-m-function-matcher-index.js";
      url = "https://cdn.jsdelivr.net/npm/@inlang/plugin-m-function-matcher@2/dist/index.js";
      hash = "sha256-hYYvYwV5O1a/2a/lNosJbmP7Kuqzi3eZwFFRe+NJnAs=";
    })
  ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gale";
  version = "1.13.0";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    tag = finalAttrs.version;
    hash = "sha256-q/DBgAOFyIqhagWffJ6z+F7TXAZd7otPOGJI4oid4vM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      patches
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-bCGiYVmoWjpwneTQUwetna7u29BMIv48qWgZ2gd93hQ=";
  };

  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json

    substituteInPlace project.inlang/settings.json ${
      lib.concatMapStringsSep " " (m: "--replace-fail ${m.url} ${m}") inlangModules
    }
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-V8MKgicqHU9kEMTw17xeM2pzzkAlGBZJ2j4W5OEIit0=";

  nativeBuildInputs = [
    jq
    moreutils
    pnpmConfigHook
    pnpm_10
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Lightweight Thunderstore client";
    homepage = "https://github.com/Kesomannen/gale";
    license = lib.licenses.gpl3Only;
    mainProgram = "gale";
    maintainers = with lib.maintainers; [
      tomasajt
      notohh
    ];
    platforms = lib.platforms.linux;
  };
})
