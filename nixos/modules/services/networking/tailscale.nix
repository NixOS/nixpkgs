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

    package = mkOption {
      type = types.package;
      default = pkgs.tailscale;
      defaultText = "pkgs.tailscale";
      description = "The package to use for tailscale";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ]; # for the CLI
    systemd.packages = [ cfg.package ];
    systemd.services.tailscaled = {
      wantedBy = [ "multi-user.target" ];
      path = [ pkgs.openresolv ];
      serviceConfig.Environment = "PORT=${toString cfg.port}";
    };
  };
}
