{ stdenv, fetchurl, cmake, automoc4, libktorrent, taglib, kdepimlibs, boost
, gettext, kdebase_workspace, qt4, kdelibs, phonon }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;

  pname = "ktorrent";
  version = "4.2.1";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${version}/${name}.tar.bz2";
    sha256 = "1b6w7i1vvq8mlw9yrlxvb51hvaj6rpl8lv9b9zagyl3wcanz73zd";
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
    homepage = http://ktorrent.org;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
    inherit (libktorrent.meta) platforms;
  };
}
