# LXC Configuration

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation.lxc.lxcfs;
in
{
  meta = {
    maintainers = lib.teams.lxc.members;
  };

  ###### interface
  options.virtualisation.lxc.lxcfs = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        This enables LXCFS, a FUSE filesystem for LXC.
        To use lxcfs in include the following configuration in your
        container configuration:
        ```
        virtualisation.lxc.defaultConfig = "lxc.include = ''${pkgs.lxcfs}/share/lxc/config/common.conf.d/00-lxcfs.conf";
        ```
      '';
    };
  };

  ###### implementation
  config = lib.mkIf cfg.enable {
    systemd.services.lxcfs = {
      description = "FUSE filesystem for LXC";
      wantedBy = [ "multi-user.target" ];
      before = [ "lxc.service" ];
      restartIfChanged = false;
      serviceConfig = {
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/lib/lxcfs";
        ExecStart = "${pkgs.lxcfs}/bin/lxcfs /var/lib/lxcfs";
        ExecStopPost = "-${pkgs.fuse}/bin/fusermount -u /var/lib/lxcfs";
        KillMode = "process";
        Restart = "on-failure";
      };
    };
  };
}
