{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  cargo-tauri,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  pkg-config,
  webkitgtk_4_1,
  libayatana-appindicator,
  libxscrnsaver,
  cacert,
  wrapGAppsHook3,
  autoPatchelfHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "fluux-messenger";
  version = "0.16.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "processone";
    repo = "fluux-messenger";
    rev = "v${finalAttrs.version}";
    hash = "sha256-G5VDcFHp+mIYBXh7Vju/8bGB3CPD1dyZKq8zAOKn3UY=";
  };

  cargoRoot = "apps/fluux/src-tauri";
  cargoHash = "sha256-/jaEpC0f6B1zTxN7MHv/DESFnRTSAd3qi9rrnXurcPQ=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-XAzE4I13GN4Gfi6g4VX5ZwM2DhVycKz7cGBQroAFvf8=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    (wrapGAppsHook3.override { isGraphical = true; })
    autoPatchelfHook
  ];

  buildInputs = [
    webkitgtk_4_1
    libayatana-appindicator
    libxscrnsaver
    cacert
  ];

  # libayatana-appindicator is not in the RUNPATH by default
  runtimeDependencies = [ libayatana-appindicator ];

  tauriBuildFlags = [ "--no-sign" ];

  # setting buildAndTestSubdir from the beginning interferes with buildPhase
  preCheck = "export buildAndTestSubdir=${finalAttrs.cargoRoot}";
  # tauriInstallHook only works when we are in cargoRoot
  preInstall = "pushd $buildAndTestSubdir";
  postInstall = "popd";

  meta = {
    description = "XMPP client for communities and organizations";
    homepage = "https://github.com/processone/fluux-messenger";
    license = lib.licenses.agpl3Plus;
    mainProgram = "fluux";
    maintainers = [ lib.maintainers.haansn08 ];
    platforms = lib.platforms.all;
  };
})
