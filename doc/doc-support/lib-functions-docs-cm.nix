# Generates the documentation for library functions via nixdoc. When you add
# another library file here, you also need to add it to the `doc/toc.md`.
{ pkgs ? import ../.. {} }:

with pkgs; stdenv.mkDerivation {
  name = "nixpkgs-lib-docs";
  src = ./../../lib;

  buildInputs = [ nixdoc-commonmark ];
  installPhase = ''
    function docgen {
      nixdoc -c "$1" -d "$2" -f "../lib/$1.nix"  > "$out/$1.md"
    }

    mkdir -p $out

    docgen asserts 'Assert functions'
    docgen attrsets 'Attrset functions'
    docgen strings 'String manipulation functions'
    docgen trivial 'Miscellaneous functions'
    docgen lists 'List manipulation functions'
    docgen debug 'Debugging functions'
    docgen options 'NixOS / nixpkgs option handling'
  '';
}
