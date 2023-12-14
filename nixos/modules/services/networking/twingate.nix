{ config, lib, pkgs, ... }:

let
  cfg = config.services.twingate;
in
{
  options.services.twingate = {
    enable = lib.mkEnableOption (lib.mdDoc "Twingate Client daemon");
    package = lib.mkPackageOption pkgs "twingate" { };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [ cfg.package ];
    systemd.services.twingate = {
      preStart = "cp -r --update=none ${cfg.package}/etc/twingate/. /etc/twingate/";
      wantedBy = [ "multi-user.target" ];
    };

    networking.firewall.checkReversePath = lib.mkDefault "loose";
    services.resolved.enable = lib.mkIf (!config.networking.networkmanager.enable) true;

    environment.systemPackages = [ cfg.package ]; # For the CLI.
  };
}
