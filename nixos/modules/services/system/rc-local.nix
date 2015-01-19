{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.rc-local;

in

{

  ###### interface

  options = {
    services.rc-local = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Execute a user defined commands at <literal>Multi-user Mode with Networking mode</literal>.
        '';
      };

      runCommands = mkOption {
        type = types.lines;
        # Note: if syntax errors are detected in this file, the NixOS
        # configuration will fail to build.
        default = "";
        description = ''
          You can write here shell commands you want to be executed at <literal>Multi-user Mode with Networking mode</literal>.
          Please specify full path to the executables.
        '';
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    systemd.services.rc-local = {
      description   = "Execute a user defined commands";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      serviceConfig.ExecStart = pkgs.writeScript "rc.local"
      ''
      #! ${pkgs.stdenv.shell} -e
      # Don't edit this file. Set the NixOS option ‘services.rc-local.runCommands’

      ${cfg.runCommands}

      exit 0
      '';

      serviceConfig.Type = "forking";
    };

  };

}
