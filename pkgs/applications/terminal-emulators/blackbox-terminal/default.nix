{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, meson
, ninja
, desktop-file-utils
, gettext
, glib
, gtk4
, gtk3
, libadwaita
, libmarble
, marble
, pkg-config
, vala
, vte
, json-glib
, pcre2
, libxml2
, librsvg
, cmake
, wrapGAppsHook4
, python3
, qt5
}:

stdenv.mkDerivation rec {
  pname = "blackbox-terminal";
  version = "0.12.0";

  strictDeps = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "raggesilver";
    repo = "blackbox";
    rev = "v${version}";
    hash = "sha256-8u4qHC8+3rKDFNdg5kI48dBgAm3d6ESXN5H9aT/nIBY=";
  };

  patches = [
    (fetchpatch {
      name = "yilozt_launch_fix.diff";
      url = https://raw.githubusercontent.com/yilozt/pkgbuilds/main/terminal-gtk4-git/launch_fix.diff;
      sha256 = "sha256-nrA9Fdr++B11h5LedBfvebGxK92HTzdyuSBOOSY3Z44=";
    })
  ];

  postPatch = ''
    patchShebangs /build/source/build-aux/meson/postinstall.py
  '';

  nativeBuildInputs = [
    meson
    ninja
    gettext
    desktop-file-utils
    glib
    pkg-config
    vala
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libmarble
    vte
    json-glib
    pcre2
    libxml2
    librsvg
  ];
}
