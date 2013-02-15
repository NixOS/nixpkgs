{ config, pkgs, ... }:

with pkgs.lib;

let cfg = config.services.networking.websockify; in {
  options = {
    services.networking.websockify = {
      enable = mkOption {  
        description = "Whether to enable websockify to forward websocket connections to TCP connections";

        default = false;   

        type = types.bool; 
      };

      sslCert = mkOption {
        description = "Path to the SSL certificate";
        type = types.path;
      };

      sslKey = mkOption {
        description = "Path to the SSL key";
        default = cfg.sslCert;
        type = types.path;
      };

      portMap = mkOption {
        description = "Ports to map by default";
        default = {};
        type = types.attrsOf types.int;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services."websockify@" = {
      script = ''
        IFS=':' read -a array <<< "$1"
        ${pkgs.pythonPackages.websockify}/bin/websockify --ssl-only \
          --cert=${cfg.sslCert} --key=${cfg.sslKey} 0.0.0.0:''${array[0]} 0.0.0.0:''${array[1]}
      '';
      scriptArgs = "%i";
    };

    systemd.targets."default-websockify" = {
      wants = mapAttrsToList (name: value: "websockify@${name}:${toString value}.service") cfg.portMap;
      wantedBy = [ "multi-user.target" ];
    };
  };
}
