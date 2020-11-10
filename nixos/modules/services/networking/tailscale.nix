{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.tailscale;
in {
  meta.maintainers = with maintainers; [ danderson mbaillie ];

  options.services.tailscale = {
    enable = mkEnableOption "Tailscale client daemon";

    port = mkOption {
      type = types.port;
      default = 41641;
      description = "The port to listen on for tunnel traffic (0=autoselect).";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.tailscale ]; # for the CLI
    systemd.packages = [ pkgs.tailscale ];
    systemd.services.tailscaled = {
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Environment = "PORT=${toString cfg.port}";
    };
  };
}
