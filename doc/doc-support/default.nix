{ pkgs ? (import ../.. {}), nixpkgs ? { }}:
let
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

in pkgs.runCommand "doc-support" {}
''
  mkdir result
  (
    cd result
    ln -s ${functionDocs} ./function-docs
  )
  mv result $out
''
