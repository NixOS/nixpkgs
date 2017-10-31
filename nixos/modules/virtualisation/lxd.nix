# Systemd services for lxd.

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.lxd;

in

{
  ###### interface

  options = {

    virtualisation.lxd.enable =
      mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            This option enables lxd, a daemon that manages
            containers. Users in the "lxd" group can interact with
            the daemon (e.g. to start or stop containers) using the
            <command>lxc</command> command line tool, among others.
          '';
      };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages =
      [ pkgs.lxd ];

    systemd.services.lxd =
      { description = "LXD Container Management Daemon";

        wantedBy = [ "multi-user.target" ];
        after = [ "systemd-udev-settle.service" ];

        # TODO(wkennington): Add lvm2 and thin-provisioning-tools
        path = with pkgs; [ acl rsync gnutar xz btrfs-progs gzip dnsmasq squashfsTools iproute iptables ];

        serviceConfig.ExecStart = "@${pkgs.lxd.bin}/bin/lxd lxd --syslog --group lxd";
        serviceConfig.Type = "simple";
        serviceConfig.KillMode = "process"; # when stopping, leave the containers alone
      };

    users.extraGroups.lxd.gid = config.ids.gids.lxd;

    users.extraUsers.root = {
      subUidRanges = [ { startUid = 1000000; count = 65536; } ];
      subGidRanges = [ { startGid = 1000000; count = 65536; } ];
    };

  };

}
