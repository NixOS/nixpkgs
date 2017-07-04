{ config, lib, pkgs, utils, ... }:
with lib;
let
  cfg = config.services.unifi;
  stateDir = "/var/lib/unifi";
  cmd = ''
    @${pkgs.jre}/bin/java java \
        ${optionalString (cfg.initialJavaHeapSize != null) "-Xms${(toString cfg.initialJavaHeapSize)}m"} \
        ${optionalString (cfg.maximumJavaHeapSize != null) "-Xmx${(toString cfg.maximumJavaHeapSize)}m"} \
        -jar ${stateDir}/lib/ace.jar
  '';
  mountPoints = [
    {
      what = "${pkgs.unifi}/dl";
      where = "${stateDir}/dl";
    }
    {
      what = "${pkgs.unifi}/lib";
      where = "${stateDir}/lib";
    }
    {
      what = "${pkgs.mongodb}/bin";
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

    users.extraUsers.unifi = {
      uid = config.ids.uids.unifi;
      description = "UniFi controller daemon user";
      home = "${stateDir}";
    };

    networking.firewall = mkIf cfg.openPorts {
      # https://help.ubnt.com/hc/en-us/articles/204910084-UniFi-Change-Default-Ports-for-Controller-and-UAPs
      allowedTCPPorts = [
        8080  # Port for UAP to inform controller.
        8880  # Port for HTTP portal redirect, if guest portal is enabled.
        8843  # Port for HTTPS portal redirect, ditto.
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

    systemd.services.unifi = {
      description = "UniFi controller daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ systemdMountPoints;
      partOf = systemdMountPoints;
      bindsTo = systemdMountPoints;
      unitConfig.RequiresMountsFor = stateDir;
      # This a HACK to fix missing dependencies of dynamic libs extracted from jars
      environment.LD_LIBRARY_PATH = with pkgs.stdenv; "${cc.cc.lib}/lib";

      preStart = ''
        # Ensure privacy of state and data.
        chown unifi "${stateDir}" "${stateDir}/data"
        chmod 0700 "${stateDir}" "${stateDir}/data"

        # Create the volatile webapps
        rm -rf "${stateDir}/webapps"
        mkdir -p "${stateDir}/webapps"
        chown unifi "${stateDir}/webapps"
        ln -s "${pkgs.unifi}/webapps/ROOT" "${stateDir}/webapps/ROOT"
      '';

      postStop = ''
        rm -rf "${stateDir}/webapps"
      '';

      serviceConfig = {
        Type = "simple";
        ExecStart = "${(removeSuffix "\n" cmd)} start";
        ExecStop = "${(removeSuffix "\n" cmd)} stop";
        User = "unifi";
        PermissionsStartOnly = true;
        UMask = "0077";
        WorkingDirectory = "${stateDir}";
      };
    };

  };

}
