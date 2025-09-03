{
  pkgs,
  lib,
  config,
  utils,
  ...
}:
let
  cfg = config.services.nixseparatedebuginfod2;
  url = "127.0.0.1:${toString cfg.port}";
in
{
  options = {
    services.nixseparatedebuginfod2 = {
      enable = lib.mkEnableOption "nixseparatedebuginfod2, a debuginfod server providing source and debuginfo for nix packages";
      port = lib.mkOption {
        description = "port to listen";
        default = 1950;
        type = lib.types.port;
      };
      package = lib.mkPackageOption pkgs "nixseparatedebuginfod2" { };
      substituter = lib.mkOption {
        description = "nix substituter to fetch debuginfo from. Either http/https substituters, or `local:` to use debuginfo present in the local store.";
        default = "https://cache.nixos.org";
        example = "local:";
        type = lib.types.str;
      };
      cacheExpirationDelay = lib.mkOption {
        description = "keep unused cache entries for this long. A number followed by a unit";
        default = "1d";
        type = lib.types.str;
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.nixseparatedebuginfod2 = {
      wantedBy = [ "multi-user.target" ];
      path = [ config.nix.package ];
      serviceConfig = {
        ExecStart = [
          (utils.escapeSystemdExecArgs [
            (lib.getExe cfg.package)
            "--listen-address"
            url
            "--substituter"
            cfg.substituter
            "--expiration"
            cfg.cacheExpirationDelay
          ])
        ];
        Restart = "on-failure";
        CacheDirectory = "nixseparatedebuginfod2";
        DynamicUser = true;

        # hardening
        # Filesystem stuff
        ProtectSystem = "strict"; # Prevent writing to most of /
        ProtectHome = true; # Prevent accessing /home and /root
        PrivateTmp = true; # Give an own directory under /tmp
        PrivateDevices = true; # Deny access to most of /dev
        ProtectKernelTunables = true; # Protect some parts of /sys
        ProtectControlGroups = true; # Remount cgroups read-only
        RestrictSUIDSGID = true; # Prevent creating SETUID/SETGID files
        PrivateMounts = true; # Give an own mount namespace
        RemoveIPC = true;
        UMask = "0077";

        # Capabilities
        CapabilityBoundingSet = ""; # Allow no capabilities at all
        NoNewPrivileges = true; # Disallow getting more capabilities. This is also implied by other options.

        # Kernel stuff
        ProtectKernelModules = true; # Prevent loading of kernel modules
        SystemCallArchitectures = "native"; # Usually no need to disable this
        SystemCallFilter = "@system-service";
        ProtectKernelLogs = true; # Prevent access to kernel logs
        ProtectClock = true; # Prevent setting the RTC
        ProtectProc = "noaccess";
        ProcSubset = "pid";

        # Networking
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";

        # Misc
        LockPersonality = true; # Prevent change of the personality
        ProtectHostname = true; # Give an own UTS namespace
        RestrictRealtime = true; # Prevent switching to RT scheduling
        MemoryDenyWriteExecute = true; # Maybe disable this for interpreters like python
        RestrictNamespaces = true;

      };
    };

    environment.debuginfodServers = [ "http://${url}" ];

  };
}
