{ fetchFromGitHub, stdenv, autoconf, automake, pkgconfig, m4, curl,
mesa, libXmu, libXi, freeglut, libjpeg, libtool, wxGTK, xcbutil,
sqlite, gtk2, patchelf, libXScrnSaver, libnotify, libX11, libxcb }:

stdenv.mkDerivation rec {
  version = "7.4.42";
  name = "boinc-${version}";

  src = fetchFromGitHub {
    owner = "BOINC";
    repo = "boinc";
    rev = "561fbdae0cac3be996136319828f43cbc62c9";
    sha256 = "1rlh463yyz88p2g5pc6avndn3x1162vcksgbqich0i3qb90jms29";
  };

  buildInputs = [ libtool automake autoconf m4 pkgconfig curl mesa libXmu libXi
    freeglut libjpeg wxGTK sqlite gtk2 libXScrnSaver libnotify patchelf libX11
    libxcb xcbutil
  ];

  NIX_LDFLAGS = "-lX11";

  preConfigure = ''
    ./_autosetup
    configureFlags="$configureFlags --sysconfdir=$out/etc"
  '';

  enableParallelBuilding = true;

  configureFlags = "--disable-server";

  meta = {
    description = "Free software for distributed and grid computing";

    homepage = http://boinc.berkeley.edu/;

    license = stdenv.lib.licenses.lgpl2Plus;

    platforms = stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
