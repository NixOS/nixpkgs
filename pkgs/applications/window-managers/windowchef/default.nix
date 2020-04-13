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
    homepage = "https://github.com/tudurom/windowchef";
    maintainers = with maintainers; [ bhougland ];
    license = licenses.isc;
    platforms = platforms.linux;
  };
}
