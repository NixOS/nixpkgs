# Generates the documentation for library functons via nixdoc. To add
# another library function file to this list, the include list in the
# file `doc/functions/library.xml` must also be updated.

{ pkgs ? import ./.. {}, locationsXml }:

with pkgs; stdenv.mkDerivation {
  name = "nixpkgs-lib-docs";
  src = ./../../lib;

  buildInputs = [ nixdoc ];
  installPhase = ''
    function docgen {
      nixdoc -c "$1" -d "$2" -f "../lib/$1.nix"  > "$out/$1.xml"
    }

    mkdir -p $out
    ln -s ${locationsXml} $out/locations.xml

    docgen strings 'String manipulation functions'
    docgen trivial 'Miscellaneous functions'
    docgen lists 'List manipulation functions'
    docgen debug 'Debugging functions'
    docgen options 'NixOS / nixpkgs option handling'
    docgen filesystem 'Filesystem functions'
    docgen sources 'Source filtering functions'
  '';
}
