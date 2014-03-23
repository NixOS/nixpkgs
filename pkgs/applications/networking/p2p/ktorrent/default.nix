{ stdenv, fetchurl, cmake, automoc4, libktorrent, taglib, kdepimlibs, boost
, gettext, kdebase_workspace, qt4, kdelibs, phonon }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;

  pname = "ktorrent";
  version = "4.3.1";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${version}/${name}.tar.bz2";
    sha256 = "66094f6833347afb0c49e332f0ec15ec48db652cbe66476840846ffd5ca0e4a1";
  };

  patches = [ ./find-workspace.diff ];

  KDEDIRS = libktorrent;

  buildInputs =
    [ cmake qt4 kdelibs automoc4 phonon libktorrent boost taglib kdepimlibs
      gettext kdebase_workspace
    ];

  enableParallelBuilding = true;

  meta = {
    description = "KDE integrated BtTorrent client";
    homepage = http://ktorrent.pwsp.net;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (libktorrent.meta) platforms;
  };
}
