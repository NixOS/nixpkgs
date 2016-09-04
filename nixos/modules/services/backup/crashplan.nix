{ config, pkgs, lib, ... }:

let
  cfg = config.services.crashplan;
  crashplan = pkgs.crashplan;
  varDir = "/var/lib/crashplan";
in

with lib;

{
  options = {
    services.crashplan = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Starts crashplan background service.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ crashplan ];

    systemd.services.crashplan = {
      description = "CrashPlan Backup Engine";

      wantedBy = [ "multi-user.target" ];
      after    = [ "network.target" "local-fs.target" ];

      preStart = ''
        ensureDir() {
          dir=$1
          mode=$2

          if ! test -e $dir; then
            ${pkgs.coreutils}/bin/mkdir -m $mode -p $dir
          elif [ "$(${pkgs.coreutils}/bin/stat -c %a $dir)" != "$mode" ]; then
            ${pkgs.coreutils}/bin/chmod $mode $dir
          fi
        }

        ensureDir ${crashplan.vardir} 755
        ensureDir ${crashplan.vardir}/conf 700
        ensureDir ${crashplan.manifestdir} 700
        ensureDir ${crashplan.vardir}/cache 700
        ensureDir ${crashplan.vardir}/backupArchives 700
        ensureDir ${crashplan.vardir}/log 777
        cp -avn ${crashplan}/conf.template/* ${crashplan.vardir}/conf
        for x in app.asar bin EULA.txt install.vars lang lib libjniwrap64.so libjniwrap.so libjtux64.so libjtux.so libmd564.so libmd5.so share skin upgrade; do
          rm -f ${crashplan.vardir}/$x;
          ln -sf ${crashplan}/$x ${crashplan.vardir}/$x;
        done
      '';

      serviceConfig = {
        Type = "forking";
        EnvironmentFile = "${crashplan}/bin/run.conf";
        ExecStart = "${crashplan}/bin/CrashPlanEngine start";
        ExecStop = "${crashplan}/bin/CrashPlanEngine stop";
        PIDFile = "${crashplan.vardir}/CrashPlanEngine.pid";
        WorkingDirectory = crashplan;
      };
    };
  };
}
