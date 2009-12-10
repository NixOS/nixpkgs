{stdenv, fetchurl, ocaml, lablgtk, fontschumachermisc, xset, makeWrapper}:

stdenv.mkDerivation (rec {

  name = "unison-2.27.57";
  src = fetchurl {
    url = "http://www.seas.upenn.edu/~bcpierce/unison/download/releases/unison-2.27.57/unison-2.27.57.tar.gz";
    sha256 = "49299ec14216a8467b2c6ba148f8145bec31fa787433f9ce3851c2d62f0035ae";
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
