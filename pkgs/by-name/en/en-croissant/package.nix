{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,

  nodejs,
  pnpm_10,
  pnpmConfigHook,
  cargo-tauri,
  jq,
  moreutils,
  pkg-config,
  wrapGAppsHook3,
  makeBinaryWrapper,

  openssl,
  webkitgtk_4_1,
  gst_all_1,

  nix-update-script,
}:

let
  pnpm = pnpm_10;
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "en-croissant";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "franciscoBSalgueiro";
    repo = "en-croissant";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ef6O8C1PPjCmF5lashpBQXWwjsEEKCl5R98QMOFDIBM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 2;
    hash = "sha256-p2j886NRBw/8c2UJ94o6w7YtKnOfm7hU9SgEUrzAwco=";
  };

  cargoPatches = [
    # Bump the tauri-utils package to at least 2.1.0, to fix resource path resolution on NixOS.
    ./en-croissant-update-tauri-utils.patch
  ];

  postPatch = ''
    jq '.plugins.updater.endpoints = [ ] | .bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  cargoRoot = "src-tauri";

  cargoHash = "sha256-cTb6nKHlazyOu3cpwAAp20j3QmrDxC507ZRpYT5fgQs=";

  buildAndTestSubdir = finalAttrs.cargoRoot;

  nativeBuildInputs = [
    nodejs
    pnpm
    pnpmConfigHook

    cargo-tauri.hook
    jq
    moreutils
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ makeBinaryWrapper ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    openssl
    webkitgtk_4_1

    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
  ];

  doCheck = false; # many scoring tests fail

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper "$out"/Applications/en-croissant.app/Contents/MacOS/en-croissant $out/bin/en-croissant
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ultimate Chess Toolkit";
    homepage = "https://github.com/franciscoBSalgueiro/en-croissant/";
    license = lib.licenses.gpl3Only;
    mainProgram = "en-croissant";
    maintainers = with lib.maintainers; [
      tomasajt
      snu
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
