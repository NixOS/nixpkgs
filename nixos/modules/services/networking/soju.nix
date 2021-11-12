{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.soju;
  stateDir = "/var/lib/soju";
  listenCfg = concatMapStringsSep "\n" (l: "listen ${l}") cfg.listen;
  tlsCfg = optionalString (cfg.tlsCertificate != null)
    "tls ${cfg.tlsCertificate} ${cfg.tlsCertificateKey}";
  logCfg = optionalString cfg.enableMessageLogging
    "log fs ${stateDir}/logs";

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
in
{
  ###### interface

  options.services.soju = {
    enable = mkEnableOption "soju";

    listen = mkOption {
      type = types.listOf types.str;
      default = [ ":6697" ];
      description = ''
        Where soju should listen for incoming connections. See the
        <literal>listen</literal> directive in
        <citerefentry><refentrytitle>soju</refentrytitle>
        <manvolnum>1</manvolnum></citerefentry>.
      '';
    };

    hostName = mkOption {
      type = types.str;
      default = config.networking.hostName;
      description = "Server hostname.";
    };

    tlsCertificate = mkOption {
      type = types.nullOr types.path;
      example = "/var/host.cert";
      description = "Path to server TLS certificate.";
    };

    tlsCertificateKey = mkOption {
      type = types.nullOr types.path;
      example = "/var/host.key";
      description = "Path to server TLS certificate key.";
    };

    enableMessageLogging = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable message logging.";
    };

    httpOrigins = mkOption {
      type = types.listOf types.str;
      default = [];
      description = ''
        List of allowed HTTP origins for WebSocket listeners. The parameters are
        interpreted as shell patterns, see
        <citerefentry><refentrytitle>glob</refentrytitle>
        <manvolnum>7</manvolnum></citerefentry>.
      '';
    };

    acceptProxyIP = mkOption {
      type = types.listOf types.str;
      default = [];
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
      description = "Lines added verbatim to the configuration file.";
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    systemd.services.soju = {
      description = "soju IRC bouncer";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      serviceConfig = {
        DynamicUser = true;
        Restart = "always";
        ExecStart = "${pkgs.soju}/bin/soju -config ${configFile}";
        StateDirectory = "soju";
      };
    };
  };

  meta.maintainers = with maintainers; [ malvo ];
}
