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
  version = "0.17.4";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    name = "${finalAttrs.pname}-${finalAttrs.version}-source";
    owner = "processone";
    repo = "fluux-messenger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HHXdWdKXf0qLKNJQEA1oPPpv4kxpfNuPH2uXEMo3DHg=";
  };

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-Gy1zXHsclHo0FNfZh8v0GLfSKel4boSAKBKIYxGfSW0=";
  };

  cargoRoot = "apps/fluux/src-tauri";
  cargoHash = "sha256-/Gx4fu9fBL8IEZqMP+ePpv5hvTwLrl2Nywf76g0d/Fw=";

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
    cacert
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    webkitgtk_4_1
    libayatana-appindicator
    libxscrnsaver
  ];

  # libayatana-appindicator is not in the RUNPATH by default
  runtimeDependencies = lib.optionals stdenv.hostPlatform.isLinux [ libayatana-appindicator ];

  tauriBuildFlags = [ "--no-sign" ];

  # setting buildAndTestSubdir from the beginning interferes with buildPhase
  preCheck = "export buildAndTestSubdir=${finalAttrs.cargoRoot}";
  # tauriInstallHook only works when we are in cargoRoot
  preInstall = "pushd $buildAndTestSubdir";
  postInstall = "popd";

  meta = {
    description = "XMPP client for communities and organizations";
    longDescription = "A modern, Web and Desktop cross-platform XMPP client for communities and organizations, built with a reusable Typescript SDK and Tauri for desktop";
    changelog = "https://github.com/processone/fluux-messenger/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    homepage = "https://github.com/processone/fluux-messenger";
    license = lib.licenses.agpl3Plus;
    mainProgram = "fluux";
    maintainers = [ lib.maintainers.haansn08 ];
    platforms = lib.platforms.all;
    # see also https://github.com/processone/fluux-messenger/blob/main/fluux-messenger.doap
  };
})
