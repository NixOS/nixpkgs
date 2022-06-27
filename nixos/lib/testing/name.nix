{ lib, ... }:
let
  inherit (lib) mkOption types mdDoc;
in
{
  options.name = mkOption {
    description = mdDoc ''
      The name of the test.

      This is used in the derivation names of the [{option}`driver`](#opt-driver) and [{option}`test`](#opt-test) runner.
    '';
    type = types.str;
  };
}
