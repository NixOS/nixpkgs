{ lib, ... }:

let
  inherit (lib) mkOption types;

  person = types.record {
    fields = {
      nixerSince = mkOption {
        type = types.int;
      };
      name = mkOption {
        type = types.str;
      };
      isCool = mkOption {
        type = types.bool;
        default = true;
      };
    };
  };

in {
  options.people = mkOption {
    type = types.attrsOf person;
  };
}
