# Build a version of idris with a set of packages visible
# packages: The packages visible to idris
{ lib, idris, symlinkJoin, makeWrapper }: packages:

let paths = lib.closePropagation packages;
in
lib.appendToName "with-packages" (symlinkJoin {

  inherit (idris) name;

  paths = paths ++ [idris] ;

  nativeBuildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram $out/bin/idris \
      --set IDRIS_LIBRARY_PATH $out/libs
  '';

})
