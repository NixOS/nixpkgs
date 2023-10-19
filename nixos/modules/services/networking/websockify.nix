{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.networking.websockify; in {
  options = {
    services.networking.websockify = {
      enable = mkOption {
        description = lib.mdDoc "Whether to enable websockify to forward websocket connections to TCP connections.";

        default = false;

        type = types.bool;
      };

      sslCert = mkOption {
        description = lib.mdDoc "Path to the SSL certificate.";
        type = types.path;
      };

      sslKey = mkOption {
        description = lib.mdDoc "Path to the SSL key.";
        default = cfg.sslCert;
        defaultText = literalExpression "config.services.networking.websockify.sslCert";
        type = types.path;
      };

      portMap = mkOption {
        description = lib.mdDoc "Ports to map by default.";
        default = {};
        type = types.attrsOf types.int;
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services."websockify@" = {
      description = "Service to forward websocket connections to TCP connections (from port:to port %I)";
      script = ''
        IFS=':' read -a array <<< "$1"
        ${pkgs.python3Packages.websockify}/bin/websockify --ssl-only \
          --cert=${cfg.sslCert} --key=${cfg.sslKey} 0.0.0.0:''${array[0]} 0.0.0.0:''${array[1]}
      '';
      scriptArgs = "%i";
    };

    systemd.targets.default-websockify = {
      description = "Target to start all default websockify@ services";
      unitConfig.X-StopOnReconfiguration = true;
      wants = mapAttrsToList (name: value: "websockify@${name}:${toString value}.service") cfg.portMap;
      wantedBy = [ "multi-user.target" ];
    };
  };
}
