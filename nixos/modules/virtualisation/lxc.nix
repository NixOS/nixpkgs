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

    unprivilegedContainers = lib.mkEnableOption "support for unprivileged users to launch containers";

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

      bridgeConfig =
        lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = ''
              This is the config file for override lxc-net bridge default settings.
            '';
        };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    environment.etc."lxc/lxc.conf".text = cfg.systemConfig;
    environment.etc."lxc/lxc-usernet".text = cfg.usernetConfig;
    environment.etc."lxc/default.conf".text = cfg.defaultConfig;
    environment.etc."lxc/lxc-net".text = cfg.bridgeConfig;
    environment.pathsToLink = [ "/share/lxc" ];
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

    # We don't need the `lxc-user` group, unless the unprivileged containers are enabled.
    users.groups = lib.mkIf cfg.unprivilegedContainers { lxc-user = {}; };

    # `lxc-user-nic` needs suid to attach to bridge for unpriv containers.
    security.wrappers = lib.mkIf cfg.unprivilegedContainers {
      lxcUserNet = {
        source = "${pkgs.lxc}/libexec/lxc/lxc-user-nic";
        setuid = true;
        owner = "root";
        group = "lxc-user";
        program = "lxc-user-nic";
        permissions = "u+rx,g+x,o-rx";
      };
    };

    # Add lxc-net service if unpriv mode is enabled.
    systemd.packages = lib.mkIf cfg.unprivilegedContainers [ pkgs.lxc ];
    systemd.services = lib.mkIf cfg.unprivilegedContainers {
      lxc-net = {
        enable = true;
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.iproute2 pkgs.iptables pkgs.getent pkgs.dnsmasq ];
      };
    };
  };
}
