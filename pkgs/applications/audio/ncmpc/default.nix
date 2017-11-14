{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, ncurses
, mpd_clientlib, gettext }:

let
  rpath = stdenv.lib.makeLibraryPath [
    glib ncurses mpd_clientlib
  ];
in stdenv.mkDerivation rec {
  name = "ncmpc-${version}";
  version = "0.28";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "1z0bdkqsdb3f5k2lsws3qzav4r30fzk8fhxj9l0p738flcka6k4n";
  };

  buildInputs = [ glib ncurses mpd_clientlib ];
  nativeBuildInputs = [ meson ninja pkgconfig gettext ];

  postFixup = stdenv.lib.optionalString stdenv.isLinux ''
    for elf in "$out"/bin/*; do
      patchelf --set-rpath '${rpath}':"$out/lib" "$elf"
    done
  '';

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-lintl";

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = http://www.musicpd.org/clients/ncmpc/;
    license     = licenses.gpl2Plus;
    platforms   = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
