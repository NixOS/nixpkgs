{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, glib, ncurses, mpd_clientlib, libintlOrEmpty }:

stdenv.mkDerivation rec {
  name = "ncmpc-${version}";
  version = "0.27";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "0sfal3wadqvy6yas4xzhw35awdylikci8kbdcmgm4l2afpmc1lrr";
  };

  buildInputs = [ glib ncurses mpd_clientlib ];
    # ++ libintlOrEmpty;
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  # without this, po/Makefile.in.in is not being created
  preAutoreconf = ''
    ./autogen.sh
  '';

  configureFlags = [
    "--enable-colors"
    "--enable-lyrics-screen"
  ];

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = http://www.musicpd.org/clients/ncmpc/;
    license     = licenses.gpl2Plus;
    platforms   = platforms.all;
  };
}
