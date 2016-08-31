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

    boot.specialFileSystems."/proc".options = [ "hidepid=2" "gid=${toString config.ids.gids.proc}" ];
  };
}
