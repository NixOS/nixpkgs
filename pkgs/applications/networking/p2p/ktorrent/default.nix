{ stdenv, fetchurl, cmake, automoc4, libktorrent, taglib, kdepimlibs, boost,
  gettext, kdebase_workspace }:

stdenv.mkDerivation rec {
  name = pname + "-" + version;

  pname = "ktorrent";
  version = "4.0.5";

  src = fetchurl {
    url = "${meta.homepage}/downloads/${version}/${name}.tar.bz2";
    sha256 = "1kgy0r9c51w38vj5kjla16vh7nigs89qvvjybjjkv4r41nz9kcfn";
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
