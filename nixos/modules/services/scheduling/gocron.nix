{
  options,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.gocron;
  settingsFormat = pkgs.formats.yaml { };
  gocronConf = settingsFormat.generate "gocron.yaml" cfg.settings;
  defaultUser = "gocron";
  defaultGroup = "gocron";
  timeZone = config.time.timeZone;

  hardeningOptions = lib.mkOption {
    description = "Configuration for hardening the systemd service.";
    type = lib.types.submodule {
      options = {
        ProtectHome = lib.mkOption {
          description = ''
            Whether to make the home directories inaccessible to the service.
            See <link xlink:href="https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ProtectHome="/> for more details.
          '';
          type = lib.types.either lib.types.str lib.types.bool;
          default = true;
          example = "read-only";
        };
        ProtectSystem = lib.mkOption {
          description = ''
            Whether to make several system directories inaccessible to the service.
            See <link xlink:href="https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ProtectSystem="/> for more details.
          '';
          type = lib.types.either lib.types.str lib.types.bool;
          default = true;
          example = "full";
        };
      };
    };
  };
in
{

  options.services.gocron = {
    enable = lib.mkEnableOption "gocron, a task scheduler";

    package = lib.mkOption {
      default = pkgs.gocron;
      defaultText = lib.literalExpression "pkgs.gocron";
      type = lib.types.package;
      description = ''
        gocron package to use.
      '';
    };

    openFirewall = lib.mkOption {
      description = "Whether to open the firewall port to access the web ui.";
      type = lib.types.bool;
      default = false;
    };

    user = lib.mkOption {
      description = "Unix User to run the server under";
      type = lib.types.str;
      default = defaultUser;
    };

    group = lib.mkOption {
      description = "Unix Group to run the server under";
      type = lib.types.str;
      default = defaultGroup;
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "backup" ];
      description = ''
        Additional groups for the systemd service.
      '';
    };

    hardening = hardeningOptions;

    settings = lib.mkOption {
      # Setting this type allows for correct merging behavior
      type = settingsFormat.type;
      default = { };
      description = ''
        Configuration for gocron, see
        <link xlink:href="https://github.com/flohoss/gocron/blob/main/config/config.yaml"/>
        for supported settings.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !lib.hasAttr "software" cfg.settings;
        message = "Software installation configuration is only supported for traditional distros by upstream.";
      }
    ];

    services.gocron.settings = {
      time_zone = if timeZone != null then timeZone else lib.mkDefault "Etc/UTC";
      server = {
        address = lib.mkDefault "127.0.0.1";
        port = lib.mkDefault 8156;
      };
      db.location = lib.mkDefault "/var/lib/gocron";
    };

    systemd.services.gocron = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${lib.getExe pkgs.gocron} --config '${gocronConf}'";
        User = cfg.user;
        Group = cfg.group;
        DeviceAllow = "";
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        MountAPIVFS = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        PrivateNetwork = lib.mkDefault false;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = cfg.hardening.ProtectHome;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = cfg.hardening.ProtectSystem;
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        UMask = "0077";
        StateDirectory = lib.mkIf (cfg.settings.db.location == "/var/lib/gocron") "gocron";
        SystemCallArchitectures = "native";
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
        ];
      };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.settings.server.port ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      inherit (cfg) group;
    };

    users.groups.${cfg.group} = { };

    meta = {
      buildDocsInSandbox = true;
      maintainers = with lib.maintainers; [ juliusfreudenberger ];
    };
  };
}
