# LXC Configuration

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.virtualisation.lxc;

in

{
  ###### interface

  options.virtualisation.lxc = {
    enable =
      mkOption {
        type = types.bool;
        default = false;
        description =
          ''
            This enables Linux Containers (LXC), which provides tools
            for creating and managing system or application containers
            on Linux.
          '';
      };

    systemConfig =
      mkOption {
        type = types.lines;
        default = "";
        description =
          ''
            This is the system-wide LXC config. See
            <citerefentry><refentrytitle>lxc.system.conf</refentrytitle>
            <manvolnum>5</manvolnum></citerefentry>.
          '';
      };

    defaultConfig =
      mkOption {
        type = types.lines;
        default = "";
        description =
          ''
            Default config (default.conf) for new containers, i.e. for
            network config. See <citerefentry><refentrytitle>lxc.container.conf
            </refentrytitle><manvolnum>5</manvolnum></citerefentry>.
          '';
      };

    usernetConfig =
      mkOption {
        type = types.lines;
        default = "";
        description =
          ''
            This is the config file for managing unprivileged user network
            administration access in LXC. See <citerefentry>
            <refentrytitle>lxc-usernet</refentrytitle><manvolnum>5</manvolnum>
            </citerefentry>.
          '';
      };
  };

  ###### implementation

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.lxc ];
    environment.etc."lxc/lxc.conf".text = cfg.systemConfig;
    environment.etc."lxc/lxc-usernet".text = cfg.usernetConfig;
    environment.etc."lxc/default.conf".text = cfg.defaultConfig;
    systemd.tmpfiles.rules = [ "d /var/lib/lxc/rootfs 0755 root root -" ];

    security.apparmor.packages = [ pkgs.lxc ];
    security.apparmor.profiles = [
      "${pkgs.lxc}/etc/apparmor.d/lxc-containers"
      "${pkgs.lxc}/etc/apparmor.d/usr.bin.lxc-start"
    ];
  };
}
