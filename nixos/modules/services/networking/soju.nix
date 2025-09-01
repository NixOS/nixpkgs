{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.soju;
  stateDir = "/var/lib/soju";
  runtimeDir = "/run/soju";
  listen = cfg.listen ++ optional cfg.adminSocket.enable "unix+admin://${runtimeDir}/admin";
  listenCfg = concatMapStringsSep "\n" (l: "listen ${l}") listen;
  tlsCfg = optionalString (
    cfg.tlsCertificate != null
  ) "tls ${cfg.tlsCertificate} ${cfg.tlsCertificateKey}";
  logCfg = optionalString cfg.enableMessageLogging "message-store fs ${stateDir}/logs";

  configFile = pkgs.writeText "soju.conf" ''
    ${listenCfg}
    hostname ${cfg.hostName}
    ${tlsCfg}
    db sqlite3 ${stateDir}/soju.db
    ${logCfg}
    http-origin ${concatStringsSep " " cfg.httpOrigins}
    accept-proxy-ip ${concatStringsSep " " cfg.acceptProxyIP}

    ${cfg.extraConfig}
  '';

  sojuctl = pkgs.writeShellScriptBin "sojuctl" ''
    exec ${lib.getExe' cfg.package "sojuctl"} --config ${cfg.configFile} "$@"
  '';
in
{
  ###### interface

  options.services.soju = {
    enable = mkEnableOption "soju";

    package = mkPackageOption pkgs "soju" { };

    listen = mkOption {
      type = types.listOf types.str;
      default = [ ":6697" ];
      description = ''
        Where soju should listen for incoming connections. See the
        `listen` directive in
        {manpage}`soju(1)`.
      '';
    };

    hostName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      defaultText = literalExpression "config.networking.hostName";
      description = "Server hostname.";
    };

    tlsCertificate = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/var/host.cert";
      description = "Path to server TLS certificate.";
    };

    tlsCertificateKey = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/var/host.key";
      description = "Path to server TLS certificate key.";
    };

    enableMessageLogging = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable message logging.";
    };

    adminSocket.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Listen for admin connections from sojuctl at /run/soju/admin.
      '';
    };

    httpOrigins = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        List of allowed HTTP origins for WebSocket listeners. The parameters are
        interpreted as shell patterns, see
        {manpage}`glob(7)`.
      '';
    };

    acceptProxyIP = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Allow the specified IPs to act as a proxy. Proxys have the ability to
        overwrite the remote and local connection addresses (via the X-Forwarded-\*
        HTTP header fields). The special name "localhost" accepts the loopback
        addresses 127.0.0.0/8 and ::1/128. By default, all IPs are rejected.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = "Lines added verbatim to the generated configuration file.";
    };

    configFile = mkOption {
      type = types.path;
      default = configFile;
      defaultText = "Config file generated from other options.";
      description = ''
        Path to config file. If this option is set, it will override any
        configuration done using other options, including {option}`extraConfig`.
      '';
      example = literalExpression "./soju.conf";
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
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
      documentation = [ "man:soju(1)" ];
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        ExecStart = "${lib.getExe' cfg.package "soju"} -config ${cfg.configFile}";
        StateDirectory = "soju";
        RuntimeDirectory = "soju";
      };
    };
  };

  meta.maintainers = with maintainers; [ malte-v ];
}
