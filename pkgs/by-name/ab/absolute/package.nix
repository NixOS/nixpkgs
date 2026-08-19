{ lib, ocamlPackages }:

let
  inherit (ocamlPackages) buildDunePackage libabsolute;
in

buildDunePackage {
  pname = "absolute";
  inherit (libabsolute) src version;

  __structuredAttrs = true;

  buildInputs = [ libabsolute ];

  meta = libabsolute.meta // {
    description = "A constraint solver based on abstract domains from the theory of abstract interpretation";
  };
}
