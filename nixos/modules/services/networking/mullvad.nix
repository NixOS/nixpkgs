{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.mullvad;
in
{
  options.services.mullvad = {
    enable = mkEnableOption "the Mullvad VPN daemon";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.mullvad-vpn ];
    
    systemd.services."mullvad-vpn" = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
      path = with pkgs; [ iproute ];
      environment = 
        {
          MULLVAD_SETTINGS_DIR = "/var/lib/mullvad-vpn";
        };
      serviceConfig = {
        StateDirectory = "mullvad-vpn";
        CacheDirectory = "mullvad-vpn";
        ExecStart = ''
          ${pkgs.mullvad-vpn}/bin/mullvad-daemon --disable-log-to-file
        '';
      };
    };
  };
}
 
