{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpm_10,
  nodejs_24,
  cargo-tauri,
  openssl,
  pkg-config,
  webkitgtk_4_1,
  glib-networking,
  wrapGAppsHook4,
  pnpmConfigHook,
  jq,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "project-graph";
  version = "3.0.7";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "graphif";
    repo = "project-graph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QC1YTcyH7q+TJiGLF7zjKTe1OcfFd74fSFr+23iYMyQ=";
  };

  cargoHash = "sha256-bsRX+iVo2jInWZvrX1fVE2oAqM8L/5zNzjRwtoviQN0=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-sTThym++UWKpKFZqhQJCewRKtdYe1tKNcESrxyxpLmY=";
  };

  postPatch = ''
    TAURI_CONFIG="app/src-tauri/tauri.conf.json"
    if [ -f "$TAURI_CONFIG" ]; then
      echo "Applying Tauri v2 sandbox patches via jq..."
      ${jq}/bin/jq '.bundle.targets = [] | .bundle.createUpdaterArtifacts = false' "$TAURI_CONFIG" > temp.json && mv temp.json "$TAURI_CONFIG"
    fi
  '';

  preConfigure = ''
    export HOME="$TMPDIR"
  '';

  preBuild = ''
    pnpm run build
  '';

  nativeBuildInputs = [
    cargo-tauri.hook
    pnpmConfigHook
    nodejs_24
    pnpm_10
    pkg-config
    jq
    wrapGAppsHook4
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
  ];

  cargoRoot = "app/src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  doInstallCheck = true;

  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Node-based visual tool for organizing thoughts and notes";
    homepage = "https://graphif.dev";
    license = with lib.licenses; [
      mit
      gpl3Plus
    ];
    mainProgram = "project-graph";
    maintainers = with lib.maintainers; [ wduo87391 ];
    platforms = lib.platforms.linux;
  };
})
