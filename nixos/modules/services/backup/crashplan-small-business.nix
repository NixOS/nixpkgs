{ config, pkgs, lib, ... }:

let
  cfg = config.services.crashplansb;
  crashplansb = pkgs.crashplansb.override { maxRam = cfg.maxRam; };
  varDir = "/var/lib/crashplan";
in

with lib;

{
  options = {
    services.crashplansb = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Starts crashplan for small business background service.
        '';
      };
      maxRam = mkOption {
        default = "1024m";
        example = "2G";
        type = types.str;
        description = ''
          Maximum amount of that the crashplan engine should use.
        '';
      };
      openPorts = mkOption {
        description = "Open ports in the firewall for crashplan.";
        default = true;
        type = types.bool;
      };
      ports =  mkOption {
        # https://support.code42.com/Administrator/6/Planning_and_installing/TCP_and_UDP_ports_used_by_the_Code42_platform
        # used ports can also be checked in the desktop app console using the command connection.info
        description = "which ports to open.";
        default = [ 4242 4243 4244 4247 ];
        type = types.listOf types.int;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ crashplansb ];
    networking.firewall.allowedTCPPorts = mkIf cfg.openPorts cfg.ports;

    systemd.services.crashplansb = {
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

        ensureDir ${crashplansb.vardir} 755
        ensureDir ${crashplansb.vardir}/conf 700
        ensureDir ${crashplansb.manifestdir} 700
        ensureDir ${crashplansb.vardir}/cache 700
        ensureDir ${crashplansb.vardir}/backupArchives 700
        ensureDir ${crashplansb.vardir}/log 777
        cp -avn ${crashplansb}/conf.template/* ${crashplansb.vardir}/conf
        #for x in bin install.vars lang lib libc42archive64.so libc42core.so libjniwrap64.so libjtux64.so libleveldb64.so libnetty-tcnative.so share upgrade; do
        #  rm -f ${crashplansb.vardir}/$x;
        #  ln -sf ${crashplansb}/$x ${crashplansb.vardir}/$x;
        #done
      '';

      serviceConfig = {
        Type = "forking";
        EnvironmentFile = "${crashplansb}/bin/run.conf";
        ExecStart = "${crashplansb}/bin/CrashPlanEngine start";
        ExecStop = "${crashplansb}/bin/CrashPlanEngine stop";
        PIDFile = "${crashplansb.vardir}/CrashPlanEngine.pid";
        WorkingDirectory = crashplansb;
      };
    };
  };
}
