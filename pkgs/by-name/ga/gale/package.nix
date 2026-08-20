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
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "Kesomannen";
    repo = "gale";
    tag = finalAttrs.version;
    hash = "sha256-KQTjQTBrFVMoFBTelbGk03kSO1QLKyb3MhUt1Yhnv8E=";
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
    hash = "sha256-o0Nw1bIA2qPhcYmPDbyMuocltRUrLcFWc50J8yR7CzQ=";
  };

  postPatch = ''
    jq '.bundle.createUpdaterArtifacts = false' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json

    substituteInPlace project.inlang/settings.json ${
      lib.concatMapStringsSep " " (m: "--replace-fail ${m.url} ${m}") inlangModules
    }
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-pvtL5vDUKm2Ne6f88BgjqkImTBW3dal6G4n2yrFx8yM=";

  checkFlags = [
    "--skip=config::bepinex::tests::check_from_string" # Fails a left == right check, even with left and right data being identical
  ];

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
