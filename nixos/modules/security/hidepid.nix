{ config, pkgs, lib, ... }:
with lib;

{
  options = {
    security.hideProcessInformation = mkEnableOption "" // { description = ''
      Restrict access to process information to the owning user.  Enabling
      this option implies, among other things, that command-line arguments
      remain private.  This option is recommended for most systems, unless
      there's a legitimate reason for allowing unprivileged users to inspect
      the process information of other users.

      Members of the group "proc" are exempt from process information hiding.
      To allow a service to run without process information hiding, add "proc"
      to its supplementary groups via
      <option>systemd.services.&lt;name?&gt;.serviceConfig.SupplementaryGroups</option>.
    ''; };
  };

  config = mkIf config.security.hideProcessInformation {
    users.groups.proc.gid = config.ids.gids.proc;

    systemd.services.hidepid = {
      wantedBy = [ "local-fs.target" ];
      after = [ "systemd-remount-fs.service" ];
      before = [ "local-fs-pre.target" "local-fs.target" "shutdown.target" ];
      wants = [ "local-fs-pre.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = ''${pkgs.utillinux}/bin/mount -o remount,hidepid=2,gid=${toString config.ids.gids.proc} /proc'';
        ExecStop = ''${pkgs.utillinux}/bin/mount -o remount,hidepid=0,gid=0 /proc'';
      };

      unitConfig = {
        DefaultDependencies = false;
        Conflicts = "shutdown.target";
      };
    };
  };
}
