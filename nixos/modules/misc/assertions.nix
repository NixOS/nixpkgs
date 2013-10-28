{ config, pkgs, ... }:

with pkgs.lib;

let

  failed = map (x: x.message) (filter (x: !x.assertion) config.assertions);

  showWarnings = res: fold (w: x: builtins.trace "[1;31mwarning: ${w}[0m" x) res config.warnings;

in

{

  options = {

    assertions = mkOption {
      type = types.listOf types.unspecified;
      internal = true;
      default = [];
      example = [ { assertion = false; message = "you can't enable this for that reason"; } ];
      description = ''
        This option allows modules to express conditions that must
        hold for the evaluation of the system configuration to
        succeed, along with associated error messages for the user.
      '';
    };

    warnings = mkOption {
      internal = true;
      default = [];
      type = types.listOf types.string;
      example = [ "The `foo' service is deprecated and will go away soon!" ];
      description = ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };

  };

  config = {

    # This option is evaluated always. Thus the assertions are checked
    # as well. Hacky!
    environment.systemPackages = showWarnings (
      if [] == failed then []
      else throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failed)}");

  };

}
