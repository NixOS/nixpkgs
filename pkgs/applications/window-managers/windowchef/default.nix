{ stdenv, fetchFromGitHub, libxcb, libXrandr
, xcbutil, xcbutilkeysyms, xcbutilwm, xcbproto
}:

stdenv.mkDerivation rec {
  pname = "windowchef";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner  = "tudurom";
    repo   = "windowchef";
    rev    = "v${version}";
    sha256 = "02fvb8fxnkpzb0vpbsl6rf7ssdrvw6mlm43qvl2sxq7zb88zdw96";
  };

  buildInputs = [ libxcb libXrandr xcbutil xcbutilkeysyms xcbutilwm xcbproto];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "A stacking window manager that cooks windows with orders from the Waitron";
<<<<<<< HEAD
    homepage = https://github.com/tudurom/windowchef;
    maintainers = with maintainers; [ bhougland ];
=======
    homepage = "https://github.com/tudurom/windowchef";
    maintainers = with maintainers; [ bhougland18 ];
>>>>>>> 5bc498bfbe352f2c18e4ebf10d65879506b1c91a
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
