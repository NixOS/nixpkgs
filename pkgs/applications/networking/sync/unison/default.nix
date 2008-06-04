{stdenv, fetchurl, ocaml, lablgtk, fontschumachermisc, xset, makeWrapper}:

stdenv.mkDerivation (rec {

  name = "unison-2.13.16";
  src = fetchurl {
    url = "http://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/${name}.tar.gz";
    sha256 = "808400a933aeb67654edc770822cd186d1b2adc92e7cb5836996c71c69ffe656";
  };

  buildInputs = [ocaml makeWrapper];

  preBuild = ''
    sed -i "s|\(OCAMLOPT=.*\)$|\1 -I ${lablgtk}/lib/ocaml/lablgtk2|" Makefile.OCaml
  '';
  makeFlags = "UISTYLE=gtk2 INSTALLDIR=$(out)/bin/";
  preInstall = "ensureDir $out/bin";
  postInstall = ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i \
        --run "${xset}/bin/xset q | grep -q \"${fontschumachermisc}\" || ${xset}/bin/xset +fp \"${fontschumachermisc}/lib/X11/fonts/misc\""
    done
  '';

})
