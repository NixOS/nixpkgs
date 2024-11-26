{ lib
, desktop-file-utils
, fetchFromGitHub
, fetchYarnDeps
, fixup_yarn_lock
, gjs
, glib-networking
, gobject-introspection
, gst_all_1
, gtk4
, libadwaita
, libsoup_3
, meson
, ninja
, pkg-config
, stdenv
, wrapGAppsHook4
, yarn
, nodejs
}:

stdenv.mkDerivation rec {
  pname = "sticky-notes";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "vixalien";
    repo = "sticky";
    rev = "v${version}";
    hash = "sha256-+++xUiMjO+19hmLLBamOL6tMUqB0a8ixTXca/6A8ZK8=";
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
    hash = "sha256-GThcufSAr/VYL9AWFOBY2FDXQZGY5L7TbBdadPh7CAc=";
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
