{
  config,
  lib,
  options,
  ...
}:

let

  inherit (lib)
    concatStringsSep
    filter
    map
    showWarnings
    ;

in
{

  options = {

    assertions = lib.mkOption {
      type = lib.types.listOf lib.types.unspecified;
      internal = true;
      default = [ ];
      example = [
        {
          assertion = false;
          message = "you can't enable this for that reason";
        }
      ];
      description = ''
        This option allows modules to express conditions that must
        hold for the evaluation of the system configuration to
        succeed, along with associated error messages for the user.
      '';
    };

    warnings = lib.mkOption {
      internal = true;
      default = [ ];
      type = lib.types.listOf lib.types.str;
      example = [ "The `foo' service is deprecated and will go away soon!" ];
      description = ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };

    assertAndWarn = lib.mkOption {
      description = ''
        A function that prints the ${options.warnings} and returns its argument if the ${options.assertions} all pass.
        Otherwise, it throws an error with the assertion messages.
      '';
    };

  };

  config = {

    assertAndWarn =
      val:
      let
        failedAssertions = map (x: x.message) (filter (x: !x.assertion) config.assertions);
      in
      if failedAssertions != [ ] then
        throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failedAssertions)}"
      else
        showWarnings config.warnings val;

  };

}
