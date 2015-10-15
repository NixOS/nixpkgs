{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.copy-com;

in

{
  options = {

    services.copy-com = {

	  enable = mkOption {
          default = false;
          description = "
            Enable the Copy.com client.
            NOTE: before enabling the client for the first time, it must be
            configured by first running CopyConsole (command line) or CopyAgent
            (graphical) as the appropriate user.
          ";
      };

      user = mkOption {
        description = "The user for which the Copy.com client should be run.";
      };

      debug = mkOption {
        default = false;
        description = "Output more (debugging) messages to the console.";
      };
	  };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.postfix ];

    systemd.services."copy-com-${cfg.user}" = {
      description = "Copy.com client";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.copy-com}/bin/CopyConsole ${if cfg.debug then "-consoleOutput -debugToConsole=dirwatch,path-watch,csm_path,csm -debug -console" else ""}";
        User = "${cfg.user}";
      };

    };
  };

}

