{
  stdenv,
  fetchFromGitLab,
  ffmpeg,
  meson,
  openjdk17,
  lib,
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
  nixosTests,
  bintools,
}:

stdenv.mkDerivation {
  pname = "android-translation-layer";
  version = "0-unstable-2026-07-30";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "android_translation_layer";
    rev = "cf2c759fa93330f45df6107dcf8984cf49b29c64";
    hash = "sha256-+TTntAnE/5j/FhGcdXRui3/p/sfkc83CKNdBf9Yage0=";
  };

  patches = [
    # Required gio-unix dependency is missing in meson.build
    ./add-gio-unix-dep.patch

    # Patch custom Dex install dir
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
      --prefix LD_LIBRARY_PATH : ${art-standalone}/lib/art \
      --prefix PATH : ${
        lib.makeBinPath [
          art-standalone # dex2oat
          bintools # addr2line
        ]
      }
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
