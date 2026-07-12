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
  libGL,
  gst_all_1,
  qt6,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "project-graph";
  version = "3.0.8";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "graphif";
    repo = "project-graph";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VI2elNYYDPJVLE0LIaUJHLeemUHokqHob5oB7jgQOL4=";
  };

  cargoHash = "sha256-RFYDFZ3NKr/7OxwgApexGnxR8ZQn09DFYNzhnqVYEzE=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-6s5mv6hcpZUz/N5QNqUC8NamGT/B5Wv7DfY4Jte9jiQ=";
  };

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ libGL ]}"
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    )
  '';

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
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags Qt6WebEngineWidgets)"
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

  dontWrapQtApps = true;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    openssl
    webkitgtk_4_1
    libGL
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    qt6.qtbase
    qt6.qtwebengine
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
