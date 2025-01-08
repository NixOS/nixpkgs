{ lib, ... }:

let
  inherit (lib) mkField mkOption types;

  person = types.record {
    fields = {
      nixerSince = mkField { type = types.int; };
      name = mkField { type = types.str; };
      age = mkField {
        type = types.ints.unsigned;
        optional = true;
      };
    };
    freeformType = types.bool;
  };

in
{
  options.people = mkOption { type = types.attrsOf person; };
}
