{ lib, stdenv, fetchFromGitHub, libxcb, libXinerama
, xcbutil, xcbutilkeysyms, xcbutilwm
}:

stdenv.mkDerivation rec {
  pname = "bspwm";
  version = "0.9.10";

  src = fetchFromGitHub {
    owner  = "baskerville";
    repo   = "bspwm";
    rev    = version;
    sha256 = "0qlv7b4c2mmjfd65y100d11x8iqyg5f6lfiws3cgmpjidhdygnxc";
  };

  buildInputs = [ libxcb libXinerama xcbutil xcbutilkeysyms xcbutilwm ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Tiling window manager based on binary space partitioning";
    homepage = "https://github.com/baskerville/bspwm";
    maintainers = with maintainers; [ meisternu ];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
