{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.services.zeek;
  zeek-oneshot = pkgs.writeScript "zeek-oneshot" ''
   if [ ! -d "/var/lib/zeek/logs/current/stats.log" ];then
   ${cfg.package}/bin/zeekctl install || true
   rm -rf ${cfg.dataDir}/logs/current
   mkdir -p ${cfg.dataDir}/logs/current
   cd ${cfg.dataDir}/logs/current
   chown root:root /var/lib/zeek/logs/current
  ${cfg.dataDir}/scripts/run-zeek -1 -i ${cfg.interface} -U .status -p zeekctl -p zeekctl-live -p standalone -p local -p zeek local.zeek zeekctl zeekctl/standalone zeekctl/auto
    else
     cd ${cfg.dataDir}/logs/current
    ${cfg.dataDir}/scripts/run-zeek -1 -i ${cfg.interface} -U .status -p zeekctl -p zeekctl-live -p standalone -p local -p zeek local.zeek zeekctl zeekctl/standalone zeekctl/auto
  fi
  '';
  StandaloneConfig = ''
  [zeek]
  type=standalone
  host=${cfg.listenAddress}
  interface=${cfg.interface}
  '';

  ClusterConfig =  ''
  [logger]
  type=logger
  host=localhost
  [manager]
  type=manager
  host=localhost

  [proxy-1]
  type=proxy
  host=localhost

  [worker-1]
  type=worker
  host=localhost
  interface=eth0

  [worker-2]
  type=worker
  host=localhost
  interface=eth0
  '';

  NodeConf = pkgs.writeText "node.cfg" (if cfg.standalone then  StandaloneConfig else cfg.extraConfig);
  NetworkConf = pkgs.writeText "networks.cfg" cfg.network;

  PreShell = pkgs.writeScript "Pre-runZeek" ''
    if [ ! -d "/var/lib/zeek/logs" ];then
      mkdir -p  /var/lib/zeek/logs
     chown root:root /var/lib/zeek/logs
      fi
    if [ ! -d "/var/lib/zeek/spool" ];then
      mkdir -p  /var/lib/zeek/spool
     chown root:root /var/lib/zeek/spool
      fi
    if [ ! -d "/var/lib/zeek/etc" ];then
      mkdir -p  /var/lib/zeek/etc
     chown root:root /var/lib/zeek/etc
      fi
    if [ ! -d "/var/lib/zeek/scripts" ];then
      mkdir -p  /var/lib/zeek/scripts
     chown root:root /var/lib/zeek/scripts
      fi
    if [ ! -d "/var/lib/zeek/policy" ];then
      mkdir -p  /var/lib/zeek/policy
     chown root:root /var/lib/zeek/policy
      fi

   ln -sf ${NodeConf} /var/lib/zeek/etc/node.cfg
   ln -sf ${NetworkConf} /var/lib/zeek/etc/networks.cfg
   if [ ! -d "/var/lib/zeek/scripts/helpers" ];then
   cp -r ${cfg.package}/share/zeekctl/scripts/helpers /var/lib/zeek/scripts/
   cp -r ${cfg.package}/share/zeekctl/scripts/postprocessors /var/lib/zeek/scripts/
   fi
   cp -r ${cfg.package}/share/zeek/site/local.zeek /var/lib/zeek/policy
   for i in  run-zeek crash-diag         expire-logs        post-terminate     run-zeek-on-trace  stats-to-csv        check-config       expire-crash       make-archive-name  run-zeek           set-zeek-path             archive-log        delete-log     send-mail
   do
   ln -sf ${cfg.package}/share/zeekctl/scripts/$i /var/lib/zeek/scripts/
   done

        ${optionalString (cfg.privateScript != null)
          "echo \"${cfg.privateScript}\" >> ${cfg.dataDir}/policy/local.zeek"
         }
'';
in {

  options.services.zeek = {
    enable = mkOption {
      description = "Whether to enable zeek.";
      default = false;
      type = types.bool;
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/zeek";
      description = ''
        Data directory for zeek. Do not change
      '';
    };

    package = mkOption {
      description = "Zeek package to use.
             enable zeek plugin set name to true;
            pkgs.zeek.override{ KafkaPlugin = true; PostgresqlPlugin = true; Http2Plugin = true;}";
      default = pkgs.zeek;
      defaultText = "pkgs.zeek";
      type = types.package;
    };

    standalone = mkOption {
      description = "Whether to enable zeek Standalone mode";
      default = true;
      type = types.bool;
    };


    interface = mkOption {
      description = "Zeek listen address.";
      default = "eth0";
      type = types.str;
    };

    listenAddress = mkOption {
      description = "Zeek listen address.";
      default = "localhost";
      type = types.str;
    };

    network = mkOption {
      description = "Zeek network configuration.";
      default = ''
      # List of local networks in CIDR notation, optionally followed by a
      # descriptive tag.
      # For example, "10.0.0.0/8" or "fe80::/64" are valid prefixes.

      10.0.0.0/8          Private IP space
      172.16.0.0/12       Private IP space
      192.168.0.0/16      Private IP space
      '';
      type = types.str;
    };

    privateScript = mkOption {
      description = "Zeek load private script path";
      default ="";
      type = types.str;
    };

    extraConfig = mkOption {
      type = types.lines;
      default = ClusterConfig;
      description = "Zeek cluster configuration.";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.zeek = {
      description = "Zeek Daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.package pkgs.gawk pkgs.gzip ];
      preStart = ''
        ${pkgs.bash}/bin/bash ${PreShell}
        '';
      serviceConfig = {
        ExecStart = mkIf cfg.standalone ''
         ${pkgs.bash}/bin/bash ${zeek-oneshot}
          '';
        ExecStop  = "${pkgs.coreutils}/bin/kill -INT $MAINPID";
        User = "root";
        PrivateTmp="yes";
        PrivateDevices="yes";
        RuntimeDirectory = "zeek";
        RuntimeDirectoryMode = "0755";
        LimitNOFILE = "30000";
      };
    };
  };
}
