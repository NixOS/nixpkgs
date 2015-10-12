{ runCommand, makeWrapper, geany, gnome }:
let name = builtins.replaceStrings ["geany-"] ["geany-with-vte-"] geany.name;
in
runCommand "${name}" { nativeBuildInputs = [ makeWrapper ]; } "
   makeWrapper ${geany}/bin/geany $out/bin/geany --prefix LD_LIBRARY_PATH : ${gnome.vte}/lib
"
