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
  bintools,
}:

stdenv.mkDerivation {
  pname = "android-translation-layer";
  version = "0-unstable-2025-09-14";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "android_translation_layer";
    rev = "9de91586994af5078decda17db92ce50c5673951";
    hash = "sha256-iRjP++WzLsV7oDGNdF3m9JJJS7zLrG5W46U3h39H5uk=";
  };

  patches = [
    # Required gio-unix dependency is missing in meson.build
    ./add-gio-unix-dep.patch

    # Patch custon Dex install dir
    ./configure-dex-install-dir.patch

    # Patch atl to load microg apk from custom path
    ./configure-microg-path.patch
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

  postInstall = ''
    install -D $src/com.google.android.gms.apk $out/share/com.google.android.gms.apk
  '';

  postFixup = ''
    wrapProgram $out/bin/android-translation-layer \
      --prefix LD_LIBRARY_PATH : ${art-standalone}/lib/art \
      --prefix PATH : ${
        lib.makeBinPath [
          art-standalone # dex2oat
          bintools # addr2line
        ]
      } \
      --set MICROG_APK_PATH "$out/share/com.google.android.gms.apk"
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
