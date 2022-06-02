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
}:

stdenv.mkDerivation rec {
  pname = "xedit";
  version = "1.2.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "xorg/app";
    repo = "xedit";
    rev = "${pname}-${version}";
    sha256 = "sha256-WF+4avzRRL0+OA3KxzK7JwmArkPu9fEl+728R6ouXmg=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config utilmacros ];
  buildInputs = [
    libX11
    libXaw
    libXmu
    libXt
  ];

  configureFlags = [
    "--with-lispdir=$out/share/X11/xedit/lisp"
    "--with-appdefaultdir=$out/share/X11/app-defaults"
  ];

  meta = with lib; {
    description = "Simple graphical text editor using Athena Widgets (Xaw)";
    homepage = "https://gitlab.freedesktop.org/xorg/app/xedit";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
