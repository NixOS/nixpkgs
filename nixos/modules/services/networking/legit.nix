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
    mkOption
    mkPackageOption
    optionalAttrs
    optional
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
    enable = mkEnableOption "legit git web frontend";

    package = mkPackageOption pkgs "legit-web" { };

    user = mkOption {
      type = types.str;
      default = "legit";
      description = "User account under which legit runs.";
    };

    group = mkOption {
      type = types.str;
      default = "legit";
      description = "Group account under which legit runs.";
    };

    settings = mkOption {
      default = { };
      description = ''
        The primary legit configuration. See the
        [sample configuration](https://github.com/icyphox/legit/blob/master/config.yaml)
        for possible values.
      '';
      type = types.submodule {
        options.repo = {
          scanPath = mkOption {
            type = types.path;
            default = defaultStateDir;
            description = "Directory where legit will scan for repositories.";
          };
          readme = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Readme files to look for.";
          };
          mainBranch = mkOption {
            type = types.listOf types.str;
            default = [
              "main"
              "master"
            ];
            description = "Main branch to look for.";
          };
          ignore = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = "Repositories to ignore.";
          };
        };
        options.dirs = {
          templates = mkOption {
            type = types.path;
            default = "${pkgs.legit-web}/lib/legit/templates";
            defaultText = literalExpression ''"''${pkgs.legit-web}/lib/legit/templates"'';
            description = "Directories where template files are located.";
          };
          static = mkOption {
            type = types.path;
            default = "${pkgs.legit-web}/lib/legit/static";
            defaultText = literalExpression ''"''${pkgs.legit-web}/lib/legit/static"'';
            description = "Directories where static files are located.";
          };
        };
        options.meta = {
          title = mkOption {
            type = types.str;
            default = "legit";
            description = "Website title.";
          };
          description = mkOption {
            type = types.str;
            default = "git frontend";
            description = "Website description.";
          };
        };
        options.server = {
          name = mkOption {
            type = types.str;
            default = "localhost";
            description = "Server name.";
          };
          host = mkOption {
            type = types.str;
            default = "127.0.0.1";
            description = "Host address.";
          };
          port = mkOption {
            type = types.port;
            default = 5555;
            description = "Legit port.";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    users.groups = optionalAttrs (cfg.group == "legit") {
      "${cfg.group}" = { };
    };

    users.users = optionalAttrs (cfg.user == "legit") {
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
          ++ optional (cfg.settings.repo.scanPath == defaultStateDir) "legit"
          ++ optional (cfg.settings.dirs.static == defaultStaticDir) "legit/static"
          ++ optional (cfg.settings.dirs.templates == defaultTemplatesDir) "legit/templates";

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
