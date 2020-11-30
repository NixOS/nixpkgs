{ lib, config, ... }:

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

  };

  config._module.checks = lib.listToAttrs (lib.imap1 (n: value:
    let
      name = "_${toString n}";
      isWarning = lib.isString value;
      result = {
        enable = if isWarning then true else ! value.assertion;
        type = if isWarning then "warning" else "error";
        message = if isWarning then value else value.message;
      };
    in nameValuePair name result
  ) (config.assertions ++ config.warnings));

  # impl of assertions is in <nixpkgs/nixos/modules/system/activation/top-level.nix>
}
