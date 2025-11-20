{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.sylkserver;
  settingsFormat = pkgs.formats.ini { };
in

{
  freeformType = settingsFormat.type;
  options = {
    Server = {
      spool_dir = lib.mkOption {
        type = lib.types.path;
        default = cfg.stateDir;
        defaultText = lib.literalExpression "config.services.sylkserver.stateDir";
        description = "Directory for files created by the server, excluding logs.";
      };
      trace_dir = lib.mkOption {
        type = lib.types.path;
        default = "/var/log/sylkserver";
        description = "Directory for trace logs.";
      };
      log_level = lib.mkOption {
        type = lib.types.enum [
          "debug"
          "info"
          "warning"
          "error"
          "critical"
        ];
        default = "info";
        description = "Log level.";
      };
      ca_file = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.package}/share/sylkserver/tls/ca.crt";
        defaultText = lib.literalExpression "\"\${config.services.sylkserver.package}/share/sylkserver/tls/ca.crt\"";
        description = "Path to the Certificate Authority file for TLS.";
      };
      certificate = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.package}/share/sylkserver/tls/default.crt";
        defaultText = lib.literalExpression "\"\${config.services.sylkserver.package}/share/sylkserver/tls/default.crt\"";
        description = "Path to the server certificate file for TLS.";
      };
    };
    SIP = {
      local_ip = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Local IP address for SIP.";
      };
      local_udp_port = lib.mkOption {
        type = lib.types.port;
        default = 5060;
        description = "UDP port for SIP.";
      };
      local_tcp_port = lib.mkOption {
        type = lib.types.port;
        default = 5060;
        description = "TCP port for SIP.";
      };
      local_tls_port = lib.mkOption {
        type = lib.types.port;
        default = 5061;
        description = "TLS port for SIP.";
      };
    };
    RTP = {
      port_range = lib.mkOption {
        type = lib.types.str;
        default = "50000:50500";
        description = "Port range for RTP.";
      };
    };
    WebServer = {
      local_port = lib.mkOption {
        type = lib.types.port;
        default = 10888;
        description = "Port for the web server.";
      };
    };
  };
}
