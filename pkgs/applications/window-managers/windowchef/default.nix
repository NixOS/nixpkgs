{ stdenv, fetchFromGitHub, libxcb, libXrandr
, xcbutil, xcbutilkeysyms, xcbutilwm, xcbproto
}:

stdenv.mkDerivation rec {
  pname = "windowchef";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner  = "tudurom";
    repo   = "windowchef";
    rev    = "v${version}";
    sha256 = "0fs5ss2z6qjxvmls0g2f3gmv8hshi81xsmmcjn9x7651rv9552pl";
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
