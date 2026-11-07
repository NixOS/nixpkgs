{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.dcpomatic-server;
in
{
  meta.maintainers = with lib.maintainers; [ logn ];

  options.services.dcpomatic-server = {
    enable = lib.mkEnableOption "DCP-o-matic encoding server";

    package = lib.mkPackageOption pkgs "dcpomatic" { };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to open the firewall for ports 6192/tcp and 6193/udp, which are required for
        DCP-o-matic encoding servers to work.
      '';
    };

    threads = lib.mkOption {
      type = lib.types.nullOr lib.types.ints.positive;
      default = null;
      example = 6;
      description = ''
        Number of threads to use for encoding. If null, use DCP-o-matic's default, which is
        typically the number of CPU cores.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ 6192 ];
      allowedUDPPorts = [ 6193 ];
    };

    systemd.services.dcpomatic-server = {
      description = "DCP-o-matic encoding server";
      wantedBy = [ "multi-user.target" ];

      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = lib.escapeShellArgs (
          [
            "${cfg.package}/bin/dcpomatic2_server_cli"
            "--verbose"
          ]
          ++ lib.optionals (cfg.threads != null) [
            "--threads"
            (toString cfg.threads)
          ]
        );

        Restart = "on-failure";
        RestartSec = 5;
        StateDirectory = "dcpomatic-server";
        Environment = "HOME=/var/lib/dcpomatic-server";
        PrivateTmp = true;
      };
    };
  };
}
