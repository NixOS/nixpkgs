{ pkgs, lib, config, ... }:
let
  cfg = config.services.nixseparatedebuginfod;
  url = "127.0.0.1:${toString cfg.port}";
in
{
  options = {
    services.nixseparatedebuginfod = {
      enable = lib.mkEnableOption "separatedebuginfod, a debuginfod server providing source and debuginfo for nix packages";
      port = lib.mkOption {
        description = "port to listen";
        default = 1949;
        type = lib.types.port;
      };
      nixPackage = lib.mkOption {
        type = lib.types.package;
        default = pkgs.nix;
        defaultText = lib.literalExpression "pkgs.nix";
        description = ''
          The version of nix that nixseparatedebuginfod should use as client for the nix daemon. It is strongly advised to use nix version >= 2.18, otherwise some debug info may go missing.
        '';
      };
      allowOldNix = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Do not fail evaluation when {option}`services.nixseparatedebuginfod.nixPackage` is older than nix 2.18.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enable {
    assertions = [ {
      assertion = cfg.allowOldNix || (lib.versionAtLeast cfg.nixPackage.version "2.18");
      message = "nixseparatedebuginfod works better when `services.nixseparatedebuginfod.nixPackage` is set to nix >= 2.18 (instead of ${cfg.nixPackage.name}). Set `services.nixseparatedebuginfod.allowOldNix` to bypass.";
    } ];

    systemd.services.nixseparatedebuginfod = {
      wantedBy = [ "multi-user.target" ];
      wants = [ "nix-daemon.service" ];
      after = [ "nix-daemon.service" ];
      path = [ cfg.nixPackage ];
      serviceConfig = {
        ExecStart = [ "${pkgs.nixseparatedebuginfod}/bin/nixseparatedebuginfod -l ${url}" ];
        Restart = "on-failure";
        CacheDirectory = "nixseparatedebuginfod";
        # nix does not like DynamicUsers in allowed-users
        User = "nixseparatedebuginfod";
        Group = "nixseparatedebuginfod";

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
        ProtectKernelLogs = true; # Prevent access to kernel logs
        ProtectClock = true; # Prevent setting the RTC

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

    users.users.nixseparatedebuginfod = {
      isSystemUser = true;
      group = "nixseparatedebuginfod";
    };

    users.groups.nixseparatedebuginfod = { };

    nix.settings = lib.optionalAttrs (lib.versionAtLeast config.nix.package.version "2.4") {
      extra-allowed-users = [ "nixseparatedebuginfod" ];
    };

    environment.variables.DEBUGINFOD_URLS = "http://${url}";

    environment.systemPackages = [
      # valgrind support requires debuginfod-find on PATH
      (lib.getBin pkgs.elfutils)
    ];

    environment.etc."gdb/gdbinit.d/nixseparatedebuginfod.gdb".text = "set debuginfod enabled on";

  };
}
