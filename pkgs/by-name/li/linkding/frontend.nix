{ buildNpmPackage, callPackage }:
let
  common = callPackage ./common.nix { };
in
buildNpmPackage {
  inherit (common) src version npmDepsHash;

  pname = "linkding-frontend";

  installPhase = ''
    mkdir -p $out/bookmarks/static
    cp -r node_modules/ $out/node_modules
    cp -r bookmarks/static/bundle.js* $out/bookmarks/static/
  '';

  meta = common.meta // {
    description = "Linkding frontend";
  };
}

