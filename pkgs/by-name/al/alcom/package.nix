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
  subdir = "vrc-get-gui";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "alcom";
  version = "1.1.9";
  src = fetchFromGitHub {
    owner = "vrc-get";
    repo = "vrc-get";
    tag = "gui-v${finalAttrs.version}";
    hash = "sha256-90FLIJDawG9KoVgk6jxrvwjnue7OJYAxMLLmNhsWlto=";
  };

  nativeBuildInputs = [
    cargo-about
    cargo-tauri.hook
    makeBinaryWrapper
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook4
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libsoup_3
    webkitgtk_4_1
  ];

  cargoHash = "sha256-h+tblYrLpuUwDDZV2rS3h9q2UuZtZ/5/S2rh4BzFnHg=";
  buildFeatures = [ "no-self-updater" ];
  buildAndTestSubdir = subdir;

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      install -Dm644 ${subdir}/icons/icon.png $out/share/icons/hicolor/512x512/apps/ALCOM.png
      for size in 32x32 64x64 128x128 128x128@2x; do
        install -Dm644 ${subdir}/icons/$size.png $out/share/icons/hicolor/''${size%x}/apps/ALCOM.png
      done
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeWrapper $out/Applications/ALCOM.app/Contents/MacOS/ALCOM $out/bin/ALCOM
    '';

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/${subdir}";
    hash = "sha256-flWM2ctaGak/KaTZ5sCj3Z28vIqOeiX8VJMTaIxg2fw=";
  };
  npmRoot = subdir;

  meta = {
    description = "Experimental GUI application to manage VRChat Unity Projects";
    homepage = "https://github.com/vrc-get/vrc-get";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Scrumplex
      ImSapphire
    ];
    mainProgram = "ALCOM";
  };
})
