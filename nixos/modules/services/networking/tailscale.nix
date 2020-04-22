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
    systemd.services.tailscale = {
      description = "Tailscale client daemon";

      after = [ "network-pre.target" ];
      wants = [ "network-pre.target" ];
      wantedBy = [ "multi-user.target" ];

      unitConfig = {
        StartLimitIntervalSec = 0;
        StartLimitBurst = 0;
      };

      serviceConfig = {
        ExecStart =
          "${pkgs.tailscale}/bin/tailscaled --port ${toString cfg.port}";

        RuntimeDirectory = "tailscale";
        RuntimeDirectoryMode = 755;

        StateDirectory = "tailscale";
        StateDirectoryMode = 750;

        CacheDirectory = "tailscale";
        CacheDirectoryMode = 750;

        Restart = "on-failure";
      };
    };
  };
}
