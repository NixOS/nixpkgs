{ lib, stdenv, fetchurl, ocamlPackages, libGLU, libGL, freeglut, giflib
, libmysqlclient, mpfr, gmp, libtiff, libjpeg, libpng
}:

stdenv.mkDerivation {
  name = "glsurf-3.3.1";

  src = fetchurl {
    url = "https://raffalli.eu/~christophe/glsurf/glsurf-3.3.1.tar.gz";
    sha256 = "0w8xxfnw2snflz8wdr2ca9f5g91w5vbyp1hwlx1v7vg83d4bwqs7";
  };

  buildInputs = [ freeglut libGLU libGL libmysqlclient mpfr giflib gmp
    libtiff libjpeg libpng ]
  ++ (with ocamlPackages; [
    ocaml findlib ocaml_mysql lablgl camlimages_4_1_2 mlgmpidl
  ]);

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/glsurf
    cp ./src/glsurf.opt $out/bin/glsurf
    cp ./doc/doc.pdf $out/share/doc/glsurf
    cp -r ./examples $out/share/doc/glsurf
  '';

  meta = {
    homepage = "https://raffalli.eu/~christophe/glsurf/";
    description = "A program to draw implicit surfaces and curves";
    license = lib.licenses.gpl2Plus;
  };
}
