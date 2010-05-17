{stdenv, fetchurl, ocaml, lablgtk, fontschumachermisc, xset, makeWrapper}:

stdenv.mkDerivation (rec {

  name = "unison-2.32.52";
  src = fetchurl {
    url = "http://www.seas.upenn.edu/~bcpierce/unison/download/releases/${name}/${name}.tar.gz";
    sha256 = "11844yh1gpjjapn8pvc14hla7g70spwqy6h61qk2is83mpafahhm";
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
        --run "[ -n \"\$DISPLAY\" ] && (${xset}/bin/xset q | grep -q \"${fontschumachermisc}\" || ${xset}/bin/xset +fp \"${fontschumachermisc}/lib/X11/fonts/misc\")"
    done
  '';

  meta = {
    homepage = http://www.cis.upenn.edu/~bcpierce/unison/;
    description = "Bidirectional file synchronizer";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

})
