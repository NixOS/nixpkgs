{ lib, stdenv, fetchurl, fetchpatch, pkg-config, gettext, libtool, automake, autoconf, cairo, gtk2-x11, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "gerbv";
  version = "2.7.0";

  src = fetchurl {
    url = "mirror://sourceforge/gerbv/${pname}-${version}.tar.gz";
    sha256 = "sha256-xe6AjEIwzmvjrRCrY8VHCYOG1DAicE3iXduTeOYgU7Q=";
  };

  patches = [
    # Pull patch pending upstream inclusion for -fno-common toolchains:
    #  https://sourceforge.net/p/gerbv/patches/84/
    (fetchpatch {
      name = "fnoc-mmon.patch";
      url = "https://sourceforge.net/p/gerbv/patches/84/attachment/0001-gerbv-fix-build-on-gcc-10-fno-common.patch";
      sha256 = "1avfbkqhxl7wxn1z19y30ilkwvdgpdkzhzawrs5y3damxmqq8ggk";
    })
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config automake autoconf ];
  buildInputs = [ gettext libtool cairo gtk2-x11 ];

  configureFlags = ["--disable-update-desktop-database"];

  env.NIX_CFLAGS_COMPILE = "-Wno-format-security";

  meta = with lib; {
    description = "A Gerber (RS-274X) viewer";
    homepage = "http://gerbv.geda-project.org/";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.unix;
    license = licenses.gpl2;
  };
}
