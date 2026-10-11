{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.mindustry-server;
in {
  options = {
    services.mindustry-server = {
      enable = mkEnableOption "Mindustry server";

      package = mkPackageOption pkgs "mindustry-server" {};

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = "Open ports in the firewall for the mindustry server";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.mindustry = {
      enable = true;
      description = "Mindustry server";
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.mindustry-server}/bin/mindustry-server host";
        ExecStop = "pkill server-release.jar";
      };
      wantedBy = ["network.target"];
    };

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [6567];
      allowedUDPPorts = [6567];
    };
  };
}
