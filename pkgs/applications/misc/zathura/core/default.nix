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
  version = "0.4.4";

  src = fetchurl {
    url = "https://git.pwmt.org/pwmt/zathura/-/archive/${version}/zathura-${version}.tar.gz";
    sha256 = "0v5klgr009rsxi41h73k0398jbgmgh37asvwz2w15i4fzmw89jgb";
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
    homepage = "https://git.pwmt.org/pwmt/zathura";
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ globin ];
  };
}
