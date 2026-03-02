{
  lib,
  pkgs,
  config,
  utils,
  ...
}:
let
  inherit (lib)
    getExe
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    mkPackageOption
    types
    ;

  cfg = config.services.actual;

  formatType = pkgs.formats.json { };
in
{
  options.services.actual = {
    enable = mkEnableOption "actual, a privacy focused app for managing your finances";
    package = mkPackageOption pkgs "actual-server" { };

    openFirewall = mkOption {
      default = false;
      type = types.bool;
      description = "Whether to open the firewall for the specified port.";
    };

    user = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        User account under which Actual runs.

        If null is specified (default), a temporary user will be created by systemd. Otherwise won't be automatically created by the service.
      '';
    };

    group = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Group account under which Actual runs.

        If null is specified (default), a temporary user will be created by systemd. Otherwise won't be automatically created by the service.
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        Server settings, refer to [the documentation](https://actualbudget.org/docs/config/) for available options.
        You can specify secret values in this configuration by setting `somevalue._secret = "/path/to/file"` instead of setting `somevalue` directly.
      '';
      type = types.submodule {
        freeformType = formatType.type;

        options = {
          hostname = mkOption {
            type = types.str;
            description = "The address to listen on";
            default = "::";
          };

          port = mkOption {
            type = types.port;
            description = "The port to listen on";
            default = 3000;
          };

          dataDir = lib.mkOption {
            type = lib.types.str;
            default = "/var/lib/actual";
            description = ''
              Directory under which Actual runs and saves its data.

              Changing this after you already have a working instance may make Actual fail to start, even if you move all files in the data dir. If migration is needed, refer to [this comment](https://github.com/actualbudget/actual/issues/3957#issuecomment-2567076794) for a fix.
            '';
          };

          serverFiles = lib.mkOption {
            type = lib.types.str;
            default = "${cfg.settings.dataDir}/server-files";
            defaultText = "\${cfg.settings.dataDir}/server-files";
            description = ''
              The server will put an account.sqlite file in this directory, which will contain the (hashed) server password, a list of all the budget files the server knows about, and the active session token (along with anything else the server may want to store in the future).
            '';
          };

          userFiles = lib.mkOption {
            type = lib.types.str;
            default = "${cfg.settings.dataDir}/user-files";
            defaultText = "\${cfg.settings.dataDir}/user-files";
            description = ''
              The server will put all the budget files in this directory as binary blobs.
            '';
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.settings.port ];

    systemd.services.actual = {
      description = "Actual server, a local-first personal finance app";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment.ACTUAL_CONFIG_PATH = "/run/actual/config.json";

      preStart = ''
        # Generate config including secret values.
        ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/actual/config.json"}
      '';

      serviceConfig = {
        ExecStart = getExe cfg.package;
        StateDirectory = "actual";
        RuntimeDirectory = "actual";
        WorkingDirectory = cfg.settings.dataDir;
        LimitNOFILE = "1048576";
        PrivateTmp = true;
        PrivateDevices = true;
        StateDirectoryMode = "0700";
        Restart = "always";

        # Hardening
        CapabilityBoundingSet = "";
        LockPersonality = true;
        #MemoryDenyWriteExecute = true; # Leads to coredump because V8 does JIT
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        ReadWritePaths = [
          cfg.settings.dataDir
          cfg.settings.serverFiles
          cfg.settings.userFiles
        ];
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_NETLINK"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
        ];
        UMask = "0077";
      }
      // (
        if cfg.user != null then
          {
            DynamicUser = false;
            Group = cfg.group;
            User = cfg.user;
          }
        else
          {
            DynamicUser = true;
            User = "actual";
            Group = "actual";
          }
      );
    };
  };

  meta.maintainers = [
    lib.maintainers.oddlama
    lib.maintainers.patrickdag
  ];
}
