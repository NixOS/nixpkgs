{ stdenv, fetchFromGitHub, libxcb, libXinerama
, xcbutil, xcbutilkeysyms, xcbutilwm
}:

stdenv.mkDerivation rec {
  name = "bspwm-${version}";
  version = "0.9.6";

  src = fetchFromGitHub {
    owner  = "baskerville";
    repo   = "bspwm";
    rev    = version;
    sha256 = "1ywjhqxvggfdfd3cfki0vvlsli8lhqlziwfrj5vd57c6yisc2fyy";
  };

  buildInputs = [ libxcb libXinerama xcbutil xcbutilkeysyms xcbutilwm ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A tiling window manager based on binary space partitioning";
    homepage = https://github.com/baskerville/bspwm;
    maintainers = with maintainers; [ meisternu epitrochoid rvolosatovs ];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
