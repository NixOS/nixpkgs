{ config, pkgs, lib, ... }:

let
  cfg = config.services.crashplansb;
  crashplansb = pkgs.crashplansb.override { maxRam = cfg.maxRam; };
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
          Maximum amount of ram that the crashplan engine should use.
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
        install -d -m 755 ${crashplansb.vardir}
        install -d -m 700 ${crashplansb.vardir}/conf
        install -d -m 700 ${crashplansb.manifestdir}
        install -d -m 700 ${crashplansb.vardir}/cache
        install -d -m 700 ${crashplansb.vardir}/backupArchives
        install -d -m 777 ${crashplansb.vardir}/log
        cp -avn ${crashplansb}/conf.template/* ${crashplansb.vardir}/conf
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
