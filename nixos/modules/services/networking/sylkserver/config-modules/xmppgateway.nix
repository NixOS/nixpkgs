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
    general = {
      local_port = lib.mkOption {
        type = lib.types.port;
        default = 5269;
        description = "Port for XMPP.";
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
  };
}
