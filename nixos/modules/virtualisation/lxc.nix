# LXC Configuration

{ config, lib, pkgs, ... }:

let
  cfg = config.virtualisation.lxc;
in

{
  meta = {
    maintainers = lib.teams.lxc.members;
  };

  options.virtualisation.lxc = {
    enable =
      lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
            This enables Linux Containers (LXC), which provides tools
            for creating and managing system or application containers
            on Linux.
          '';
      };

    systemConfig =
      lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
            This is the system-wide LXC config. See
            {manpage}`lxc.system.conf(5)`.
          '';
      };
    package = lib.mkPackageOption pkgs "lxc" { };

    defaultConfig =
      lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
            Default config (default.conf) for new containers, i.e. for
            network config. See {manpage}`lxc.container.conf(5)`.
          '';
      };

    usernetConfig =
      lib.mkOption {
        type = lib.types.lines;
        default = "";
        description = ''
            This is the config file for managing unprivileged user network
            administration access in LXC. See {manpage}`lxc-usernet(5)`.
          '';
      };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc."lxc/lxc.conf".text = cfg.systemConfig;
    environment.etc."lxc/lxc-usernet".text = cfg.usernetConfig;
    environment.etc."lxc/default.conf".text = cfg.defaultConfig;
    systemd.tmpfiles.rules = [ "d /var/lib/lxc/rootfs 0755 root root -" ];

    security.apparmor.packages = [ cfg.package ];
    security.apparmor.policies = {
      "bin.lxc-start".profile = ''
        include ${cfg.package}/etc/apparmor.d/usr.bin.lxc-start
      '';
      "lxc-containers".profile = ''
        include ${cfg.package}/etc/apparmor.d/lxc-containers
      '';
    };
  };
}
