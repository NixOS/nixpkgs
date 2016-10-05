{ stdenv, fetchdarcs, ocaml, findlib,  lablgl, camlimages, mesa, freeglut, ocaml_mysql, mysql, mlgmp, mpfr, gmp, libtiff, libjpeg, libpng, giflib }:

stdenv.mkDerivation {
  name = "glsurf-3.3";

  src = fetchdarcs {
    url = "http://lama.univ-savoie.fr/~raffalli/GlSurf";
    rev = "3.3";
    sha256 = "0ljvvzz31j7l8rvsv63x1kj70nhw3al3k294m79hpmwjvym1mzfa";
  };

  buildInputs = [ ocaml findlib freeglut mesa
  	          lablgl camlimages ocaml_mysql mysql.lib mlgmp mpfr gmp
		  libtiff libjpeg libpng giflib ];

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/glsurf
    cp ./src/glsurf.opt $out/bin/glsurf
    cp ./doc/doc.pdf $out/share/doc/glsurf
    cp -r ./examples $out/share/doc/glsurf
  '';

  meta = {
    homepage = http://www.lama.univ-savoie.fr/~raffalli/glsurf;
    description = "A program to draw implicit surfaces and curves";
    broken = true;
  };
}
