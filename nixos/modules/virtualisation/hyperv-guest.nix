{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.hypervGuest;

in {
  options = {
    virtualisation.hypervGuest = {
      enable = mkEnableOption "Hyper-V Guest Support";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ config.boot.kernelPackages.hyperv-daemons.bin ];

    security.rngd.enable = false;

    # enable hotadding memory
    services.udev.packages = lib.singleton (pkgs.writeTextFile {
      name = "hyperv-memory-hotadd-udev-rules";
      destination = "/etc/udev/rules.d/99-hyperv-memory-hotadd.rules";
      text = ''
        ACTION="add", SUBSYSTEM=="memory", ATTR{state}="online"
      '';
    });

    systemd = {
      packages = [ config.boot.kernelPackages.hyperv-daemons.lib ];

      targets.hyperv-daemons = {
        wantedBy = [ "multi-user.target" ];
      };
    };
  };
}
