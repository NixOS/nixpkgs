# Systemd services for anbox.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.anbox;

  kernelPackages = config.boot.kernelPackages;

in

{
  ###### interface

  options.virtualisation.anbox = {
    enable = mkEnableOption "Anbox Container Management Daemon";
  };

  ###### implementation

  config = mkIf cfg.enable {
    virtualisation.lxc.enable = true;

    environment.systemPackages = [ pkgs.anbox.exe ];

    boot.kernelModules = [ "ashmem" "binder" ];
    boot.extraModulePackages = with kernelPackages.anbox; [ ashmem binder ];

    services.udev.extraRules = ''
      KERNEL=="binder", MODE="0666"
      KERNEL=="ashmem", MODE="0666"
    '';

    systemd.services.anbox-container-manager = {
      description = "Anbox Container Management Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];

      serviceConfig.ExecStart = "${pkgs.anbox.exe}/bin/anbox container-manager --data-path=/var/lib/anbox --android-image=${pkgs.anbox.image} --privileged";
    };
  };

}
