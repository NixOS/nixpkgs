{ lib
, stdenv
, fetchFromGitLab
, autoreconfHook
, pkg-config
, utilmacros
, libX11
, libXaw
, libXmu
, libXt
, breakpointHook
}:

stdenv.mkDerivation rec {
  pname = "xedit";
  version = "1.2.2";

  src = fetchFromGitLab {
    owner = "xorg/app";
    domain = "gitlab.freedesktop.org";
    repo = "xedit";
    rev = "${pname}-${version}";
    sha256 = "0b5ic13aasv6zh20v2k7zyxsqbnsxfq5rs3w8nwzl1gklmgrjxa3";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config utilmacros breakpointHook ];
  buildInputs = [
    libX11
    libXaw
    libXmu
    libXt
  ];

  configureFlags = [ "--with-lispdir=$out/share/X11/xedit/lisp"
                     "--with-appdefaultdir=$out/share/X11/app-defaults"];

  meta = with lib; {
    description = "Simple graphical text editor using Athena Widgets (Xaw)";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xedit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
