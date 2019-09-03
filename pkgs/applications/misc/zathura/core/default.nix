{ stdenv, fetchurl, meson, ninja, wrapGAppsHook, pkgconfig
, appstream-glib, desktop-file-utils, python3
, gtk, girara, gettext, libxml2, check
, sqlite, glib, texlive, libintl, libseccomp
, file, librsvg
, gtk-mac-integration
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "zathura-core";
  version = "0.4.3";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/download/zathura-${version}.tar.xz";
    sha256 = "0hgx5x09i6d0z45llzdmh4l348fxh1y102sb1w76f2fp4r21j4ky";
  };

  outputs = [ "bin" "man" "dev" "out" ];

  # Flag list:
  # https://github.com/pwmt/zathura/blob/master/meson_options.txt
  mesonFlags = [
    "-Dsqlite=enabled"
    "-Dmagic=enabled"
    # "-Dseccomp=enabled"
    "-Dmanpages=enabled"
    "-Dconvert-icon=enabled"
    "-Dsynctex=enabled"
  ];

  nativeBuildInputs = [
    meson ninja pkgconfig desktop-file-utils python3.pkgs.sphinx
    gettext wrapGAppsHook libxml2 check
  ] ++ optional stdenv.isLinux appstream-glib;

  buildInputs = [
    gtk girara libintl sqlite glib file librsvg
    texlive.bin.core
  ] ++ optional stdenv.isLinux libseccomp
    ++ optional stdenv.isDarwin gtk-mac-integration;

  doCheck = true;

  meta = {
    homepage = https://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
}
