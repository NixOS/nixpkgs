{ fetchgit, stdenv, autoconf, automake, pkgconfig, m4, curl,
mesa, libXmu, libXi, freeglut, libjpeg, libtool, wxGTK, xcbutil,
sqlite, gtk, patchelf, libXScrnSaver, libnotify, libX11, libxcb }:

stdenv.mkDerivation rec {
  name = "boinc-7.4.14";

  src = fetchgit {
    url = "git://boinc.berkeley.edu/boinc-v2.git";
    rev = "fb31ab18f94f3b5141bea03e8537d76c606cd276";
    sha256 = "1465zl8l87fm1ps5f2may6mcc3pp40mpd6wphpxnwwk1lmv48x96";
  };

  buildInputs = [ libtool automake autoconf m4 pkgconfig curl mesa libXmu libXi
    freeglut libjpeg wxGTK sqlite gtk libXScrnSaver libnotify patchelf libX11 
    libxcb xcbutil
  ];

  postConfigure = ''
    sed -i -e s,/etc,$out/etc, client/scripts/Makefile
  '';

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
