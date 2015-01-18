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
          Enable /etc/rc.local compatibility via systemd
        '';
      };

      localCommands = mkOption {
        type = types.lines;
        # Note: if syntax errors are detected in this file, the NixOS
        # configuration will fail to build.
        default = "";
        description = ''
          This string contains the contents of the
          <filename>/etc/rc.local</filename> file.

          You can write here shell commands you want to be executed at the start of the NixOS.
          Please use full path to the executables.
        '';
      };

    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.etc = [
    { source = pkgs.writeScript "rc.local"
      ''
      #! ${pkgs.stdenv.shell} -e
      # Don't edit this file. Set the NixOS option ‘services.rc-local.localCommands’
      ${cfg.localCommands}

      exit 0
      '';
      target = "rc.local";
    } ];

    systemd.services.rc-local = {
      description   = "Execute /etc/rc.local";
      wantedBy      = [ "multi-user.target" ];
      after         = [ "network.target" ];

      serviceConfig.ExecStart = "/etc/rc.local";
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
    };

  };

}
