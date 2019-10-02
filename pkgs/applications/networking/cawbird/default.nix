{ stdenv, fetchFromGitHub, glib, gtk3, json-glib, sqlite, libsoup, gettext, vala
, meson, ninja, pkgconfig, gnome3, gst_all_1, wrapGAppsHook, gobject-introspection
, glib-networking, python3 }:

stdenv.mkDerivation rec {
  version = "1.0.1";
  pname = "cawbird";

  src = fetchFromGitHub {
    owner = "IBBoard";
    repo = "cawbird";
    rev = "v${version}";
    sha256 = "sha256:0bk33fh32nnv6ya6j0ij34abw6a3g6m8fq13303slhhja8xhvmb1";
  };

  nativeBuildInputs = [
    meson ninja vala pkgconfig wrapGAppsHook python3
    gobject-introspection # for setup hook
  ];

  buildInputs = [
    glib gtk3 json-glib sqlite libsoup gettext gnome3.dconf gnome3.gspell glib-networking
  ] ++ (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-bad (gst-plugins-good.override { gtkSupport = true; }) gst-libav ]);

  postPatch = ''
    chmod +x data/meson_post_install.py # patchShebangs requires executable file
    patchShebangs data/meson_post_install.py
  '';

  meta = with stdenv.lib; {
    description = "Native GTK Twitter client for the Linux desktop";
    longDescription = "Cawbird is a modern, easy and fun Twitter client. Fork of the discontinued Corebird.";
    homepage = https://ibboard.co.uk/cawbird/;
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ jonafato schmittlauch ];
  };
}
