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
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nuclear";
  version = "1.37.3";

  src = fetchFromGitHub {
    owner = "nukeop";
    repo = "nuclear";
    tag = "player@1.37.3";
    hash = "sha256-Ada86CXCrkIaEUKsCrBeji8Su5Bbl1a/ENghO5OJPZc=";
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
    hash = "sha256-TeoNYkP6rUfqxtnklcl8wLODesbv1kasKviTspVKKWU=";
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

  cargoHash = "sha256-bVioujpKUo3q3pNqFwgPRP+kFRZsNXxALDxXbpV0CjY=";

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
})
