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
  version = "2019-10-12";

  src = fetchFromGitHub {
    owner = "akiraux";
    repo = "Akira";
    rev = "cab952dee4591b6bde34d670c1f853f5a3ff6b19";
    sha256 = "1fp3a79hkh6xwwqqdrx4zqq2zhsm236c6fhhl5f2nmi108yxz04q";
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

  patches = [ ./fix-build-with-vala-0-44-or-later.patch ];

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
