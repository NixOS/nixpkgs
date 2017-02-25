# LXC Configuration

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.virtualisation.lxc.lxcfs;
in {
  meta.maintainers = [ maintainers.mic92 ];

  ###### interface
  options.virtualisation.lxc.lxcfs = {
    enable =
      mkOption {
        type = types.bool;
        default = false;
        description = ''
          This enables LXCFS, a FUSE filesystem for LXC.
          To use lxcfs in include the following configuration in your
          container configuration:
          <code>
            virtualisation.lxc.defaultConfig = "lxc.include = ''${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf";
          </code>
        '';
      };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.cgmanager.enable = true;

    systemd.services.lxcfs = {
      description = "FUSE filesystem for LXC";
      wantedBy = [ "multi-user.target" ];
      requires = [ "cgmanager.service" ];
      after = [ "cgmanager.service" ];
      before = [ "lxc.service" ];
      restartIfChanged = false;
      serviceConfig = {
        ExecStartPre="${pkgs.coreutils}/bin/mkdir -p /var/lib/lxcfs";
        ExecStart="${pkgs.lxcfs}/bin/lxcfs /var/lib/lxcfs";
        ExecStopPost="-${pkgs.fuse}/bin/fusermount -u /var/lib/lxcfs";
        KillMode="process";
        Restart="on-failure";
      };
    };
  };
}
