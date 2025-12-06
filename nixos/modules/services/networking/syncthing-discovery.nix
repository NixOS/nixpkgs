{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkOption optional types;

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
    enable = lib.mkEnableOption "Syncthing discovery service";

    listenAddress = mkOption {
      type = types.str;
      default = if cfg.http then "127.0.0.1" else "0.0.0.0";
      defaultText = lib.literalExpression ''
        if config.services.syncthing.discovery.http
        then "127.0.0.1"
        else "0.0.0.0"
      '';
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
      default = if cfg.http then null else "cert.pem";
      defaultText = lib.literalExpression ''
        if config.services.syncthing.discovery.http
        then null
        else "/var/lib/syncthing-discovery/cert.pem"
      '';
      example = "/path/to/your/cert.pem";
      description = ''
        Path to the `cert.pem` file.
      '';
    };

    key = mkOption {
      type = types.nullOr types.str;
      default = if cfg.http then null else "key.pem";
      defaultText = lib.literalExpression ''
        if config.services.syncthing.discovery.http
        then null
        else "/var/lib/syncthing-discovery/key.pem"
      '';
      example = "/path/to/your/key.pem";
      description = ''
        Path to the `key.pem` file.
      '';
    };

    extraOptions = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Extra command line arguments to pass to stdiscosrv.
        See <https://docs.syncthing.net/users/stdiscosrv.html>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.syncthing-discovery = {
      description = "Syncthing discovery service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      serviceConfig = {
        DynamicUser = true;
        StateDirectory = baseNameOf dataDirectory;

        Restart = "on-failure";
        ExecStart = "${pkgs.syncthing-discovery}/bin/stdiscosrv ${lib.concatStringsSep " " discoveryOptions}";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ jmsuen ];
}
