{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.zerotierone;
in
{
  options.services.zerotierone.enable = mkEnableOption "ZeroTierOne";
  
  config = mkIf cfg.enable {
    systemd.services.zerotierone = {
      description = "ZeroTierOne";
      path = [ pkgs.zerotierone ];
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart =
        ''
        mkdir -p /var/lib/zerotier-one
        chmod 700 /var/lib/zerotier-one
        chown -R root:root /var/lib/zerotier-one
        '';
      serviceConfig = {
        ExecStart = "${pkgs.zerotierone}/bin/zerotier-one";
        Restart = "always";
        KillMode = "process";
      };
    };
  environment.systemPackages = [ pkgs.zerotierone ];
  };
}
