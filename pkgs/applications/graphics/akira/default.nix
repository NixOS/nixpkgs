{ stdenv
, lib
, fetchFromGitHub
, appstream-glib
, desktop-file-utils
, meson
, ninja
, pantheon
, pkgconfig
, python3
, vala
, vala-lint
, wrapGAppsHook
, cairo
, glib
, goocanvas2
, gtk3
, gtksourceview3
, json-glib
, libarchive
, libgee
, libxml2 }:

stdenv.mkDerivation rec {
  pname = "akira";
  version = "2020-05-01";

  src = fetchFromGitHub {
    owner = "akiraux";
    repo = "Akira";
    rev = "87c495fa0a686b1e9b84aff7d9c0a9553da2c466";
    sha256 = "0ikz6dyx0z2wqskas628hbrbhx3z5gy7i4acrvspfhhg6rk88aqd";
  };

  nativeBuildInputs = [
    appstream-glib
    desktop-file-utils
    meson
    ninja
    pkgconfig
    python3
    vala
    vala-lint
    wrapGAppsHook
  ];

  buildInputs = [
    cairo
    glib
    goocanvas2
    pantheon.granite
    gtk3
    gtksourceview3
    json-glib
    libarchive
    libgee
    libxml2
  ];

  mesonFlags = [ "-Dprofile=default" ];

  postPatch = ''
    chmod +x build-aux/meson/post_install.py
    patchShebangs build-aux/meson/post_install.py
  '';

  meta = with lib; {
    description = "Native Linux Design application built in Vala and GTK";
    homepage = "https://github.com/akiraux/Akira";
    license = licenses.gpl3;
    maintainers = with maintainers; [ filalex77 ] ++ pantheon.maintainers;
    platforms = platforms.linux;
  };
}
