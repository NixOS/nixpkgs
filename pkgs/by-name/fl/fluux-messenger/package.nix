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
  version = "0.16.1";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "processone";
    repo = "fluux-messenger";
    rev = "v${finalAttrs.version}";
    hash = "sha256-os6zEB1E3D4WSRfru/UCDY0mgZxy0Zu/YcjhMbXt47g=";
  };

  cargoRoot = "apps/fluux/src-tauri";
  cargoHash = "sha256-V6iDPPBpdJQV5PA/isRy+Gz6NdwUUEj3mf9PM/nX10s=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    hash = "sha256-iMkb7QZZrKjzmTzvWGbw8reF1nX4Avd1XKzyybz3q00=";
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
