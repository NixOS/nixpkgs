{ stdenv, fetchurl, fetchmtn, qt4 }:

let version = "1.0-mtn-head"; in
stdenv.mkDerivation rec {
  name = "guitone-${version}";

  #src = fetchurl {
  #  url = "${meta.homepage}/count.php/from=default/${version}/${name}.tgz";
  #  sha256 = "08kcyar6p6v5z4dq6q6c1dhyxc2jj49qcd6lj3rdn1rb9hz4n7ms";
  #};

  src = fetchmtn {
    dbs = ["mtn://code.monotone.ca/guitone"];
    selector = "2777cdef424c65df93fa1ff181f02ee30d4901ab";
    sha256 = "918d36a83060b84efa0ee0fe0fd058f1c871c91156d91366e2e979c886ff4271";
    branch = "net.venge.monotone.guitone";
  };

  buildInputs = [ qt4 ];

  prefixKey="PREFIX=";
  configureScript = "qmake guitone.pro";

  meta = {
    description = "Qt4 based GUI for monotone";
    homepage = http://guitone.thomaskeller.biz;
    inherit (qt4.meta) platforms;
  };
}
