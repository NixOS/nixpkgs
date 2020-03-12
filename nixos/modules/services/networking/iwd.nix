{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.wireless.iwd;
in {
  options.networking.wireless.iwd.enable = mkEnableOption "iwd";

  config = mkIf cfg.enable {
    assertions = [{
      assertion = !config.networking.wireless.enable;
      message = ''
        Only one wireless daemon is allowed at the time: networking.wireless.enable and networking.wireless.iwd.enable are mutually exclusive.
      '';
    }];

    # for iwctl
    environment.systemPackages =  [ pkgs.iwd ];

    services.dbus.packages = [ pkgs.iwd ];

    systemd.packages = [ pkgs.iwd ];

    systemd.services.iwd.wantedBy = [ "multi-user.target" ];
  };

  meta.maintainers = with lib.maintainers; [ mic92 dtzWill ];
}
