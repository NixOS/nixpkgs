{ stdenv, fetchurl, qt4 }:

let version = "1.0rc4"; in
stdenv.mkDerivation rec {
  name = "guitone-${version}";

  src = fetchurl {
    url = "${meta.homepage}/count.php/from=default/${version}/${name}.tgz";
    sha256 = "08kcyar6p6v5z4dq6q6c1dhyxc2jj49qcd6lj3rdn1rb9hz4n7ms";
  };

  buildInputs = [ qt4 ];

  prefixKey="PREFIX=";
  configureScript = "qmake";

  meta = {
    description = "Qt4 based GUI for monotone";
    homepage = http://guitone.thomaskeller.biz;
    inherit (qt4.meta) platforms;
  };
}
