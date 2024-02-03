{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.hadoop;
  hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";
  restartIfChanged  = mkOption {
    type = types.bool;
    description = lib.mdDoc ''
      Automatically restart the service on config change.
      This can be set to false to defer restarts on clusters running critical applications.
      Please consider the security implications of inadvertently running an older version,
      and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
    '';
    default = false;
  };
  extraFlags = mkOption{
    type = with types; listOf str;
    default = [];
    description = lib.mdDoc "Extra command line flags to pass to the service";
    example = [
      "-Dcom.sun.management.jmxremote"
      "-Dcom.sun.management.jmxremote.port=8010"
    ];
  };
  extraEnv = mkOption{
    type = with types; attrsOf str;
    default = {};
    description = lib.mdDoc "Extra environment variables";
  };
in
{
  options.services.hadoop.yarn = {
    resourcemanager = {
      enable = mkEnableOption (lib.mdDoc "Hadoop YARN ResourceManager");
      inherit restartIfChanged extraFlags extraEnv;

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open firewall ports for resourcemanager
        '';
      };
    };
    nodemanager = {
      enable = mkEnableOption (lib.mdDoc "Hadoop YARN NodeManager");
      inherit restartIfChanged extraFlags extraEnv;

      resource = {
        cpuVCores = mkOption {
          description = lib.mdDoc "Number of vcores that can be allocated for containers.";
          type = with types; nullOr ints.positive;
          default = null;
        };
        maximumAllocationVCores = mkOption {
          description = lib.mdDoc "The maximum virtual CPU cores any container can be allocated.";
          type = with types; nullOr ints.positive;
          default = null;
        };
        memoryMB = mkOption {
          description = lib.mdDoc "Amount of physical memory, in MB, that can be allocated for containers.";
          type = with types; nullOr ints.positive;
          default = null;
        };
        maximumAllocationMB = mkOption {
          description = lib.mdDoc "The maximum physical memory any container can be allocated.";
          type = with types; nullOr ints.positive;
          default = null;
        };
      };

      useCGroups = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Use cgroups to enforce resource limits on containers
        '';
      };

      localDir = mkOption {
        description = lib.mdDoc "List of directories to store localized files in.";
        type = with types; nullOr (listOf path);
        example = [ "/var/lib/hadoop/yarn/nm" ];
        default = null;
      };

      addBinBash = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Add /bin/bash. This is needed by the linux container executor's launch script.
        '';
      };
      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Open firewall ports for nodemanager.
          Because containers can listen on any ephemeral port, TCP ports 1024–65535 will be opened.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf cfg.gatewayRole.enable {
      users.users.yarn = {
        description = "Hadoop YARN user";
        group = "hadoop";
        uid = config.ids.uids.yarn;
      };
    })

    (mkIf cfg.yarn.resourcemanager.enable {
      systemd.services.yarn-resourcemanager = {
        description = "Hadoop YARN ResourceManager";
        wantedBy = [ "multi-user.target" ];
        inherit (cfg.yarn.resourcemanager) restartIfChanged;
        environment = cfg.yarn.resourcemanager.extraEnv;

        serviceConfig = {
          User = "yarn";
          SyslogIdentifier = "yarn-resourcemanager";
          ExecStart = "${cfg.package}/bin/yarn --config ${hadoopConf} " +
                      " resourcemanager ${escapeShellArgs cfg.yarn.resourcemanager.extraFlags}";
          Restart = "always";
        };
      };

      services.hadoop.gatewayRole.enable = true;

      networking.firewall.allowedTCPPorts = (mkIf cfg.yarn.resourcemanager.openFirewall [
        8088 # resourcemanager.webapp.address
        8030 # resourcemanager.scheduler.address
        8031 # resourcemanager.resource-tracker.address
        8032 # resourcemanager.address
        8033 # resourcemanager.admin.address
      ]);
    })

    (mkIf cfg.yarn.nodemanager.enable {
      # Needed because yarn hardcodes /bin/bash in container start scripts
      # These scripts can't be patched, they are generated at runtime
      systemd.tmpfiles.rules = [
        (mkIf cfg.yarn.nodemanager.addBinBash "L /bin/bash - - - - /run/current-system/sw/bin/bash")
      ];

      systemd.services.yarn-nodemanager = {
        description = "Hadoop YARN NodeManager";
        wantedBy = [ "multi-user.target" ];
        inherit (cfg.yarn.nodemanager) restartIfChanged;
        environment = cfg.yarn.nodemanager.extraEnv;

        preStart = ''
          # create log dir
          mkdir -p /var/log/hadoop/yarn/nodemanager
          chown yarn:hadoop /var/log/hadoop/yarn/nodemanager

          # set up setuid container executor binary
          umount /run/wrappers/yarn-nodemanager/cgroup/cpu || true
          rm -rf /run/wrappers/yarn-nodemanager/ || true
          mkdir -p /run/wrappers/yarn-nodemanager/{bin,etc/hadoop,cgroup/cpu}
          cp ${cfg.package}/bin/container-executor /run/wrappers/yarn-nodemanager/bin/
          chgrp hadoop /run/wrappers/yarn-nodemanager/bin/container-executor
          chmod 6050 /run/wrappers/yarn-nodemanager/bin/container-executor
          cp ${hadoopConf}/container-executor.cfg /run/wrappers/yarn-nodemanager/etc/hadoop/
        '';

        serviceConfig = {
          User = "yarn";
          SyslogIdentifier = "yarn-nodemanager";
          PermissionsStartOnly = true;
          ExecStart = "${cfg.package}/bin/yarn --config ${hadoopConf} " +
                      " nodemanager ${escapeShellArgs cfg.yarn.nodemanager.extraFlags}";
          Restart = "always";
        };
      };

      services.hadoop.gatewayRole.enable = true;

      services.hadoop.yarnSiteInternal = with cfg.yarn.nodemanager; mkMerge [ ({
        "yarn.nodemanager.local-dirs" = mkIf (localDir!= null) (concatStringsSep "," localDir);
        "yarn.scheduler.maximum-allocation-vcores" = resource.maximumAllocationVCores;
        "yarn.scheduler.maximum-allocation-mb" = resource.maximumAllocationMB;
        "yarn.nodemanager.resource.cpu-vcores" = resource.cpuVCores;
        "yarn.nodemanager.resource.memory-mb" = resource.memoryMB;
      }) (mkIf useCGroups {
        "yarn.nodemanager.linux-container-executor.cgroups.hierarchy" = "/hadoop-yarn";
        "yarn.nodemanager.linux-container-executor.resources-handler.class" = "org.apache.hadoop.yarn.server.nodemanager.util.CgroupsLCEResourcesHandler";
        "yarn.nodemanager.linux-container-executor.cgroups.mount" = "true";
        "yarn.nodemanager.linux-container-executor.cgroups.mount-path" = "/run/wrappers/yarn-nodemanager/cgroup";
      })];

      networking.firewall.allowedTCPPortRanges = [
        (mkIf (cfg.yarn.nodemanager.openFirewall) {from = 1024; to = 65535;})
      ];
    })

  ];
}
