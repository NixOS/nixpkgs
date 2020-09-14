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
  version = "0.0.13";

  src = fetchFromGitHub {
    owner = "akiraux";
    repo = "Akira";
    rev = "v${version}";
    sha256 = "1i20q78jagy8xky68nmd0n7mqvh88r98kp626rnlgyzvlc3c22cm";
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
    maintainers = with maintainers; [ filalex77 neonfuz ] ++ pantheon.maintainers;
    platforms = platforms.linux;
  };
}
