{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.hitide;
in
{
  options.services.hitide = {
    enable = mkEnableOption "the hitide service";

    backendHost = mkOption {
      default = "localhost";
      type = types.str;
      description = "URL path to lotide.";
      example = "http://localhost:3333/";
    };

    port = mkOption {
      default = 4333;
      type = types.port;
      description = "Port number to bind to.";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.hitide = {
      description = "hitide Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "networking.target" ] ++ lib.optional (cfg.backendHost == "localhost") "lotide.service";
      environment = {
        BACKEND_HOST = cfg.backendHost;
        PORT         = builtins.toString cfg.port;
      };
      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.hitide}/bin/hitide";
        PrivateTmp = true;
        Restart = "always";
        StateDirectory = "hitide";
        WorkingDirectory = "%S/hitide";
      };
    };
  };
}
