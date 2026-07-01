{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.surfshark;
in
{
  options.services.surfshark = {
    enable = lib.mkEnableOption "Surfshark VPN client";
    package = lib.mkPackageOption pkgs "surfshark" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    systemd.services.surfsharkd2 = {
      serviceConfig.Description = "surfsharkd — per-user daemon (IPC bridge between GUI and system daemon)";
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [
        coreutils
        procps
        which
        iputils
      ];
    };

  };

  meta.maintainers = with lib.maintainers; [ FazalAAli ];
}
