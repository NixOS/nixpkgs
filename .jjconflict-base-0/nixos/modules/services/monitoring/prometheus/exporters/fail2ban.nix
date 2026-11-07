{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.fail2ban;

  inherit (lib)
    mkOption
    types
    getExe
    optionalString
    mkIf
    boolToString
    ;
in
{
  port = 9191;
  extraOpts = {
    host = mkOption {
      description = "The host that the fail2ban exporter should listen on";
      type = types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
    };
    fail2banSocket = mkOption {
      description = "Path to the fail2ban server socket. Permissions will be set automatically if fail2ban runs on this system.";
      type = types.str;
      default = config.services.fail2ban.daemonSettings.Definition.socket;
      defaultText = "config.services.fail2ban.daemonSettings.Definition.socket";
    };
    exitOnError = mkOption {
      description = "When set to true the exporter will immediately exit on a fail2ban socket connection error";
      type = types.bool;
      default = true;
      example = false;
    };
    username = mkOption {
      description = "Username to protect endpoints with HTTP basic authentication";
      type = types.nullOr types.str;
      default = null;
      example = "admin";
    };
    passwordFile = mkOption {
      description = "File that contains the password to protect endpoints with HTTP basic authentication";
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/prometheus-fail2ban-exporter-password.txt";
    };
  };

  assertions = [
    {
      assertion = (cfg.username != null) -> (cfg.passwordFile != null);
      message = "Setting an http basic auth username requires the password to be non-null";
    }
  ];

  serviceOpts = {
    serviceConfig = {
      SupplementaryGroups = [
        config.systemd.sockets.fail2ban.socketConfig.SocketGroup
      ];
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
      LoadCredential = mkIf (cfg.passwordFile != null) [
        "web-basic-auth-password:${cfg.passwordFile}"
      ];
    };

    environment = {
      F2B_COLLECTOR_SOCKET = cfg.fail2banSocket;
      F2B_EXIT_ON_SOCKET_CONN_ERROR = boolToString cfg.exitOnError;
      F2B_WEB_LISTEN_ADDRESS = "${cfg.host}:${toString cfg.port}";
      F2B_WEB_BASICAUTH_USER = mkIf (cfg.username != null) cfg.username;
    };

    script = ''
      ${optionalString (cfg.passwordFile != null) ''
        export F2B_WEB_BASICAUTH_PASS="$(<"$CREDENTIALS_DIRECTORY/web-basic-auth-password")"
      ''}

      exec ${getExe pkgs.prometheus-fail2ban-exporter}
    '';
  };
}
