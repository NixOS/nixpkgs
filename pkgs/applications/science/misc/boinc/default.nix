#TODO: build without GUI for headless operation.

{ fetchgit, stdenv, autoconf, automake, pkgconfig, m4, curl,
mesa, libXmu, libXi, freeglut, libjpeg, libtool, wxGTK, xcbutil,
sqlite, gtk, patchelf, libXScrnSaver, libnotify, libX11, libxcb }:

let
  version = "7.2.42";
in
stdenv.mkDerivation rec {
  name = "boinc-${version}";

  src = fetchgit {
    url = git://boinc.berkeley.edu/boinc-v2.git;
    rev = "refs/tags/client_release/7.2/${version}";
    sha256 = "1zifpi3mjgaj68fba6kammp3x7z8n2x164zz6fj91xfiapnan56j";
  };

  buildInputs = [ libtool automake autoconf m4 pkgconfig curl mesa libXmu libXi
    freeglut libjpeg wxGTK sqlite gtk libXScrnSaver libnotify patchelf libX11 
    libxcb xcbutil
  ];

  patches = [ ./no-runscript.patch ];

  NIX_LDFLAGS = "-lX11";

  preConfigure = "./_autosetup";

  enableParallelBuilding = true;

  configureFlags = "--disable-server";

  meta = {
    description = "Free software for distributed and grid computing";
    homepage = http://boinc.berkeley.edu/;
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.emery ];
    platforms = stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
