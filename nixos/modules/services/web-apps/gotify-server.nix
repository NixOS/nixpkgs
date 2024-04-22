{ pkgs, lib, config, ... }:

with lib;

let
  cfg = config.services.gotify;
in {
  options = {
    services.gotify = {
      enable = mkEnableOption "Gotify webserver";

      port = mkOption {
        type = types.port;
        description = ''
          Port the server listens to.
        '';
      };

      stateDirectoryName = mkOption {
        type = types.str;
        default = "gotify-server";
        description = ''
          The name of the directory below {file}`/var/lib` where
          gotify stores its runtime data.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.gotify-server = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      description = "Simple server for sending and receiving messages";

      environment = {
        GOTIFY_SERVER_PORT = toString cfg.port;
      };

      serviceConfig = {
        WorkingDirectory = "/var/lib/${cfg.stateDirectoryName}";
        StateDirectory = cfg.stateDirectoryName;
        Restart = "always";
        DynamicUser = "yes";
        ExecStart = "${pkgs.gotify-server}/bin/server";
      };
    };
  };
}
