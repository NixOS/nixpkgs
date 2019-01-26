{ stdenv, fetchurl, meson, ninja, makeWrapper, pkgconfig
, appstream-glib, desktop-file-utils, python3
, gtk, girara, gettext, libxml2
, sqlite, glib, texlive, libintl, libseccomp
, gtk-mac-integration, synctexSupport ? true
}:

assert synctexSupport -> texlive != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "zathura-core-${version}";
  version = "0.4.1";

  src = fetchurl {
    url = "https://pwmt.org/projects/zathura/download/zathura-${version}.tar.xz";
    sha256 = "1znr3psqda06xklzj8mn452w908llapcg1rj468jwpg0wzv6pxfn";
  };

  outputs = [ "bin" "man" "dev" "out" ];

  nativeBuildInputs = [
    meson ninja pkgconfig appstream-glib desktop-file-utils python3.pkgs.sphinx
    gettext makeWrapper libxml2
  ];

  buildInputs = [
    gtk girara libintl libseccomp
    sqlite glib
  ] ++ optional synctexSupport texlive.bin.core
    ++ optional stdenv.isDarwin [ gtk-mac-integration ];

  meta = {
    homepage = https://pwmt.org/projects/zathura/;
    description = "A core component for zathura PDF viewer";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ garbas ];
  };
}
