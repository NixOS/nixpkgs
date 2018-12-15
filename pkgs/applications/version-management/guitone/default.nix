{ stdenv, fetchmtn, qt4, qmake4Hook, pkgconfig, graphviz }:

let version = "1.0-mtn-head"; in
stdenv.mkDerivation rec {
  name = "guitone-${version}";

  #src = fetchurl {
  #  url = "${meta.homepage}/count.php/from=default/${version}/${name}.tgz";
  #  sha256 = "08kcyar6p6v5z4dq6q6c1dhyxc2jj49qcd6lj3rdn1rb9hz4n7ms";
  #};

  src = fetchmtn {
    dbs = ["mtn://code.monotone.ca/guitone"];
    selector = "3a728afdbd3943b1d86c2a249b1e2ede7bf64c27";
    sha256 = "01vs8m00phs5pl75mjkpdarynfpkqrg0qf4rsn95czi3q6nxiaq5";
    branch = "net.venge.monotone.guitone";
  };

  patches = [ ./parallel-building.patch ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ qt4 qmake4Hook graphviz ];

  qmakeFlags = [ "guitone.pro" ];

  meta = {
    description = "Qt4 based GUI for monotone";
    homepage = https://guitone.thomaskeller.biz;
    downloadPage = https://code.monotone.ca/p/guitone/;
    license = stdenv.lib.licenses.gpl3;
    inherit (qt4.meta) platforms;
  };
}
