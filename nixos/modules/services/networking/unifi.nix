{ config, options, lib, pkgs, utils, ... }:
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
in
{

  options = {

    services.unifi.enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether or not to enable the unifi controller service.
      '';
    };

    services.unifi.jrePackage = mkOption {
      type = types.package;
      default = if (lib.versionAtLeast (lib.getVersion cfg.unifiPackage) "7.3") then pkgs.jdk11 else pkgs.jre8;
      defaultText = literalExpression ''if (lib.versionAtLeast (lib.getVersion cfg.unifiPackage) "7.3" then pkgs.jdk11 else pkgs.jre8'';
      description = lib.mdDoc ''
        The JRE package to use. Check the release notes to ensure it is supported.
      '';
    };

    services.unifi.unifiPackage = mkOption {
      type = types.package;
      default = pkgs.unifi5;
      defaultText = literalExpression "pkgs.unifi5";
      description = lib.mdDoc ''
        The unifi package to use.
      '';
    };

    services.unifi.mongodbPackage = mkOption {
      type = types.package;
      default = pkgs.mongodb-4_2;
      defaultText = literalExpression "pkgs.mongodb";
      description = lib.mdDoc ''
        The mongodb package to use. Please note: unifi7 officially only supports mongodb up until 3.6 but works with 4.2.
      '';
    };

    services.unifi.openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
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
      description = lib.mdDoc ''
        Set the initial heap size for the JVM in MB. If this option isn't set, the
        JVM will decide this value at runtime.
      '';
    };

    services.unifi.maximumJavaHeapSize = mkOption {
      type = types.nullOr types.int;
      default = null;
      example = 4096;
      description = lib.mdDoc ''
        Set the maximum heap size for the JVM in MB. If this option isn't set, the
        JVM will decide this value at runtime.
      '';
    };

  };

  config = mkIf cfg.enable {

    users.users.unifi = {
      isSystemUser = true;
      group = "unifi";
      description = "UniFi controller daemon user";
      home = "${stateDir}";
    };
    users.groups.unifi = {};

    networking.firewall = mkIf cfg.openFirewall {
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

    systemd.services.unifi = {
      description = "UniFi controller daemon";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];

      # This a HACK to fix missing dependencies of dynamic libs extracted from jars
      environment.LD_LIBRARY_PATH = with pkgs.stdenv; "${cc.cc.lib}/lib";
      # Make sure package upgrades trigger a service restart
      restartTriggers = [ cfg.unifiPackage cfg.mongodbPackage ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${(removeSuffix "\n" cmd)} start";
        ExecStop = "${(removeSuffix "\n" cmd)} stop";
        Restart = "on-failure";
        TimeoutSec = "5min";
        User = "unifi";
        UMask = "0077";
        WorkingDirectory = "${stateDir}";
        # the stop command exits while the main process is still running, and unifi
        # wants to manage its own child processes. this means we have to set KillSignal
        # to something the main process ignores, otherwise every stop will have unifi.service
        # fail with SIGTERM status.
        KillSignal = "SIGCONT";

        # Hardening
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        # ProtectClock= adds DeviceAllow=char-rtc r
        DeviceAllow = "";
        DevicePolicy = "closed";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [ "@system-service" ];

        StateDirectory = "unifi";
        RuntimeDirectory = "unifi";
        LogsDirectory = "unifi";
        CacheDirectory= "unifi";

        TemporaryFileSystem = [
          # required as we want to create bind mounts below
          "${stateDir}/webapps:rw"
        ];

        # We must create the binary directories as bind mounts instead of symlinks
        # This is because the controller resolves all symlinks to absolute paths
        # to be used as the working directory.
        BindPaths =  [
          "/var/log/unifi:${stateDir}/logs"
          "/run/unifi:${stateDir}/run"
          "${cfg.unifiPackage}/dl:${stateDir}/dl"
          "${cfg.unifiPackage}/lib:${stateDir}/lib"
          "${cfg.mongodbPackage}/bin:${stateDir}/bin"
          "${cfg.unifiPackage}/webapps/ROOT:${stateDir}/webapps/ROOT"
        ];

        # Needs network access
        PrivateNetwork = false;
        # Cannot be true due to OpenJDK
        MemoryDenyWriteExecute = false;
      };
    };

  };
  imports = [
    (mkRemovedOptionModule [ "services" "unifi" "dataDir" ] "You should move contents of dataDir to /var/lib/unifi/data" )
    (mkRenamedOptionModule [ "services" "unifi" "openPorts" ] [ "services" "unifi" "openFirewall" ])
  ];

  meta.maintainers = with lib.maintainers; [ erictapen pennae ];
}
