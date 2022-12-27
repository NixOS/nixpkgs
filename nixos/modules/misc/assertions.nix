{ config, lib, ... }:

let
  inherit (lib)
    filter
    concatStringsSep
    mkOption
    showWarnings
    types
    ;

  failedAssertions = map (x: x.message) (filter (x: !x.assertion) config.assertions);

  assertAndWarn = x: if failedAssertions != []
    then throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
    else showWarnings config.warnings x;

in
{

  options = {

    assertions = mkOption {
      type = types.listOf types.unspecified;
      internal = true;
      default = [];
      example = [ { assertion = false; message = "you can't enable this for that reason"; } ];
      description = lib.mdDoc ''
        This option allows modules to express conditions that must
        hold for the evaluation of the system configuration to
        succeed, along with associated error messages for the user.
      '';
    };

    warnings = mkOption {
      internal = true;
      default = [];
      type = types.listOf types.str;
      example = [ "The `foo' service is deprecated and will go away soon!" ];
      description = lib.mdDoc ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };

    _module.assertAndWarn = mkOption {
      internal = true;
      type = types.functionTo types.raw;
      description = ''
        A function that applies the assertions and warnings.
        If there are none, it behaves like the identity function, `x: x`.
      '';
    };
  };

  config = {
    _module.assertAndWarn = assertAndWarn;
  };
}
