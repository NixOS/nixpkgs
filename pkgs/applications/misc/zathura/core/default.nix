{ stdenv, fetchurl, meson, ninja, wrapGAppsHook, pkgconfig
, appstream-glib, desktop-file-utils, python3
, gtk, girara, gettext, libxml2, check
, sqlite, glib, texlive, libintl, libseccomp
, file, librsvg
, gtk-mac-integration
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "zathura";
  version = "0.4.5";

  src = fetchurl {
    url = "https://pwmt.org/projects/${pname}/download/${pname}-${version}.tar.xz";
    sha256 = "0b3nrcvykkpv2vm99kijnic2gpfzva520bsjlihaxandzfm9ff8c";
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
    # Make sure tests are enabled for doCheck
    "-Dtests=enabled"
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
    homepage = "https://git.pwmt.org/pwmt/zathura";
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
}
