{ config, pkgs, ... }:

with pkgs.lib;

let

  failed = map (x: x.message) (filter (x: !x.assertion) config.assertions);

in

{

  options = {

    assertions = mkOption {
      default = [];
      example = [ { assertion = false; message = "you can't enable this for that reason"; } ];
      merge = pkgs.lib.mergeListOption;
      description = ''
        This option allows modules to express conditions that must
        hold for the evaluation of the system configuration to
        succeed, along with associated error messages for the user.
      '';
    };

  };

  config = {

    # This option is evaluated always. Thus the assertions are checked as well. hacky!
    environment.systemPackages =
      if [] == failed then []
      else throw "\nFailed assertions:\n${concatStringsSep "\n" (map (x: "- ${x}") failed)}";

  };

}
