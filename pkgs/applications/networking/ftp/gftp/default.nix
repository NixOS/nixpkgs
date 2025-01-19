{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  gettext,
  gtk,
  intltool,
  libtool,
  ncurses,
  openssl,
  pkg-config,
  readline,
}:

stdenv.mkDerivation rec {
  pname = "gftp";
  version = "2.9.1b";

  src = fetchFromGitHub {
    owner = "masneyb";
    repo = pname;
    rev = version;
    hash = "sha256-0zdv2oYl24BXh61IGCWby/2CCkzNjLpDrAFc0J89Pw4=";
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

  preConfigure = ''
    ./autogen.sh
  '';

  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://github.com/masneyb/gftp";
    description = "GTK-based multithreaded FTP client for *nix-based machines";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
# TODO: report the hardeningDisable to upstream
