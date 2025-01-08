{ config, lib, pkgs, ... }:

let
  cfg = config.services.soju;
  stateDir = "/var/lib/soju";
  runtimeDir = "/run/soju";
  listen = cfg.listen
    ++ lib.optional cfg.adminSocket.enable "unix+admin://${runtimeDir}/admin";
  listenCfg = lib.concatMapStringsSep "\n" (l: "listen ${l}") listen;
  tlsCfg = lib.optionalString (cfg.tlsCertificate != null)
    "tls ${cfg.tlsCertificate} ${cfg.tlsCertificateKey}";
  logCfg = lib.optionalString cfg.enableMessageLogging
    "message-store fs ${stateDir}/logs";

  configFile = pkgs.writeText "soju.conf" ''
    ${listenCfg}
    hostname ${cfg.hostName}
    ${tlsCfg}
    db sqlite3 ${stateDir}/soju.db
    ${logCfg}
    http-origin ${lib.concatStringsSep " " cfg.httpOrigins}
    accept-proxy-ip ${lib.concatStringsSep " " cfg.acceptProxyIP}

    ${cfg.extraConfig}
  '';

  sojuctl = pkgs.writeShellScriptBin "sojuctl" ''
    exec ${cfg.package}/bin/sojuctl --config ${configFile} "$@"
  '';
in
{
  ###### interface

  options.services.soju = {
    enable = lib.mkEnableOption "soju";

    package = lib.mkPackageOption pkgs "soju" { };

    listen = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ":6697" ];
      description = ''
        Where soju should listen for incoming connections. See the
        `listen` directive in
        {manpage}`soju(1)`.
      '';
    };

    hostName = lib.mkOption {
      type = lib.types.str;
      default = config.networking.hostName;
      defaultText = lib.literalExpression "config.networking.hostName";
      description = "Server hostname.";
    };

    tlsCertificate = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/host.cert";
      description = "Path to server TLS certificate.";
    };

    tlsCertificateKey = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = "/var/host.key";
      description = "Path to server TLS certificate key.";
    };

    enableMessageLogging = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable message logging.";
    };

    adminSocket.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Listen for admin connections from sojuctl at /run/soju/admin.
      '';
    };

    httpOrigins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        List of allowed HTTP origins for WebSocket listeners. The parameters are
        interpreted as shell patterns, see
        {manpage}`glob(7)`.
      '';
    };

    acceptProxyIP = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = ''
        Allow the specified IPs to act as a proxy. Proxys have the ability to
        overwrite the remote and local connection addresses (via the X-Forwarded-\*
        HTTP header fields). The special name "localhost" accepts the loopback
        addresses 127.0.0.0/8 and ::1/128. By default, all IPs are rejected.
      '';
    };

    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Lines added verbatim to the configuration file.";
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = (cfg.tlsCertificate != null) == (cfg.tlsCertificateKey != null);
        message = ''
          services.soju.tlsCertificate and services.soju.tlsCertificateKey
          must both be specified to enable TLS.
        '';
      }
    ];

    environment.systemPackages = [ sojuctl ];

    systemd.services.soju = {
      description = "soju IRC bouncer";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        ExecStart = "${cfg.package}/bin/soju -config ${configFile}";
        StateDirectory = "soju";
        RuntimeDirectory = "soju";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ malte-v ];
}
