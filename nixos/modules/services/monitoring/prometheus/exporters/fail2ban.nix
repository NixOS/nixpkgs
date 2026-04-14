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
    requires = mkIf config.services.fail2ban.enable [ "prometheus-fail2ban-exporter-setup.service" ];
    serviceConfig = {
      DynamicUser = false;
      ExecStart = ''
        ${getExe pkgs.prometheus-fail2ban-exporter} \
          ${optionalString cfg.exitOnError ''--collector.f2b.exit-on-socket-connection-error \''}
          ${optionalString (cfg.username != null) ''
            --web.basic-auth.username="${cfg.username}" \
            --web.basic-auth.password="$(cat ${cfg.passwordFile})" \
          ''}
          --web.listen-address="${cfg.host}:${toString cfg.port}" \
          --collector.f2b.socket=${cfg.fail2banSocket}
      '';
      RestrictAddressFamilies = [
        "AF_INET"
        "AF_INET6"
        "AF_UNIX"
      ];
    };
  };
}
