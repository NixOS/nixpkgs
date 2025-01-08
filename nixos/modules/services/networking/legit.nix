{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    lib.mkOption
    mkPackageOption
    lib.optionalAttrs
    lib.optional
    types
    ;

  cfg = config.services.legit;

  yaml = pkgs.formats.yaml { };
  configFile = yaml.generate "legit.yaml" cfg.settings;

  defaultStateDir = "/var/lib/legit";
  defaultStaticDir = "${cfg.settings.repo.scanPath}/static";
  defaultTemplatesDir = "${cfg.settings.repo.scanPath}/templates";
in
{
  options.services.legit = {
    enable = lib.mkEnableOption "legit git web frontend";

    package = lib.mkPackageOption pkgs "legit-web" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "legit";
      description = "User account under which legit runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "legit";
      description = "Group account under which legit runs.";
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        The primary legit configuration. See the
        [sample configuration](https://github.com/icyphox/legit/blob/master/config.yaml)
        for possible values.
      '';
      type = lib.types.submodule {
        options.repo = {
          scanPath = lib.mkOption {
            type = lib.types.path;
            default = defaultStateDir;
            description = "Directory where legit will scan for repositories.";
          };
          readme = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Readme files to look for.";
          };
          mainBranch = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [
              "main"
              "master"
            ];
            description = "Main branch to look for.";
          };
          ignore = lib.mkOption {
            type = lib.types.listOf lib.types.str;
            default = [ ];
            description = "Repositories to ignore.";
          };
        };
        options.dirs = {
          templates = lib.mkOption {
            type = lib.types.path;
            default = "${pkgs.legit-web}/lib/legit/templates";
            defaultText = lib.literalExpression ''"''${pkgs.legit-web}/lib/legit/templates"'';
            description = "Directories where template files are located.";
          };
          static = lib.mkOption {
            type = lib.types.path;
            default = "${pkgs.legit-web}/lib/legit/static";
            defaultText = lib.literalExpression ''"''${pkgs.legit-web}/lib/legit/static"'';
            description = "Directories where static files are located.";
          };
        };
        options.meta = {
          title = lib.mkOption {
            type = lib.types.str;
            default = "legit";
            description = "Website title.";
          };
          description = lib.mkOption {
            type = lib.types.str;
            default = "git frontend";
            description = "Website description.";
          };
        };
        options.server = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "Server name.";
          };
          host = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            description = "Host address.";
          };
          port = lib.mkOption {
            type = lib.types.port;
            default = 5555;
            description = "Legit port.";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.groups = lib.optionalAttrs (cfg.group == "legit") {
      "${cfg.group}" = { };
    };

    users.users = lib.optionalAttrs (cfg.user == "legit") {
      "${cfg.user}" = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    systemd.services.legit = {
      description = "legit git frontend";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      restartTriggers = [ configFile ];

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/legit -config ${configFile}";
        Restart = "always";

        WorkingDirectory = cfg.settings.repo.scanPath;
        StateDirectory =
          [ ]
          ++ lib.optional (cfg.settings.repo.scanPath == defaultStateDir) "legit"
          ++ lib.optional (cfg.settings.dirs.static == defaultStaticDir) "legit/static"
          ++ lib.optional (cfg.settings.dirs.templates == defaultTemplatesDir) "legit/templates";

        # Hardening
        CapabilityBoundingSet = [ "" ];
        DeviceAllow = [ "" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateTmp = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        ReadWritePaths = cfg.settings.repo.scanPath;
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        UMask = "0077";
      };
    };
  };
}
