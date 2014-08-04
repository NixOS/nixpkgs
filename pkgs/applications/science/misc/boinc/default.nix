{ fetchgit, stdenv, autoconf, automake, pkgconfig, m4, curl,
mesa, libXmu, libXi, freeglut, libjpeg, libtool, wxGTK, xcbutil,
sqlite, gtk, patchelf, libXScrnSaver, libnotify, libX11, libxcb }:

stdenv.mkDerivation rec {
  name = "boinc-7.2.42";

  src = fetchgit {
    url = "git://boinc.berkeley.edu/boinc-v2.git";
    rev = "dd0d630882547c123ca0f8fda7a62e058d60f6a9";
    sha256 = "1zifpi3mjgaj68fba6kammp3x7z8n2x164zz6fj91xfiapnan56j";
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
