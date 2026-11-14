{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  cfg = config.services.weewx;

  # WeeWX package extended with user-requested extra python libraries (e.g. paho-mqtt, psycopg2)
  weewxPackage =
    let
      extraPkgs = cfg.extraPythonPackages pkgs.python3Packages;
    in
    if extraPkgs == [ ] then
      cfg.package
    else
      cfg.package.overridePythonAttrs (old: {
        dependencies = (old.dependencies or [ ]) ++ extraPkgs;
      });

  # Runtime configuration file (rendered via envsubst if environmentFile is set)
  activeConfigFile = if cfg.environmentFile != null then "/run/weewx/weewx.conf" else cfg.configFile;
in
{
  meta.maintainers = with lib.maintainers; [ xela-zone ];

  options.services.weewx = {
    enable = lib.mkEnableOption "WeeWX weather station daemon";

    package = lib.mkPackageOption pkgs "weewx" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "weewx";
      description = "User account under which WeeWX runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "weewx";
      description = "Group account under which WeeWX runs.";
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression "./weewx.conf";
      description = ''
        Path to the {file}`weewx.conf` configuration file.
      '';
    };

    environmentFile = lib.mkOption {
      type = with lib.types; nullOr (either path str);
      default = null;
      example = "/run/secrets/weewx.env";
      description = ''
        Environment file as defined in {manpage}`systemd.exec(5)`.
        Variables matching `$VARIABLE` in {option}`services.weewx.configFile` will be substituted at service startup.
      '';
    };

    extraPythonPackages = lib.mkOption {
      type = lib.types.functionTo (lib.types.listOf lib.types.package);
      default = ps: [ ];
      defaultText = lib.literalExpression "ps: [ ]";
      example = lib.literalExpression "ps: [ ps.paho-mqtt ]";
      description = ''
        Extra Python packages available to WeeWX at runtime.
        Useful for third-party extensions such as MQTT or database drivers.
      '';
    };

    skins = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = lib.literalExpression ''
        {
          neowx-material = pkgs.fetchzip {
            url = "https://github.com/neoground/neowx-material/releases/download/v1.11/neowx-material-1.11.zip";
            hash = "sha256-1111111111111111111111111111111111111111111=";
            stripRoot = false;
          };
        }
      '';
      description = ''
        Additional WeeWX skins to link into {file}`/var/lib/weewx/skins/<name>`.
        Each attribute value must evaluate to a directory containing a {file}`skin.conf` file.
      '';
    };

    userModules = lib.mkOption {
      type = lib.types.attrsOf lib.types.path;
      default = { };
      example = lib.literalExpression ''
        {
          "mqtt.py" = ./mqtt.py;
        }
      '';
      description = ''
        Additional WeeWX user extensions or drivers to link into {file}`/var/lib/weewx/bin/user/<name>`.
      '';
    };

    checkConfig = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Whether to validate the configuration file using {command}`weectl` debug
        before starting the service.
      '';
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--exit" ];
      description = "Extra command-line arguments passed to {command}`weewxd`.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.configFile != null;
        message = "services.weewx: 'configFile' must be specified.";
      }
    ];

    # Expose weewx CLI tools in system environment
    environment.systemPackages = [ weewxPackage ];

    # Automatically install udev rules for all recognized weather stations
    services.udev.packages = [ cfg.package ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      # dialout gives permission to serial/USB weather station devices
      extraGroups = [ "dialout" ];
      home = "/var/lib/weewx";
      description = "WeeWX daemon user";
    };

    users.groups.${cfg.group} = { };

    systemd.services.weewx = {
      description = "WeeWX weather software system";
      documentation = [ "https://weewx.com/docs/" ];
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "time-sync.target"
      ]
      ++ lib.optional config.services.mysql.enable "mysql.service";
      wants = [
        "network-online.target"
        "time-sync.target"
      ];

      preStart = ''
        mkdir -p /var/lib/weewx/skins
        ${pkgs.findutils}/bin/find /var/lib/weewx/skins -maxdepth 1 -type l -delete
        for skin_dir in ${weewxPackage}/lib/python*/site-packages/weewx_data/skins/*; do
          if [ -d "$skin_dir" ]; then
            skin_name=$(${pkgs.coreutils}/bin/basename "$skin_dir")
            ln -sfn -T "$skin_dir" "/var/lib/weewx/skins/$skin_name"
          fi
        done
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: path: ''
            ln -sfn -T ${lib.escapeShellArg "${path}"} ${lib.escapeShellArg "/var/lib/weewx/skins/${name}"}
          '') cfg.skins
        )}
        mkdir -p /var/lib/weewx/bin/user
        touch /var/lib/weewx/bin/user/__init__.py
        ${pkgs.findutils}/bin/find /var/lib/weewx/bin/user -maxdepth 1 -type l -delete
        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: path: ''
            ln -sfn -T ${lib.escapeShellArg "${path}"} ${lib.escapeShellArg "/var/lib/weewx/bin/user/${name}"}
          '') cfg.userModules
        )}
        ${lib.optionalString (cfg.environmentFile != null) ''
          ${lib.getExe pkgs.envsubst} -i ${lib.escapeShellArg cfg.configFile} -o /run/weewx/weewx.conf
          chmod 0600 /run/weewx/weewx.conf
        ''}
        ${lib.optionalString cfg.checkConfig ''
          ${weewxPackage}/bin/weectl debug --config=${activeConfigFile} --output=/dev/null
        ''}
      '';

      serviceConfig = {
        EnvironmentFile = lib.optional (cfg.environmentFile != null) cfg.environmentFile;
        ExecStart = utils.escapeSystemdExecArgs (
          [
            "${weewxPackage}/bin/weewxd"
            activeConfigFile
          ]
          ++ cfg.extraArgs
        );
        User = cfg.user;
        Group = cfg.group;
        Restart = "on-failure";
        RestartSec = "30s";
        UMask = "0022";

        # Standard directories
        StateDirectory = "weewx";
        RuntimeDirectory = "weewx";
        RuntimeDirectoryMode = "0700";

        # Hardening
        NoNewPrivileges = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectHostname = true;
        PrivateTmp = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectControlGroups = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
          "AF_NETLINK"
        ];
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
        ];
        LockPersonality = true;
      };
    };
  };
}
