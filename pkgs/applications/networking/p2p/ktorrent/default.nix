{ stdenv, fetchurl, cmake, automoc4, libktorrent, taglib, kdepimlibs, boost
, gettext, kdebase_workspace, qt4, kdelibs, phonon }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;

  pname = "ktorrent";
  version = "4.1.3";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${version}/${name}.tar.bz2";
    sha256 = "0ih68bml6ic3mxk5l4ypgmxwyg9mglp57gw5igrnm5yszm7jz19g";
  };

  patches = [ ./find-workspace.diff ./drop-taskmanager-dependency.patch ];

  KDEDIRS = libktorrent;

  buildInputs =
    [ cmake qt4 kdelibs automoc4 phonon libktorrent boost taglib kdepimlibs
      gettext kdebase_workspace
    ];

  enableParallelBuilding = true;

  meta = {
    description = "KDE integrated BtTorrent client";
    homepage = http://ktorrent.org;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (libktorrent.meta) platforms;
  };
}
