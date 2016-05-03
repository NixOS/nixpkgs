{ config, lib, pkgs, ... }:

let
  cfg = config.flyingcircus;

in
{
  config = {
    fileSystems."/".options = "usrquota,prjquota";

    environment.etc.projects.text = ''
      1:/
    '';

    environment.etc.projid.text = ''
      root:1
    '';

    system.activationScripts.setupXFSQuota = {
      text =
      let
        msg = "Reboot to activate filesystem quotas";
      in
        # keep the grep expression in sync with that one in fcmanage/resize.py
        with pkgs; ''
          if egrep -q ' / .*usrquota,.*prjquota' /proc/self/mounts; then
            if ! ${xfsprogs}/bin/xfs_quota -x -c 'state -p' / | \
                grep -qi 'Accounting:.*ON'; then
              ${xfsprogs}/bin/xfs_quota -x -c 'project -s root' / 2>/dev/null
              ${xfsprogs}/bin/xfs_quota -x -c 'timer -p 1m' / 2>/dev/null
              # fc-resize sets the actual quota limit
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
