{ stdenv, fetchurl, meson, ninja, makeWrapper, pkgconfig
, appstream-glib, desktop-file-utils, python3
, gtk, girara, gettext, libxml2
, sqlite, glib, texlive, libintl, libseccomp
, file, librsvg
, gtk-mac-integration, synctexSupport ? true
}:

assert synctexSupport -> texlive != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "zathura-core-${version}";
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
  ] ++ optional synctexSupport "-Dsynctex=enabled";

  nativeBuildInputs = [
    meson ninja pkgconfig desktop-file-utils python3.pkgs.sphinx
    gettext makeWrapper libxml2
  ] ++ optional stdenv.isLinux appstream-glib;

  buildInputs = [
    gtk girara libintl sqlite glib file librsvg
  ] ++ optional synctexSupport texlive.bin.core
    ++ optional stdenv.isLinux libseccomp
    ++ optional stdenv.isDarwin gtk-mac-integration;

  meta = {
    homepage = https://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ garbas ];
  };
}
