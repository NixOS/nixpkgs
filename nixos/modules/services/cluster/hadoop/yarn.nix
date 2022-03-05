{ config, lib, pkgs, ...}:
with lib;
let
  cfg = config.services.hadoop;
  hadoopConf = "${import ./conf.nix { inherit cfg pkgs lib; }}/";
  restartIfChanged  = mkOption {
    type = types.bool;
    description = ''
      Automatically restart the service on config change.
      This can be set to false to defer restarts on clusters running critical applications.
      Please consider the security implications of inadvertently running an older version,
      and the possibility of unexpected behavior caused by inconsistent versions across a cluster when disabling this option.
    '';
    default = false;
  };
in
{
  options.services.hadoop.yarn = {
    resourcemanager = {
      enable = mkEnableOption "Whether to run the Hadoop YARN ResourceManager";
      inherit restartIfChanged;
      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Open firewall ports for resourcemanager
        '';
      };
    };
    nodemanager = {
      enable = mkEnableOption "Whether to run the Hadoop YARN NodeManager";
      inherit restartIfChanged;
      addBinBash = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Add /bin/bash. This is needed by the linux container executor's launch script.
        '';
      };
      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Open firewall ports for nodemanager.
          Because containers can listen on any ephemeral port, TCP ports 1024–65535 will be opened.
        '';
      };
    };
  };

  config = mkMerge [
    (mkIf (
        cfg.yarn.resourcemanager.enable || cfg.yarn.nodemanager.enable
    ) {

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

        serviceConfig = {
          User = "yarn";
          SyslogIdentifier = "yarn-resourcemanager";
          ExecStart = "${cfg.package}/bin/yarn --config ${hadoopConf} " +
                      " resourcemanager";
          Restart = "always";
        };
      };
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

        preStart = ''
          # create log dir
          mkdir -p /var/log/hadoop/yarn/nodemanager
          chown yarn:hadoop /var/log/hadoop/yarn/nodemanager

          # set up setuid container executor binary
          rm -rf /run/wrappers/yarn-nodemanager/ || true
          mkdir -p /run/wrappers/yarn-nodemanager/{bin,etc/hadoop}
          cp ${cfg.package}/lib/${cfg.package.untarDir}/bin/container-executor /run/wrappers/yarn-nodemanager/bin/
          chgrp hadoop /run/wrappers/yarn-nodemanager/bin/container-executor
          chmod 6050 /run/wrappers/yarn-nodemanager/bin/container-executor
          cp ${hadoopConf}/container-executor.cfg /run/wrappers/yarn-nodemanager/etc/hadoop/
        '';

        serviceConfig = {
          User = "yarn";
          SyslogIdentifier = "yarn-nodemanager";
          PermissionsStartOnly = true;
          ExecStart = "${cfg.package}/bin/yarn --config ${hadoopConf} " +
                      " nodemanager";
          Restart = "always";
        };
      };

      networking.firewall.allowedTCPPortRanges = [
        (mkIf (cfg.yarn.nodemanager.openFirewall) {from = 1024; to = 65535;})
      ];
    })

  ];
}
