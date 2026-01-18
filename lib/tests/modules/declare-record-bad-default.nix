{ lib, ... }:

let
  inherit (lib) mkField mkOption types;

  person = types.record {
    fields = {
      nixerSince = mkField { type = types.int; };
      name = mkField { type = types.str; };
      isCool = mkField {
        type = types.bool;
        default = "yeah";
      };
    };
  };

in
{
  options.people = mkOption { type = types.attrsOf person; };
}
