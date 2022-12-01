{ lib, stdenv, fetchgit, fetchpatch, pkg-config, gettext, libtool, automake, autoconf, cairo, gtk2, autoreconfHook }:

stdenv.mkDerivation {
  pname = "gerbv";
  version = "2015-10-08";

  src = fetchgit {
    url = "git://git.geda-project.org/gerbv.git";
    rev = "76b8b67bfa10823ce98f1c4c3b49a2afcadf7659";
    sha256 = "00jn1xhf6kblxc5gac1wvk8zm12fy6sk81nj3jwdag0z6wk3z446";
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
  buildInputs = [ gettext libtool cairo gtk2 ];

  configureFlags = ["--disable-update-desktop-database"];

  meta = with lib; {
    description = "A Gerber (RS-274X) viewer";
    homepage = "http://gerbv.geda-project.org/";
    maintainers = with maintainers; [ mog ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
