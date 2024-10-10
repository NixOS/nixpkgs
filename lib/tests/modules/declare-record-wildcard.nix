{ lib, ... }:

let
  inherit (lib) mkOption types;

  person = types.record {
    fields = {
      nixerSince = mkOption { type = types.int; };
      name = mkOption { type = types.str; };
    };
    wildcard = mkOption { type = types.bool; };
  };

in
{
  options.people = mkOption { type = types.attrsOf person; };
}
