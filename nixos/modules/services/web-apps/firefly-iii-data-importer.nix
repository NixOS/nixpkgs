{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.firefly-iii-data-importer;

  user = cfg.user;
  group = cfg.group;

  defaultUser = "firefly-iii-data-importer";
  defaultGroup = "firefly-iii-data-importer";

  artisan = "${cfg.package}/artisan";

  env-file-values = lib.attrsets.mapAttrs' (
    n: v: lib.attrsets.nameValuePair (lib.strings.removeSuffix "_FILE" n) v
  ) (lib.attrsets.filterAttrs (n: v: lib.strings.hasSuffix "_FILE" n) cfg.settings);
  env-nonfile-values = lib.attrsets.filterAttrs (n: v: !lib.strings.hasSuffix "_FILE" n) cfg.settings;

  data-importer-maintenance = pkgs.writeShellScript "data-importer-maintenance.sh" ''
    set -a
    ${lib.strings.toShellVars env-nonfile-values}
    ${lib.strings.concatLines (
      lib.attrsets.mapAttrsToList (n: v: "${n}=\"$(< ${v})\"") env-file-values
    )}
    set +a
    ${artisan} package:discover
    ${artisan} cache:clear
    ${artisan} config:cache
  '';

  commonServiceConfig = {
    Type = "oneshot";
    User = user;
    Group = group;
    StateDirectory = "firefly-iii-data-importer";
    ReadWritePaths = [ cfg.dataDir ];
    WorkingDirectory = cfg.package;
    PrivateTmp = true;
    PrivateDevices = true;
    CapabilityBoundingSet = "";
    AmbientCapabilities = "";
    ProtectSystem = "strict";
    ProtectKernelTunables = true;
    ProtectKernelModules = true;
    ProtectControlGroups = true;
    ProtectClock = true;
    ProtectHostname = true;
    ProtectHome = "tmpfs";
    ProtectKernelLogs = true;
    ProtectProc = "invisible";
    ProcSubset = "pid";
    PrivateNetwork = false;
    RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
    SystemCallArchitectures = "native";
    SystemCallFilter = [
      "@system-service @resources"
      "~@obsolete @privileged"
    ];
    RestrictSUIDSGID = true;
    RemoveIPC = true;
    NoNewPrivileges = true;
    RestrictRealtime = true;
    RestrictNamespaces = true;
    LockPersonality = true;
    PrivateUsers = true;
  };

