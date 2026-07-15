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
  version = "0.17.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    name = "${finalAttrs.pname}-${finalAttrs.version}-source";
    owner = "processone";
    repo = "fluux-messenger";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aT7X11BOmksEcCLk5hkokfLx7Q8Jk2zTWskoN8aZha0=";
  };

  cargoRoot = "apps/fluux/src-tauri";
  cargoHash = "sha256-fEHe7enJzdEauou1xWfM94WHL1uAP1sfY2JN1ZmZmEE=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-4Op4jykCtc9oFBIn8vOUqxGr7/OloIhPD1JT+q4dX7Y=";
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
