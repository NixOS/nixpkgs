# Systemd services for lxd.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.lxd;

in

{
  ###### interface

  options = {

    virtualisation.lxd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          This option enables lxd, a daemon that manages
          containers. Users in the "lxd" group can interact with
          the daemon (e.g. to start or stop containers) using the
          <command>lxc</command> command line tool, among others.
        '';
      };
      zfsSupport = mkOption {
        type = types.bool;
        default = false;
        description = ''
          enables lxd to use zfs as a storage for containers.
          This option is enabled by default if a zfs pool is configured
          with nixos.
        '';
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.lxd ];

    security.apparmor = {
      enable = true;
      profiles = [
        "${pkgs.lxc}/etc/apparmor.d/usr.bin.lxc-start"
        "${pkgs.lxc}/etc/apparmor.d/lxc-containers"
      ];
      packages = [ pkgs.lxc ];
    };

    systemd.services.lxd = {
      description = "LXD Container Management Daemon";

      wantedBy = [ "multi-user.target" ];
      after = [ "systemd-udev-settle.service" ];

      path = lib.optional cfg.zfsSupport pkgs.zfs;

      preStart = ''
        mkdir -m 0755 -p /var/lib/lxc/rootfs
      '';

      serviceConfig = {
        ExecStart = "@${pkgs.lxd.bin}/bin/lxd lxd --group lxd";
        Type = "simple";
        KillMode = "process"; # when stopping, leave the containers alone
      };

    };

    users.groups.lxd.gid = config.ids.gids.lxd;

    users.users.root = {
      subUidRanges = [ { startUid = 1000000; count = 65536; } ];
      subGidRanges = [ { startGid = 1000000; count = 65536; } ];
    };
  };
}
