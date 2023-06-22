{ pkgs ? (import ../.. {}), nixpkgs ? { }}:
let
  inherit (pkgs) lib;
  inherit (lib) hasPrefix removePrefix;

  libsets = [
    { name = "asserts"; description = "assertion functions"; }
    { name = "attrsets"; description = "attribute set functions"; }
    { name = "strings"; description = "string manipulation functions"; }
    { name = "versions"; description = "version string functions"; }
    { name = "trivial"; description = "miscellaneous functions"; }
    { name = "lists"; description = "list manipulation functions"; }
    { name = "debug"; description = "debugging functions"; }
    { name = "options"; description = "NixOS / nixpkgs option handling"; }
    { name = "path"; description = "path functions"; }
    { name = "filesystem"; description = "filesystem functions"; }
    { name = "sources"; description = "source filtering functions"; }
    { name = "cli"; description = "command-line serialization functions"; }
  ];

  functionDocs = import ./lib-function-docs.nix { inherit pkgs nixpkgs libsets; };
  version = pkgs.lib.version;

  # NB: This file describes the Nixpkgs manual, which happens to use module
  #     docs infra originally developed for NixOS.
  optionsDoc = pkgs.nixosOptionsDoc {
    inherit (pkgs.lib.evalModules {
      modules = [ ../../pkgs/top-level/config.nix ];
      class = "nixpkgsConfig";
    }) options;
    documentType = "none";
    transformOptions = opt:
      opt // {
        declarations =
          map
            (decl:
              if hasPrefix (toString ../..) (toString decl)
              then
                let subpath = removePrefix "/" (removePrefix (toString ../..) (toString decl));
                in { url = "https://github.com/NixOS/nixpkgs/blob/master/${subpath}"; name = subpath; }
              else decl)
            opt.declarations;
        };
  };

in pkgs.runCommand "doc-support" {}
''
  mkdir result
  (
    cd result
    ln -s ${functionDocs} ./function-docs
    ln -s ${optionsDoc.optionsJSON} ./config-options.json
  )
  mv result $out
''
