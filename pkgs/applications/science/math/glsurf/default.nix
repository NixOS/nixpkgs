{ lib
, stdenv
, fetchurl
, ocamlPackages
, makeWrapper
, libGLU
, libGL
, freeglut
, mpfr
, gmp
, pkgsHostTarget
}:

let
  inherit (pkgsHostTarget.targetPackages.stdenv) cc;
in

stdenv.mkDerivation rec {
  pname = "glsurf";
  version = "3.3.1";

  src = fetchurl {
    url = "https://raffalli.eu/~christophe/glsurf/glsurf-${version}.tar.gz";
    sha256 = "0w8xxfnw2snflz8wdr2ca9f5g91w5vbyp1hwlx1v7vg83d4bwqs7";
  };

  nativeBuildInputs = [
    makeWrapper
  ] ++ (with ocamlPackages; [
    ocaml
    findlib
  ]);

  buildInputs = [
    freeglut
    libGL
    libGLU
    mpfr
    gmp
  ] ++ (with ocamlPackages; [
    camlp4
    lablgl
    camlimages_4_2_4
  ]);

  postPatch = ''
    for f in callbacks*/Makefile src/Makefile; do
      substituteInPlace "$f" --replace "+camlp4" \
        "${ocamlPackages.camlp4}/lib/ocaml/${ocamlPackages.ocaml.version}/site-lib/camlp4"
    done
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/doc/glsurf
    cp ./src/glsurf.opt $out/bin/glsurf
    cp ./doc/doc.pdf $out/share/doc/glsurf
    cp -r ./examples $out/share/doc/glsurf

    wrapProgram "$out/bin/glsurf" --set CC "${cc}/bin/${cc.targetPrefix}cc"
  '';

  meta = {
    homepage = "https://raffalli.eu/~christophe/glsurf/";
    description = "A program to draw implicit surfaces and curves";
    license = lib.licenses.gpl2Plus;
  };
}
