{ stdenv, fetchurl, cmake, automoc4, libktorrent, taglib, kdepimlibs, boost,
  gettext, kdebase_workspace }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;

  pname = "ktorrent";
  version = "4.0.3";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${version}/${name}.tar.bz2";
    sha256 = "02hp52333w75mdywgsln28samf9ybr9yldg1jsw0b93lj44pfxli";
  };

  patches = [ ./find-workspace.diff ];

  KDEDIRS = libktorrent;

  buildInputs = [ automoc4 cmake libktorrent taglib kdepimlibs boost gettext
    kdebase_workspace ];

  meta = {
    description = "KDE integrated BtTorrent client";
    homepage = http://ktorrent.org;
    maintainers = with stdenv.lib.maintainers; [ sander urkud ];
  };
}
