{ runCommand, makeWrapper, geany, gnome }:
let name = builtins.replaceStrings ["geany-"] ["geany-with-vte-"] geany.name;
in
runCommand "${name}" { nativeBuildInputs = [ makeWrapper ]; } "
   mkdir -p $out
   ln -s ${geany}/share $out
   makeWrapper ${geany}/bin/geany $out/bin/geany --prefix LD_LIBRARY_PATH : ${gnome.vte}/lib
"
