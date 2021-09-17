{ lib
, stdenv
, fetchFromGitHub
, autoconf
, automake
, gettext
, gtk
, intltool
, libtool
, ncurses
, openssl
, pkg-config
, readline
}:

stdenv.mkDerivation rec {
  pname = "gftp";
  version = "2.7.0b";

  src = fetchFromGitHub {
    owner = "masneyb";
    repo = pname;
    rev = version;
    hash = "sha256-cIB3SneYKavgdI8eTtM1qsOrBJJ0c7/3CEvNPishNog=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    gettext
    intltool
    libtool
    pkg-config
  ];
  buildInputs = [
    gtk
    ncurses
    openssl
    readline
  ];

  hardeningDisable = [ "format" ];

  preConfigure = ''
    ./autogen.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/masneyb/gftp";
    description = "GTK-based multithreaded FTP client for *nix-based machines";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: report the hardeningDisable to upstream
