{ config, lib, pkgs, ... }:

with lib;

let
  ceph = pkgs.ceph;
  cfg  = config.services.ceph;
  # function that translates "camelCaseOptions" to "camel case options", credits to tilpner in #nixos@freenode
  translateOption = replaceStrings upperChars (map (s: " ${s}") lowerChars);
  generateDaemonList = (daemonType: daemons: extraServiceConfig:
    mkMerge (
      map (daemon: 
        { "ceph-${daemonType}-${daemon}" = generateServiceFile daemonType daemon cfg.global.clusterName ceph extraServiceConfig; }
      ) daemons
    )
  );
  generateServiceFile = (daemonType: daemonId: clusterName: ceph: extraServiceConfig: {
    enable = true;
    description = "Ceph ${builtins.replaceStrings lowerChars upperChars daemonType} daemon ${daemonId}";
    after = [ "network-online.target" "local-fs.target" "time-sync.target" ] ++ optional (daemonType == "osd") "ceph-mon.target";
    wants = [ "network-online.target" "local-fs.target" "time-sync.target" ];
    partOf = [ "ceph-${daemonType}.target" ];
    wantedBy = [ "ceph-${daemonType}.target" ];

    serviceConfig = {
      LimitNOFILE = 1048576;
      LimitNPROC = 1048576;
      Environment = "CLUSTER=${clusterName}";
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
      PrivateDevices = "yes";
      PrivateTmp = "true";
      ProtectHome = "true";
      ProtectSystem = "full";
      Restart = "on-failure";
      StartLimitBurst = "5";
      StartLimitInterval = "30min";
      ExecStart = "${ceph.out}/bin/${if daemonType == "rgw" then "radosgw" else "ceph-${daemonType}"} -f --cluster ${clusterName} --id ${if daemonType == "rgw" then "client.${daemonId}" else daemonId} --setuser ceph --setgroup ceph";
    } // extraServiceConfig
      // optionalAttrs (daemonType == "osd") { ExecStartPre = "${ceph.out}/libexec/ceph/ceph-osd-prestart.sh --id ${daemonId} --cluster ${clusterName}"; };
    } // optionalAttrs (builtins.elem daemonType [ "mds" "mon" "rgw" "mgr" ]) { preStart = ''
        daemonPath="/var/lib/ceph/${if daemonType == "rgw" then "radosgw" else daemonType}/${clusterName}-${daemonId}"
        if [ ! -d ''$daemonPath ]; then
          mkdir -m 755 -p ''$daemonPath
          chown -R ceph:ceph ''$daemonPath 
        fi
      '';
    } // optionalAttrs (daemonType == "osd") { path = [ pkgs.getopt ]; }
  );
  generateTargetFile = (daemonType:
    {
      "ceph-${daemonType}" = {
        description = "Ceph target allowing to start/stop all ceph-${daemonType} services at once";
        partOf = [ "ceph.target" ];
        before = [ "ceph.target" ];
      };
    }
  );
