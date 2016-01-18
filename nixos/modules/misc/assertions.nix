{ config, lib, pkgs, ... }:

with lib;

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
      type = types.listOf types.str;
      example = [ "The `foo' service is deprecated and will go away soon!" ];
      description = ''
        This option allows modules to show warnings to users during
        the evaluation of the system configuration.
      '';
    };

    handle-assertions = mkOption {
      internal = true;
      type = types.unspecified;
      description = ''
        This is a function you can call to display all warnings to the user and
        fail if any assertions fail.
      '';
    };
  };
  # impl of assertions is in <nixpkgs/nixos/modules/system/activation/top-level.nix>
  config = {
    handle-assertions =
      let failed = map (x: x.message) (filter (x: !x.assertion) config.assertions);
          showWarnings = inCategory: res: fold (w: x: builtins.trace "[1;31mwarning${inCategory}: ${w}[0m" x) res config.warnings;
      in category: res: let inCategory = if category != "" then " in ${category}" else ""; in showWarnings inCategory (
              if failed == [] then
                res
              else
                throw "\nFailed assertions${inCategory}:\n${concatStringsSep "\n" (map (x: "- ${x}") failed)}");
  };
}
