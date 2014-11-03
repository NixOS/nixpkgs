{ stdenv, fetchgit, ocaml, mupdf, lablgl, mesa
, libX11, libXext, gtk3, freetype, zlib, openjpeg
, jbig2dec, libjpeg, ncurses }:

stdenv.mkDerivation {
  name = "llpp-2014-05-26";

  src = fetchgit {
    url = "git://repo.or.cz/llpp.git";
    rev  = "902143de64d86b5714b3a59d2cc7085083b87249";
    sha256 = "038xl4gbvm57na2lz1fw36sf43zaxq407zi2d53985vc33677j9s";
  };

  buildInputs = [ ocaml mupdf lablgl mesa libX11 libXext gtk3
                  freetype jbig2dec libjpeg openjpeg zlib ncurses ];

  # The build phase was extracted from buildall.sh, because that script
  # fetched the dependencies on its own.
  buildPhase = ''
    ccopt="-O"
    ccopt="$ccopt -I ${jbig2dec}/include"
    ccopt="$ccopt -I ${libjpeg}/include"
    ccopt="$ccopt -I ${freetype}/include/freetype2"
    ccopt="$ccopt -I ${openjpeg}/include"
    ccopt="$ccopt -I ${zlib}/include"
    ccopt="$ccopt -I ${mupdf}/include"
    ccopt="$ccopt -include ft2build.h"
    ccopt="$ccopt -D_GNU_SOURCE"

    cclib="$cclib -lmupdf"
    cclib="$cclib -lz -ljpeg -lopenjp2 -ljbig2dec -lfreetype -lpthread"
    cclib="$cclib -lX11"
    cclib="$cclib -lfreetype"

    comp=ocamlc.opt
    cmsuf=cmo

    sh mkhelp.sh keystoml.ml KEYS > help.ml

    $comp -c -o link.o -ccopt "$ccopt" link.c
    $comp -c -o help.$cmsuf help.ml
    $comp -c -o utils.$cmsuf utils.ml
    $comp -c -o wsi.cmi wsi.mli
    $comp -c -o wsi.$cmsuf wsi.ml
    $comp -c -o parser.$cmsuf parser.ml
    $comp -c -o main.$cmsuf -I ${lablgl}/lib/ocaml/4.01.0/site-lib/lablgl main.ml

    $comp -custom -o llpp           \
          -I ${lablgl}/lib/ocaml/4.01.0/site-lib/lablgl \
          str.cma unix.cma lablgl.cma \
          link.o                      \
          -cclib "$cclib"             \
          help.cmo                    \
          utils.cmo                   \
          parser.cmo                  \
          wsi.cmo                     \
          main.cmo
  '';

  # Binary fails with 'No bytecode file specified.' if stripped.
  dontStrip = true;

  installPhase = ''
    install -d $out/bin
    install llpp llppac $out/bin
  '';

  meta = {
    homepage = http://repo.or.cz/w/llpp.git;
    description = "A MuPDF based PDF pager written in OCaml";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.pSub ];
    license = "GPL";
  };
}
