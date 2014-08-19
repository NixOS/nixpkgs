{ stdenv, fetchdarcs, ocaml, findlib,  lablgl, camlimages, mesa, freeglut, ocaml_mysql, mlgmp, mpfr, gmp, libtiff, libjpeg, libpng, giflib }:

let
  ocaml_version = (builtins.parseDrvName ocaml.name).version;
in

stdenv.mkDerivation {
  name = "glsurf-3.3";

  src = fetchdarcs {
    url = "http://lama.univ-savoie.fr/~raffalli/GlSurf";
    rev = "3.3";
    sha256 = ""; md5="";
  };

  buildInputs = [ ocaml findlib freeglut mesa
  	          lablgl camlimages ocaml_mysql mlgmp mpfr gmp
		  libtiff libjpeg libpng giflib ];

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/glsurf
    cp ./src/glsurf.opt $out/bin/glsurf
    cp ./doc/doc.pdf $out/share/doc/glsurf
    cp -r ./examples $out/share/doc/glsurf
  '';

  meta = {
    homepage = http://www.lama.univ-savoie.fr/~raffalli/glsurf;
    description = "GlSurf: a program to draw implicit surfaces and curves";
  };
}
