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
  pname = "pawn-appetit";
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "Pawn-Appetit";
    repo = "pawn-appetit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WJ/tFOizESDqdLy4maMKUZ79mgyyxqLuwCxWZ0+NVX4=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-amXrz/ZzvjvNYlqxzTtQXiZw/NnUVJ7PhqG8oHsEe88=";
  };

  postPatch = ''
    jq '.plugins.updater.endpoints = [ ] | .bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  '';

  cargoRoot = "src-tauri";

  cargoHash = "sha256-UKaW+NiNA398nyGs9+SjY+tUvLjCPrSxX6bZLSl7/EQ=";

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
    makeWrapper "$out"/Applications/pawn-appetit.app/Contents/MacOS/pawn-appetit $out/bin/pawn-appetit
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Ultimate Chess Toolkit (fork of en-croissant)";
    homepage = "https://github.com/Pawn-Appetit/pawn-appetit/";
    license = lib.licenses.gpl3Only;
    mainProgram = "pawn-appetit";
    maintainers = with lib.maintainers; [ snu ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
