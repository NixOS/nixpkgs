{ stdenv, fetchFromGitHub, libxcb, libXinerama
, sxhkd, xcbutil, xcbutilkeysyms, xcbutilwm
}:

stdenv.mkDerivation rec {
  name = "bspwm-${version}";
  version = "0.9.3";

  src = fetchFromGitHub {
    owner  = "baskerville";
    repo   = "bspwm";
    rev    = version;
    sha256 = "144g0vg0jsy0lja2jv1qbdps8k05nk70pc7vslj3im61a21vnbis";
  };

  buildInputs = [ libxcb libXinerama xcbutil xcbutilkeysyms xcbutilwm ];

  PREFIX = "$out";

  meta = with stdenv.lib; {
    description = "A tiling window manager based on binary space partitioning";
    homepage = http://github.com/baskerville/bspwm;
    maintainers = with maintainers; [ meisternu epitrochoid ];
    license = licenses.bsd2;
    platforms = platforms.linux;
  };
}
