# Build a version of Agda with a set of packages visible
# packages: The packages visible to Agda
# This file is inspired by idris-modules/with-packages.nix
{ symlinkJoin, lib, Agda, makeWrapper, packages }:

let paths' = lib.filter (dep: dep ? isAgdaLibrary && dep.isAgdaLibrary)
                        (lib.closePropagation packages);
    packagesShareAgda = map (x: x + "/share/agda") paths';
    buildFlags = builtins.concatStringsSep " " (map (x: "-i " + x) packagesShareAgda);

in symlinkJoin rec {

  inherit (Agda) version meta;

  name = Agda.name + "-with-packages";

  paths = paths' ++ [ Agda ];

  buildInputs = [ makeWrapper ] ++ paths;

  postBuild = ''
    wrapProgram $out/bin/agda --add-flags '${buildFlags}'
  '';
}
