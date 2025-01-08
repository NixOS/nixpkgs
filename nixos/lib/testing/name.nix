{ lib, ... }:
let
  inherit (lib) lib.mkOption types;
in
{
  options.name = lib.mkOption {
    description = ''
      The name of the test.

      This is used in the derivation names of the [{option}`driver`](#test-opt-driver) and [{option}`test`](#test-opt-test) runner.
    '';
    type = lib.types.str;
  };
}
