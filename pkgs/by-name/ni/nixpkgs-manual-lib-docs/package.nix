{ pkgs
, nixpkgs-doc-lib-function-docs
} :

import nixpkgs-doc-lib-function-docs {
  inherit pkgs;
  nixpkgs = null;
  libsets = [
    { name = "asserts"; description = "assertion functions"; }
    { name = "attrsets"; description = "attribute set functions"; }
    { name = "strings"; description = "string manipulation functions"; }
    { name = "versions"; description = "version string functions"; }
    { name = "trivial"; description = "miscellaneous functions"; }
    { name = "fixedPoints"; baseName = "fixed-points"; description = "explicit recursion functions"; }
    { name = "lists"; description = "list manipulation functions"; }
    { name = "debug"; description = "debugging functions"; }
    { name = "options"; description = "NixOS / nixpkgs option handling"; }
    { name = "path"; description = "path functions"; }
    { name = "filesystem"; description = "filesystem functions"; }
    { name = "fileset"; description = "file set functions"; }
    { name = "sources"; description = "source filtering functions"; }
    { name = "cli"; description = "command-line serialization functions"; }
    { name = "gvariant"; description = "GVariant formatted string serialization functions"; }
    { name = "customisation"; description = "Functions to customise (derivation-related) functions, derivatons, or attribute sets"; }
    { name = "meta"; description = "functions for derivation metadata"; }
    { name = "derivations"; description = "miscellaneous derivation-specific functions"; }
  ];
}
