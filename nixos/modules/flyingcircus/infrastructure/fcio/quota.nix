{ config, lib, pkgs, ... }:

let
  cfg = config.flyingcircus;

in
{
  config = {
    fileSystems."/".options = "prjquota";

    environment.etc.projects.text = ''
      0:/
    '';

    environment.etc.projid.text = ''
      root:0
    '';

    system.activationScripts.setupXFSQuota = {
      text =
      let
        msg = "Reboot to activate filesystem quotas";
      in
        with pkgs; ''
          if egrep -q ' / .*p(rj)?quota' /proc/self/mounts; then
            if ! ${xfsprogs}/bin/xfs_quota -x -c 'state -p' / | \
                grep -qi 'Accounting:.*ON'; then
              ${xfsprogs}/bin/xfs_quota -x -c 'project -s 0' / 2>/dev/null
              # see fc-resize for the actual quota setting
            fi
          else
            if ! ${fcmaintenance}/bin/list-maintenance | fgrep -q "${msg}";
            then
              ${fcmaintenance}/bin/scheduled-reboot -c "${msg}"
            fi
          fi
        '';
        deps = [ ];
    };
  };
}
