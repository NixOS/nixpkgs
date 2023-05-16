<<<<<<< HEAD
{ lib
, stdenv
, autoconf
, automake
, autoreconfHook
, cairo
, fetchFromGitHub
, gettext
, gtk2-x11
, libtool
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "gerbv";
  version = "2.10.0";

  src = fetchFromGitHub {
    owner = "gerbv";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-sr48RGLYcMKuyH9p+5BhnR6QpKBvNOqqtRryw3+pbBk=";
  };

  postPatch = ''
    sed -i '/AC_INIT/s/m4_esyscmd.*/${version}])/' configure.ac
  '';

  nativeBuildInputs = [
    autoconf
    automake
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    cairo
    gettext
    gtk2-x11
    libtool
  ];

  configureFlags = [
    "--disable-update-desktop-database"
  ];

  meta = with lib; {
    description = "A Gerber (RS-274X) viewer";
    homepage = "https://gerbv.github.io/";
    changelog = "https://github.com/gerbv/gerbv/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mog ];
    platforms = platforms.unix;
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
