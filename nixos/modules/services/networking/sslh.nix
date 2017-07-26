{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.sslh;
  configFile = pkgs.writeText "sslh.conf" ''
    verbose: ${boolToString cfg.verbose};
    foreground: true;
    inetd: false;
    numeric: false;
    transparent: false;
    timeout: "${toString cfg.timeout}";
    user: "nobody";
    pidfile: "${cfg.pidfile}";

    listen:
    (
      { host: "${cfg.listenAddress}"; port: "${toString cfg.port}"; }
    );

    ${cfg.appendConfig}
  '';
  defaultAppendConfig = ''
    protocols:
    (
      { name: "ssh"; service: "ssh"; host: "localhost"; port: "22"; probe: "builtin"; },
      { name: "openvpn"; host: "localhost"; port: "1194"; probe: "builtin"; },
      { name: "xmpp"; host: "localhost"; port: "5222"; probe: "builtin"; },
      { name: "http"; host: "localhost"; port: "80"; probe: "builtin"; },
      { name: "ssl"; host: "localhost"; port: "443"; probe: "builtin"; },
      { name: "anyprot"; host: "localhost"; port: "443"; probe: "builtin"; }
    );
  '';
in
{
  options = {
    services.sslh = {
      enable = mkEnableOption "sslh";

      verbose = mkOption {
        type = types.bool;
        default = false;
        description = "Verbose logs.";
      };

      timeout = mkOption {
        type = types.int;
        default = 2;
        description = "Timeout in seconds.";
      };

      pidfile = mkOption {
        type = types.path;
        default = "/run/sslh.pid";
        description = "PID file path for sslh daemon.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = config.networking.hostName;
        description = "Listening hostname.";
      };

      port = mkOption {
        type = types.int;
        default = 443;
        description = "Listening port.";
      };

      appendConfig = mkOption {
        type = types.str;
        default = defaultAppendConfig;
        description = "Verbatim configuration file.";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.sslh = {
      description = "Applicative Protocol Multiplexer (e.g. share SSH and HTTPS on the same port)";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.ExecStart = "${pkgs.sslh}/bin/sslh -F${configFile}";
      serviceConfig.KillMode = "process";
      serviceConfig.PIDFile = "${cfg.pidfile}";
    };
  };
}
