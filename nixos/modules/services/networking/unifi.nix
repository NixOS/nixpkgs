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
  ];
  systemdMountPoints = map (m: "${utils.escapeSystemdPath m.where}.mount") mountPoints;

  systemProperties = {
    # device inform
    "unifi.http.port" = cfg.httpPort;
    # controller UI / API
    "unifi.https.port" = cfg.httpsPort;
    # STUN (UDP)
    "unifi.stun.port" = cfg.stunPort;
    # DB
    "unifi.db.nojournal" = !cfg.database.journaling;
    # HSTS
    "unifi.https.hsts" = cfg.enableHsts;
    "unifi.https.hsts.max_age" = 31536000;
    "unifi.https.hsts.preload" = false;
    "unifi.https.hsts.subdomain" = false;
  } // cfg.systemProperties;

in
{

  options.services.unifi = {

    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether or not to enable the unifi controller service.
      '';
    };

    jrePackage = mkOption {
      type = types.package;
      default = pkgs.jre8;
      defaultText = "pkgs.jre8";
      description = ''
        The JRE package to use. Check the release notes to ensure it is supported.
      '';
    };

    unifiPackage = mkOption {
      type = types.package;
      default = pkgs.unifiLTS;
      defaultText = "pkgs.unifiLTS";
      description = ''
        The unifi package to use.
      '';
    };

    mongodbPackage = mkOption {
      type = types.package;
      default = pkgs.mongodb;
      defaultText = "pkgs.mongodb";
      description = ''
        The mongodb package to use.
      '';
    };

    openPorts = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether or not to open the minimum required ports on the firewall.

        This is necessary to allow firmware upgrades and device discovery to
        work. For remote login, you should additionally open (or forward) port
        8443.
      '';
    };

    initialJavaHeapSize = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 1024;
      description = ''
        Set the initial heap size for the JVM in MB. If this option isn't set, the
        JVM will decide this value at runtime.
      '';
    };

    maximumJavaHeapSize = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 4096;
      description = ''
        Set the maximimum heap size for the JVM in MB. If this option isn't set, the
        JVM will decide this value at runtime.
      '';
    };

    httpPort = mkOption {
      type = types.port;
      default = 8080;
      description = ''
        Port for AP inform
      '';
    };

    httpsPort = mkOption {
      type = types.port;
      default = 8443;
      description = ''
        Port for HTTPS traffic to controller UI.
      '';
    };

    stunPort = mkOption {
      type = types.port;
      default = 3478;
      description = ''
        Port for STUN traffic.
      '';
    };

    enableHsts = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable HSTS.
      '';
    };

    database.journaling = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Use database journaling. Disable this to use less disk space in exchange for a higher risk of file corruption.
      '';
    };

    systemProperties = mkOption {
      type = types.attrs;
      default = {};
      description = ''
        Key-value pairs that will be written to system.properties
      '';
    };
  };

  config = mkIf cfg.enable {

    users.users.unifi = {
      description = "UniFi controller daemon user";
      home = stateDir;
      group = "unifi";
    };

    users.groups.unifi = {};

    networking.firewall = mkIf cfg.openPorts {
      # https://help.ubnt.com/hc/en-us/articles/218506997
      allowedTCPPorts = [
        cfg.httpPort  # Port for UAP to inform controller.
        cfg.httpsPort # Port for controller UI/API.
        8880          # Port for HTTP portal redirect, if guest portal is enabled.
        8843          # Port for HTTPS portal redirect, ditto.
        6789          # Port for UniFi mobile speed test.
      ];
      allowedUDPPorts = [
        cfg.stunPort  # UDP port used for STUN.
        10001         # UDP port used for device discovery.
      ];
    };

    # We must create the binary directories as bind mounts instead of symlinks
    # This is because the controller resolves all symlinks to absolute paths
    # to be used as the working directory.
    systemd.mounts = map ({ what, where }: {
        bindsTo = [ "unifi.service" ];
        partOf = [ "unifi.service" ];
        options = "bind";
        inherit what where;
      }) mountPoints;

    systemd.services.unifi-setup = {
      description = "UniFi controller daemon - setup";
      wantedBy = [ "multi-user.target" ];
      before = [ "unifi.service" ];

      script = let
        props = "${stateDir}/data/system.properties";

        toStr = val: if builtins.isBool val
          then lib.boolToString val
          else toString val;
      in ''
        set -Euo pipefail

        rm -f ${stateDir}/webapps/ROOT
        ln -s ${cfg.unifiPackage}/webapps/ROOT ${stateDir}/webapps/ROOT

        touch ${props}
        ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: ''
          ${pkgs.crudini}/bin/crudini --set ${props} \
            "" ${name} ${toStr value}
        '') systemProperties)}
      '';

      serviceConfig = {
        Type = "oneshot";
        User = "unifi";
        Group = "unifi";
      };
    };

    systemd.services.unifi = {
      description = "UniFi controller daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ systemdMountPoints;
      requires = systemdMountPoints ++ [ "unifi-setup.service" ];
      partOf = systemdMountPoints;
      bindsTo = systemdMountPoints;
      # This a HACK to fix missing dependencies of dynamic libs extracted from jars
      environment.LD_LIBRARY_PATH = with pkgs.stdenv; "${cc.cc.lib}/lib";

      serviceConfig = {
        Type = "simple";
        ExecStart = "${(removeSuffix "\n" cmd)} start";
        ExecStop = "${(removeSuffix "\n" cmd)} stop";
        User = "unifi";
        Group = "unifi";
        LogsDirectory = "unifi";
        Restart = "always";
        WorkingDirectory = stateDir;
      };
    };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0700 unifi unifi - -"
    ]
    ++ (map (e: "d ${stateDir}/${e} 0700 unifi unifi - -")
      [ "data" "logs" "run" "webapps" ])
    ++ [ "Z ${stateDir} - unifi unifi - -" ];
  };

  meta.maintainers = with lib.maintainers; [ erictapen peterhoeg ];
}
