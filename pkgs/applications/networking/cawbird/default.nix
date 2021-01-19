{ lib, stdenv
, fetchFromGitHub
, glib
, gtk3
, json-glib
, sqlite
, libsoup
, liboauth
, gettext
, gspell
, vala
, meson
, ninja
, pkg-config
, dconf
, gst_all_1
, wrapGAppsHook
, gobject-introspection
, glib-networking
, librest
, python3
}:

stdenv.mkDerivation rec {
  version = "1.3.2";
  pname = "cawbird";

  src = fetchFromGitHub {
    owner = "IBBoard";
    repo = "cawbird";
    rev = "v${version}";
    sha256 = "1baw3h5wq2ib4bnphazq7n9c9wc94g0n6v4y5kg71n1dir0c3jkh";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    pkg-config
    wrapGAppsHook
    python3
    gobject-introspection # for setup hook
  ];

  buildInputs = [
    glib
    gtk3
    json-glib
    sqlite
    libsoup
    liboauth
    gettext
    dconf
    gspell
    glib-networking
    librest
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    (gst-plugins-good.override {
      gtkSupport = true;
    })
    gst-libav
  ]);

  postPatch = ''
    chmod +x data/meson_post_install.py # patchShebangs requires executable file
    patchShebangs data/meson_post_install.py
  '';

  meta = with lib; {
    description = "Native GTK Twitter client for the Linux desktop";
    longDescription = "Cawbird is a modern, easy and fun Twitter client. Fork of the discontinued Corebird.";
    homepage = "https://ibboard.co.uk/cawbird/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ jonafato schmittlauch ];
  };
}
