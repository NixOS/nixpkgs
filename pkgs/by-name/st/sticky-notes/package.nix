{
  lib,
  desktop-file-utils,
  fetchFromGitHub,
  fetchYarnDeps,
  fixup_yarn_lock,
  gjs,
  glib-networking,
  gobject-introspection,
  gst_all_1,
  gtk4,
  libadwaita,
  libsoup_3,
  meson,
  ninja,
  pkg-config,
  stdenv,
  wrapGAppsHook4,
  yarn,
  nodejs,
}:

stdenv.mkDerivation rec {
  pname = "sticky-notes";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "vixalien";
    repo = "sticky";
    tag = "v${version}";
    hash = "sha256-82Yxw8NSw82rxhuAgsdN2lCiQ/hli4tQiU6jCgGyp4U=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    nodejs
    pkg-config
    wrapGAppsHook4
    yarn
    fixup_yarn_lock
  ];

  buildInputs = [
    gjs
    glib-networking
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gtk4
    libadwaita
    libsoup_3
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/yarn.lock";
    hash = "sha256-NDGuG2rXJH0bHsD7yQMY6HAZDkMq0j63SYVz8+X3fPQ=";
  };

  preConfigure = ''
    export HOME="$PWD"
    yarn config --offline set yarn-offline-mirror $yarnOfflineCache
    fixup_yarn_lock yarn.lock
  '';

  mesonFlags = [
    "-Dyarnrc=../.yarnrc"
  ];

  postPatch = ''
    meson rewrite kwargs set project / version '${version}'
  '';

  postFixup = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'com.vixalien.sticky';" $out/bin/.com.vixalien.sticky-wrapped
  '';

  meta = {
    description = "Simple sticky notes app for GNOME";
    homepage = "https://github.com/vixalien/sticky";
    changelog = "https://github.com/vixalien/sticky/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pokon548 ];
    mainProgram = "com.vixalien.sticky";
    platforms = lib.platforms.linux;
  };
}
