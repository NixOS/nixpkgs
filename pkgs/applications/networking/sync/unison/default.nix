{stdenv, fetchurl, ocaml, lablgtk, fontschumachermisc, xset, makeWrapper, ncurses
, enableX11 ? true}:

let
  nativeCode = if stdenv.system == "armv5tel-linux" then false else true;
in
stdenv.mkDerivation (rec {

  name = "unison-2.32.52";
  src = fetchurl {
    url = "http://www.seas.upenn.edu/~bcpierce/unison/download/releases/${name}/${name}.tar.gz";
    sha256 = "11844yh1gpjjapn8pvc14hla7g70spwqy6h61qk2is83mpafahhm";
  };

  buildInputs = [ ocaml makeWrapper ncurses ];

  preBuild = if enableX11 then ''
    sed -i "s|\(OCAMLOPT=.*\)$|\1 -I $(echo "${lablgtk}"/lib/ocaml/*/site-lib/lablgtk2)|" Makefile.OCaml
  '' else "";

  makeFlags = "INSTALLDIR=$(out)/bin/" + (if enableX11 then " UISTYLE=gtk2" else "")
    + (if ! nativeCode then " NATIVE=false" else "");

  preInstall = "ensureDir $out/bin";

  postInstall = if enableX11 then ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i \
        --run "[ -n \"\$DISPLAY\" ] && (${xset}/bin/xset q | grep -q \"${fontschumachermisc}\" || ${xset}/bin/xset +fp \"${fontschumachermisc}/lib/X11/fonts/misc\")"
    done
  '' else "";

  dontStrip = if ! nativeCode then true else false;

  meta = {
    homepage = http://www.cis.upenn.edu/~bcpierce/unison/;
    description = "Bidirectional file synchronizer";
    license = "GPLv3+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };

})
