{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.bindery;

  inherit (lib)
    mkIf
    mkOption
    literalExpression
    mkEnableOption
    mkPackageOption
    optional
    optionalAttrs
    ;

  inherit (lib.types)
    str
    port
    nullOr
    path
    attrsOf
    bool
    submodule
    ;
in
{
  options.services.bindery = {
    enable = mkEnableOption "bindery";
    package = mkPackageOption pkgs "bindery" { };

    user = mkOption {
      type = str;
      default = "bindery";
      description = "The user to run the bindery service as.";
    };

    group = mkOption {
      type = str;
      default = "bindery";
      description = "The group to run the bindery service as.";
    };

    port = mkOption {
      type = port;
      description = "The port bindery listens on.";
      default = 8787;
    };

    downloadDir = mkOption {
      type = path;
      description = "Where the download client places downloads.";
    };

    audiobookDownloadDir = mkOption {
      type = path;
      description = "Where the download client places audiobook downloads.";
      default = cfg.downloadDir;
      defaultText = literalExpression "config.services.bindery.downloadDir";
    };

    libraryDir = mkOption {
      type = path;
      description = "Destination for imported ebook files.";
      default = "/var/lib/bindery/books";
    };

    audiobookLibraryDir = mkOption {
      type = path;
      description = "Destination for imported audiobook folders.";
      default = cfg.libraryDir;
      defaultText = literalExpression "config.services.bindery.libraryDir";
    };

    environment = mkOption {
      type = attrsOf str;
      description = ''
        Environment variables to set for the bindery service.
        These take precedence over settings configured through `services.bindery.config`.
      '';
      default = { };
    };

    environmentFile = mkOption {
      type = nullOr path;
      description = "Environment file to load extra environment variables from.";
      default = null;
    };

    openFirewall = mkOption {
      type = bool;
      default = false;
      description = "Open port in the firewall for the Bindery web interface.";
    };

    calibre = mkOption {
      type = submodule {
        options = {
          enable = mkEnableOption "calibre integration";
          package = mkPackageOption pkgs "calibre" { };
        };
      };
      description = "Options for calibre integration.";
    };

  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.environment ? BINDERY_API_KEY);
        message = "Don't set BINDERY_API_KEY in `services.bindery.environment`. Use an environment file instead.";
      }
    ];

    users = {
      users = mkIf (cfg.user == "bindery") {
        bindery = {
          inherit (cfg) group;
          isSystemUser = true;
        };
      };
      groups = mkIf (cfg.group == "bindery") { bindery = { }; };
    };

    systemd.services.bindery = {
      description = "Automated book download manager for Usenet";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        BINDERY_DATA_DIR = "%S/bindery/config";
        BINDERY_PORT = toString cfg.port;
        BINDERY_DOWNLOAD_DIR = cfg.downloadDir;
        BINDERY_AUDIOBOOK_DOWNLOAD_DIR = cfg.audiobookDownloadDir;
        BINDERY_LIBRARY_DIR = cfg.libraryDir;
        BINDERY_AUDIOBOOK_LIBRARY_DIR = cfg.audiobookLibraryDir;
        BINDERY_DB_PATH = "%S/bindery/config/bindery.db";
      }
      // cfg.environment;

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        StateDirectory = "bindery";
        ExecStart = lib.getExe cfg.package;

        # Hardening
        ProtectSystem = "full";
        ProtectHome = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectKernelTunables = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        LockPersonality = true;
        RestrictRealtime = true;
        ProtectClock = true;
        MemoryDenyWriteExecute = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        SocketBindDeny = [
          "ipv4:udp"
          "ipv6:udp"
        ];
        CapabilityBoundingSet = [
          "~CAP_BLOCK_SUSPEND"
          "~CAP_BPF"
          "~CAP_CHOWN"
          "~CAP_IPC_LOCK"
          "~CAP_MKNOD"
          "~CAP_NET_RAW"
          "~CAP_PERFMON"
          "~CAP_SYS_BOOT"
          "~CAP_SYS_CHROOT"
          "~CAP_SYS_MODULE"
          "~CAP_SYS_NICE"
          "~CAP_SYS_PACCT"
          "~CAP_SYS_PTRACE"
          "~CAP_SYS_TIME"
          "~CAP_SYSLOG"
          "~CAP_WAKE_ALARM"
        ];
        SystemCallFilter = [
          "~@aio:EPERM"
          "~@chown:EPERM"
          "~@clock:EPERM"
          "~@cpu-emulation:EPERM"
          "~@debug:EPERM"
          "~@keyring:EPERM"
          "~@memlock:EPERM"
          "~@module:EPERM"
          "~@mount:EPERM"
          "~@obsolete:EPERM"
          "~@pkey:EPERM"
          "~@privileged:EPERM"
          "~@raw-io:EPERM"
          "~@reboot:EPERM"
          "~@resources:EPERM"
          "~@sandbox:EPERM"
          "~@setuid:EPERM"
          "~@swap:EPERM"
        ];
      }
      // optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = cfg.environmentFile;
      };

      systemd.tmpfiles.settings.binderyFiles = builtins.listToAttrs (
        map
          (dir: {
            name = dir;
            value.d = {
              inherit (cfg) user group;
              mode = "0700";
            };
          })
          lib.lists.unique
          [
            cfg.libraryDir
            cfg.audiobookLibraryDir
          ]
      );

      path = optional cfg.calibre.enable cfg.calibre.package;
    };

    networking.firewall.allowedTCPPorts = optional cfg.openFirewall cfg.port;
  };

  meta.maintainers = with lib.maintainers; [
    flyingpeakock
  ];
}
