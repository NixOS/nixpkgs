{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.syncthing.discovery;

  dataDirectory = "/var/lib/syncthing-discovery";

  discoveryOptions = [
    "--db-dir=${dataDirectory}"
    "--listen=${cfg.listenAddress}:${toString cfg.port}"
  ]
  ++ optional (cfg.http) "--http"
  ++ optional (cfg.cert != null) "--cert=${dataDirectory}/${cfg.cert}"
  ++ optional (cfg.key != null) "--key=${dataDirectory}/${cfg.key}"
  ++ cfg.extraOptions;
in
{
  options.services.syncthing.discovery = {
    enable = mkEnableOption "Syncthing discovery service";

    listenAddress = mkOption {
      type = types.str;
      default = "";
      example = "1.2.3.4";
      description = ''
        Address to listen on for discovery server.
      '';
    };

    port = mkOption {
      type = types.port;
      default = 8443;
      description = ''
        Port to listen on for discovery server.
      '';
    };

    http = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to listen on HTTP (behind an HTTPS proxy).
      '';
    };

    cert = mkOption {
      type = types.nullOr types.str;
      default = "cert.pem";
      description = ''
        Path to the `cert.pem` file.
      '';
    };

    key = mkOption {
      type = types.nullOr types.str;
      default = "key.pem";
      description = ''
        Path to the `key.pem` file.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra command line arguments to pass to stdiscosrv.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.syncthing-discovery = {
      description = "Syncthing discovery service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = baseNameOf dataDirectory;

        Restart = "on-failure";
        ExecStart = "${pkgs.syncthing-discovery}/bin/stdiscosrv ${concatStringsSep " " discoveryOptions}";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ jmsuen ];
}
