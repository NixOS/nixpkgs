{ pkgs, config, ... }:

let
  script = pkgs.writeScriptBin "usernixos" (''
    #!${pkgs.bash}/bin/bash
  '' + config.activationContents);
in
with pkgs.lib;
{
  options = {
    activation = mkOption {
      default = {};
    };

    activationContents = mkOption {
      default = "";
      internal = true;
      merge = concatStringsSep "\n";
      description = ''
        Commands to run at activation
      '';
    };
  };

  config.activation.toplevel = script;
}
