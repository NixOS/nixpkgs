{ stdenv, fetchFromGitHub
, autoreconfHook, autoconf-archive, pkgconfig
, libpulseaudio, ncurses }:

stdenv.mkDerivation rec {
  name = "pamix-${version}";
  version = "1.5";

  src = fetchFromGitHub {
    owner  = "patroclos";
    repo   = "pamix";
    rev    = version;
    sha256 = "1d6b0iv8p73bwq88kdaanm4igvmp9rkq082vyaxpc67mz398yjbp";
  };

  nativeBuildInputs = [ autoreconfHook autoconf-archive pkgconfig ];
  buildInputs = [ libpulseaudio ncurses ];

  meta = with stdenv.lib; {
    description = "Pulseaudio terminal mixer";
    homepage    = https://github.com/patroclos/PAmix;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ ericsagnes ];
  };
}
