{
  stdenv,
  fetchFromGitLab,
  ffmpeg,
  meson,
  openjdk17,
  lib,
  glib,
  pkg-config,
  wayland-protocols,
  wayland,
  wayland-scanner,
  gtk4,
  openxr-loader,
  libglvnd,
  libportal-gtk4,
  sqlite,
  libdrm,
  libgudev,
  webkitgtk_6_0,
  ninja,
  art-standalone,
  bionic-translation,
  alsa-lib,
  makeWrapper,
  replaceVars,
  nixosTests,
}:

stdenv.mkDerivation {
  pname = "android-translation-layer";
  version = "0-unstable-2025-07-14";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "android_translation_layer";
    rev = "828f779c4f7170f608047c500d6d3b64b480df7f";
    hash = "sha256-1KYZWlzES3tbskqvA8qSQCegE0uLTLCq4q2CX6uix4o=";
  };

  patches = [
    # meson: use pkg-config from art-standalone instead of manual library search
    # See: https://gitlab.com/android_translation_layer/android_translation_layer/-/merge_requests/164
    (replaceVars ./configure-art-path.patch {
      artStandalonePackageDir = "${art-standalone}";
    })

    # Required gio-unix dependency is missing in meson.build
    ./add-gio-unix-dep.patch

    # Patch custon Dex install dir
    ./configure-dex-install-dir.patch
  ];

  postPatch = ''
    # As we need the $out reference, we can't use `replaceVars` here.
    substituteInPlace src/main-executable/main.c \
      --replace-fail '@out@' "$out"
  '';

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    openjdk17
    pkg-config
  ];

  buildInputs = [
    alsa-lib
    art-standalone
    bionic-translation
    ffmpeg
    gtk4
    libdrm
    libglvnd
    libgudev
    libportal-gtk4
    openxr-loader
    sqlite
    wayland
    wayland-protocols
    wayland-scanner
    webkitgtk_6_0
  ];

  postFixup = ''
    wrapProgram $out/bin/android-translation-layer \
      --prefix LD_LIBRARY_PATH : ${art-standalone}/lib/art
  '';

  passthru.tests = {
    inherit (nixosTests) android-translation-layer;
  };

  meta = {
    description = "Translation layer that allows running Android apps on a Linux system";
    homepage = "https://gitlab.com/android_translation_layer/android_translation_layer";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "android-translation-layer";
  };
}
