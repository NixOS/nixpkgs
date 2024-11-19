{
  stdenv,
  fetchFromGitLab,
  ffmpeg,
  meson,
  openjdk17,
  lib,
  glib,
  pkg-config,
  cmake,
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
  dioxus-cli,
  ninja,
  art-standalone,
}:

stdenv.mkDerivation {
  pname = "android-translation-layer";
  version = "0-unstable-2024-12-19";

  src = fetchFromGitLab {
    owner = "android_translation_layer";
    repo = "android_translation_layer";
    rev = "f3bc468a1c9ab13992ad4aaa15761e00e2d3863c";
    hash = "sha256-xPPQVKrUlLWAFMSChLPPoyBNCkbndPxO/hpelh+c42Y=";
  };

  postPatch = ''
    # Temporary hack
    sed -i '13,16d;17,19d;20,22d;23,25d;26,34d;160d' meson.build
    #substituteInPlace meson.build --replace "libart_dep, " ""
    substituteInPlace meson.build --replace "libdl_bio_dep, " ""
    sed -i '580d' src/api-impl/meson.build
  '';

  #patches = [./atl.patch];

  nativeBuildInputs = [
    pkg-config
  #  makeWrapper
  #  patchelf
    meson
    ninja
  #  aapt
    cmake
    openjdk17
    dioxus-cli
  ];

  buildInputs = [
    wayland-scanner
  #  jre
  #  alsa-lib
    ffmpeg
  #  capnproto
  #  xorg_sys_opengl
    glib.dev
    gtk4.dev
    libgudev
    openxr-loader.dev
    libportal-gtk4
    sqlite.dev
  #  wolfssljni
  #  bionic_translation
    art-standalone
  #  SkiaSharp
    wayland-protocols
    libglvnd
    libdrm
    webkitgtk_6_0
  #  libepoxy
    wayland.dev
  ];

  #configurePhase = ''
  #  meson setup builddir -Dart_lib=${art_standalone}/lib -Dbionic_lib=${bionic_translation}/lib
  #'';

  #buildPhase = ''
  #  cd builddir
  #  meson compile
  #'';

  #installPhase = ''
  #  DESTDIR="$out" MESON_INSTALL_PREFIX="" meson install
    # mv $out/usr/local/* $out
    # rm -rf $out/usr
    #wrapProgram $out/usr/local/bin/android-translation-layer \
    #  --prefix PATH : #$#{art_standalone}/bin \
    #  --prefix LD_LIBRARY_PATH : #$#{bionic_translation}/lib:#$#{art_standalone}/lib/art:#$#{art_standalone}/lib/java/dex/art/natives:$out/usr/local/lib:$out/usr/local/lib/java/dex/android_translation_layer/natives:#$#{opensles}/lib
  #'';

  meta = {
    description = "Translation layer that allows running Android apps on a Linux system";
    homepage = "https://gitlab.com/android_translation_layer/android_translation_layer";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ onny ];
  };
}
