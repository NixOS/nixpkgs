{ lib, config, ... }:
{
  imports = [
    ./assertions.nix
    (lib.mkRemovedOptionModule [ "a" "b" ] "instructions")
    (lib.mkRemovedOptionModule [ "c" "d" "e" ] "")
  ];

  options = {
    errors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = map (x: x.message) (lib.filter (x: !x.assertion) config.assertions);
    };
  };

  config = {
    a.b = lib.mkDefinition {
      file = "example-file";
      value = 1234;
    };
  };
}
