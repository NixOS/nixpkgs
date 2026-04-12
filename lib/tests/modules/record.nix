{ lib, ... }:
let
  inherit (lib) mkOption types;
  person = types.record {
    fields = {
      since = {
        type = types.int;
      };
      name = {
        type = types.str;
      };
      cool = {
        type = types.bool;
        default = true;
      };
    };
    finalise =
      {
        name,
        self,
        fields,
      }:
      {
        name = lib.mkDefault name;
      };
  };
in
{
  options.people = mkOption { type = types.attrsOf person; };
  config.people.alice.since = 2016;
  config.people.bob = {
    since = 2019;
    cool = false;
  };
}
