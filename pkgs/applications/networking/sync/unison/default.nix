{stdenv, fetchurl, ocaml, lablgtk, fontschumachermisc, xset, makeWrapper}:

stdenv.mkDerivation {
  name = "unison-2.13.16";
  src = fetchurl {
    url = http://www.seas.upenn.edu/~bcpierce/unison//download/releases/stable/unison-2.13.16.tar.gz;
    sha256 = "808400a933aeb67654edc770822cd186d1b2adc92e7cb5836996c71c69ffe656";
  };

  buildInputs = [ocaml];

  addInputsHook = "source $makeWrapper";
  preBuild = "sed -i \"s|\\(OCAMLOPT=.*\\)$|\\1 -I $lablgtk/lib/ocaml/lablgtk2|\" Makefile.OCaml";
  makeFlags = "UISTYLE=gtk2 INSTALLDIR=$(out)/bin/";
  preInstall = "ensureDir $out/bin";
  postInstall = [
    "for i in $(cd $out/bin && ls); do"
    "   mv $out/bin/$i $out/bin/.orig-$i;"
    "   echo \"#! $SHELL\" > $out/bin/$i;"
    "   echo \"$xset/bin/xset q | grep -q \\\"$fontschumachermisc\\\" || $xset/bin/xset +fp \\\"$fontschumachermisc/lib/X11/fonts/misc\\\"\" >> $out/bin/$i;"
    "   echo \"exec \\\"$out/bin/.orig-$i\\\" \\\"\\\$@\\\"\" >> $out/bin/$i;"
    "   chmod +x $out/bin/$i;"
    "done"
  ];

  inherit lablgtk fontschumachermisc xset makeWrapper;
}
