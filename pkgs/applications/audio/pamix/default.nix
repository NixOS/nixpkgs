{ stdenv, fetchFromGitHub
, autoreconfHook, autoconf-archive, pkgconfig
, libpulseaudio, ncurses }:

stdenv.mkDerivation rec {
  name = "pamix-${version}";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner  = "patroclos";
    repo   = "pamix";
    rev    = "v${version}";
    sha256 = "06pxpalzynb8z7qwhkfs7sj823k9chdmpyj40rp27f2znf2qga19";
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
