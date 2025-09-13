{
  cargo-about,
  cargo-tauri,
  fetchFromGitHub,
  fetchNpmDeps,
  glib-networking,
  lib,
  libsoup_3,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  rustPlatform,
  stdenv,
  wrapGAppsHook4,
  webkitgtk_4_1,
}:
let
  pname = "alcom";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "vrc-get";
    repo = "vrc-get";
    tag = "gui-v${version}";
    hash = "sha256-pGWDMQIS2WgtnqRoOXRZrc25kJ5c6TY6UE2aZtpxN/s=";
  };

  subdir = "vrc-get-gui";
in
rustPlatform.buildRustPackage {
  inherit pname version src;

  patches = [
    ./disable-updater-artifacts.patch
  ];

  nativeBuildInputs = [
    cargo-about
    cargo-tauri.hook
    nodejs
    npmHooks.npmConfigHook
    wrapGAppsHook4
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libsoup_3
    makeBinaryWrapper
    webkitgtk_4_1
  ];

  cargoHash = "sha256-JuZHfpOYuLNdb03srECx73GK5ajgL6bHlbKbiuMN2NE=";
  buildAndTestSubdir = subdir;

  npmDeps = fetchNpmDeps {
    inherit src;
    sourceRoot = "${src.name}/${subdir}";
    hash = "sha256-snXOfAtanLPhQNo0mg/r8UUXJua2X+52t7+7QS1vOkI=";
  };
  npmRoot = subdir;

  meta = {
    description = "Experimental GUI application to manage VRChat Unity Projects";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "ALCOM";
  };
}
