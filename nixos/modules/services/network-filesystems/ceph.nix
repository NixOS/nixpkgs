{ config, lib, pkgs, ... }:

with lib;

let
  cfg  = config.services.ceph;

  # function that translates "camelCaseOptions" to "camel case options", credits to tilpner in #nixos@freenode
  expandCamelCase = replaceStrings upperChars (map (s: " ${s}") lowerChars);
  expandCamelCaseAttrs = mapAttrs' (name: value: nameValuePair (expandCamelCase name) value);

  makeServices = (daemonType: daemonIds:
    mkMerge (map (daemonId:
      { "ceph-${daemonType}-${daemonId}" = makeService daemonType daemonId cfg.global.clusterName pkgs.ceph; })
      daemonIds));

  makeService = (daemonType: daemonId: clusterName: ceph:
    let
      stateDirectory = "ceph/${if daemonType == "rgw" then "radosgw" else daemonType}/${clusterName}-${daemonId}"; in {
    enable = true;
    description = "Ceph ${builtins.replaceStrings lowerChars upperChars daemonType} daemon ${daemonId}";
    after = [ "network-online.target" "time-sync.target" ] ++ optional (daemonType == "osd") "ceph-mon.target";
    wants = [ "network-online.target" "time-sync.target" ];
    partOf = [ "ceph-${daemonType}.target" ];
    wantedBy = [ "ceph-${daemonType}.target" ];

    path = [ pkgs.getopt ];

    # Don't start services that are not yet initialized
    unitConfig.ConditionPathExists = "/var/lib/${stateDirectory}/keyring";
    startLimitBurst =
      if daemonType == "osd" then 30 else if lib.elem daemonType ["mgr" "mds"] then 3 else 5;
    startLimitIntervalSec = 60 * 30;  # 30 mins

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
      StateDirectory = stateDirectory;
      User = "ceph";
      Group = if daemonType == "osd" then "disk" else "ceph";
      ExecStart = ''${ceph.out}/bin/${if daemonType == "rgw" then "radosgw" else "ceph-${daemonType}"} \
                    -f --cluster ${clusterName} --id ${daemonId}'';
    } // optionalAttrs (daemonType == "osd") {
      ExecStartPre = "${ceph.lib}/libexec/ceph/ceph-osd-prestart.sh --id ${daemonId} --cluster ${clusterName}";
      RestartSec = "20s";
      PrivateDevices = "no"; # osd needs disk access
    } // optionalAttrs ( daemonType == "mon") {
      RestartSec = "10";
    };
  });

  makeTarget = (daemonType:
    {
      "ceph-${daemonType}" = {
        description = "Ceph target allowing to start/stop all ceph-${daemonType} services at once";
        partOf = [ "ceph.target" ];
        wantedBy = [ "ceph.target" ];
        before = [ "ceph.target" ];
        unitConfig.StopWhenUnneeded = true;
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
        description = lib.mdDoc ''
          Filesystem ID, a generated uuid, its must be generated and set before
          attempting to start a cluster
        '';
      };

      clusterName = mkOption {
        type = types.str;
        default = "ceph";
        description = lib.mdDoc ''
          Name of cluster
        '';
      };

      mgrModulePath = mkOption {
        type = types.path;
        default = "${pkgs.ceph.lib}/lib/ceph/mgr";
        defaultText = literalExpression ''"''${pkgs.ceph.lib}/lib/ceph/mgr"'';
        description = lib.mdDoc ''
          Path at which to find ceph-mgr modules.
        '';
      };

      monInitialMembers = mkOption {
        type = with types; nullOr commas;
        default = null;
        example = ''
          node0, node1, node2
        '';
        description = lib.mdDoc ''
          List of hosts that will be used as monitors at startup.
        '';
      };

      monHost = mkOption {
        type = with types; nullOr commas;
        default = null;
        example = ''
          10.10.0.1, 10.10.0.2, 10.10.0.3
        '';
        description = lib.mdDoc ''
          List of hostname shortnames/IP addresses of the initial monitors.
        '';
      };

      maxOpenFiles = mkOption {
        type = types.int;
        default = 131072;
        description = lib.mdDoc ''
          Max open files for each OSD daemon.
        '';
      };

      authClusterRequired = mkOption {
        type = types.enum [ "cephx" "none" ];
        default = "cephx";
        description = lib.mdDoc ''
          Enables requiring daemons to authenticate with eachother in the cluster.
        '';
      };

      authServiceRequired = mkOption {
        type = types.enum [ "cephx" "none" ];
        default = "cephx";
        description = lib.mdDoc ''
          Enables requiring clients to authenticate with the cluster to access services in the cluster (e.g. radosgw, mds or osd).
        '';
      };

      authClientRequired = mkOption {
        type = types.enum [ "cephx" "none" ];
        default = "cephx";
        description = lib.mdDoc ''
          Enables requiring the cluster to authenticate itself to the client.
        '';
      };

      publicNetwork = mkOption {
        type = with types; nullOr commas;
        default = null;
        example = ''
          10.20.0.0/24, 192.168.1.0/24
        '';
        description = lib.mdDoc ''
          A comma-separated list of subnets that will be used as public networks in the cluster.
        '';
      };

      clusterNetwork = mkOption {
        type = with types; nullOr commas;
        default = null;
        example = ''
          10.10.0.0/24, 192.168.0.0/24
        '';
        description = lib.mdDoc ''
          A comma-separated list of subnets that will be used as cluster networks in the cluster.
        '';
      };

      rgwMimeTypesFile = mkOption {
        type = with types; nullOr path;
        default = "${pkgs.mailcap}/etc/mime.types";
        defaultText = literalExpression ''"''${pkgs.mailcap}/etc/mime.types"'';
        description = lib.mdDoc ''
          Path to mime types used by radosgw.
        '';
      };
    };

    extraConfig = mkOption {
      type = with types; attrsOf str;
      default = {};
      example = {
        "ms bind ipv6" = "true";
      };
      description = lib.mdDoc ''
        Extra configuration to add to the global section. Use for setting values that are common for all daemons in the cluster.
      '';
    };

    mgr = {
      enable = mkEnableOption "Ceph MGR daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "name1" "name2" ];
        description = lib.mdDoc ''
          A list of names for manager daemons that should have a service created. The names correspond
          to the id part in ceph i.e. [ "name1" ] would result in mgr.name1
        '';
      };
      extraConfig = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = lib.mdDoc ''
          Extra configuration to add to the global section for manager daemons.
        '';
      };
    };

    mon = {
      enable = mkEnableOption "Ceph MON daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "name1" "name2" ];
        description = lib.mdDoc ''
          A list of monitor daemons that should have a service created. The names correspond
          to the id part in ceph i.e. [ "name1" ] would result in mon.name1
        '';
      };
      extraConfig = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = lib.mdDoc ''
          Extra configuration to add to the monitor section.
        '';
      };
    };

    osd = {
      enable = mkEnableOption "Ceph OSD daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "name1" "name2" ];
        description = lib.mdDoc ''
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
        description = lib.mdDoc ''
          Extra configuration to add to the OSD section.
        '';
      };
    };

    mds = {
      enable = mkEnableOption "Ceph MDS daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "name1" "name2" ];
        description = lib.mdDoc ''
          A list of metadata service daemons that should have a service created. The names correspond
          to the id part in ceph i.e. [ "name1" ] would result in mds.name1
        '';
      };
      extraConfig = mkOption {
        type = with types; attrsOf str;
        default = {};
        description = lib.mdDoc ''
          Extra configuration to add to the MDS section.
        '';
      };
    };

    rgw = {
      enable = mkEnableOption "Ceph RadosGW daemon";
      daemons = mkOption {
        type = with types; listOf str;
        default = [];
        example = [ "name1" "name2" ];
        description = lib.mdDoc ''
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
        type = with types; attrsOf (attrsOf str);
        default = {};
        example = literalExpression ''
          {
            # This would create a section for a radosgw daemon named node0 and related
            # configuration for it
            "client.radosgw.node0" = { "some config option" = "true"; };
          };
        '';
        description = lib.mdDoc ''
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
      "Not setting up a list of members in monInitialMembers requires that you set the host variable for each mon daemon or else the cluster won't function";

    environment.etc."ceph/ceph.conf".text = let
      # Merge the extraConfig set for mgr daemons, as mgr don't have their own section
      globalSection = expandCamelCaseAttrs (cfg.global // cfg.extraConfig // optionalAttrs cfg.mgr.enable cfg.mgr.extraConfig);
      # Remove all name-value pairs with null values from the attribute set to avoid making empty sections in the ceph.conf
      globalSection' = filterAttrs (name: value: value != null) globalSection;
      totalConfig = {
          global = globalSection';
        } // optionalAttrs (cfg.mon.enable && cfg.mon.extraConfig != {}) { mon = cfg.mon.extraConfig; }
          // optionalAttrs (cfg.mds.enable && cfg.mds.extraConfig != {}) { mds = cfg.mds.extraConfig; }
          // optionalAttrs (cfg.osd.enable && cfg.osd.extraConfig != {}) { osd = cfg.osd.extraConfig; }
          // optionalAttrs (cfg.client.enable && cfg.client.extraConfig != {})  cfg.client.extraConfig;
      in
        generators.toINI {} totalConfig;

    users.users.ceph = {
      uid = config.ids.uids.ceph;
      description = "Ceph daemon user";
      group = "ceph";
      extraGroups = [ "disk" ];
    };

    users.groups.ceph = {
      gid = config.ids.gids.ceph;
    };

    systemd.services = let
      services = []
        ++ optional cfg.mon.enable (makeServices "mon" cfg.mon.daemons)
        ++ optional cfg.mds.enable (makeServices "mds" cfg.mds.daemons)
        ++ optional cfg.osd.enable (makeServices "osd" cfg.osd.daemons)
        ++ optional cfg.rgw.enable (makeServices "rgw" cfg.rgw.daemons)
        ++ optional cfg.mgr.enable (makeServices "mgr" cfg.mgr.daemons);
      in
        mkMerge services;

    systemd.targets = let
      targets = [
        { ceph = {
          description = "Ceph target allowing to start/stop all ceph service instances at once";
          wantedBy = [ "multi-user.target" ];
          unitConfig.StopWhenUnneeded = true;
        }; } ]
        ++ optional cfg.mon.enable (makeTarget "mon")
        ++ optional cfg.mds.enable (makeTarget "mds")
        ++ optional cfg.osd.enable (makeTarget "osd")
        ++ optional cfg.rgw.enable (makeTarget "rgw")
        ++ optional cfg.mgr.enable (makeTarget "mgr");
      in
        mkMerge targets;

    systemd.tmpfiles.rules = [
      "d /etc/ceph - ceph ceph - -"
      "d /run/ceph 0770 ceph ceph -"
      "d /var/lib/ceph - ceph ceph - -"]
    ++ optionals cfg.mgr.enable [ "d /var/lib/ceph/mgr - ceph ceph - -"]
    ++ optionals cfg.mon.enable [ "d /var/lib/ceph/mon - ceph ceph - -"]
    ++ optionals cfg.osd.enable [ "d /var/lib/ceph/osd - ceph ceph - -"];
  };
}
