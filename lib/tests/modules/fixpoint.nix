{ lib, ... }:
let
  inherit (lib) types mkOption;

  person = types.record {
    fields = {
      name = mkOption { type = lib.types.str; };
      age = mkOption { type = lib.types.int; };
    };
  };

  bobber = { value }: {
    name = if value.age < 10 then "bobby" else "bob";
  };
in
{
  options = {
    people = mkOption {
      type = types.attrsOf (types.fix person);
      default = {};
    };
  };
  config = {
    people.bob = lib.mkMerge [ { age = 23; } bobber ];
    people.lilbob = lib.mkMerge [ { age = 3; } bobber ];
  };
}
