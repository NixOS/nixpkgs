{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.services.unifi;
  stateDir = "/var/lib/unifi";
  cmd = ''
    @${cfg.jrePackage}/bin/java java \
        ${optionalString (cfg.initialJavaHeapSize != null) "-Xms${(toString cfg.initialJavaHeapSize)}m"} \
        ${optionalString (cfg.maximumJavaHeapSize != null) "-Xmx${(toString cfg.maximumJavaHeapSize)}m"} \
        -jar ${stateDir}/lib/ace.jar
  '';
  mountPoints = [
    {
      what = "${cfg.unifiPackage}/dl";
      where = "${stateDir}/dl";
    }
    {
      what = "${cfg.unifiPackage}/lib";
      where = "${stateDir}/lib";
    }
    {
      what = "${cfg.mongodbPackage}/bin";
      where = "${stateDir}/bin";
    }
    {
      what = "${cfg.dataDir}";
      where = "${stateDir}/data";
    }
  ];
  systemdMountPoints = map (m: "${utils.escapeSystemdPath m.where}.mount") mountPoints;
in
{

  options = {

    services.unifi.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether or not to enable the unifi controller service.
      '';
    };

    services.unifi.jrePackage = mkOption {
      type = types.package;
      default = pkgs.jre8;
      defaultText = "pkgs.jre8";
      description = ''
        The JRE package to use. Check the release notes to ensure it is supported.
      '';
    };

    services.unifi.unifiPackage = mkOption {
      type = types.package;
      default = pkgs.unifiLTS;
      defaultText = "pkgs.unifiLTS";
      description = ''
        The unifi package to use.
      '';
    };

    services.unifi.mongodbPackage = mkOption {
      type = types.package;
      default = pkgs.mongodb;
      defaultText = "pkgs.mongodb";
      description = ''
        The mongodb package to use.
      '';
    };

    services.unifi.dataDir = mkOption {
      type = types.str;
      default = "${stateDir}/data";
      description = ''
        Where to store the database and other data.

        This directory will be bind-mounted to ${stateDir}/data as part of the service startup.
      '';
    };

    services.unifi.openPorts = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not to open the minimum required ports on the firewall.

        This is necessary to allow firmware upgrades and device discovery to
        work. For remote login, you should additionally open (or forward) port
        8443.
      '';
    };

    services.unifi.initialJavaHeapSize = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 1024;
      description = ''
        Set the initial heap size for the JVM in MB. If this option isn't set, the
        JVM will decide this value at runtime.
      '';
    };

    services.unifi.maximumJavaHeapSize = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 4096;
      description = ''
        Set the maximimum heap size for the JVM in MB. If this option isn't set, the
        JVM will decide this value at runtime.
      '';
    };

  };

  config = mkIf cfg.enable {

    users.users.unifi = {
      uid = config.ids.uids.unifi;
      description = "UniFi controller daemon user";
      home = "${stateDir}";
    };

    networking.firewall = mkIf cfg.openPorts {
      # https://help.ubnt.com/hc/en-us/articles/218506997
      allowedTCPPorts = [
        8080  # Port for UAP to inform controller.
        8880  # Port for HTTP portal redirect, if guest portal is enabled.
        8843  # Port for HTTPS portal redirect, ditto.
        6789  # Port for UniFi mobile speed test.
      ];
      allowedUDPPorts = [
        3478  # UDP port used for STUN.
        10001 # UDP port used for device discovery.
      ];
    };

    # We must create the binary directories as bind mounts instead of symlinks
    # This is because the controller resolves all symlinks to absolute paths
    # to be used as the working directory.
    systemd.mounts = map ({ what, where }: {
        bindsTo = [ "unifi.service" ];
        partOf = [ "unifi.service" ];
        unitConfig.RequiresMountsFor = stateDir;
        options = "bind";
        what = what;
        where = where;
      }) mountPoints;

    systemd.tmpfiles.rules = [
      "d '${stateDir}' 0700 unifi - - -"
      "d '${stateDir}/data' 0700 unifi - - -"
      "d '${stateDir}/webapps' 0700 unifi - - -"
      "L+ '${stateDir}/webapps/ROOT' - - - - ${cfg.unifiPackage}/webapps/ROOT"
    ];

    systemd.services.unifi = {
      description = "UniFi controller daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ systemdMountPoints;
      partOf = systemdMountPoints;
      bindsTo = systemdMountPoints;
      unitConfig.RequiresMountsFor = stateDir;
      # This a HACK to fix missing dependencies of dynamic libs extracted from jars
      environment.LD_LIBRARY_PATH = with pkgs.stdenv; "${cc.cc.lib}/lib";

      serviceConfig = {
        Type = "simple";
        ExecStart = "${(removeSuffix "\n" cmd)} start";
        ExecStop = "${(removeSuffix "\n" cmd)} stop";
        Restart = "on-failure";
        User = "unifi";
        UMask = "0077";
        WorkingDirectory = "${stateDir}";
      };
    };

  };

  meta.maintainers = with lib.maintainers; [ erictapen ];
}
