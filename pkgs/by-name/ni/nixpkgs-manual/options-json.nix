{ lib, nixosOptionsDoc }:

let
  inherit (lib) evalModules hasPrefix removePrefix;

  modules = evalModules {
    modules = [ ../../../top-level/config.nix ];
    class = "nixpkgsConfig";
  };

  prefixBelowPath = toString ../../../../..;
  prefixAtPath = toString ../../../..;

  transformDeclarations =
    decl:
    let
      declStr = toString decl;
    in
    if hasPrefix prefixBelowPath declStr then
      let
        subpath = removePrefix "/" (removePrefix prefixAtPath declStr);
      in
      {
        url = "https://github.com/NixOS/nixpkgs/blob/master/${subpath}";
        name = subpath;
      }
    else
      decl;

  transformOptions = opt: opt // { declarations = map transformDeclarations opt.declarations; };

  optionsDoc = nixosOptionsDoc {
    inherit (modules) options;
    inherit transformOptions;
    documentType = "none";
  };
in

optionsDoc
