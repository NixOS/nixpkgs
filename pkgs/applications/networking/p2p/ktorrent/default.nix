{ stdenv, fetchurl, cmake, automoc4, libktorrent, taglib, kdepimlibs, boost
, gettext, kdebase_workspace, qt4, kdelibs, phonon }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;

  pname = "ktorrent";
  version = "4.1.1";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${version}/${name}.tar.bz2";
    sha256 = "1h0fqh344sfwfbvnwhn00k8czb14568flapjf4754zss6bxpw4g4";
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
  };
}
