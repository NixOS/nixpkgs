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
  pname = "muzika";
  version = "unstable-2023-06-07";

  src = fetchFromGitHub {
    owner = "vixalien";
    repo = "muzika";
    rev = "d0ca7eebad67082e73513ebd7ca04edb1fdec7ce";
    hash = "sha256-ycnHpyYaUJZgproTLCWCVzsvnUisXlq3fqlij1KryWA=";
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
    hash = "sha256-FvPEbYIydgfyKKsf2jnXUbPEhIboPi3wR7BWzEuo72Q=";
  };

  preConfigure = ''
    export HOME="$PWD"
    yarn config --offline set yarn-offline-mirror $yarnOfflineCache
    ${fixup_yarn_lock}/bin/fixup_yarn_lock yarn.lock
  '';

  mesonFlags = [
    "-Dyarnrc=../.yarnrc"
  ];

  postFixup = ''
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 'com.vixalien.muzika';" $out/bin/.com.vixalien.muzika-wrapped
    ln -s $out/bin/com.vixalien.muzika $out/bin/muzika
  '';

  meta = with lib; {
    description = "Elegant music streaming app";
    homepage = "https://github.com/vixalien/muzika";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ onny ];
  };
}
