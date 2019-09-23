{ stdenv, fetchFromGitHub, libxcb, libXinerama
, xcbutil, xcbutilkeysyms, xcbutilwm
}:

stdenv.mkDerivation rec {
  pname = "bspwm";
  version = "0.9.9";

  src = fetchFromGitHub {
    owner  = "baskerville";
    repo   = "bspwm";
    rev    = version;
    sha256 = "1i7crmljk1vra1r6alxvj6lqqailjjcv0llyg7a0gm23rbv4a42g";
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
