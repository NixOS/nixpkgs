{
  fetchFromGitHub,
  fetchPnpmDeps,
  lib,
  rustPlatform,
  # Common
  cargo-tauri,
  jq,
  moreutils,
  nix-update-script,
  nodejs_22,
  pkg-config,
  pnpmConfigHook,
  pnpm_10,
  stdenv,
  # Linux Dependents
  glib-networking,
  openssl,
  webkitgtk_4_1,
  wrapGAppsHook4,
  # Darwin Dependents
  darwin,
}:
rustPlatform.buildRustPackage (
  finalAttrs:
  let
    version = "1.39.1";
  in
  {
    pname = "nuclear";
    inherit version;

    src = fetchFromGitHub {
      owner = "nukeop";
      repo = "nuclear";
      tag = "player@${version}";
      hash = "sha256-s1D394YRB3sl4q9mqm4gOn4KlPUcQcbNd/XQAvI/xV4=";
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
      hash = "sha256-nwqUTgcLxEq01Q2vEJNFxBTPH/vi3u+LKADrqE+9cXg=";
    };

    cargoRoot = "packages/player/src-tauri";

    postPatch =
      let
        tauriConfJson = "${finalAttrs.cargoRoot}/tauri.conf.json";
      in
      ''
        jq '.bundle.createUpdaterArtifacts = false' ${tauriConfJson} | sponge ${tauriConfJson}
      ''
      # Disable Tauri's built-in codesigning
      + lib.optionalString stdenv.hostPlatform.isDarwin ''
        jq '.bundle.macOS.signingIdentity = null' ${tauriConfJson} | sponge ${tauriConfJson}
      '';

    buildAndTestSubdir = finalAttrs.cargoRoot;

    cargoHash = "sha256-GyuVVSBoANqJa+03IY3eOQYv0MiuyMeCXQ2f29lk/kk=";

    tauriBuildFlags = [ "--verbose" ];

    nativeBuildInputs = [
      cargo-tauri.hook
      jq
      moreutils
      nodejs_22
      pkg-config
      pnpmConfigHook
      pnpm_10
      wrapGAppsHook4
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ darwin.autoSignDarwinBinariesHook ];

    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
      glib-networking
      openssl
      webkitgtk_4_1
    ];

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Streaming music player that finds free music for you";
      homepage = "https://nuclear.js.org/";
      license = lib.licenses.agpl3Plus;
      maintainers = [ ];
      platforms = lib.platforms.linux ++ lib.platforms.darwin;
      mainProgram = "nuclear-music-player";
    };
  }
)
