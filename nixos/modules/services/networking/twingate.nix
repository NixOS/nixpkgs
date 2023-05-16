{ config, lib, pkgs, ... }:

<<<<<<< HEAD
let
  cfg = config.services.twingate;
in
{
  options.services.twingate = {
    enable = lib.mkEnableOption (lib.mdDoc "Twingate Client daemon");
    package = lib.mkPackageOptionMD pkgs "twingate" { };
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
=======
with lib;

let
  cfg = config.services.twingate;

in {

  options.services.twingate = {
    enable = mkEnableOption (lib.mdDoc "Twingate Client daemon");
  };

  config = mkIf cfg.enable {

    networking.firewall.checkReversePath = lib.mkDefault false;
    networking.networkmanager.enable = true;

    environment.systemPackages = [ pkgs.twingate ]; # for the CLI
    systemd.packages = [ pkgs.twingate ];

    systemd.services.twingate.preStart = ''
      cp -r -n ${pkgs.twingate}/etc/twingate/. /etc/twingate/
    '';

    systemd.services.twingate.wantedBy = [ "multi-user.target" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