in
{

  options.services.firefly-iii-data-importer = {
    enable = lib.mkEnableOption "Firefly III Data Importer";

    user = lib.mkOption {
      type = lib.types.str;
      default = defaultUser;
      description = "User account under which firefly-iii-data-importer runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = if cfg.enableNginx then "nginx" else defaultGroup;
      defaultText = "If `services.firefly-iii-data-importer.enableNginx` is true then `nginx` else ${defaultGroup}";
      description = ''
        Group under which firefly-iii-data-importer runs. It is best to set this to the group
        of whatever webserver is being used as the frontend.
      '';
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/firefly-iii-data-importer";
      description = ''
        The place where firefly-iii data importer stores its state.
      '';
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.firefly-iii-data-importer;
      defaultText = lib.literalExpression "pkgs.firefly-iii-data-importer";
      description = ''
        The firefly-iii-data-importer package served by php-fpm and the webserver of choice.
        This option can be used to point the webserver to the correct root. It
        may also be used to set the package to a different version, say a
        development version.
      '';
      apply =
        firefly-iii-data-importer:
        firefly-iii-data-importer.override (prev: {
          dataDir = cfg.dataDir;
        });
    };

    enableNginx = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether to enable nginx or not. If enabled, an nginx virtual host will
        be created for access to firefly-iii data importer. If not enabled, then you may use
        `''${config.services.firefly-iii-data-importer.package}` as your document root in
        whichever webserver you wish to setup.
      '';
    };

    virtualHost = lib.mkOption {
      type = lib.types.str;
      default = "localhost";
      description = ''
        The hostname at which you wish firefly-iii-data-importer to be served. If you have
        enabled nginx using `services.firefly-iii-data-importer.enableNginx` then this will
        be used.
      '';
    };

    poolConfig = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.oneOf [
          lib.types.str
          lib.types.int
          lib.types.bool
        ]
      );
      default = { };
      defaultText = lib.literalExpression ''
        {
          "pm" = "dynamic";
          "pm.max_children" = 32;
          "pm.start_servers" = 2;
          "pm.min_spare_servers" = 2;
          "pm.max_spare_servers" = 4;
          "pm.max_requests" = 500;
        }
      '';
      description = ''
        Options for the Firefly III Data Importer PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    settings = lib.mkOption {
      default = { };
      description = ''
        Options for firefly-iii data importer configuration. Refer to
        <https://github.com/firefly-iii/data-importer/blob/main/.env.example> for
        details on supported values. All <option>_FILE values supported by
        upstream are supported here.

        APP_URL will be the same as `services.firefly-iii-data-importer.virtualHost` if the
        former is unset in `services.firefly-iii-data-importer.settings`.
      '';
      example = lib.literalExpression ''
        {
          APP_ENV = "local";
          LOG_CHANNEL = "syslog";
          FIREFLY_III_ACCESS_TOKEN= = "/var/secrets/firefly-iii-access-token.txt";
        }
      '';
      type = lib.types.submodule {
        freeformType = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.str
            lib.types.int
            lib.types.bool
          ]
        );
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.phpfpm.pools.firefly-iii-data-importer = {
      inherit user group;
      phpPackage = cfg.package.phpPackage;
      phpOptions = ''
        log_errors = on
      '';
      settings = {
        "listen.mode" = "0660";
        "listen.owner" = user;
        "listen.group" = group;
        "pm" = lib.mkDefault "dynamic";
        "pm.max_children" = lib.mkDefault 32;
        "pm.start_servers" = lib.mkDefault 2;
        "pm.min_spare_servers" = lib.mkDefault 2;
        "pm.max_spare_servers" = lib.mkDefault 4;
        "pm.max_requests" = lib.mkDefault 500;
      } // cfg.poolConfig;
    };

    systemd.services.firefly-iii-data-importer-setup = {
      requiredBy = [ "phpfpm-firefly-iii-data-importer.service" ];
      before = [ "phpfpm-firefly-iii-data-importer.service" ];
      serviceConfig = {
        ExecStart = data-importer-maintenance;
        RemainAfterExit = true;
      } // commonServiceConfig;
      unitConfig.JoinsNamespaceOf = "phpfpm-firefly-iii-data-importer.service";
      restartTriggers = [ cfg.package ];
    };

    services.nginx = lib.mkIf cfg.enableNginx {
      enable = true;
      recommendedTlsSettings = lib.mkDefault true;
      recommendedOptimisation = lib.mkDefault true;
      recommendedGzipSettings = lib.mkDefault true;
      virtualHosts.${cfg.virtualHost} = {
        root = "${cfg.package}/public";
        locations = {
          "/" = {
            tryFiles = "$uri $uri/ /index.php?$query_string";
            index = "index.php";
            extraConfig = ''
              sendfile off;
            '';
          };
          "~ \.php$" = {
            extraConfig = ''
              include ${config.services.nginx.package}/conf/fastcgi_params ;
              fastcgi_param SCRIPT_FILENAME $request_filename;
              fastcgi_param modHeadersAvailable true;
              fastcgi_pass unix:${config.services.phpfpm.pools.firefly-iii-data-importer.socket};
            '';
          };
        };
      };
    };

    systemd.tmpfiles.settings."10-firefly-iii-data-importer" =
      lib.attrsets.genAttrs
        [
          "${cfg.dataDir}/storage"
          "${cfg.dataDir}/storage/app"
          "${cfg.dataDir}/storage/app/public"
          "${cfg.dataDir}/storage/configurations"
          "${cfg.dataDir}/storage/conversion-routines"
          "${cfg.dataDir}/storage/debugbar"
          "${cfg.dataDir}/storage/framework"
          "${cfg.dataDir}/storage/framework/cache"
          "${cfg.dataDir}/storage/framework/sessions"
          "${cfg.dataDir}/storage/framework/testing"
          "${cfg.dataDir}/storage/framework/views"
          "${cfg.dataDir}/storage/jobs"
          "${cfg.dataDir}/storage/logs"
          "${cfg.dataDir}/storage/submission-routines"
          "${cfg.dataDir}/storage/uploads"
          "${cfg.dataDir}/cache"
        ]
        (n: {
          d = {
            group = group;
            mode = "0710";
            user = user;
          };
        })
      // {
        "${cfg.dataDir}".d = {
          group = group;
          mode = "0700";
          user = user;
        };
      };

    users = {
      users = lib.mkIf (user == defaultUser) {
        ${defaultUser} = {
          description = "Firefly-iii Data Importer service user";
          inherit group;
          isSystemUser = true;
          home = cfg.dataDir;
        };
      };
      groups = lib.mkIf (group == defaultGroup) { ${defaultGroup} = { }; };
    };
  };
}
