{
  config,
  options,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.unifi;
  stateDir = "/var/lib/unifi";
  cmd = lib.escapeShellArgs (
    [
      "@${cfg.jrePackage}/bin/java"
      "java"
      "--add-opens=java.base/java.lang=ALL-UNNAMED"
      "--add-opens=java.base/java.time=ALL-UNNAMED"
      "--add-opens=java.base/sun.security.util=ALL-UNNAMED"
      "--add-opens=java.base/java.io=ALL-UNNAMED"
      "--add-opens=java.rmi/sun.rmi.transport=ALL-UNNAMED"
    ]
    ++ (lib.optional (cfg.initialJavaHeapSize != null) "-Xms${(toString cfg.initialJavaHeapSize)}m")
    ++ (lib.optional (cfg.maximumJavaHeapSize != null) "-Xmx${(toString cfg.maximumJavaHeapSize)}m")
    ++ cfg.extraJvmOptions
    ++ [
      "-jar"
      "${stateDir}/lib/ace.jar"
    ]
  );
in
{

  options = {

    services.unifi.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether or not to enable the unifi controller service.
      '';
    };

    services.unifi.jrePackage = lib.mkPackageOption pkgs "jdk" {
      default = "jdk17_headless";
      extraDescription = ''
        Check the UniFi controller release notes to ensure it is supported.
      '';
    };

    services.unifi.unifiPackage = lib.mkPackageOption pkgs "unifi" { };

    services.unifi.mongodbPackage = lib.mkPackageOption pkgs "mongodb" {
      default = "mongodb-7_0";
    };

    services.unifi.openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether or not to open the minimum required ports on the firewall.

        This is necessary to allow firmware upgrades and device discovery to
        work. For remote login, you should additionally open (or forward) port
        8443.
      '';
    };

    services.unifi.initialJavaHeapSize = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      example = 1024;
      description = ''
        Set the initial heap size for the JVM in MB. If this option isn't set, the
        JVM will decide this value at runtime.
      '';
    };

    services.unifi.maximumJavaHeapSize = lib.mkOption {
      type = with lib.types; nullOr int;
      default = null;
      example = 4096;
      description = ''
        Set the maximum heap size for the JVM in MB. If this option isn't set, the
        JVM will decide this value at runtime.
      '';
    };

    services.unifi.extraJvmOptions = lib.mkOption {
      type = with lib.types; listOf str;
      default = [ ];
      example = lib.literalExpression ''["-Xlog:gc"]'';
      description = ''
        Set extra options to pass to the JVM.
      '';
    };

  };

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion =
          lib.versionAtLeast config.system.stateVersion "24.11"
          || (
            options.services.unifi.unifiPackage.highestPrio < (lib.mkOptionDefault { }).priority
            && options.services.unifi.mongodbPackage.highestPrio < (lib.mkOptionDefault { }).priority
          );
        message = ''
          Support for UniFi < 8 has been dropped; please explicitly set
          `services.unifi.unifiPackage` and `services.unifi.mongodbPackage`.

          Note that the previous default MongoDB version was 5.0 and MongoDB
          only supports migrating one major version at a time; therefore, you
          may wish to set `services.unifi.mongodbPackage = pkgs.mongodb-6_0;`
          and activate your configuration before upgrading again to the default
          `mongodb-7_0` supported by `unifi`.

          For more information, see the MongoDB upgrade notes:
          <https://www.mongodb.com/docs/manual/release-notes/7.0-upgrade-standalone/#upgrade-recommendations-and-checklists>
        '';
      }
    ];

    users.users.unifi = {
      isSystemUser = true;
      group = "unifi";
      description = "UniFi controller daemon user";
      home = "${stateDir}";
    };
    users.groups.unifi = { };

    networking.firewall = lib.mkIf cfg.openFirewall {
      # https://help.ubnt.com/hc/en-us/articles/218506997
      allowedTCPPorts = [
        8080 # Port for UAP to inform controller.
        8880 # Port for HTTP portal redirect, if guest portal is enabled.
        8843 # Port for HTTPS portal redirect, ditto.
        6789 # Port for UniFi mobile speed test.
      ];
      allowedUDPPorts = [
        3478 # UDP port used for STUN.
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
      restartTriggers = [
        cfg.unifiPackage
        cfg.mongodbPackage
      ];

      serviceConfig = {
        Type = "notify";
        ExecStart = "${cmd} start";
        ExecStop = "${cmd} stop";
        Restart = "always";
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
        CacheDirectory = "unifi";

        TemporaryFileSystem = [
          # required as we want to create bind mounts below
          "${stateDir}/webapps:rw"
        ];

        # We must create the binary directories as bind mounts instead of symlinks
        # This is because the controller resolves all symlinks to absolute paths
        # to be used as the working directory.
        BindPaths = [
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
    (lib.mkRemovedOptionModule [
      "services"
      "unifi"
      "dataDir"
    ] "You should move contents of dataDir to /var/lib/unifi/data")
    (lib.mkRenamedOptionModule [ "services" "unifi" "openPorts" ] [ "services" "unifi" "openFirewall" ])
  ];
}
