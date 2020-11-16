{ config, lib, pkgs, ... }:

with lib;

let
  xcfg = config.services.xserver;
  dmcfg = xcfg.displayManager;
  xEnv = config.systemd.services.display-manager.environment;
  cfg = dmcfg.dtlogin;

  xserverWrapper = pkgs.writeScript "xserver-wrapper"
    ''
      #! ${pkgs.bash}/bin/bash
      ${concatMapStrings (n: "export ${n}=\"${getAttr n xEnv}\"\n") (attrNames xEnv)}

      display=$(echo "$@" | xargs -n 1 | grep -P ^:\\d\$ | head -n 1 | sed s/^://)
      if [ -z "$display" ]
      then additionalArgs=":0 -logfile /var/log/X.0.log"
      else additionalArgs="-logfile /var/log/X.$display.log"
      fi

      exec ${dmcfg.xserverBin} ${toString dmcfg.xserverArgs} $additionalArgs "$@"
    '';
in
{
  options = {
    services.xserver.displayManager.dtlogin = {
      enable = mkEnableOption "dtlogin";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = config.services.xserver.desktopManager.cde.enable;
        message = ''
          dtlogin is meant to be used with 'services.xserver.desktopManager.cde'
        '';
      }
    ];

    services.xserver.displayManager.job.execCmd = ''
      exec ${pkgs.cdesktopenv}/opt/dt/bin/dtlogin -server ":0 Local local_uid@none root ${xserverWrapper}" -udpPort 0
    '';
  };

  meta.maintainers = [ maintainers.gnidorah ];
}
