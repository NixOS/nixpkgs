{ pkgs, config, lib, ... }:
let
  inherit (lib) mkEnableOption mkPackageOption mkIf types mkOption;
  cfg = config.services.vpp;
in
{
  options.services.vpp = {
    enable = mkEnableOption ''
      vector packet processing framework.

      VPP replaces the Linux network stack by a userspace-based network stack,
      driven by `vppctl`. You can enable the Linux Control Plane to continue
      to interop with Linux APIs.
    '';

    package = mkPackageOption pkgs "vpp" { };

    configFile = mkOption {
      type = types.path;
      description = "VPP configuration file for startup";
    };
  };

  config = mkIf cfg.enable {
    users.groups.vpp = {};
    environment.systemPackages = [ cfg.package ];
    boot.kernel.sysctl = {
     "vm.nr_hugepages" = lib.mkDefault 1024;
     "max_map_count" = lib.mkDefault 3096;
     "hugetlb_shm_group" = lib.mkDefault 0;
      # Assert that shm max ≥ total size of hugepages.
      "shmmax" = lib.mkDefault 2147483648;
    };
    systemd.services.vpp = {
      description = "Vector Packet Processing process";
      after = [ "syslog.target" "network.target" "auditd.service" ];
      serviceConfig = {
        ExecStartPre = [
          "-${pkgs.coreutils}/bin/rm -f /dev/shm/db /dev/shm/global_vm /dev/shm/vpe-api"
          "-/run/current-system/sw/bin/modprobe uio_pci_generic"
        ];

        ExecStart = "${cfg.package}/bin/vpp -c ${cfg.configFile}";
        Type = "simple";
        Restart = "on-failure";
        RestartSec = "5s";
        RuntimeDirectory = "vpp";
      };
      wantedBy = [ "multi-user.target" ];
    };
  };
}
