{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.services.shiori;
in {
  options = {
    services.shiori = {
      enable = mkEnableOption "Shiori simple bookmarks manager";

      package = mkOption {
        type = types.package;
        default = pkgs.shiori;
        defaultText = "pkgs.shiori";
        description = "The Shiori package to use.";
      };

      address = mkOption {
        type = types.str;
        default = "";
        description = ''
          The IP address on which Shiori will listen.
          If empty, listens on all interfaces.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 8080;
        description = "The port of the Shiori web application";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.shiori = with cfg; {
      description = "Shiori simple bookmarks manager";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${package}/bin/shiori serve --address '${address}' --port '${toString port}'";
        DynamicUser = true;
        Environment = "SHIORI_DIR=/var/lib/shiori";
        StateDirectory = "shiori";
      };
    };
  };

  meta.maintainers = with maintainers; [ minijackson ];
}