in 
{
  options.services.ceph = {
    # Ceph has a monolithic configuration file but different sections for
    # each daemon, a separate client section and a global section
    enable = mkEnableOption "Ceph global configuration";

    global = {
      fsid = mkOption {
        type = types.str;
        example = ''
          433a2193-4f8a-47a0-95d2-209d7ca2cca5
        '';
        description = ''
          Filesystem ID, a generated uuid, its must be generated and set before
          attempting to start a cluster
        '';
      };

      clusterName = mkOption {
        type = types.str;
        default = "ceph";
        description = ''
          Name of cluster
        '';
      };

      monInitialMembers = mkOption {
        type = with types; nullOr commas;
        default = null;
        example = ''
          node0, node1, node2 
        '';
        description = ''
          List of hosts that will be used as monitors at startup.
        '';
      };

      monHost = mkOption {
        type = with types; nullOr commas;
        default = null;
        example = ''
          10.10.0.1, 10.10.0.2, 10.10.0.3
        '';
        description = ''
          List of hostname shortnames/IP addresses of the initial monitors.
        '';
      };

      maxOpenFiles = mkOption {
        type = types.int;
        default = 131072;
        description = ''
          Max open files for each OSD daemon.
        '';
      };

      authClusterRequired = mkOption {
        type = types.enum [ "cephx" "none" ];
        default = "cephx";
        description = ''
          Enables requiring daemons to authenticate with eachother in the cluster.
        '';
      };

      authServiceRequired = mkOption {
        type = types.enum [ "cephx" "none" ];
        default = "cephx";
        description = ''
          Enables requiring clients to authenticate with the cluster to access services in the cluster (e.g. radosgw, mds or osd).
        '';
      };

      authClientRequired = mkOption {
        type = types.enum [ "cephx" "none" ];
        default = "cephx";
        description = ''
          Enables requiring the cluster to authenticate itself to the client.
        '';
      };

      publicNetwork = mkOption {
        type = with types; nullOr commas;
        default = null;
        example = ''
          10.20.0.0/24, 192.168.1.0/24
        '';
        description = ''
          A comma-separated list of subnets that will be used as public networks in the cluster.
        '';
      };

      clusterNetwork = mkOption {
        type = with types; nullOr commas;
        default = null;
        example = ''
          10.10.0.0/24, 192.168.0.0/24
        '';
        description = ''
          A comma-separated list of subnets that will be used as cluster networks in the cluster.
        '';
      };
    };

    mgr = {
      enable = mkEnableOption "Ceph MGR daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = ''
          [ "name1" "name2" ];
        '';
        description = ''
          A list of names for manager daemons that should have a service created. The names correspond
          to the id part in ceph i.e. [ "name1" ] would result in mgr.name1
        '';
      };
      extraConfig = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = ''
          Extra configuration to add to the global section for manager daemons.
        '';
      };
    };

    mon = {
      enable = mkEnableOption "Ceph MON daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = ''
          [ "name1" "name2" ];
        '';
        description = ''
          A list of monitor daemons that should have a service created. The names correspond
          to the id part in ceph i.e. [ "name1" ] would result in mon.name1
        '';
      };
      extraConfig = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = ''
          Extra configuration to add to the monitor section.
        '';
      };
    };

    osd = {
      enable = mkEnableOption "Ceph OSD daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = ''
          [ "name1" "name2" ];
        '';
        description = ''
          A list of OSD daemons that should have a service created. The names correspond
          to the id part in ceph i.e. [ "name1" ] would result in osd.name1
        '';
      };
      extraConfig = mkOption {
        type = with types; attrsOf str;
        default = {
          "osd journal size" = "10000";
          "osd pool default size" = "3";
          "osd pool default min size" = "2";
          "osd pool default pg num" = "200";
          "osd pool default pgp num" = "200";
          "osd crush chooseleaf type" = "1";
        };
        description = ''
          Extra configuration to add to the OSD section.
        '';
      };
    };

    mds = {
      enable = mkEnableOption "Ceph MDS daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = ''
          [ "name1" "name2" ];
        '';
        description = ''
          A list of metadata service daemons that should have a service created. The names correspond
          to the id part in ceph i.e. [ "name1" ] would result in mds.name1
        '';
      };
      extraConfig = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = ''
          Extra configuration to add to the MDS section.
        '';
      };
    };

    rgw = {
      enable = mkEnableOption "Ceph RadosGW daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = ''
          [ "name1" "name2" ];
        '';
        description = ''
          A list of rados gateway daemons that should have a service created. The names correspond
          to the id part in ceph i.e. [ "name1" ] would result in client.name1, radosgw daemons
          aren't daemons to cluster in the sense that OSD, MGR or MON daemons are. They are simply
          daemons, from ceph, that uses the cluster as a backend.
        '';
      };
    };

    client = {
      enable = mkEnableOption "Ceph client configuration";
      extraConfig = mkOption {
        type = with types; attrsOf str;
        default = {};
        example = ''
          {
            # This would create a section for a radosgw daemon named node0 and related
            # configuration for it
            "client.radosgw.node0" = { "some config option" = "true"; };
          };
        '';
        description = ''
          Extra configuration to add to the client section. Configuration for rados gateways
          would be added here, with their own sections, see example.
        '';
      };
    };
  };

  config = mkIf config.services.ceph.enable {
    assertions = [
      { assertion = cfg.global.fsid != "";
        message = "fsid has to be set to a valid uuid for the cluster to function";
      }
      { assertion = cfg.mgr.enable == true;
        message = "ceph 12.x requires atleast 1 MGR daemon enabled for the cluster to function";
      }
      { assertion = cfg.mon.enable == true -> cfg.mon.daemons != [];
        message = "have to set id of atleast one MON if you're going to enable Monitor";
      }
      { assertion = cfg.mds.enable == true -> cfg.mds.daemons != [];
        message = "have to set id of atleast one MDS if you're going to enable Metadata Service";
      }
      { assertion = cfg.osd.enable == true -> cfg.osd.daemons != [];
        message = "have to set id of atleast one OSD if you're going to enable OSD";
      }
      { assertion = cfg.mgr.enable == true -> cfg.mgr.daemons != [];
        message = "have to set id of atleast one MGR if you're going to enable MGR";
      }
    ];

    warnings = optional (cfg.global.monInitialMembers == null) 
      ''Not setting up a list of members in monInitialMembers requires that you set the host variable for each mon daemon or else the cluster won't function'';
    
    environment.etc."ceph/ceph.conf".text = let
      # Translate camelCaseOptions to the expected camel case option for ceph.conf
      translatedGlobalConfig = mapAttrs' (name: value: nameValuePair (translateOption name) value) cfg.global;
      # Merge the extraConfig set for mgr daemons, as mgr don't have their own section
      globalAndMgrConfig = translatedGlobalConfig // optionalAttrs cfg.mgr.enable cfg.mgr.extraConfig;
      # Remove all name-value pairs with null values from the attribute set to avoid making empty sections in the ceph.conf
      globalConfig = mapAttrs' (name: value: nameValuePair (translateOption name) value) (filterAttrs (name: value: value != null) globalAndMgrConfig);
      totalConfig = {
          "global" = globalConfig;
        } // optionalAttrs (cfg.mon.enable && cfg.mon.extraConfig != {}) { "mon" = cfg.mon.extraConfig; }
          // optionalAttrs (cfg.mds.enable && cfg.mds.extraConfig != {}) { "mds" = cfg.mds.extraConfig; }
          // optionalAttrs (cfg.osd.enable && cfg.osd.extraConfig != {}) { "osd" = cfg.osd.extraConfig; }
          // optionalAttrs (cfg.client.enable && cfg.client.extraConfig != {})  cfg.client.extraConfig;
      in
        generators.toINI {} totalConfig;

    users.extraUsers = singleton {
      name = "ceph";
      uid = config.ids.uids.ceph;
      description = "Ceph daemon user";
    };

    users.extraGroups = singleton {
      name = "ceph";
      gid = config.ids.gids.ceph;
    };

    systemd.services = let
      services = [] 
        ++ optional cfg.mon.enable (generateDaemonList "mon" cfg.mon.daemons { RestartSec = "10"; }) 
        ++ optional cfg.mds.enable (generateDaemonList "mds" cfg.mds.daemons { StartLimitBurst = "3"; })
        ++ optional cfg.osd.enable (generateDaemonList "osd" cfg.osd.daemons { StartLimitBurst = "30"; RestartSec = "20s"; })
        ++ optional cfg.rgw.enable (generateDaemonList "rgw" cfg.rgw.daemons { })
        ++ optional cfg.mgr.enable (generateDaemonList "mgr" cfg.mgr.daemons { StartLimitBurst = "3"; });
      in 
        mkMerge services;

    systemd.targets = let
      targets = [
        { "ceph" = { description = "Ceph target allowing to start/stop all ceph service instances at once"; }; }
      ] ++ optional cfg.mon.enable (generateTargetFile "mon")
        ++ optional cfg.mds.enable (generateTargetFile "mds")
        ++ optional cfg.osd.enable (generateTargetFile "osd")
        ++ optional cfg.rgw.enable (generateTargetFile "rgw")
        ++ optional cfg.mgr.enable (generateTargetFile "mgr");
      in
        mkMerge targets;

    systemd.tmpfiles.rules = [
      "d /run/ceph 0770 ceph ceph -"
    ];
  };
}
