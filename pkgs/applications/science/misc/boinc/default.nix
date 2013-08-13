{ fetchgit, stdenv, autoconf, automake, pkgconfig, m4, curl,
mesa, libXmu, libXi, freeglut, libjpeg, libtool, wxGTK, xcbutil,
sqlite, gtk, patchelf, libXScrnSaver, libnotify, libX11, libxcb }:

stdenv.mkDerivation rec {
  name = "boinc-7.0.44";

  src = fetchgit {
    url = "git://boinc.berkeley.edu/boinc-v2.git";
    rev = "7c449b1fb8a681ceb27d6895751b62a2b3adf0f2";
    sha256 = "0hdramyl9nip3gadp7xiaz8ngyld15i93d8ai1nsd04bmrvdfqia";
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

    license = "LGPLv2+";

    platforms = stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
