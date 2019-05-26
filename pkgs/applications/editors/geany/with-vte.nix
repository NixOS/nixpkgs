{ runCommand, makeWrapper, geany, gnome2 }:
let name = builtins.replaceStrings ["geany-"] ["geany-with-vte-"] geany.name;
in
runCommand "${name}" { nativeBuildInputs = [ makeWrapper ]; inherit (geany.meta); } "
   mkdir -p $out
   ln -s ${geany}/share $out
   makeWrapper ${geany}/bin/geany $out/bin/geany --prefix LD_LIBRARY_PATH : ${gnome2.vte}/lib
"
