{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    types
    ;
  cfg = config.services.openems.ui;
in
{
  options.services.openems.ui = {
    enable = mkEnableOption "OpenEMS UI";

    package = mkPackageOption pkgs "openems-ui" { };

    hostName = lib.mkOption {
      type = lib.types.str;
      description = "Hostname to use for the nginx vhost.";
      example = "openems.example.com";
    };

    websocket = {
      port = mkOption {
        type = types.port;
        default = 8082;
        description = "Websocket port to connect to";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      nginx = {
        enable = true;
        virtualHosts."${cfg.hostName}" =
          let
            ui-package = cfg.ui.package.override { websocket-port = cfg.websocket.port; };
          in
          {
            root = "${ui-package}/share/openems-ui/browser";
            serverAliases = [
              "localhost"
            ];
            locations = {
              "/" = {
                tryFiles = "$uri $uri/ /index.html";
                extraConfig = ''
                  error_page 404 300 /index.html;
                '';
              };
            };
          };
      };
    };
  };
}
